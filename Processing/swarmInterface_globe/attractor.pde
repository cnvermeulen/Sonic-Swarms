Attractor beeAttr = new Attractor(1200, 300, 40, color(255, 204, 0));
Attractor tpAttr = new Attractor(1200, 600, 40, color(32, 165, 245));

class Attractor {
  PVector location, attractLocation;
  int size;
  float attractAngle = 0;
  boolean overAttr = false, locked = false;
  color attractColor;
  
  Attractor(int startXPos, int startYPos, int size_, color color_) {
    location = new PVector(startXPos, startYPos);
    attractLocation = new PVector(location.x + size, location.y);
    size = size_;
    attractColor = color_;
  }
  
  void checkMouseOver() {
    PVector mouseLoc = new PVector(mouseX, mouseY);
    if(mouseLoc.dist(location) < size) {
      overAttr = true;
    } else {
      overAttr = false;
    }
  }
  
  void updateAttractLoc(int time) {
    attractAngle += map(noise(time/100), 0, 1, 0, PI/16);
    attractLocation.x = cos(attractAngle) * size + location.x;
    attractLocation.y = sin(attractAngle) * size + location.y;
  }
  
  void drawAttractor() {
    pushMatrix();
    noFill();
    if(overAttr) {
      fill(attractColor);
    }
    stroke(attractColor);
    strokeWeight(3);
    ellipse(location.x, location.y, size, size);
    
    ellipse(attractLocation.x, attractLocation.y, 5, 5);
    popMatrix();
  }
  
  
}

void mousePressed() {
  //Dragger
  
  if(beeAttr.overAttr) {
    beeAttr.locked = true;
  } else {
    beeAttr.locked = false;
  }
  if(tpAttr.overAttr) {
    tpAttr.locked = true;
  } else {
    tpAttr.locked = false;
  }
  for(int i = 0; i < bees.size(); i++) {
    if(bees.get(i).mouseOver) {
      bees.get(i).locked = true;
    } else {
      bees.get(i).locked = false;
    }
  }
  //for(int i = 0; i < tadpoles.size(); i++) {
  //  if(tadpoles.get(i).mouseOver) {
  //    tadpoles.get(i).locked = true;
  //  } else {
  //    tadpoles.get(i).locked = false;
  //  }
  //}
}

void mouseDragged() {
  PVector mouseVector = new PVector(mouseX, mouseY);
  //Move attractor
  if(beeAttr.locked) {
    beeAttr.location = mouseVector;
  }
  if(tpAttr.locked) {
    tpAttr.location = mouseVector;
  }
  //Move bee
  for(int i = 0; i < bees.size(); i++) {
    if(bees.get(i).locked) {
      bees.get(i).location = mouseVector;
    }
  }
  //for(int i = 0; i < tadpoles.size(); i++) {
  //  if(tadpoles.get(i).locked) {
  //    tadpoles.get(i).location = mouseVector;
  //    bodies.get(i).headLocation = mouseVector;
  //    bodies.get(i).displayBody();
  //  }
  //}
}
