class Explosion {
  final PVector loc;
  final float range = 20;
  float size = 0;
  int r = 0;
  int g = 0;
  int b = 0;
  
  Explosion(PVector loc, int flock) {
    this.loc = new PVector(loc.x, loc.y);
    switch (flock) {
    case 0:
      r = 255;  g = 255;  b = 255;
      break;
    case 1:
      g = 255;
      break;
    case 2:
      r = 255;
      break;
    case 3:
      b = 255;
    }
  }
  
  void boom() {
    size += .5;
    stroke(r, g, b);
    for (int i = 0; i < 5; i++) {
      
      if (size - i > 0 && size - i < range) {
        ellipse(loc.x, loc.y, size - i, size - i);
      }
    }
    if (size >= range + 4) {
      removeCount++;
    }
  }
}