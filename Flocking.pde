import java.util.Arrays;

PVector mouse = new PVector();
int width = 1000;
int height = 700;

ArrayList<Bird>[] flocks = new ArrayList[4];
int[] flockIndices = new int[flocks.length];

Bird[][] space = new Bird[width + 1][height + 1];
ArrayList<Integer>[] destroyLists = new ArrayList[flocks.length];
//int debugWaitTime = 100;
//ArrayList<Integer>[] debugLists = new ArrayList[flocks.length]; 

ArrayList<Explosion> explosions = new ArrayList<Explosion>();
int removeCount;

ScrollBar[] bars = new ScrollBar[5];
String[] bartitles = {"Cohere", "Avoid", "Align", "Max Speed", "Max Steering"};
Button[] buttons = new Button[7];
String[] buttontitles = {"Collide", "Smash", "Random Coordinates", "Follow", "Ripple", "Pause", "Change"};
int[] nextLine = {1, 0, 1, 1, 0, 1, 0};

float[] variables = new float[bars.length];

void setup() {
  size(1000, 700);
  for (int i = 0; i < flocks.length; i++) {
    flocks[i] = new ArrayList<Bird>();
  }
  
  for (int i = 0; i < destroyLists.length; i++) {
    destroyLists[i] = new ArrayList<Integer>();
  }
  
  for (int i = 0; i < bars.length; i++) {
    bars[i] = new ScrollBar(25, 50+i*50, 150, 15, bartitles[i]);
  }
  
  int lines = 0;
  int line = 0;
  for (int i = 0; i < buttons.length; i++) {
    lines += nextLine[i];
    line ++; line -= nextLine[i]*line;
    buttons[i] = new Button(33+line*50, lines*50 + bars.length*50, 15, 15, buttontitles[i]);
  }
  ellipseMode(RADIUS);
}
void addBird(int f, float x, float y) {
  flocks[f].add(new Bird(f, x, y, flockIndices[f]++));
}
void addNewBird(int f, float x, float y) {
  flocks[f].add(new newBird(f, x, y, flockIndices[f]++));
}
void addExplosion(int f, PVector loc) {
  explosions.add(new Explosion(loc, f));
}

/**********************************************************************************/

void draw() {
  mouse.set(mouseX, mouseY);
  background(50);
  strokeWeight(3);
  for (int i = 0; i < bars.length; i++) {
    bars[i].run();
  }
  for (int i = 0; i < buttons.length; i++) {
    buttons[i].run();
  }
  
  variables[0] = map(bars[0].position(), 0, 1, 0, 2.5);
  variables[1] = map(bars[1].position(), 0, 1, 0, 2.5);
  variables[2] = map(bars[2].position(), 0, 1, 0, 2.5);
  variables[3] = map(bars[3].position(), 0, 1, 0, 15);
  variables[4] = map(bars[4].position(), 0, 1, 0, .4);
  
  if (!buttons[5].pressed) {
    for (int i = 0; i < flocks.length; i++) {
      ArrayList<Bird> flockToDraw = flocks[i];
      if (flockToDraw.size() > 0) {
        flockToDraw.get(0).displayColor();
      }
      for (Bird b : flockToDraw) {
        b.display();
        b.flock();
        b.update();
      }
    }
  } else {
    for (int i = 0; i < flocks.length; i++) {
      ArrayList<Bird> flockToDraw = flocks[i];
      if (flockToDraw.size() > 0) {
        flockToDraw.get(0).displayColor();
      }
      for (Bird b : flockToDraw) {
        b.display();
      }
    }
  }
  fill(255);
  for (int i = 0; i < destroyLists.length; i++) {
    ArrayList<Integer> listToDestroy = destroyLists[i];
    for (int j = 0; j < listToDestroy.size(); j++) {
      addExplosion(0, new PVector(width - 100, height - 100));
      int removeIndex = findBird(i, listToDestroy.get(j), flocks[i].size());
      flocks[i].get(removeIndex).leave();
      flocks[i].remove(removeIndex);
    }
    destroyLists[i] = new ArrayList<Integer>();
  }
  strokeWeight(1);
  fill(0, 0, 0, 0);
  for (Explosion e : explosions) {
    e.boom();
  }
  for (int i = 0; i < removeCount; i++) {
    explosions.remove(0);
  }
  removeCount = 0;
  fill(255);
  for (int i = flocks.length - 1; i >= 0; i--) {
    text(flocks[i].size(), 25, height - 25 - i*25);
  }
}

/**********************************************************************************/

int findBird(int flock, int target, int range) {
  int max = range;
  int min = 0;
  int checkPoint = (max + min)/2;

  for (int i = 0; i < range/2 + 1; i++) {
    int attempt = flocks[flock].get(checkPoint).flockIndex;
    if (attempt != target) {
      if (attempt < target) {
        min = checkPoint;
      } else {
        max = checkPoint;
      }
    } else {
      return checkPoint;
    }
    checkPoint = (max + min)/2;
    
    attempt = flocks[flock].get(checkPoint).flockIndex;
    if (attempt != target) {
      if (attempt < target) {
        min = checkPoint;
      } else {
        max = checkPoint;
      }
    } else {
      return checkPoint;
    }
    checkPoint = (max + min)/2;
    if (checkPoint == min) {
      checkPoint++;
    }
  }
  return range;
}

/**********************************************************************************/

void keyPressed() {
  
  if (!buttons[6].pressed) {
      int r = (int)random(flocks.length);
      if (r == flocks.length) { r -= 1; }
      for (int i = 0; i < 10; i++) {
        addNewBird(r, giveX(), giveY());
      }
    }
  } else {
    if (key > '0' && key < '6') {
      int newLength = key - 49;
      if (newLength == flocks.length) {
        return;
      } else if (newLength < flocks.length) {
        ArrayList<Bird>[] oldFlocks = flocks;
        flocks = new ArrayList[key - 49];
        for (int i = newLength; i < flocks.length; i++) {
          for (Bird b : flocks[i]) {
            b.dead = true;
            b.leave();
          }
        }
        for (int i = 0; i < newLength; i++) {
          flocks[i] = oldFlocks[i];
        }
      } else {
        ArrayList<Bird>[] oldFlocks = flocks;
        flocks = new ArrayList[key - 49];
        for (int i = 0; i < oldFlocks.length; i++) {
          flocks[i] = oldFlocks[i];
        }
        for (int i = oldFlocks.length; i < newLength; i++) {
          flocks[i] = new ArrayList<Bird>();
        }
      }
    }
  }
  
  if (key == '0') {
    for (int i = 0; i < flocks.length; i++) {
      flocks[i] = new ArrayList<Bird>();
      flockIndices[i] = 0;
    }
    space = new Bird[width + 1][height + 1];
    
    explosions = new ArrayList<Explosion>();
  }
}

/**********************************************************************************/

float giveX() {
  if (buttons[2].pressed) { return random(width); }
  return mouseX;
}
float giveY() {
  if (buttons[2].pressed) { return random(height); }
  return mouseY;
}
