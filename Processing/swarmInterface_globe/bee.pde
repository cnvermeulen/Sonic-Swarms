
//FLYER
int beeN = 2;
ArrayList<Bee> bees = new ArrayList<Bee>();  
ArrayList<Bee> mirrorBees = new ArrayList<Bee>();
float maxSpeed = 5, maxForce = 1;
int wallWidth = 100;

class Bee {
  
  PVector location, velocity, acceleration, mirrorLoc;
  float thetaCentre, distCentre, rotationAngle;
  boolean onEdge, closeToEdge;
  float mass, strength, wandertheta, vision, distToNeighbour, receivedForce;
  int bodySize, listIndex; 
  PVector exitPoint;
  boolean debug = false;
  
  int locIndex;
  boolean neighbourTadpoleClose;
  boolean neighbourTadpoleCalls;
  Tadpole neighbourTadpole;
  float distToNeighbourTadpole;
  
  boolean neighbourBeeClose;
  Bee neighbourBee;
  float distToNeighbourBee;
  
  boolean followsPath;
  Path itsPath;
  
  String nextMove;
  
  float callsBeeChance, callsTadpoleChance;
  boolean callsBee, callsTadpole;

  boolean attractorClose = false;
  boolean mouseOver = false;
  boolean locked = false;
  
  Bee(float x, float y, PVector startVelocity, float mass_, int bodySize_, float strength_, int listIndex_) {
    location = new PVector(x, y);
    mirrorLoc = new PVector();
    velocity = startVelocity;
    acceleration = new PVector(0,0);
    mass = mass_;
    bodySize = bodySize_;
    strength = strength_;
    vision = beeVisionKnob.getValue();
    listIndex = listIndex_;
    exitPoint = new PVector(removeBees.getPosition()[0], removeBees.getPosition()[1]);
    distToNeighbour = vision;
  }
  
  void observe(int beeIndex, ArrayList<Bee> allBees, ArrayList<Tadpole> allTadpoles, Path pathIn) {
    PVector sideVect = new PVector(sysCentre.x + sysWinRadius, sysCentre.y);
    PVector compareAngle = sideVect.sub(sysCentre);
    checkMouseOver();
    locIndex = beeIndex;
    distCentre = location.dist(sysCentre);
    rotationAngle = velocity.heading();
    vision = beeVisionKnob.getValue();
    if(location.y > sysCentre.y) {
      thetaCentre = (2*PI) - PVector.angleBetween(compareAngle, location.copy().sub(sysCentre));
    } else {
      thetaCentre = PVector.angleBetween(compareAngle, location.copy().sub(sysCentre));
    }
    if(distCentre > distGlobeHorizon) {
      onEdge = true;
    } else {
      onEdge = false;
    }
    if(distCentre > (sysWinRadius - wallWidth)) {
      closeToEdge = true;
    } else {
      closeToEdge = false;
    }    
    receivedForce = forcefield1(thetaCentre, distCentre);
    neighbourTadpoleClose = tadpoleClose(allTadpoles);
    neighbourBeeClose = beeClose(allBees);
    if(neighbourTadpoleClose) {
      neighbourTadpoleCalls = neighbourTadpoleCalls();
    } else {
      neighbourTadpoleCalls = false;
    }
    followsPath = pathOn(pathIn);
    if(location.dist(beeAttr.location) < vision) {
      attractorClose = true;
    } else {
      attractorClose = false;
    }
  }
  
  void checkMouseOver() {
    PVector mouseLoc = new PVector(mouseX, mouseY);
    if(mouseLoc.dist(location) < 20) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
  }
  
  void think() { 
    if(followsPath) {
      nextMove = "followPath";
    } else {
      nextMove = "wander";
    }
    if(flockingOnOff.getState()) {
      nextMove = "flock";
    }
    if(attractorClose) {
      nextMove = "seekAttractor";
    }
    if(closeToEdge&&edgesOnOff.getState()) {
      nextMove = "avoidEdge";
    }
  }
  
  void decide() {
    makeMove(nextMove);
    decideCall();
  }
  void run() {
    update();
    edges();
    display();
    //displayMirror();
    if(this.isSuckedUp()) {
      bees.remove(locIndex);
      beeDeleted(locIndex);
    }
  }
  ////////BEES DECIDE FUNCTIONS
  
  void makeMove(String nextMove) {
    if(nextMove == "followPath") {
      followPath(itsPath);
    }
    if(nextMove == "wander") {
      wander();
    }
    if(nextMove == "flock") {
      flock(bees);
    }
    if(nextMove == "avoidEdge") {
      avoidWall();
    }
    if(nextMove == "seekAttractor") {
      seekAttractor();
      
    }
    text(nextMove, location.x + 10, location.y);
  }  
  void decideCall() {
    if((random(1) < beeCallTadpoleChance.getValue())&&neighbourTadpoleClose) {
      pushMatrix();
      stroke(31, 232, 14);
      strokeWeight(5);
      noFill();
      ellipse(location.x, location.y, 50, 50);
      popMatrix();
      callsTadpole = true;
    } else {
      callsTadpole = false;
    }
    if((random(1) < beeCallBeeChance.getValue())&&neighbourBeeClose) {
      pushMatrix();
      stroke(232, 225, 14);
      strokeWeight(5);
      noFill();
      ellipse(location.x, location.y, 50, 50);
      popMatrix();
      callsBee = true;
    } else {
      callsBee = false;
    }
  }
////////BEES OBSERVE FUNCTIONS
  
  boolean tadpoleClose(ArrayList<Tadpole> tadpolesIn) {
    if(tadpolesIn.size() > 0) {
      float tadpoleDistances[] = new float[tadpolesIn.size()];
      int nearestIndex = 0;
      for(int i = 0; i < tadpolesIn.size(); i++) {
          tadpoleDistances[i] = tadpolesIn.get(i).location.copy().sub(location).mag();
      }
      for(int i = 0; i < tadpoleDistances.length; i++) {
        if(tadpoleDistances[i] == min(tadpoleDistances)) {
          nearestIndex = i;
        }
      }
      if(min(tadpoleDistances) < vision) {
         neighbourTadpole = tadpolesIn.get(nearestIndex);
         distToNeighbourTadpole = min(tadpoleDistances);
         pushMatrix();
         stroke(31, 232, 14);
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
    if(beesIn.size() > 1) {
      float beeDistances[] = new float[beesIn.size()-1];
      float mirrorBeeDistances[] = new float[mirrorBees.size()];
      int nearestIndex = 0, nearestMirrorIndex = 0;
      int distIndex = 0;
      for(int i = 0; i < beesIn.size(); i++) {
        if(i != locIndex) {
          beeDistances[distIndex] = beesIn.get(i).location.copy().sub(location).mag();
          distIndex += 1;
        }
      }
      for(int i = 0; i < beeDistances.length; i++) {
        if(beeDistances[i] == min(beeDistances)) {
          nearestIndex = i;
        }
      }
      for(int i = 0; i < mirrorBees.size(); i++) {
        mirrorBeeDistances[i] = mirrorBees.get(i).mirrorLoc.copy().sub(location).mag();
      }
      for(int i = 0; i < mirrorBeeDistances.length; i++) {
        if(mirrorBeeDistances[i] == min(mirrorBeeDistances)) {
          nearestMirrorIndex = i;
        }
      }
      if(min(beeDistances) < min(mirrorBeeDistances)) {
        if(min(beeDistances) < vision) {
          if(nearestIndex < locIndex) {
            neighbourBee = beesIn.get(nearestIndex);
            distToNeighbourBee = min(beeDistances);
          } else {
            neighbourBee = beesIn.get(nearestIndex + 1);
            distToNeighbourBee = min(beeDistances);
          } 
          pushMatrix();
          stroke(165, 125, 22);
          strokeWeight(4);
          line(location.x, location.y, neighbourBee.location.x, neighbourBee.location.y);
          popMatrix();
           
          return true;
        } else {
          distToNeighbourBee = vision;
          return false;
        }
      } else {
          if(min(mirrorBeeDistances) < vision) {
            neighbourBee = mirrorBees.get(nearestMirrorIndex);
            distToNeighbourBee = min(mirrorBeeDistances);
            pushMatrix();
            stroke(165, 125, 22);
            strokeWeight(4);
            line(location.x, location.y, neighbourBee.mirrorLoc.x, neighbourBee.mirrorLoc.y);
            popMatrix();
            
            return true;
          } else {
         
            distToNeighbourBee = vision;
            return false;
          }
        }
      } else { 
          distToNeighbourBee = vision;
          return false;
      }
  }
  
  boolean neighbourTadpoleCalls() {
    if(neighbourTadpole.callsBee) {
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
  
  boolean pathOn(Path path) {
    if(pathOnOff.getState()) {
      itsPath = path;
      return true;
    } else {
      return false;
    }
  }
  
  boolean isSuckedUp() {
    if((distCentre > (sysWinRadius - 10)) && (removeBees.isPressed())) {
      return true;
    } else {
      return false;
    }
  }
  
  //BEE MOVEMENT FUNCTIONS
  
  void followPath(Path path) {
    PVector pathSeekForce = calcPathSeek(path);
    this.applyForce(pathSeekForce);
  }
  
  void wander() {
    float wanderR = 5;         // Radius for our "wander circle"
    float wanderD = 30;         // Distance for our "wander circle"
    float change = 0.5;
    float angVelocity = random(-change,change);
    wandertheta = (wandertheta + angVelocity)%TWO_PI;     // Randomly change wander theta

    // Now we have to calculate the new location to steer towards on the wander circle
    PVector circleloc = velocity.copy();    // Start with velocity
    circleloc.normalize();            // Normalize to get heading
    circleloc.mult(wanderD);          // Multiply by distance
    circleloc.add(location);               // Make it relative to boid's location
    
    float h = velocity.heading();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h),wanderR*sin(wandertheta+h));
    PVector target = PVector.add(circleloc,circleOffSet);
    applyForce(seek(target));
    
    if (debug) drawWanderStuff(location,circleloc,target,wanderR);
  }
  
  void avoidWall() {
     PVector desired = null;
     float distEdge = sysWinRadius - distCentre;
     float avoidCoef = wallWidth - distCentre;
    
    if(distEdge < wallWidth) {
      desired = PVector.sub(sysCentre, location).setMag(wallWidth - distEdge);
    }
    
    if(desired == null) {
      wander();
    } else {
      applyForce(seekNotWall(desired, avoidCoef));
    }
  }
  
  void flock(ArrayList<Bee> bees) {
    PVector sep = separate(bees);   // Separation
    PVector ali = align(bees);      // Alignment
    PVector coh = cohesion(bees);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(seperationWeight.getValue());
    ali.mult(allignmentWeight.getValue());
    coh.mult(cohesionWeight.getValue());
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
     
   void seekAttractor() {
     PVector seekAttr = seek(beeAttr.attractLocation);
     PVector sep = separate(bees);
     seekAttr.mult(2.0);
     sep.mult(seperationWeight.getValue());
     applyForce(seekAttr);
     applyForce(sep);
     
   }
  
  PVector calcPathSeek(Path path) {
    // Predict location 25 (arbitrary choice) frames ahead
    PVector predict = velocity.copy();
    predict.normalize();
    predict.mult(25);
    PVector predictLoc = PVector.add(location, predict);

    // Now we must find the normal to the path from the predicted location
    // We look at the normal for each line segment and pick out the closest one
    PVector normal = null;
    PVector target = null;
    float worldRecord = 1000000;  // Start with a very high worldRecord distance that can easily be beaten

    // Loop through all points of the path
    for (int i = 0; i < path.points.size(); i++) {

      // Look at a line segment
      PVector a = path.points.get(i);
      PVector b = path.points.get((i+1)%path.points.size()); // Note Path has to wraparound

      // Get the normal point to that line
      PVector normalPoint = getNormalPoint(predictLoc, a, b);

      // Check if normal is on line segment
      PVector dir = PVector.sub(b, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      //if (da + db > line.mag()+1) {
      if (normalPoint.x < min(a.x,b.x) || normalPoint.x > max(a.x,b.x) || normalPoint.y < min(a.y,b.y) || normalPoint.y > max(a.y,b.y)) {
        normalPoint = b.copy();
        // If we're at the end we really want the next line segment for looking ahead
        a = path.points.get((i+1)%path.points.size());
        b = path.points.get((i+2)%path.points.size());  // Path wraps around
        dir = PVector.sub(b, a);
      }

      // How far away are we from the path?
      float d = PVector.dist(predictLoc, normalPoint);
      // Did we beat the worldRecord and find the closest line segment?
      if (d < worldRecord) {
        worldRecord = d;
        normal = normalPoint;
        
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir.normalize();
        // This is an oversimplification
        // Should be based on distance to path & velocity
        dir.mult(25);
        target = normal.copy();
        target.add(dir);
        
      }
    }

    // Draw the debugging stuff
    if (debug) {
      // Draw predicted future location
      stroke(0);
      fill(0);
      line(location.x, location.y, predictLoc.x, predictLoc.y);
      ellipse(predictLoc.x, predictLoc.y, 4, 4);

      // Draw normal location
      stroke(0);
      fill(0);
      ellipse(normal.x, normal.y, 4, 4);
      // Draw actual target (red if steering towards it)
      line(predictLoc.x, predictLoc.y, target.x, target.y);
      if (worldRecord > path.radius) fill(255, 0, 0);
      noStroke();
      ellipse(target.x, target.y, 8, 8);
    }

    // Only if the distance is greater than the path's radius do we bother to steer
    if (worldRecord > path.radius) {
      return seek(target);
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    float attRepBorder = pow(2, 6 * attractRepulse.getValue())/8;
    float ffVel = pow(2, 6 * ffVelDepth.getValue())/8;
    float ffForce = pow(2, 6 * ffForceDepth.getValue())/8;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxSpeed * map(distToNeighbourBee, vision, 0, 1, attRepBorder) * map(receivedForce, 0, 1, 1, ffVel));
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce * map(receivedForce, 0, 1, 1, ffForce));  // Limit to maximum steering force
    return steer;
   }

  PVector seekNotWall(PVector target, float avoidCoef) {
    // Normalize desired and scale to maximum speed
    target.normalize();
    target.mult(maxSpeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(target,velocity);
    steer.limit(maxForce);  // Limit to maximum steering force
    return steer;
    }
    
     // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Bee> bees) {
    float desiredseparation = vision/2;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Bee other : bees) {
      float d = PVector.dist(location,other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location,other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }
  
  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Bee> bees) {
    float neighbordist = vision;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Bee other : bees) {
      float d = PVector.dist(location,other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0,0);
    }
  }
  
  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Bee> bees) {
    float neighbordist = vision;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Bee other : bees) {
      float d = PVector.dist(location,other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } else {
      return new PVector(0,0);
    }
  }
  
 ////////BEES ENVIRONMENTAL PROCESSES
  
  void suckUp() {
    if(removeBees.isPressed()) {
      PVector desired = exitPoint.copy().sub(location).setMag(2);
      acceleration.add(desired);
      velocity.add(acceleration);
      location.add(velocity);
      callsBee = false;
    }
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  ////////BEES BASIC DISPLAY FUNCTIONS
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(15);
    location.add(velocity);
    acceleration.mult(0);
    if((location.x < sysCentre.x)&&(location.y > sysCentre.y)) {
      mirrorLoc.x = location.x + (cos(thetaCentre - PI) * sysWinRadius * 2);
      mirrorLoc.y = location.y - (sin(thetaCentre - PI) * sysWinRadius * 2);
    } 
    if((location.x < sysCentre.x)&&(location.y < sysCentre.y)) {
      mirrorLoc.x = location.x + (sin(thetaCentre - (0.5*PI)) * sysWinRadius * 2);
      mirrorLoc.y = location.y + (cos(thetaCentre - (0.5*PI)) * sysWinRadius * 2);
    } 
    if((location.x > sysCentre.x)&&(location.y < sysCentre.y)) {
      mirrorLoc.x = location.x - (sin((0.5*PI) - thetaCentre) * sysWinRadius * 2);
      mirrorLoc.y = location.y + (cos((0.5*PI) - thetaCentre) * sysWinRadius * 2);
    } 
    if((location.x > sysCentre.x)&&(location.y > sysCentre.y)) {
      mirrorLoc.x = location.x - (cos((2*PI) - thetaCentre) * sysWinRadius * 2);
      mirrorLoc.y = location.y - (sin((2*PI) - thetaCentre) * sysWinRadius * 2);
    } 
    
  }
  
  
  void display() {
    
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + PI/2;
    color c = color(255, 204, 0); 
    fill(c);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    beginShape();
    vertex(0, -bodySize*2);
    vertex(-bodySize, bodySize*2);
    vertex(bodySize, bodySize*2);
    endShape(CLOSE);
    popMatrix();
  }
  
  void displayMirror() {
    //stroke(100);
    //strokeWeight(2);
    //line(location.x, location.y, mirrorLoc.x, mirrorLoc.y);
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + PI/2;
    color c = color(150); 
    fill(c);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(mirrorLoc.x,mirrorLoc.y);
    rotate(theta);
    beginShape();
    vertex(0, -bodySize*2);
    vertex(-bodySize, bodySize*2);
    vertex(bodySize, bodySize*2);
    endShape(CLOSE);
    popMatrix();
  }
  
  void edges() {
    if(distCentre > sysWinRadius) {
      location.x -= 1.99 * cos(thetaCentre) * distCentre;
      location.y += 1.99 * sin(thetaCentre) * distCentre;
      
      if((location.x < sysCentre.x)&&(location.y > sysCentre.y)) {
        mirrorLoc.x = location.x + (cos(thetaCentre - PI) * sysWinRadius * 2);
        mirrorLoc.y = location.y - (sin(thetaCentre - PI) * sysWinRadius * 2);
      } 
      if((location.x < sysCentre.x)&&(location.y < sysCentre.y)) {
        mirrorLoc.x = location.x + (sin(thetaCentre - (0.5*PI)) * sysWinRadius * 2);
        mirrorLoc.y = location.y + (cos(thetaCentre - (0.5*PI)) * sysWinRadius * 2);
      } 
      if((location.x > sysCentre.x)&&(location.y < sysCentre.y)) {
        mirrorLoc.x = location.x - (sin((0.5*PI) - thetaCentre) * sysWinRadius * 2);
        mirrorLoc.y = location.y + (cos((0.5*PI) - thetaCentre) * sysWinRadius * 2);
      } 
      if((location.x > sysCentre.x)&&(location.y > sysCentre.y)) {
        mirrorLoc.x = location.x - (cos((2*PI) - thetaCentre) * sysWinRadius * 2);
        mirrorLoc.y = location.y - (sin((2*PI) - thetaCentre) * sysWinRadius * 2);
      } 
    }
    
      
    
  }
  
  void drawWanderStuff(PVector location, PVector circle, PVector target, float rad) {
    pushMatrix();
    stroke(255);
    strokeWeight(1);
    noFill();
    ellipseMode(CENTER);
    ellipse(circle.x,circle.y,rad*2,rad*2);
    ellipse(target.x,target.y,4,4);
    line(location.x,location.y,circle.x,circle.y);
    line(circle.x,circle.y,target.x,target.y);
    popMatrix();
 }
  
  
}
