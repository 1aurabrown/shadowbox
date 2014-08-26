// Some real-time FFT! This visualizes music in the frequency domain using a
// polar-coordinate particle system. Particle size and radial distance are modulated
// using a filtered FFT. Color is sampled from an image.

import ddf.minim.analysis.*;
import ddf.minim.*;

OPC opc;
PImage dot;
PImage colors;
Minim minim;
AudioPlayer music;
FFT fft;
float[] fftFilter;

float spin = 0.0002;
float radianStep = radians(35);
float decay = 0.95;
float opacity = 200;
float minSize = 0.3;
float maxSize = 2.0;
float gain = 0.5;
float radiusScale = 0.12;
float maxRadius = 0.5;
float sizeScale = 0.4;

void setup()
{
  size(250, 250);

  minim = new Minim(this); 
  music = minim.loadFile("iSE - Chilled As A Spider.mp3", 512);
  music.loop();
  fft = new FFT(music.bufferSize(), music.sampleRate());
  fftFilter = new float[fft.specSize()];

  dot = loadImage("ring.png");
  colors = loadImage("colors.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  int spacing = 10;               // Number of pixels per LED in strips
  float radius = spacing * 6.7;   // Distance from strip to center
    
  // Make the front ring of LEDs in a large square
  opc.ledStrip(64*0 + 13*0, 13, width/2 - radius, height/2, spacing, radians(-90), false);
  opc.ledStrip(64*0 + 13*1, 13, width/2, height/2 - radius, spacing, radians(0), false);
  opc.ledStrip(64*0 + 13*2, 13, width/2 + radius, height/2, spacing, radians(90), false);
  opc.ledStrip(64*0 + 13*3, 13, width/2, height/2 + radius, spacing, radians(180), false);

  // Now the back ring, in a smaller inset square
  spacing = spacing / 2;
  radius = radius / 2;
  opc.ledStrip(64*1 + 13*0, 13, width/2 - radius, height/2, spacing, radians(-90), false);
  opc.ledStrip(64*1 + 13*1, 13, width/2, height/2 - radius, spacing, radians(0), false);
  opc.ledStrip(64*1 + 13*2, 13, width/2 + radius, height/2, spacing, radians(90), false);
  opc.ledStrip(64*1 + 13*3, 13, width/2, height/2 + radius, spacing, radians(180), false);  
}

void colorDot(float x, float y, color c, float size)
{
  blendMode(ADD);
  tint(c);
  
  image(dot, x - size/2, y - size/2, size, size); 
  
  noTint();
  blendMode(NORMAL);
}

void draw()
{
  background(0);

  fft.forward(music.mix);
  for (int i = 0; i < fftFilter.length; i++) {
    fftFilter[i] = max(fftFilter[i] * decay, log(1 + gain * fft.getBand(i)));
  }
 
  int bucket = 1;
  int number = 0;
  while (bucket < fftFilter.length) {

    float intensity = fftFilter[bucket];
    float size = height * min(maxSize, (minSize + sizeScale * intensity));
    PVector center = new PVector(width * min(maxRadius, intensity * radiusScale), 0);
    center.rotate(millis() * spin + number * radianStep);

    color c = colors.get(int(map(number, 0, 8, 0, colors.width-1)), 0);
    colorDot(center.x + width/2, center.y + height/2, c, size);
    
    number = number + 1;
    bucket = bucket * 2;
  }
}

