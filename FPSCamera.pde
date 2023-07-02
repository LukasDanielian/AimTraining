class FPSCamera 
{
  public float yaw, pitch;
  public float x = -width/2;
  public float y = -height+200;
  public float z = 0;
  
  void apply(PGraphics c, float zoom) 
  {
    if (!c.is3D()) return;
    PVector view = getViewDirection();
    c.perspective(PI/zoom, float(width)/height, 0.01, 10000);
    c.camera(view.x, view.y, view.z, 0,0,0, 0, 1, 0);
    c.translate(x, y, z);
  }
  PVector getViewDirection() {
    return new PVector(cos(yaw) * cos(pitch), sin(pitch), sin(yaw) * cos(pitch));
  }
}
