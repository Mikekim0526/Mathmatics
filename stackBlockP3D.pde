//Set block size: 240 x 40 x 20
int blockLength = 240;
int blockHeight = 20;
int blockWidth = 40;
float blockLengthInc = blockLength*0.25;      //variable for coord test
float blockHeightInc = blockHeight*0.75;      //variable for coord test

int blockNum = 1;          //Current block number to stack this time
int blockData = 1;         //Highest index recorded in List px, py during the playtime 
int blockNumMax = 500;     //Endline of block to stack
float blockNumInc = 1;     //Control the block increment speed

//The storage to record reach of each block
FloatList px;
FloatList py;

//Graph Origin, Camera Eye level, Camera Center point
float gox, goy, goz;
float cex, cey, cez;
float ccx, ccy, ccz;

void setup() {
  size(1200, 600, P3D);
  background(0);
  lights();
  blendMode(LIGHTEST);
  
  camera(width/2, 0,        height/tan(PI/3),
         width/2, height/2, 0,
         0,       1,        0);
  
  //Set the graph coordinate origin(0,0,0)==(gox, goy, goz), let not change while code
  gox=0;         goy=0;          goz=0;
  
  //Initialize Camera Eye level at (cex, cey, cez) of world coordinate xy-plane (regardless of graph) 
  //Default Camera Eye level: MIDDLE_TOP of image plane
  //Default AV(Angle of View): PI/3
  //cex=width/2;   cey=0;          cez=height/tan(PI/3);
  cex=px.get(1)/2;   cey=height-py.get(1)/2;   cez=height/tan(PI/6);
  
  //Initialize screen center(focus level) to (ccx, ccy, ccz) of world coordinate system (regardless of graph)
  //Default Center: Center of Image plane
  //ccx=width/2;   ccy=height/2;   ccz=0;
  ccx=px.get(1)/2;   ccy=height-py.get(1)/2;   ccz=0;
  
  
  px = new FloatList();
  py = new FloatList();

  px.set(0, 0);
  py.set(0, 0);
  
}

void draw() {
  //To stack new blocks over blockData, calculate new block location data(px, py)
  if(blockNum>blockData){
    newBlockData(blockNum);
  }
  
  //Before stack and blocks, display background environment
  moveCam();
  camera(cex, cey, cez, ccx, ccy, ccz, 0, 1, 0);
  drawGround();
  
  stackBlock(blockNum);
  countBlock();
  
  if(keyPressed){
    if(key=='l'){
      blockNum+=blockNumInc;
    }else if (key == 'h'){
      blockNum-=blockNumInc;
    }else if (key == 'i'){
      blockNum=1;
    }
  }
}

//=================================================
//=================================================
//=================================================

void newBlockData(int cnt) {
  for (int i=blockData; i==cnt; i++){
    px.set(i+1, px.get(i)+blockLength/(2*i+2));
    py.set(i+1, py.get(i)+blockHeight);
  }
  blockData = blockNum;
}

void moveCam(){
  //float cexInc = px.get(blockNum-1)/2;
  //float ceyInc = height-py.get(blockNum-1)/2;
  float cexInc=10;
  float ceyInc=3;
  
  //cex=blockNum*blockLengthInc/2;   cey=height-blockNum*blockHeight/2;
  //ccx=blockNum*blockLengthInc/2;   ccy=height-blockNum*blockHeight/2;
  cex = px.get(blockNum-1)/2;
  cey = height - py.get(blockNum-1)/2;
  ccx = cex;
  ccy = cey;
  cez = px.get(blockNum-1)/tan(PI/6);
  ccz = 0;
  
  if(mousePressed){
    if(mouseX>width*0.8){
      cex+= cexInc;
      ccx+= cexInc;
    } else if(mouseX<width*0.2){
      cex-= cexInc;
      ccx-= cexInc;
    }
    
    if(mouseY<height*0.2){
      cey-= ceyInc;
      ccy-= ceyInc;
    } else if(mouseY>height*0.8){
      cey+= ceyInc;
      ccy+= ceyInc;
    }
  }
  
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
void drawGround(){
  background(0);
  fill(80);
  
  beginShape(QUAD);
  vertex(-blockLength/2, height+blockHeight/2, cez);
  vertex(-blockLength/2, height+blockHeight/2, -cez);
  vertex(width, height+blockHeight/2, -cez);
  vertex(width, height+blockHeight/2, cez);
  endShape(CLOSE);
  //stackBlock(blockNum);
}

void block(float x, float y, float z) {
  fill(140, 100);
  stroke(255);
  strokeWeight(1);

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
  translate(x+gox, height-goy-y, gox+z);
  lights();
  box(blockLength, blockHeight, blockWidth);
  popMatrix();
}

void stackBlock(int cnt){
  for (int i=cnt; i>=0; i--){
    block(px.get(i), py.get(i), 0);
  }
  //delay(100);
}

void countBlock(){
  if (key == 'h'){
    blockNum -= blockNumInc;
  } else if (key == 'l'){
    blockNum += blockNumInc;
  }
  
  if(keyPressed && key == 'j'){
    blockNum -= blockNumInc;
  } else   if(keyPressed && key == 'k'){
    blockNum += blockNumInc;
  }
}
