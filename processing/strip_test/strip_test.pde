// Test one strip with 4 * 13 = 52 LEDs.
// A light will chase down the strip, and the last LED will flash green.

int numLeds = 52;

OPC opc;
PImage dot;

void setup()
{
  size(600, 150, P3D);

  // Load a grayscale picture of a fuzzy dot. We layer this image
  // and tint it with different colors to draw our scene for the LEDs.
  // This image helps define the "texture" of the light as it moves.
  dot = loadImage("gray-dot.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map one strip to the center of the window
  opc.ledStrip(0, numLeds, width/2, height/2, 8, 0, false);
}

void draw()
{
  background(0);

  // Have some dots race across the strip at different rates and periodically align,
  // producing a pulsating pattern that runs down the length of the strip. Each dot
  // is a different color of the rainbow, and when they merge the colors blend.

  float t = millis() * 0.008;
  float dotSize = width * 0.2;

  for (int number = 1; number < 20; number++) {
    float x = (t * number) % width;
    blendMode(ADD);
    colorMode(HSB, 100);
    tint((t + number * 2) % 100, 80, 20);
    image(dot, x - dotSize/2, height/2 - dotSize/2, dotSize, dotSize);
  }
  
  // Where is the last LED?

  int lastLocation = opc.pixelLocations[numLeds - 1];
  int lastX = lastLocation % width;
  int lastY = lastLocation / width;
  
  // Draw a little box around only the last LED, flashing green.

  blendMode(ADD);
  colorMode(RGB, 255);
  fill(0, 255, 0, sin(millis() * 0.008) * 175);
  rect(lastX - 2, lastY - 2, 5, 5);
}

