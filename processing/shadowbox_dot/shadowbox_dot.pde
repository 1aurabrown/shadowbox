PImage dot, colorDot;

void boxSetup(PGraphics top, PGraphics bottom)
{
  dot = loadImage("dot.png");
  colorDot = loadImage("color-dot.png");
}

void boxDraw(PGraphics top, PGraphics bottom)
{
  int size = 200;
  
  float x = mouseX - topScreenOrigin.x - size/2;
  float y = mouseY - topScreenOrigin.y - size/2;

  top.beginDraw();
  top.background(0);
//  top.image(colorDot, x, y, size, size);
  top.endDraw();

  bottom.beginDraw();
  bottom.background(0);
  bottom.image(dot, x, y, size, size);
  bottom.endDraw();
}

