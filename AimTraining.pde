import com.jogamp.newt.opengl.GLWindow;
import processing.sound.*;

float speed = 5;

void setup()
{
  fullScreen(P3D);
  frameRate(144);
  rectMode(CENTER);
  elimSound = new SoundFile(this, "elimSound.wav");
  hitSound = new SoundFile(this, "hitSound.wav");
  cam = new FPSCamera();
  r=(GLWindow)surface.getNative();
  mouseLock = false;
  Sensitivity = 0.001;
  oldMouse = new PVector(mouseX, mouseY);
  keys = new boolean[256];
  eSize = 50;
  lockMouse();
  settings = false;
  newEnemys();
  makeButtons();
  close = new Button(width/2 + width * .375, height/2 - height * .375, 50, 50, #FF0000, "X");
  updateLables();
}

void draw()
{
  // mouse shenanigans
  if (!focused && mouseLock) {
    unlockMouse();
  }
  if (mouseLock) {
    // camera code here
    cam.yaw += (mouseX-offsetX-width/2.0)*Sensitivity;
    cam.pitch -= (mouseY-offsetY-height/2.0)*Sensitivity;
    r.setPointerVisible(false); //When locked and trying to move, the pointer jerks all over the place, so best to hide it.
    r.warpPointer(width/2, height/2); //Move it to the exact center of the sketch window.
    r.confinePointer(true); //Locks pointer inside of the sketch's window so it doesn't escape.
  } else {
    r.confinePointer(false);
    r.setPointerVisible(true);
  }
  offsetX=offsetY=0;
  cam.pitch = constrain(cam.pitch, -HALF_PI + 0.0001, HALF_PI- .0001); // glitchyness near 90 degrees
  cam.apply(g, zoom);
  view = cam.getViewDirection();

  background(0);

  spotLight(255, 255, 255, -cam.x, -cam.y, -cam.z, -view.x, -view.y, -view.z, PI/2, 1);
  spotLight(150, 150, 150, 0, -height, 0, 0, 1, 0, PI/2, 1);

  //ROOM
  renderBox(1, height, width*2, -width/2, height/2, 0);
  renderBox(1, height, width*2, width * 1.5, height/2, 0);
  renderBox(width*2, 1, width*2, width/2, height, 0);
  renderBox(width*2, 1, width*2, width/2, 0, 0);
  renderBox(width*2, height, 1, width/2, height/2, -width);
  renderBox(width*2, height, 1, width/2, height/2, width);



  translate(-cam.x, -cam.y, -cam.z);

  //Renders all enemys
  for (int i = 0; i < enemys.size(); i++)
  {
    enemys.get(i).render();
  }


  hint(DISABLE_DEPTH_TEST);
  for (Enemy e : enemys) {
    e.renderOnTop();
  }
  hint(ENABLE_DEPTH_TEST);


  //Hit scan and zooming
  if (mousePressed)
  {
    if (mouseButton == LEFT && !settings)
    {
      cam.pitch+=recoil;
      int numHit = 0;
      for (int i = 0; i < enemys.size(); i++)
      {
        if (enemys.get(i).sphereRayCol(0, 0, 0, view.x, view.y, view.z))
        {
          hitSound(1);
          numHit++;
          enemys.get(i).updateHealth();
          effectTime = 1;
          if (enemys.get(i).health <= 0)
          {
            elimSound.play(1, .5, volume*10);
            enemys.remove(i);
            enemys.add(new Enemy(eSize));
          }
        }
      }
      if (numHit == 0)
      {
        hitSound(2);
      }
    } else if (mouseButton == RIGHT)
    {
      zoomer = .25;
    }
  }
  zoom += zoomer;
  if (zoom >= maxZoom)
  {
    zoom = maxZoom;
  } else if (zoom <= 3)
  {
    zoom = 3;
  }

  if (keyPressed)
  {
    if (keyDown('W'))
    {
      cam.x += view.x * speed;
      cam.z += view.z * speed;
    }
    if (keyDown('S'))
    {
      cam.x -= view.x * speed;
      cam.z -= view.z * speed;
    }
    if (keyDown('A'))
    {
      cam.x += cos(cam.yaw - PI/2) * cos(cam.pitch) * speed * 2;
      cam.z += sin(cam.yaw - PI/2) * cos(cam.pitch) * speed * 2;
    }
    if (keyDown('D'))
    {
      cam.x -= cos(cam.yaw - PI/2) * cos(cam.pitch) * 10;
      cam.z -= sin(cam.yaw - PI/2) * cos(cam.pitch) * 10;
    }
  }

  if (cam.x <= width * -1.5 + 50)
  {
    cam.x = width * -1.5 + 50;
  }
  if (cam.x > width/2 - 50)
  {
    cam.x = width/2 - 50;
  }
  if (cam.z >= width - 50)
  {
    cam.z = width - 50;
  }
  if (cam.z < -width + 50)
  {
    cam.z = -width + 50;
  }

  //ON Screen 2D effects
  pushMatrix();
  hint(DISABLE_DEPTH_TEST);
  rectMode(CENTER);
  camera();
  ortho();

  if (settings)
  {
    renderMenu();
  } else
  {
    stroke(255, 0, 0);
    strokeWeight(1);
    rect(width/2, height/2, 1, 15);
    rect(width/2, height/2, 15, 1);
    noFill();
    strokeWeight(2);
    ellipse(width/2, height/2, 25, 25);
  }

  textAlign(LEFT, TOP);
  fill(255);
  textSize(25);
  text("FPS: " + frameRate, 5, 5);

  textAlign(CENTER, CENTER);
  text("Settings: 'P'", width/2, 25);

  if (effectTime > 0)
  {
    noFill();
    stroke(255, 0, 0);
    pushMatrix();
    translate(width/2, height/2);
    rotate(QUARTER_PI);
    for (int i = 0; i < 4; i++)
    {
      rotate(HALF_PI);
      rect(0, -30, 1, 15);
    }
    popMatrix();
    effectTime--;
  }

  hint(ENABLE_DEPTH_TEST);
  popMatrix();
}
