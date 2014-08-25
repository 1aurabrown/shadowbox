void boxSetup(PGraphics top, PGraphics bottom)
{
  frameRate(15);
}

void boxDraw(PGraphics top, PGraphics bottom)
{
  top.beginDraw();
  top.background(constrain(mouseX*2,0,255));
  top.endDraw();
  
  bottom.beginDraw();
  bottom.background(constrain(mouseY*2,0,255));
  bottom.endDraw();
}

