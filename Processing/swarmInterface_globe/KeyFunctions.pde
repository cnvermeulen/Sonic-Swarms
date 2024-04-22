void keyPressed() {
  //Add single particles
  if(key == 49) {
    makeTadpole();
  }
  if(key == 50) {
    makeBee();
  }
}

void makeTadpole() {
  float xPos, yPos;
  float theta, distR;
  theta = random(0, 2*PI);
  distR = random(0, sysWinRadius);
  xPos = sysCentre.x + (cos(theta) * distR);
  yPos = sysCentre.y + (sin(theta) * distR);
  Tadpole addedPart = new Tadpole( ///MAKE PARTICLE WITH ARGUMENTS: XPOS, YPOS, MASS, BODYSIZE, STRENGTH, AGE, KIND
          xPos,
          yPos,
          -5,
          random(0.1, 2),
          1,
          random(1, 10),
          0); 
    tadpoles.add(addedPart);  
    bodies.add(new Body(addedPart));
}


void makeBee() {
  float xPos, yPos;
  float theta, distR;
  PVector startVelocity;
  theta = random(0, 2*PI);
  distR = random(0, sysWinRadius);
  xPos = sysCentre.x + (cos(theta) * distR);
  yPos = sysCentre.y + (sin(theta) * distR);
  //xPos = mouseX; yPos = mouseY;
  startVelocity = new PVector(random(-2, 2), random(-2, 2));
  Bee addedBee = new Bee(
   
              xPos,          //XPOS
              yPos,         //YPOS
              startVelocity,
              random(1, 1),           //MASS
              round(random(9,12)),    //BODYSIZE
              random(1,10),           //STRENGTH
              bees.size());
   bees.add(addedBee);
   beeCreated();
}
