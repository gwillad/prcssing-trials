int[][] balls; 
int displayWidth = 1000;
int displayHeight = 460;
int ballCount = 50;

void setup() {
  size(displayWidth, displayHeight);
  frameRate(60);

  balls = new int[ballCount][5];

  for (int i = 0; i < ballCount; i++) {
    int columnWidth = displayWidth/ballCount;
    balls[i][0] = (i*columnWidth)+columnWidth/2;
    balls[i][1] = getRandomY();
    balls[i][2] = getRandomDirection();
    balls[i][3] = getRandomRadius();
    balls[i][4] = getRandomDirection();
  }
}

int getRandom(int i) {
  return floor(random(i));
}

int getRandomY() {
  return getRandom(displayHeight);
}

int getRandomRadius() {
  return getRandom(displayWidth/ballCount);
}

int getRandomDirection() {
  if (random(1) > .5) {
    return -1;
  }
  return 1;
}

void swapDir(int i, int j) { 
  balls[i][j] = -balls[i][j];
}

void moveAspect(int ballIndex, int aspectIndex, int directionIndex, int lowerBound, int upperBound) {
    balls[ballIndex][aspectIndex] += balls[ballIndex][directionIndex];
    if (balls[ballIndex][aspectIndex] <= lowerBound) {
      swapDir(ballIndex,directionIndex);
      balls[ballIndex][aspectIndex] = lowerBound + 1;
    } else if (balls[ballIndex][aspectIndex] >= upperBound) {
      swapDir(ballIndex,directionIndex);
      balls[ballIndex][aspectIndex] = upperBound - 1;
    }
}

void move() {
  for (int i = 0; i < balls.length; i++) {
    // move direction
    moveAspect(i, 1, 2, 0, displayHeight);
    
    // move radius
    if (frameCount % 2 == 0) {
      moveAspect(i, 3, 4, 1, displayWidth/ballCount);
    }
  }
}

void render() {
  for (int i = 0; i < balls.length; i++) {
    ellipse(balls[i][0], balls[i][1], balls[i][3], balls[i][3]);
  }
}

void draw() {
  background(0);
  move();
  render();
}
