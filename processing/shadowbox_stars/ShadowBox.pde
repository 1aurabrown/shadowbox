/*
 * Common code for LED shadow boxes in the workshop,
 * Intro to Interactive Light Art.
 *
 * This file has two Processing "PGraphics" objects,
 * which are like virtual windows you can draw into.
 * These represent the top and bottom rings of LEDs,
 * making it easy to keep your drawing for each layer
 * separate.
 *
 * Using the Fadecandy "OPC" object, we will set up
 * a correspondence between each LED in our sculpure
 * and a pixel on the Processing window. These two
 * PGraphics objects are drawn to the window, and the
 * previously associated pixels are grabbed each frame
 * and sent to the Fadecandy hardware.
 *
 * In a compromise between simplicity and the desire to
 * "quilt" together multiple shadow boxes later, this
 * common code contains the Processing setup() and draw()
 * functions. It calls boxSetup() and boxDraw() functions,
 * which take the two PGraphics layers as parameters.
 *
 * Micah Elizabeth Scott, 2014
 * This file is released into the public domain.
 */


/*
 * Try not to refer to the variables here in your art, we might
 * need to change them later when we design light sculptures that
 * cooperate with each other.
 */

OPC opc;
PGraphics topGraphics, bottomGraphics;
PVector topScreenOrigin, bottomScreenOrigin;

// This function is called by Processing itself when you first "Run" the sketch.
void setup()
{
  // Establish how big things are
  size(220, 430, P2D);                             // Size of the processing window
  topGraphics = createGraphics(200, 200, P2D);     // Size of the top and bottom layers we draw to
  bottomGraphics = createGraphics(200, 200, P2D);
  
  // Where are things in our window?
  topScreenOrigin = new PVector(10, 10);
  bottomScreenOrigin = new PVector(10, 220);
  
  // Connect to the Fadecandy LED server, on this computer
  opc = new OPC(this, "127.0.0.1", 7890);

  // Turn off the small LED on the Fadecandy board. This light might be
  // distracting if it flickers into the area behind the shadow box.
  opc.setStatusLed(false);

  // Which LED are we starting with? Zero is the first output on the first Fadecandy board.
  int index = 0;
 
  // How are we positioning LEDs in the window?
  int spacing = 8;                // Number of pixels per LED in strips
  float radius = spacing * 6.7;   // Distance from strip to center
  
  // Calculate center position for the top layer
  float x = topScreenOrigin.x + topGraphics.width / 2;
  float y = topScreenOrigin.y + topGraphics.height / 2;
  
  // Make a square out of LED strips
  opc.ledStrip(index + 13*0, 13, x - radius, y, spacing, radians(-90), false);
  opc.ledStrip(index + 13*1, 13, x, y - radius, spacing, radians(0), false);
  opc.ledStrip(index + 13*2, 13, x + radius, y, spacing, radians(90), false);
  opc.ledStrip(index + 13*3, 13, x, y + radius, spacing, radians(180), false);

  // Now the position of the bottom layer
  x = bottomScreenOrigin.x + bottomGraphics.width / 2;
  y = bottomScreenOrigin.y + bottomGraphics.height / 2;
  index = index + 64;

  // Make another square just like the above. This could be a function if we wanted.  
  opc.ledStrip(index + 13*0, 13, x - radius, y, spacing, radians(-90), false);
  opc.ledStrip(index + 13*1, 13, x, y - radius, spacing, radians(0), false);
  opc.ledStrip(index + 13*2, 13, x + radius, y, spacing, radians(90), false);
  opc.ledStrip(index + 13*3, 13, x, y + radius, spacing, radians(180), false);

  // Now let the art do any setup that needs to happen once!
  boxSetup(topGraphics, bottomGraphics);
}

void draw()
{
  // Neutral background will serve as a border color after we've drawn the layer images.
  background(60);
  
  // Let the art update each layer
  boxDraw(topGraphics, bottomGraphics);

  // Draw layers
  image(topGraphics, topScreenOrigin.x, topScreenOrigin.y);
  image(bottomGraphics, bottomScreenOrigin.x, bottomScreenOrigin.y);
}

