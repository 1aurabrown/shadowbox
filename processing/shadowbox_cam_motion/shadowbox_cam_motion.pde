// Let us explore an image as if it's another world behind the lights,
// using a camera that amplifies every small motion into a journey.
// Inspired by the technique used in Ecstatic Epiphany.
//
// The camera tracking uses SpeedyEye and the Playstation Eye camera.
// Run SpeedyEye first, and put its tracking file in this sketch's "data" folder.

import java.io.*;
import java.nio.*;
import java.nio.channels.*;

OPC opc;
PImage world;
MappedByteBuffer mapping;
float smoothMotionX, smoothMotionY;

void setup()
{
  size(640, 480);
  world = loadImage("world.jpg");

  // The tracking buffer is a file on disk that, when we "map" it into memory,
  // allows us to access the same memory that the SpeedyEye app is writing to.

  try {
    FileChannel fc = new RandomAccessFile(dataFile("tracking-buffer.bin"), "rw").getChannel();
    mapping = fc.map(FileChannel.MapMode.READ_WRITE, 0, fc.size());
    mapping.order(ByteOrder.LITTLE_ENDIAN);
  } catch (IOException e) {
    println(e);
    assert(false);
  }
  
  // Initialize our filter with the current motion totals. This is optional, but without these
  // lines the filter will 'rubber-band' to the current position slowly when you run the sketch.
  
  smoothMotionX = mapping.getFloat(0);
  smoothMotionY = mapping.getFloat(4);

  // Set up the LEDs!

  opc = new OPC(this, "127.0.0.1", 7890);
  int spacing = 16;               // Number of pixels per LED in strips
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

void draw()
{
  // Read the total motion from the buffer's header
  // (To see what else is in the buffer, check out the SpeedyEye source. You can
  // get image RGB data, and all individual tracking points for each frame.)

  float totalX = mapping.getFloat(0);
  float totalY = mapping.getFloat(4);
 
  // Filter and magnify the motion

  float zoom = -10.0;
  float filterRate = 0.1;

  smoothMotionX += (totalX - smoothMotionX) * filterRate; 
  smoothMotionY += (totalY - smoothMotionY) * filterRate; 
 
  // Wrap around at the edges of our 'world' image
 
  float pixelX = (smoothMotionX * zoom) % world.width;
  if (pixelX < 0) pixelX += world.width;

  float pixelY = (smoothMotionY * zoom) % world.height;
  if (pixelY < 0) pixelY += world.height;

  // Tile the image

  clear();
  for (int x = -1; x <= 0; x++) {
    for (int y = -1; y <= 0; y++) {
      image(world, pixelX + x * world.width, pixelY + y * world.height, world.width, world.height);
    }
  }
}

