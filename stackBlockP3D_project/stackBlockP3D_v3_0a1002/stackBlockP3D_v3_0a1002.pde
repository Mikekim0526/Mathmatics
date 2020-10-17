//Set block size: 240 x 40 x 20
float blockLength = 240;
float blockHeight = 10;
float blockWidth = 40;
float blockLengthInc = blockLength*0.25;      //variable for coord test
float blockHeightInc = blockHeight*0.75;      //variable for coord test

int blockNum;              //Current block number to stack this time
int blockData;             //Highest index recorded in List px, py during the playtime 
int blockNumMax = 500;     //Endline of block to stack
float blockNumInc = 1;     //Control the block increment speed

//The storage to record reach of each block
FloatList px;
FloatList py;

//Graph Origin, Camera Eye level, Camera Center point
float gox, goy, goz;
float cex, cey, cez;
float ccx, ccy, ccz;
float cexMov, ceyMov, cezMov;
float ccxMov, ccyMov, cczMov;

void setup() {
  size(1200, 600, P3D);
  background(0);
  smooth();
  lights();
  //blendMode(LIGHTEST);

  camera(width/2,   0,         height/tan(PI/3), 
         width/2,   height/2,  0, 
         0,         1,         0);

  //Set the graph coordinate origin(0,0,0)==(gox, goy, goz), let not change while code
  gox=0;         goy=0;          goz=0;

  //Initialize Camera Eye level at (cex, cey, cez) of world coordinate xy-plane (regardless of graph) 
  //Default Camera Eye level: MIDDLE_TOP of image plane
  //Default AV(Angle of View): PI/3
  //cex=width/2;   cey=0;          cez=height/tan(PI/3);
  cex=blockLength/2;     cey=height-blockHeight/2;   cez=height/tan(PI/3);
  cexMov=0;              ceyMov=0;                   cezMov=0;

  //Initialize screen center(focus level) to (ccx, ccy, ccz) of world coordinate system (regardless of graph)
  //Default Center: Center of Image plane
  //ccx=width/2;   ccy=height/2;   ccz=0;
  ccx=blockLength/2;     ccy=height-blockHeight/2;   ccz=0;
  ccxMov=0;              ccyMov=0;                   cczMov=0;

  px = new FloatList();
  py = new FloatList();
  px.set(0, 0);
  py.set(0, 0);

  blockNum=1;
  blockData=0;
  newBlockData(blockNum);
}

void draw() {
  //To stack new blocks over blockData, calculate new block location data(px, py)
  if (blockNum>blockData) {
    newBlockData(blockNum);
  }

  //Before stack and blocks, display background environment
  moveCam();
  camera(cex, cey, cez,
         ccx, ccy, ccz,
         0,   1,   0);
  drawGround();

  stackBlock(blockNum);
  countBlock();
}

//=============================================================================
//================================F=U=N=C=T=I=O=N=S============================
//=============================================================================

//Using the recorded blockData(0 ~ Data), calculate new blocks(Data+1 ~ Num)
void newBlockData(int cnt) {
  for (int i=blockData; i<cnt; i++) {
    px.set(i+1, px.get(i)+blockLength/(2*i+2));
    py.set(i+1, py.get(i)+blockHeight);
    //px.set(i+1, i*blockLengthInc);
    //py.set(i+1, i*blockHeightInc);
  }
  blockData = cnt;
}

void moveCam() {
  //float pcex = cex;    float pcey = cey;    float pcez = cez;
  //float pccx = ccx;    float pccy = ccy;    float pccz = ccz;

  float cexInc;    float ceyInc;    float cezInc;
  float ccxInc;    float ccyInc;
  
  //cex=blockNum*blockLengthInc/2;   cey=height-blockNum*blockHeight/2;
  //ccx=blockNum*blockLengthInc/2;   ccy=height-blockNum*blockHeight/2;
  
  if (py.get(blockNum)>height*0.6) {
    cexInc = 1;
    ceyInc = 1;
    cezInc = 0;
    ccxInc = 1;
    ccyInc = 0.6;
    ccx = px.get(blockNum)/2;
    ccy = height - blockHeight*(5+blockNum*0.3);
    ccz = 0;
    cex = px.get(blockNum)/2 + cexMov;
    cey = height - blockHeight*(10+blockNum);
    cez = py.get(blockNum)/tan(PI/3);
  } else {
    cexInc = 0;
    ceyInc = 0.6;
    cezInc = 0;
    ccxInc = 0;
    ccyInc = 0.3;
    
    ccx = blockLength*1.5;
    ccy = height - blockHeight*(5+blockNum*0.3);
    ccz = 0;
    cex = blockLength*1.5;
    cey = height - blockHeight*(10+blockNum*0.6);
    cez = width/tan(PI/3);
  }
  
  ccx = px.get(blockNum)*ccxInc + blockLength*(1-ccxInc) +ccxMov;
  ccy = height - py.get(blockNum)*ccyInc - blockHeight*10*(1-ccyInc) +ccyMov;
  ccz = 0 + cczMov;
  cex = px.get(blockNum)*cexInc + blockLength*(1-cexInc) + cexMov;
  cey = height - py.get(blockNum)*ceyInc - blockHeight*10*(1-ceyInc) + ceyMov;
  cez = (py.get(blockNum)*cezInc + width*(1-cezInc))/tan(PI/3) + cezMov;


  if (mousePressed) {
    if (mouseX>width*0.8) {
      cexMov+= blockLength*(1+cexInc);
    } else if (mouseX<width*0.2) {
      cexMov-= blockLength*(1+cexInc);
    }

    if (mouseY<height*0.2) {
      ceyMov+= ceyInc;
    } else if (mouseY>height*0.8) {
      ceyMov-= ceyInc;
    }
  }

  println("No.", blockNum, "eye(", cex, cey, cez, ") /// focus=(", ccx, ccy, ccz, ")");

  //if(keyPressed){
  //  if(key == 'l'){
  //    cex+= cexInc;
  //    ccx+= cexInc;
  //    cey-= ceyInc;
  //    ccy-= ceyInc;
  //  } else if (key == 'h'){
  //    cex-= cexInc;
  //    ccx-= cexInc;
  //    cey+= ceyInc;
  //    ccy+= ceyInc;
  //  }
  //}
}

//Draw all the space and ground beneath the xz-plane, without any blocks 
void drawGround() {
  background(0);
  fill(80);

  beginShape(QUAD);
  vertex(-blockLength/2, height+blockHeight/2, height/tan(PI/6));
  vertex(-blockLength/2, height+blockHeight/2, -height/tan(PI/6));
  vertex(width, height+blockHeight/2, -height/tan(PI/6));
  vertex(width, height+blockHeight/2, height/tan(PI/6));
  endShape(CLOSE);
}

//Put a block at (x, y, z) to be the LEFT_BOTTOM_MID line
void block(float x, float y, float z) {
  fill(140, 100);
  stroke(255);
  strokeWeight(2);

  //beginShape(QUADS);
  //vertex(x-blockLength/2, y-blockHeight/2, z-blockWidth/2);
  //vertex(x+blockLength/2, y-blockHeight/2, z-blockWidth/2);
  //vertex(x+blockLength/2, y+blockHeight/2, z-blockWidth/2);
  //vertex(x-blockLength/2, y+blockHeight/2, z-blockWidth/2);

  //vertex(x-blockLength/2, y+blockHeight/2, z+blockWidth/2);
  //vertex(x+blockLength/2, y+blockHeight/2, z+blockWidth/2);
  //vertex(x+blockLength/2, y-blockHeight/2, z+blockWidth/2);
  //vertex(x-blockLength/2, y-blockHeight/2, z+blockWidth/2);

  ////vertex(x+blockLength/2, y+blockHeight/2, z+blockWidth/2);
  ////vertex(x+blockLength/2, y+blockHeight/2, z+blockWidth/2);
  ////vertex(x+blockLength/2, y+blockHeight/2, z+blockWidth/2);
  ////vertex(x+blockLength/2, y+blockHeight/2, z+blockWidth/2);

  //endShape(CLOSE);

  pushMatrix();
  translate(x+blockLength/2+gox, height-y-blockHeight/2-goy, gox+z);
  lights();
  fill(255, 150);
  box(blockLength, blockHeight, blockWidth);
  popMatrix();
}

void stackBlock(int cnt) {
  for (int i=cnt; i>0; i--) {
    block(px.get(cnt)-px.get(i), py.get(cnt)-py.get(i), 0);
  }
  //delay(100);
}

void countBlock() {
  if (keyPressed && key == 'j' && blockNum >1) {
    blockNum -= blockNumInc;
  } else if (keyPressed && key == 'k' && blockNum < blockNumMax) {
    blockNum += blockNumInc;
  }
}
