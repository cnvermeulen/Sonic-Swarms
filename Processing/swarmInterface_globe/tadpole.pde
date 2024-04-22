
//TADPOLES
float movement = 0.01, agility = 5, airFric = 0.01;
int tadpoleN = 0, foodN = 1;
ArrayList<Tadpole> tadpoles = new ArrayList<Tadpole>();
ArrayList<Body> bodies = new ArrayList<Body>();
int segLength = 10;

class Tadpole {
  
  PVector[] body = new PVector[20];
  PVector location, velocity, acceleration;
  float thetaCentre, distCentre, vision;
  int bodySize, brightness, age, locIndex, maxSize;
  float mass, strength;
  boolean regMovement;
  
  PVector exitPoint;
  
  boolean neighbourTadpoleClose;
  Tadpole neighbourTadpole;
  float distToNeighbourTadpole;
  
  boolean neighbourBeeClose;
  boolean neighbourBeeCalls;
  Bee neighbourBee;
  float distToNeighbourBee;
  
  boolean foodClose, foodWithinReach;
  Food foodTarget;
  
  String nextMove;
  
  float callsBeeChance, callsTpChance;
  boolean callsBee, callsTadpole;
  
  boolean attractorClose;
  boolean mouseOver = false, locked = false;
  
  
  Tadpole(float x, float y, float velocityX, float mass_, int bodySize_, float strength_, int age_) {
    location = new PVector(x, y);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    velocity.x = velocityX;
    mass = mass_;
    bodySize = bodySize_;
    maxSize = 10;
    strength = strength_;
    vision = tadpoleVisionKnob.getValue();
    distToNeighbourBee = vision;
    age = age_;
  }
  
    ////////TADPOLES OBSERVE/THINK/DECIDE/RUN PROCESS
  
  void observe(int tadpoleIndex, ArrayList<Tadpole> allTadpoles, ArrayList<Bee> allBees, ArrayList<Food> allFood) {
    PVector sideVect = new PVector(sysCentre.x + sysWinRadius, sysCentre.y);
    PVector compareAngle = sideVect.sub(sysCentre);
    checkMouseOver();
    distCentre = location.dist(sysCentre);
    vision = tadpoleVisionKnob.getValue();
    if(location.y > sysCentre.y) {
      thetaCentre = (2*PI) - PVector.angleBetween(compareAngle, location.copy().sub(sysCentre));
    } else {
      thetaCentre = PVector.angleBetween(compareAngle, location.copy().sub(sysCentre));
    }
    locIndex = tadpoleIndex;
    neighbourTadpoleClose = tadpoleClose(allTadpoles);
    neighbourBeeClose = beeClose(allBees);
    
    if(neighbourBeeClose) {
      neighbourBeeCalls = neighbourBeeCalls();
    } else {
      neighbourBeeCalls = false;
    }
    if(location.dist(tpAttr.location) < vision) {
      attractorClose = true;
    } else {
      attractorClose = false;
    }
    foodClose = foodClose(allFood);
  }
  
  void think() {
    nextMove = "noMove";
    callsBee = false;
    callsTadpole = false;
    if(regMovement) {
      if((time%(101 - round(movementSliderTadpole.getValue() * 500))) == 0) {
        nextMove = "normalMove";
        if(foodClose) {
          nextMove = "foodMove";
        }
        if(attractorClose) {
          nextMove = "attractorMove";
        }
        decideCall();
      }
    } else {
      if(random(1) < movementSliderTadpole.getValue()) {
        nextMove = "normalMove";
        if(foodClose) {
          nextMove = "foodMove";
        }
        if(attractorClose) {
          nextMove = "attractorMove";
        }
        decideCall();
      }
      
      if(neighbourBeeClose && neighbourBeeCalls) {
        nextMove = "fleeMove";
      }
    }
  }
  
  void decide() {
    makeMove(nextMove);
    eatFood(foodWithinReach);
  }
  
  void run() {
    
    //apply aging on the particles
    age += 1;
    
    //calculate and apply air resistance
    PVector dragForce = airResistance.calcDrag(this);
    this.applyForce(dragForce);
    
    //update position
    this.updatePosition();
    this.edges();
    
    //display particle
    this.display();
    acceleration.mult(0);
    
    //display bodies
    bodies.get(locIndex).displayBody();
    
    //Check whether the particle is dead
    if(this.isDead()) {
      tadpoles.remove(locIndex);
      bodies.remove(locIndex);
    } else if(this.isSuckedUp()) {
      tadpoles.remove(locIndex);
      bodies.remove(locIndex);
    }
  }
  
  ////////TADPOLES DECIDE FUNCTIONS
  
  void makeMove(String nextMove) {
    if(nextMove == "normalMove") {
      sendTadpoleData(this, 0);
      PVector desired = PVector.random2D().mult(strengthSliderTadpole.getValue());
      acceleration.add(desired);
    }
    if(nextMove == "foodMove") {
      sendTadpoleData(this, 0);
      PVector desired = foodTarget.location().copy().sub(location).setMag(strengthSliderTadpole.getValue());
      acceleration.add(desired);
    }
    if(nextMove == "fleeMove") {
      sendTadpoleData(this, 1);
      PVector desired = neighbourBee.location.copy().sub(location).normalize().rotate(PI).mult(strengthSliderTadpole.getValue());
      applyForce(desired);
    }
    if(nextMove == "attractorMove") {
      sendTadpoleData(this, 0);
      PVector desired = tpAttr.attractLocation.copy().sub(location).normalize().mult(strengthSliderTadpole.getValue()/2);
      applyForce(desired);
    }
  }
  
  void eatFood(boolean foodWithinReach) {
    if(foodWithinReach) {
      if(bodySize < maxSize) {
        bodies.get(locIndex).addSegment();
        foodTarget.eaten();
        bodySize += 1;
        mass += 2;
        strength += 2;
      } else {
        bodySize = maxSize;
        foodTarget.eaten();
      }
    }
  }
  
  void decideCall() {
    if((random(1) < tadpoleCallBeeChance.getValue())&&((neighbourBeeClose))) {
      pushMatrix();
      stroke(4, 108, 3);
      strokeWeight(4);
      noFill();
      ellipse(location.x, location.y, 50, 50);
      popMatrix(); 
      callsBee = true;
    } else {
      callsBee = false;
    }
    if((random(1) < tadpoleCalltadpoleChance.getValue())&&((neighbourTadpoleClose))) {
      pushMatrix();
      stroke(32, 165, 245);
      strokeWeight(4);
      noFill();
      ellipse(location.x, location.y, 50, 50);
      popMatrix();
      callsTadpole = true;
    } else {
      callsTadpole = false;
    }
  }
  
  ////////TADPOLES OBSERVE FUNCTIONS
  
  void checkMouseOver() {
    PVector mouseLoc = new PVector(mouseX, mouseY);
    if(mouseLoc.dist(location) < 20) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
  }
  
  boolean tadpoleClose(ArrayList<Tadpole> tadpolesIn) {
    if(tadpolesIn.size() > 1) {
      float tadpoleDistances[] = new float[tadpolesIn.size()-1];
      int nearestIndex = 0;
      int distIndex = 0;
      for(int i = 0; i < tadpolesIn.size(); i++) {
        if(i != locIndex) {
          tadpoleDistances[distIndex] = tadpolesIn.get(i).location.copy().sub(location).mag();
          distIndex += 1;
        }
      }
      for(int i = 0; i < tadpoleDistances.length; i++) {
        if(tadpoleDistances[i] == min(tadpoleDistances)) {
          nearestIndex = i;
        }
      }
      if(min(tadpoleDistances) < vision) {
        if(nearestIndex < locIndex) {
          neighbourTadpole = tadpolesIn.get(nearestIndex);
          distToNeighbourTadpole = min(tadpoleDistances);
        } else {
          neighbourTadpole = tadpolesIn.get(nearestIndex + 1);
          distToNeighbourTadpole = min(tadpoleDistances);
        }
        pushMatrix();
        stroke(36, 31, 203);
        strokeWeight(4);
        line(location.x, location.y, neighbourTadpole.location.x, neighbourTadpole.location.y);
        popMatrix();
        return true;
      } else {
        distToNeighbourTadpole = vision;
        return false;
      }
    } else {
      distToNeighbourTadpole = vision;
      return false;
    }
  }
  
  boolean beeClose(ArrayList<Bee> beesIn) {
    if(beesIn.size() > 0) {
      float beeDistances[] = new float[beesIn.size()];
      int nearestIndex = 0;
      for(int i = 0; i < beesIn.size(); i++) {
        beeDistances[i] = beesIn.get(i).location.copy().sub(location).mag();
      }
      for(int i = 0; i < beeDistances.length; i++) {
        if(beeDistances[i] == min(beeDistances)) {
          nearestIndex = i;
        }
      }
      if(min(beeDistances) < vision) {
        neighbourBee = beesIn.get(nearestIndex);
        distToNeighbourBee = min(beeDistances);
        pushMatrix();
        stroke(4, 108, 3);
        strokeWeight(4);
        line(location.x, location.y, neighbourBee.location.x, neighbourBee.location.y);
        popMatrix();
        return true;
      } else {
        return false;
      }
    }
    distToNeighbourBee = vision;
    return false;
  }
  
  boolean neighbourTadpoleCalls() {
    if(neighbourTadpole.callsTadpole) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean neighbourBeeCalls() {
    if(bees.size() > 0) {
      if(neighbourBee.callsTadpole) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  
  boolean foodClose(ArrayList<Food> allFood_) {
    float distances[] = new float[allFood_.size()];
    int minIndex = 0;
    if(allFood_.size() >= 1) {
      //Check for food, and memorize it
      for(int i = 0; i < allFood_.size(); i++) {
       float distance = allFood_.get(i).location().sub(location).mag();
       distances[i] = distance;
      }
      for(int i = 0; i < allFood_.size(); i++) {
        if(distances[i] == min(distances)) {
          minIndex = i;
        }
      }
      if(min(distances) < vision) {
        foodTarget = allFood_.get(minIndex);
        foodWithinReach = foodWithinReach(min(distances));
        return true;
      } else {
        foodWithinReach = false;
        return false;
      }
    } else {
      foodWithinReach = false;
      return false;
    }
  }
  
  
  boolean foodWithinReach(float distance) {
    if(distance<10) {
       return true;
     } else {
       return false;
     }
  }
  
  ////////TADPOLES ENVIRONMENTAL PROCESSES
  
  boolean isSuckedUp() {
    exitPoint = new PVector(removeTadpoles.getPosition()[0], removeTadpoles.getPosition()[1]);
    if(distCentre > (sysWinRadius - 5) && (removeTadpoles.isPressed())) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean isDead() {
    if(age > 12000) {
      return true;
    } else {
      return false;
    }
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  void suckUp() {
      PVector desired = exitPoint.sub(location).setMag(30).copy();
      acceleration.add(desired);
      velocity.add(acceleration);
      location.add(velocity);
  }
  
  ////////TADPOLES BASIC DISPLAY FUNCTIONS
  
  void updatePosition() {
    velocity.add(acceleration);
    velocity.limit(15);
    if(velocity.mag() > 0.1) {
      location.add(velocity);
    }
  }
  
  void display() {
    
    //Map brightness of a particle to age and velocity
    pushMatrix();
    stroke(32, 165, 245);
    strokeWeight(2);
    fill(200);
    ellipse(location.x, location.y, 12, 12);
    popMatrix();
  }
  
  void edges() {
     if(distCentre > sysWinRadius) {
       location.x = sysCentre.x + cos(thetaCentre) * distCentre * 0.99;
       location.y = sysCentre.y - sin(thetaCentre) * distCentre * 0.99;
       velocity.x *= -1;
       velocity.y *= -1;
    }
  }
  
  
}
