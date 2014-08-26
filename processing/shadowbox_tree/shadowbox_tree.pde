// Create a procedural animation, reminiscent of a tree.
// This is actually a very simple fractal, created using recursion

OPC opc;
PImage dot;

int sizeLimit = 90;          // Increase this if it runs too slowly
float animationRate = 0.1;   // How quickly to change animation parameters
float brightness = 20;

float paramX = 0;            // Parameter changed with X/Y coordinate of mouse
float paramY = 0;

void setup()
{
  size(400, 400);
  
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
}

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

void recursiveTree(float x, float y, float angle, float size, float hue)
{
  if (size < sizeLimit) {
    return;
  }

  float z = size * 0.2;
  float xStep = sin(angle) * z;
  float yStep = cos(angle) * -z;

  x += xStep;
  y += yStep;
  colorDot(x, y, hue % 100, 50, brightness, size);
  
  x += xStep;
  y += yStep;
  colorDot(x, y, hue % 100, 50, brightness, size);
  
  float s = radians(paramX);
  float t = radians(paramY);

  recursiveTree(x, y, angle + s + t, size * 0.76, hue + 5);
  recursiveTree(x, y, angle - s + t, size * 0.76, hue - 5);
}

void draw()
{
  // Smoothly animate parameters
  paramX = paramX + (mouseX - paramX) * animationRate;
  paramY = paramY + (mouseY - paramY) * animationRate;

  background(0);

  recursiveTree(width/2, height, 0, width * 0.75, paramY);  
}

