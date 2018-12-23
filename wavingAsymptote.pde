float X,Y;
float t;
float pX, pY;
int n=20;

void setup(){
  background(255);
  size(800,600);
  line(0, height-30, width, height-30);
  line(30, 0, 30, height);
  frameRate(3600);
}

void draw(){
  stroke(0);
  t=t+0.01;
  X=t+ cos(14*t)/t;
  Y=t+ sin(14*t)/t;
  
  strokeWeight(1);
  point(30+n*X,height-30-n*Y);
  strokeWeight(1);
  stroke(0,200);
  line(30+n*X,height-30-n*Y,30+n*pX,height-30-n*pY);
  pX=X;
  pY=Y;
}
