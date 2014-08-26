// Two glowing orbs orbiting at different speeds, causing a periodic beat to emerge.
//
// This is an example for using the Open Sound Control (OSC) protocol to integrate
// LED patterns written in Processing with other software like Max/MSP or TouchOSC.
//
// This example creates an OSC server listening on UDP port 12000.
// There are some parameters that control two orbiting particles:
//
//     /dot1/rpm            Rotation speed, in revolutions per minute
//     /dot1/radius         Distance from the center, as a proportion of window size
//     /dot1/size           Size of the dot image, as a proportion of the window size
//     /dot1/hue            Hue of the dot image, from 0 to 100
//     /dot1/brightness     Brightness of the dot, from 0 to 100
//
//     /dot2/...            Another dot
//
// This example requires the "oscP5" library. You can install it with the menu
//   Sketch -> Import Library... -> Add Library...
//
// Read more about Max/MSP, OSC, and Processing:
//   http://www.conceptualinertia.net/aoakenfo/sketch-1

import oscP5.*;

OPC opc;
PImage dot;
OscP5 oscP5;
int lastMillis;

// A place to store settings, and we'll define their default values

float dot1_rpm = 28;
float dot1_size = 2.0;
float dot1_brightness = 70;
float dot1_hue = 15;
float dot1_angle = 0;

float dot2_rpm = 29;
float dot2_size = 3.0;
float dot2_brightness = 50;
float dot2_hue = 80;
float dot2_angle = 0;

void setup()
{
  size(300, 300);
  
  opc = new OPC(this, "127.0.0.1", 7890);
  dot = loadImage("gray-dot.png");

  int spacing = 20;               // Number of pixels per LED in strips
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

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  // Connect OSC message names to function names
  oscP5.plug(this, "set_dot1_rpm",        "/dot1/rpm");
  oscP5.plug(this, "set_dot1_size",       "/dot1/size");
  oscP5.plug(this, "set_dot1_brightness", "/dot1/brightness");
  oscP5.plug(this, "set_dot1_hue",        "/dot1/hue");
  oscP5.plug(this, "set_dot2_rpm",        "/dot2/rpm");
  oscP5.plug(this, "set_dot2_size",       "/dot2/size");
  oscP5.plug(this, "set_dot2_brightness", "/dot2/brightness");
  oscP5.plug(this, "set_dot2_hue",        "/dot2/hue");
}

// Trivial functions that store dot parameters
void set_dot1_rpm(float x)        { dot1_rpm = x; }
void set_dot1_size(float x)       { dot1_size = x; }
void set_dot1_brightness(float x) { dot1_brightness = x; }
void set_dot1_hue(float x)        { dot1_hue = x; }
void set_dot2_rpm(float x)        { dot2_rpm = x; }
void set_dot2_size(float x)       { dot2_size = x; }
void set_dot2_brightness(float x) { dot2_brightness = x; }
void set_dot2_hue(float x)        { dot2_hue = x; }

// This is a function which knows how to draw a copy of the "dot" image with a color tint.
void colorDot(float x, float y, float hue, float saturation, float brightness, float size)
{
  blendMode(ADD);
  colorMode(HSB, 100);
  tint(hue, saturation, brightness);
  
  image(dot, x - size/2, y - size/2, size, size); 
  
  noTint();
  colorMode(RGB, 255);
  blendMode(NORMAL);
}

void draw()
{
  background(0);

  int thisMillis = millis();
  int elapsedTime = thisMillis - lastMillis;
  lastMillis = thisMillis;

  // Dot 1
  dot1_angle = (dot1_angle + elapsedTime * dot1_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius1 = 0.48;
  float x1 = width/2 + width * radius1 * cos(dot1_angle);
  float y1 = height/2 + width * radius1 * sin(dot1_angle);
  colorDot(x1, y1, dot1_hue, 80, dot1_brightness, width * dot1_size);
  colorDot(x1, y1, dot1_hue, 10, dot1_brightness, width * dot1_size * 0.25);

  // Dot 2
  dot2_angle = (dot2_angle + elapsedTime * dot2_rpm * (2 * PI / 60000)) % (2 * PI);
  float radius2 = 0.15;
  float x2 = width/2 + width * radius2 * cos(dot2_angle);
  float y2 = height/2 + width * radius2 * sin(dot2_angle);
  colorDot(x2, y2, dot2_hue, 80, dot2_brightness, width * dot2_size);
  colorDot(x2, y2, dot2_hue, 10, dot2_brightness, width * dot2_size * 0.25);
}

