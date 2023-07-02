class Button
{
  float x,y,w,h;
  int c;
  String text;
  
  public Button(float x, float y, float w, float h, int c, String text)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.text = text;
  }
  
  void render()
  {
    rectMode(CENTER);
    textAlign(CENTER,CENTER);
    
    fill(c);
    stroke(255);
    rect(x,y,w,h,15);
    
    fill(255);
    text(text,x,y);
  }
  
  boolean isClicked()
  {
    if(mousePressed && mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2)
    {
       return true;
    }
    return false;
  }
}

void makeButtons()
{
  float x;
  float y = height * .3;

  for(int i = 0; i < 3; i++)
  {
    x = width * .21;
    for(int j = 0; j < 4; j++)
    {
      buttons.add(new Button(x,y,100,50,#FF0000,"-"));
      x += 100;
      buttons.add(new Button(x,y,100,50,#16AA21,"+"));
      x += width/8;
    }
    y += height/6;
  }
}
