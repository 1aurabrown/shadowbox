// Play a video,
// mapping an outer ring of pixels to the top layer of LEDs,
// and an inner ring to the bottom layer of LEDs.
// This video is a blured slow-motion bicycle ride in San Francisco.
// Props to Jim Campbell.

import processing.video.*;

OPC opc;
Movie movie;

void setup()
{
  movie = new Movie(this, "bicycle.m4v");
  movie.loop();
  movie.read();

  // Make the window the same size as the movie (otherwise we would scale the movie)
  size(movie.width, movie.height);

  // The video is slow-mo, send the frames slowly so the Fadecandy can smoothly interpolate
  frameRate(14);

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
  if (movie.available()) {
    movie.read();
  }
  image(movie, 0, 0, width, height);
}

