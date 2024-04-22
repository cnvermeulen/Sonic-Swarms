//SYSTEMWINDOW
int systemWindow[] = new int[2];
int systemWindowWidth = 700, systemWindowHeight = 700;
int systemWindowXOffset = 50, systemWindowYOffset = 0;
int systemWindowLeft, systemWindowRight, systemWindowTop, systemWindowBottom;
int listeningWindowSize = 200;
int matrixWindowWidth = 400, matrixWindowHeight = 200;
int matrixWindowXOffset = 750, matrixWindowYOffset = 700;
PFont kindFont;

int sysWinRadius = 350;
int distGlobeHorizon = 175;
PVector sysCentre;

void drawText() {
  kindFont = createFont("Arial",16,true);
  textFont(kindFont,32);                 
  fill(150);                       
  text("Tadpoles", systemWindowLeft + 30, systemWindowBottom + 30);   
  text("Bees", systemWindowLeft + 320, systemWindowBottom + 30); 
  textFont(kindFont, 16);                 
  fill(150);     
  text("Tadpoles", matrixWindowXOffset + 70, matrixWindowYOffset - 20);   
  text("Bees", matrixWindowXOffset + 270, matrixWindowYOffset - 20); 
  text("Tadpoles", matrixWindowXOffset + 470, matrixWindowYOffset + 25);   
  text("Bees", matrixWindowXOffset + 470, matrixWindowYOffset + 125); 
}

//initiate systemWindow
void initSystemWindow() {
  systemWindowLeft = systemWindowXOffset + 5;
  systemWindowRight = systemWindowXOffset + systemWindowWidth;
  systemWindowTop = systemWindowYOffset;
  systemWindowBottom = systemWindowYOffset + systemWindowHeight;
}

//Draw systemWindow
void drawSystemWindow() {
  pushMatrix();
  fill(100);
  stroke(100);
  strokeWeight(4);
  ellipse(width/2, height/2, sysWinRadius*2, sysWinRadius*2);
  fill(0);
  ellipse(width/2, height/2, sysWinRadius*2 - 10, sysWinRadius*2 - 10);
  popMatrix();
}

void drawMatrixWindow() {
  pushMatrix();
  strokeWeight(3);
  stroke(50);
  for(int i = 0; i < 6; i++) {
    if(i < 3) {
      line(matrixWindowXOffset + (200 * i), matrixWindowYOffset, matrixWindowXOffset + (200 * i), matrixWindowYOffset + matrixWindowHeight);
    } else {
      line(matrixWindowXOffset, matrixWindowYOffset + (100 * (i%3)), matrixWindowXOffset + matrixWindowWidth, matrixWindowYOffset + (100 * (i%3)));
    }
  }
  popMatrix();
}