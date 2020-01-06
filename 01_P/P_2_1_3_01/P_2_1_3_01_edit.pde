float tileCountX = 10;
float tileCountY = 10;
float tileWidth, tileHeight;

int count = 0;
int colorStep = 30;
int circleCount;
float endSize, endOffset;

int actRandomSeed = 37;

enum Direction { NORTH, EAST, SOUTH, WEST };

Direction dir = Direction.SOUTH;
float posX, posY, posXCross, posYCross;
float angleCount = 7;
float angle = getRandomAngle(dir);
float stepSize = 3; 
int minLength = 10;

int dWeight = 50;
float dStroke = 1.5;

void setup() { 
  size(800, 800);
  tileWidth = width / tileCountX;
  tileHeight = height / tileCountY;
  rectMode(CENTER);
  colorMode(HSB, 360, 100, 100);
  
  posX = 0;
  posY = 5;
  posXCross = posX;
  posYCross = posY;
  
  background(360);
  strokeCap(ROUND);
  
  drawCircleMatrix();
} 


void draw() { 
 
  for(int i = 0; i <= mouseX; i++) {
    strokeWeight(1);
    stroke(180);
    
    posX += cos(radians(angle)) * stepSize;
    posY += sin(radians(angle)) * stepSize;
    
    boolean reachedBorder = false;
    
    if (posY <= 5) {
      dir = Direction.SOUTH;
      reachedBorder = true;
    }
    else if (posX >= width - 5) {
      dir = Direction.WEST;
      reachedBorder = true;
    }
    else if (posY >= height - 5) {
      dir = Direction.NORTH;
      reachedBorder = true;
    }
    else if (posX <= 5) {
      dir = Direction.EAST;
      reachedBorder = true;
    }
    
    int px = (int) posX;
    int py = (int) posY; 
    // get(px, py) != color(360)
    if (get(px, py) != color(360) || reachedBorder) {
      angle = getRandomAngle(dir);
      float distance = dist(posX, posY, posXCross, posYCross);
      if (distance >= minLength) {
        strokeWeight(distance / dWeight);
        if ((int) random(0, 3) > 1) stroke(360, 100, distance/dStroke);
        else stroke(240, 100, distance/dStroke);
        line(posX, posY, posXCross, posYCross);
      }
      posXCross = posX;
      posYCross = posY;
    }
  }
}


void drawCircleMatrix () {
  // set up each circle as a stroke w/ no fill
  // noFill();
  noStroke();
  background(360); 
  randomSeed(actRandomSeed);

  // translate grid for offset to origin of the first circle (moving 0,0);
  translate((width/tileCountX)/2, (height/tileCountY)/2);

  
  //circleCount = mouseX / 30 + 1; // add circles as we move to the right
  //endSize = map(mouseX, 0, width, tileWidth / 3.0, 0); // as we move to right circles shrink
  //endOffset = map(mouseY, 0, height, 0, (tileWidth - endSize) / 2); // offset circle in the direction of the tile
  
  circleCount = 30;
  endSize = 2.0;
  endOffset = (tileWidth - endSize) / 2;

  // for each memeber of grid
  for (int y = 0; y <= tileCountY; y++) {
    for (int x = 0; x <= tileCountX; x++) {
      pushMatrix();
      // translate origin to 
      translate(tileWidth * x, tileHeight * y);
      // scale y by height / width
      scale(1, tileHeight / tileWidth);
      
      int toggle = (int) random(0,4);
      if (toggle == 0) rotate(-HALF_PI);
      if (toggle == 1) rotate(0);
      if (toggle == 2) rotate(HALF_PI);
      if (toggle == 3) rotate(PI);
      
      // create smaller circles until we hit endSize diampeter
      for (int i = 0; i < circleCount; i++) {
        float diameter = map(i, 0, circleCount, tileWidth, endSize);
        float offset = map(i, 0, circleCount, 0, endOffset);
        fill(360 - (i * colorStep), i / 7);
        
        //color c = lerpColor(color(#FFFFFF), color(#000000), (float) i / circleCount);
        //fill(c);
        ellipse(offset, 0, diameter, diameter);
      }
      popMatrix();
    }  
  }
}

void mouseClicked() {
  actRandomSeed = (int)random(10000);
  println(actRandomSeed);
}

float getRandomAngle(Direction dir) {
  float a = (floor(random(-angleCount, angleCount)) + 0.5) * 90.0 / angleCount;
  
  if (dir == Direction.NORTH) return a - 90;
  if (dir == Direction.EAST) return a;
  if (dir == Direction.SOUTH) return a + 90;
  if (dir == Direction.WEST) return a + 180;
  
  return 0;
}

void keyReleased () {
  if (key == 's' || key == 'S') saveFrame();
}