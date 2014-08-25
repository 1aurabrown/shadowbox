// Some real-time FFT! This visualizes music in the frequency domain using a
// polar-coordinate particle system. Particle size and radial distance are modulated
// using a filtered FFT. Color is sampled from an image.

import ddf.minim.analysis.*;
import ddf.minim.*;

OPC opc;
PImage dot;
PImage colors;
Minim minim;
AudioInput in;
FFT fft;
float[] fftFilter;

float spin = 0.0002;
float radiansPerBucket = radians(2);
float decay = 0.985;
float opacity = 50;
float minSize = 0.1;
float sizeScale = 0.8;

void mapShadowBox()
{
  // Represent the upper and lower rings as two side-by-side rings

  int index = 0;
  int spacing = 4;
  float radius = spacing * 6.7;
  float x = width / 4;
  float y = height / 2;
  
  opc.ledStrip(index + 13*0, 13, x - radius, y, spacing, radians(-90), false);
  opc.ledStrip(index + 13*1, 13, x, y - radius, spacing, radians(0), false);
  opc.ledStrip(index + 13*2, 13, x + radius, y, spacing, radians(90), false);
  opc.ledStrip(index + 13*3, 13, x, y + radius, spacing, radians(180), false);

  x = width * 3 / 4;
  index = index + 64;
  
  opc.ledStrip(index + 13*0, 13, x - radius, y, spacing, radians(-90), false);
  opc.ledStrip(index + 13*1, 13, x, y - radius, spacing, radians(0), false);
  opc.ledStrip(index + 13*2, 13, x + radius, y, spacing, radians(90), false);
  opc.ledStrip(index + 13*3, 13, x, y + radius, spacing, radians(180), false);
}

void setup()
{
  size(400, 200, P3D);

  minim = new Minim(this); 

  // Small buffer size!
  in = minim.getLineIn(minim.MONO, 512);

  fft = new FFT(in.bufferSize(), in.sampleRate());
  fftFilter = new float[fft.specSize()];

  dot = loadImage("dot.png");
  colors = loadImage("colors.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);
  mapShadowBox();
}

void draw()
{
  background(0);

  fft.forward(in.mix);
  for (int i = 0; i < fftFilter.length; i++) {
    fftFilter[i] = max(fftFilter[i] * decay, log(1 + fft.getBand(i)));
  }
 
  for (int i = 0; i < fftFilter.length; i += 3) {   
 
    float size = height * (minSize + sizeScale * fftFilter[i]);
    PVector center = new PVector(width * (fftFilter[i] * 0.2), 0);
    center.rotate(millis() * spin + i * radiansPerBucket);

    {
      color rgb = colors.get(int(map(i, 0, fftFilter.length-1, 0, colors.width-1)), colors.height/4);
      tint(rgb, fftFilter[i] * opacity);
      blendMode(ADD);
      image(dot, center.x - size/2 + width * 0.25,
        center.y - size/2 + height * 0.5, size, size);
    }

    {
      color rgb = colors.get(int(map(i, 0, fftFilter.length-1, 0, colors.width-1)), colors.height*3/4);
      tint(rgb, fftFilter[i] * opacity);
      blendMode(ADD);
      image(dot, center.x - size/2 + width * 0.75,
        center.y - size/2 + height * 0.5, size, size);
    }
  }
}

