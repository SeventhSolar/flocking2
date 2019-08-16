class ScrollBar {
  PVector loc;
  PVector size;
  PVector boxloc;
  PVector boxsize;
  String name;
  Boolean chosen;

  ScrollBar(float x, float y, float w, float h, String n) {
    loc = new PVector(x+w/2, y);
    size = new PVector(w, h);
    boxloc = loc.get();
    boxsize = new PVector(w/20, h);
    name = n;
    chosen = false;
  }

  void run() {
    overbox();
    drag();
    display();
  }

  void display() {
    rectMode(CENTER);
    noStroke();
    fill(255);
    text(name, loc.x-size.x/2, loc.y-size.y/2-5);
    fill(255, 50);
    rect(loc.x, loc.y, size.x, size.y);
    stroke(0);
    if (chosen) {
      fill(255, 0, 0, 150);
    }
    else {
      fill(255, 150);
    }
    line(loc.x-size.x/2, loc.y, loc.x + size.x/2, loc.y);
    rect(boxloc.x, boxloc.y, boxsize.x, boxsize.y);
  }

  void overbox() {
    if (mouseX > boxloc.x-boxsize.x/2 && mouseX < boxloc.x + boxsize.x/2 && mouseY > boxloc.y -boxsize.y/2 && mouseY < boxloc.y + boxsize.y/2) {
      chosen = true;
    }
    if (mouseY < boxloc.y - boxsize.y/2 || mouseY > boxloc.y + boxsize.y/2) {
      chosen = false;
    }
  }

  void drag() {
    if (mousePressed && chosen) {
      boxloc.x = mouseX;
      boxloc.x = constrain(boxloc.x, loc.x - size.x/2 + boxsize.x/2, loc.x + size.x/2 - boxsize.x/2);
    }
  }

  float position() {
    float pos = map(boxloc.x, loc.x - size.x/2 + boxsize.x/2, loc.x + size.x/2 - boxsize.x/2, 0, 1);
    return pos;
  }
}



class Button {
  PVector loc;
  PVector size;
  String name;
  boolean chosen;
  boolean down;
  boolean pressed;
  
  Button(float x, float y, float w, float h, String n) {
    loc = new PVector(x, y);
    size = new PVector(w, h);
    name = n;
    chosen = false;
    down = false;
    pressed = false;
  }
  
  void run() {
    overbutton();
    click();
    display();
  }
  
  void overbutton() {
    if (mouseX > loc.x-size.x/2 && mouseX < loc.x + size.x/2 && mouseY > loc.y -size.y/2 && mouseY < loc.y + size.y/2) {
      chosen = true;
    }
    else {
      chosen = false;
    }
  }
  
  void click() {
    if (chosen && mousePressed && !down) {
      pressed = !pressed;
      down = true;
    }
    if (!mousePressed) {
      down = false;
    }
  }
  
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(255);
    text(name, loc.x-size.x/2, loc.y-size.y/2-5);
    fill(255, 50);
    rect(loc.x, loc.y, size.x, size.y);
    stroke(0);
    if (pressed) {
      if (chosen) {
        fill(255, 0, 0);
      } else {
        fill(255, 0, 0, 150);
      }
    }
    else {
      if (chosen) {
        fill(255);
      } else {
        fill(255, 150);
      }
    }
    rect(loc.x, loc.y, size.x, size.y);
  }
}
