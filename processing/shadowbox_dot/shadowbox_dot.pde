// A glowing dot you can move with the mouse cursor.
// Many small LEDs act in unison to make a large virtual flashlight.
// The texture of the light as it moves comes from a "dot" image,
// handcrafted in Photoshop to have the desired softness.

OPC opc;
PImage dot;

void setup()
{
  size(500, 500);
  
  opc = new OPC(this, "127.0.0.1", 7890);
  dot = loadImage("gray-dot.png");

  int spacing = 12;               // Number of pixels per LED in strips
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

  // Outer dim blue dot
  colorDot(mouseX, mouseY, 70, 40, 70, 400);

  // Inner bright yellowish dot
  colorDot(mouseX, mouseY, 20, 95, 90, 100);
}

