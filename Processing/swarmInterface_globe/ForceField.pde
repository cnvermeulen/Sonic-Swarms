
////INTERESTING FORCEFIELDS:
// xy(3-x^2-y^2)*0.45 + 0.5


float forcefield1(float angle, float distCentre) {
  float xPos, yPos, force;
  xPos = cos(angle) * map(distCentre, 0, sysWinRadius, 0, 1);
  yPos = sin(angle) * map(distCentre, 0, sysWinRadius, 0, 1);
  //force = xPos * yPos * (3-sq(xPos)-sq(yPos))*0.45 + 0.5;
  force = -(sq(xPos) + sq(yPos)) + 1;
  //force = (sin(map(yPos, 0, 1, 0, TWO_PI)) + cos(map(xPos, 0, 1, 0, TWO_PI))/4) + 0.5;
  //force = map(yPos, -1, 1, 0, 1);
  return force;
}

void drawForcefield() {
  float theta, radius, brightness;
  theta = 0;
  radius = 0;
  for(int i = 0; i < 15; i++) {
    radius = 0;
    theta += (TWO_PI / 15);
    for(int j = 0; j < 10; j++) {
      radius += (sysWinRadius/10);
      brightness = map(forcefield1(theta, radius), 0, 1, 0, 100);
      pushMatrix();
      stroke(brightness);
      noFill();
      strokeWeight(sysWinRadius / 14);
      arc(sysCentre.x, sysCentre.y, radius * 2, radius * 2, theta - (TWO_PI/15), theta);
      //ellipse((cos(theta) * radius) + sysCentre.x, (sin(theta) * radius) + sysCentre.y, 20 + , 20 + j);
      popMatrix();
    }
  }
}

///Draw Forcefield patchbay
void drawForcefieldWindow() {
  stroke(160);
  fill(170);
  strokeWeight(2);
  for(int i = 0; i < 10; i++) {
    if(!forcefieldNodeSel) {
      noFill();
      ellipse(sysCentre.x + sysWinRadius + 200 + random(-30, 30), height/2 + random(-30, 30), random(10, 50), random(10, 50));
    } else {
      ellipse(sysCentre.x + sysWinRadius + 200 + random(-30, 30), height/2 + random(-30, 30), random(10, 50), random(10, 50));
    }
  }
}
