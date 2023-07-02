//Locks mouse into place
void lockMouse() {
  if (!mouseLock) {
    oldMouse = new PVector(mouseX, mouseY);
    offsetX = mouseX - width/2;
    offsetY = mouseY - height/2;
  }
  mouseLock = true;
}

//unlocks mouse
void unlockMouse() {

  if (mouseLock) {
    r.warpPointer((int) oldMouse.x, (int) oldMouse.y);
  }
  mouseLock = false;
}

//opens menu
void keyPressed()
{
  if (keyCode >= 0 && keyCode < 256) {
    keys[keyCode] = true;
  }
  if (keyDown('P'))
  {
    updateMenu();
  }
}

void keyReleased() {
  if (keyCode >= 0 && keyCode < 256) {
    keys[keyCode] = false;
  }
}

boolean keyDown(int key) {
  return keys[key];
}

//Menu buttons
void mousePressed()
{
  if(settings)
  {
    hitSound(4);
    preformAction();
  }
  if (mouseButton == RIGHT)
  {
    Sensitivity /= 2;
  }
}

//Zoomer effect
void mouseReleased()
{
  if (mouseButton != LEFT)
  {
    zoomer = -.25;
    Sensitivity *= 2;
  }
}
