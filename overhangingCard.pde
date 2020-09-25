int count;

int blockN=50;         //Amount of blocks to stack
int blockW=300;        //Width of blocks
int blockH=6;         //Height of blocks


FloatList px;
FloatList py;


void setup() {
  background(255);
  size(1200, 900);

  px = new FloatList();
  py = new FloatList();

  px.set(0, 0);
  py.set(0, 0);

  count=1;
}

void draw() {
  background(255);
  stroke(0);
  strokeWeight(1);
  line(0, height-30, width, height-30);
  line(30, 0, 30, height);

  px.set(count, A(count));
  py.set(count, py.get(count-1)+blockH);
  translate(30+px.get(count), height-30-py.get(count));
  stackBlock(count);
  countBlock(count);
  delay(20);
}


//Put a block at (-x, y) from the top block
void block(float x, float y) {
  fill(0);
  rectMode(CENTER);
  rect(-x+blockW/2, y-blockH/2, blockW, blockH-2);
}

//Stack blocks as many as 'count', starting from the bottom.
void stackBlock(int count) {
  for (int i=count; i>=0; i--) {
    block(px.get(i), py.get(i));
  }
}

float A(int n) {
  float An = px.get(n-1)+blockW/(2*n);
  return An;
}

void countBlock(int cnt) {
  if (cnt<=blockN) {
    count+=1;
  }
}
