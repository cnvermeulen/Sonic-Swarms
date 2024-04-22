import controlP5.*;
ControlP5 cp5;
boolean agentSlidVis = true;
boolean soundSlidVis = true;
boolean matrixVis = false;
boolean systemButVis = true;

int interfaceDistEdge = 55;
int interfaceDistEdgeLayer2 = 65;

PVector tpTpNode, beeBeeNode, tpBeeNode, beeTpNode, distBeeNode, distTpNode, forcefieldNode, beeSpeedNode;
PVector allNodes[] = new PVector[8];

//BEE KNOB IND POS
PVector freqSlidIndPos[] = new PVector[6];
PVector freqModFreqIndPos[] = new PVector[6];
PVector freqModDepthIndPos[] = new PVector[6];
PVector hpfBeeIndPos[] = new PVector[6];
PVector lpfBeeIndPos[] = new PVector[6];
PVector beeAmpIndPos[] = new PVector[6];
PVector ws1DepthIndPos[] = new PVector[6];
PVector ws1FreqIndPos[] = new PVector[6];
PVector ws2DepthIndPos[] = new PVector[6];
PVector ws2FreqIndPos[] = new PVector[6];
PVector beeBeeEnvAttackIndPos;
PVector beeBeeEnvReleaseIndPos;
PVector tpBeeEnvAttackIndPos;
PVector tpBeeEnvReleaseIndPos;
PVector beeTpEnvAttackIndPos;
PVector beeTpEnvReleaseIndPos;


//TP KNOB IND POS
PVector fundFreqIndPos[] = new PVector[5];
PVector formFreqIndPos[] = new PVector[5];
PVector bodyFreqIndPos[] = new PVector[5];
PVector grainSizeIndPos[] = new PVector[5];
PVector hpfTpIndPos[] = new PVector[5];
PVector lpfTpIndPos[] = new PVector[5];
PVector tpAmpIndPos[] = new PVector[5];
PVector wsTp1FreqIndPos[] = new PVector[5];
PVector wsTp1DepthIndPos[] = new PVector[5];
PVector wsTp2FreqIndPos[] = new PVector[5];
PVector wsTp2DepthIndPos[] = new PVector[5];


//booleans which interaction function is selected
boolean tpTpNodeSel, beeBeeNodeSel, tpBeeNodeSel, beeTpNodeSel, distBeeNodeSel, distTpNodeSel, forcefieldNodeSel, beeSpeedNodeSel;
boolean allNodesSel[] = new boolean[8];

//Node connection arrays to send via OSC
int distBeeNodeCon[] = new int[9];
int beeBeeNodeCon[] = new int[9];
int tpBeeNodeCon[] = new int[19];
int beeTpNodeCon[] = new int[19];
int tpTpNodeCon[] = new int[10];
int distTpNodeCon[] = new int[10];
int beeSpeedNodeCon[] = new int[9];
int envNodeCon[] = new int[12];
int forceFieldNodeCon[] = new int[19];

int beeAmpNodeCon[] = new int[6];

color allColors[] = new color[8];

//tadPole interface
Knob movementSliderTadpole, strengthSliderTadpole, tadpoleVisionKnob, fundFreqSlider, formFreqSlider, bodyFreqSlider, grainSize, hpfCutoffTpSlider, lpfCutoffTpSlider, wsTp1Freq, wsTp1Depth, wsTp2Freq, wsTp2Depth;
//bee interface
Knob maxSpeedSlider, maxForceSlider, beeVisionKnob, attractRepulse, ffVelDepth, ffForceDepth;
Knob freqSlider, hpfCutoffBeeSlider, lpfCutoffBeeSlider, freqModFreqSlider, freqModDepthSlider, waveShaper1Freq, waveShaper1Depth, waveShaper2Freq, waveShaper2Depth;
//sliderArrays
Knob soundKnobs[] = new Knob[19];
Knob envKnobs[] = new Knob[6];

//AmplitudeSliders
Slider beeAmplitudeSlider, tadpoleAmplitudeSlider;

//Matrix buttons
Knob tadpoleCalltadpoleChance, tadpoleCalltadpoleDepth, tadpoleCallBeeChance, tadpoleCallBeeDepth, beeCallTadpoleChance, beeCallTadpoleDepth, beeCallBeeChance, beeCallBeeDepth, tadpoleRespondDepth, beeRespondDepth;

//MatrixKnobs 
Knob distBeeDepth, distTpDepth, beeBeeEnvAttack, beeBeeEnvRelease, tpBeeEnvAttack, tpBeeEnvRelease, beeTpEnvAttack, beeTpEnvRelease;

//addParticles Buttons
Button addTadpoles;
Button addBees;
Button removeTadpoles;
Button removeBees;
Button tpFollowMouse;
Button beeFollowMouse;
Toggle tadpoleRegIrr;

//Turn path on/off
Toggle pathOnOff;
//Turn Edges On/Off
Toggle edgesOnOff;
//Turn flocking on/off
Toggle flockingOnOff;
Slider seperationWeight, allignmentWeight, cohesionWeight;

//Tadpole movement button
void tpMovementButt() {
  if(tadpoleRegIrr.getState()) {
    for(int i = 0; i < tadpoles.size(); i++) {
      tadpoles.get(i).regMovement = true;
    }
  } else {
    for(int i = 0; i < tadpoles.size(); i++) {
      tadpoles.get(i).regMovement = false;
    }
  }
}

//Particle spray buttons
void particleSprayer() {
    if(addTadpoles.isPressed()) {
      makeTadpole();
    }
    if(addBees.isPressed()) {
       makeBee();
  }
}

//Particle remove buttons
void particleRemover() {
  if(removeTadpoles.isPressed()) {
    for(int i = 0; i < tadpoles.size(); i++) {
      tadpoles.get(i).suckUp();
    }
    for(int i = 0; i < tadpoles.size(); i++) {
      if(tadpoles.get(i).isSuckedUp()) {
        tadpoles.remove(i);
        bodies.remove(i);
      }
    }
    
  }
  if(removeBees.isPressed()) {
    for(int i = 0; i < bees.size(); i++) {
      bees.get(i).suckUp();
      }
    for(int i = 0; i<bees.size(); i++) {
      if(bees.get(i).isSuckedUp()) {
        beeDeleted(i);
        bees.remove(i);
      }
    }
  }
}

//Food management buttons
Button addFood;
Button removeFood;

void foodManagement() {
  if(addFood.isPressed()) {
    food.add(new Food(sysCentre.x + cos(random(0, 2*PI)) * random(0, sysWinRadius-100), sysCentre.y - sin(random(0, 2*PI)) * random(0, sysWinRadius-100)));
  }
  if(removeFood.isPressed()) {
    if(food.size() >= 1) {
      food.remove(0);
    }
  }
}

//Path on/off

void pathManagement() {
  if(pathOnOff.getState()) {
    path.display();
  } 
}

void initInterface(int xPos, int yPos) {
   //instanciate controls;
  float radiusSelfArrow = 70;
  cp5 = new ControlP5(this);
  
  tpTpNode = new PVector(100 + xPos + (cos(1.5*PI) * (radiusSelfArrow/2)), 300 + yPos - (sin(1.5*PI) * (radiusSelfArrow/2)));
  beeBeeNode = new PVector(100 + xPos + (cos(0.5*PI) * (radiusSelfArrow/2)), 100 + yPos - (sin(0.5*PI) * (radiusSelfArrow/2)));
  tpBeeNode = new PVector(135 + xPos + (cos(PI) * (radiusSelfArrow)), 200 + yPos - (sin(PI) * (radiusSelfArrow)));
  beeTpNode = new PVector(65 + xPos + (cos(0) * (radiusSelfArrow)), 200 + yPos - (sin(0) * (radiusSelfArrow)));
  distBeeNode = new PVector(100 + xPos, yPos);
  distTpNode = new PVector(100 + xPos, 400 + yPos);
  forcefieldNode = new PVector(sysCentre.x + sysWinRadius + 200, height/2);
  
  //TADPOLE AGENT INTERFACE
  movementSliderTadpole = cp5.addKnob("movementTadpole")
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(1.6 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(1.6 * PI)))
    .setRange(0,0.2)
    .setValue(0.1)
    .setSize(50, 50)
    .setLabelVisible(true);   
  tadpoleRegIrr = cp5.addToggle("regIrr")
     .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge - 20) * cos(1.6 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge - 20) * sin(1.6 * PI)))
     .setSize(20, 20);
  movementSliderTadpole.setVisible(agentSlidVis);
  strengthSliderTadpole = cp5.addKnob("strengthTadpole")
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(1.7 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(1.7 * PI)))
    .setRange(0, 6)
    .setValue(2)
    .setSize(50, 50)
    .setLabelVisible(true);
  strengthSliderTadpole.setVisible(agentSlidVis);
  tadpoleVisionKnob = cp5.addKnob("tadpoleVisionKnob")
    .setPosition( (sysCentre.x - 25) + (sysWinRadius + interfaceDistEdge) * cos(1.8 * PI), (sysCentre.y - 25) - (sysWinRadius + interfaceDistEdge) * sin(1.8 * PI))
    .setRange(10,300)
    .setValue(175)
    .setSize(50, 50)
    .setLabelVisible(true);
  tadpoleVisionKnob.setVisible(agentSlidVis);
  
  //TADPOLE SOUND INTERFACE
   tadpoleAmplitudeSlider = cp5.addSlider("tadpoleAmplitude")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(10, height - 100)
    .setSize(20, 80)
    .setLabelVisible(true);
  tadpoleAmplitudeSlider.setVisible(soundSlidVis);
  fundFreqSlider = cp5.addKnob("fundFreq")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition((sysCentre.x - 155) + ((sysWinRadius + interfaceDistEdge) * cos(1.4 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(1.4 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  fundFreqSlider.setVisible(soundSlidVis);
  formFreqSlider = cp5.addKnob("formFreq")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition((sysCentre.x - 90) + ((sysWinRadius + interfaceDistEdge) * cos(1.4 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(1.4 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  formFreqSlider.setVisible(soundSlidVis);
  bodyFreqSlider = cp5.addKnob("bodyFreq")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition((sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(1.4 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(1.4 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  bodyFreqSlider.setVisible(soundSlidVis);
  grainSize = cp5.addKnob("grainSize")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition((sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(1.25 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(1.25 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  bodyFreqSlider.setVisible(soundSlidVis);
  hpfCutoffTpSlider = cp5.addKnob("hpfCutoffTp")
    .setRange(0,1)
    .setValue(0.1)
    .setPosition((sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(1.13 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(1.13 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  lpfCutoffTpSlider = cp5.addKnob("lpfCutoffTp")
    .setRange(0,1)
    .setValue(0.2)
    .setPosition((sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(1.05 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(1.05 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  wsTp1Freq = cp5.addKnob("wsTp1Freq")
    .setRange(0,1)
    .setValue(0.2)
    .setPosition(110, height - 85)
    .setSize(50, 50)
    .setLabelVisible(true);
  wsTp1Depth = cp5.addKnob("wsTp1Depth")
    .setRange(0,1)
    .setValue(0.2)
    .setPosition(195, height - 85)
    .setSize(50, 50)
    .setLabelVisible(true);
  wsTp2Freq = cp5.addKnob("wsTp2Freq")
    .setRange(0,1)
    .setValue(0.2)
    .setPosition(280, height - 85)
    .setSize(50, 50)
    .setLabelVisible(true);
  wsTp2Depth = cp5.addKnob("wsTp2Depth")
    .setRange(0,1)
    .setValue(0.2)
    .setPosition(365, height - 85)
    .setSize(50, 50)
    .setLabelVisible(true);
  
  
  
  //BEE AGENT INTERFACE
  maxSpeedSlider = cp5.addKnob("maxSpeed")
    .setRange(0,10)
    .setValue(2.0)
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(0.4 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(0.4 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  maxSpeedSlider.setVisible(agentSlidVis);
  maxForceSlider = cp5.addKnob("maxForce")
    .setRange(0.01, 2)
    .setValue(0.2)
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(0.3 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(0.3 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  maxForceSlider.setVisible(agentSlidVis);
  beeVisionKnob = cp5.addKnob("beeVision")
    .setRange(10, 200)
    .setValue(175)
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(0.2 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(0.2 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  beeVisionKnob.setVisible(agentSlidVis);
  attractRepulse = cp5.addKnob("attract-repulse")
    .setRange(0, 1)
    .setValue(0.5)
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge + 100) * cos(0.32 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge + 100) * sin(0.32 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  attractRepulse.setVisible(agentSlidVis);
  ffVelDepth = cp5.addKnob("forcefield-velocity")
    .setRange(0, 1)
    .setValue(0.5)
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge + 100) * cos(0.28 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge + 100) * sin(0.28 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  ffVelDepth.setVisible(agentSlidVis);
  ffForceDepth = cp5.addKnob("forcefield-force")
    .setRange(0, 1)
    .setValue(0.5)
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge + 100) * cos(0.24 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge + 100) * sin(0.24 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  ffForceDepth.setVisible(agentSlidVis);
  ///BEE SOUND INTERFACE
  beeAmplitudeSlider = cp5.addSlider("beeAmplitude")
    .setRange(0,1)
    .setValue(0.25)
    .setPosition(10, 10)
    .setSize(20, 100)
    .setLabelVisible(true);
  beeAmplitudeSlider.setVisible(soundSlidVis);
  freqSlider = cp5.addKnob("freq")
    .setRange(0,1)
    .setValue(0.3)
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius + interfaceDistEdge) * cos(0.6 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(0.6 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  freqSlider.setVisible(soundSlidVis);
  
  freqModFreqSlider = cp5.addKnob("fmFreq")
    .setRange(0,1)
    .setValue(0)
    .setPosition( (sysCentre.x - 130) + ((sysWinRadius +interfaceDistEdge) * cos(0.75 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(0.75 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  freqModFreqSlider.setVisible(soundSlidVis);
  freqModDepthSlider = cp5.addKnob("fmDepth")
    .setRange(0,1)
    .setValue(0)
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius +interfaceDistEdge) * cos(0.75 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(0.75 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  freqModDepthSlider.setVisible(soundSlidVis);
  
  hpfCutoffBeeSlider = cp5.addKnob("hpfCutoff")
    .setRange(0,1)
    .setValue(0)
    .setPosition((sysCentre.x - 25) + ((sysWinRadius +interfaceDistEdge) * cos(0.87 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(0.87 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  hpfCutoffBeeSlider.setVisible(soundSlidVis);
  lpfCutoffBeeSlider = cp5.addKnob("lpfCutoff")
    .setRange(0,1)
    .setValue(0.3)
    .setPosition( (sysCentre.x - 25) + ((sysWinRadius +interfaceDistEdge) * cos(0.95 * PI)), (sysCentre.y - 25) - ((sysWinRadius + interfaceDistEdge) * sin(0.95 * PI)))
    .setSize(50, 50)
    .setLabelVisible(true);
  lpfCutoffBeeSlider.setVisible(soundSlidVis);
  
  waveShaper1Freq = cp5.addKnob("waveShaper1Freq")
    .setRange(0,1)
    .setValue(0)
    .setPosition(110, 35)
    .setSize(50, 50)
    .setLabelVisible(true);
  waveShaper1Depth = cp5.addKnob("waveShaper1Depth")
    .setRange(0,1)
    .setValue(0)
    .setPosition(195, 35)
    .setSize(50, 50)
    .setLabelVisible(true);
  waveShaper2Freq = cp5.addKnob("waveShaper2Freq")
    .setRange(0,1)
    .setValue(0)
    .setPosition(280, 35)
    .setSize(50, 50)
    .setLabelVisible(true);
  waveShaper2Depth = cp5.addKnob("waveShaper2Depth")
    .setRange(0,1)
    .setValue(0)
    .setPosition(365, 35)  
    .setSize(50, 50)
    .setLabelVisible(true);
  
    
    
  //Interaction Matrix
  distBeeDepth = cp5.addKnob("distBeeDepth") 
    .setRange(0, 1)
    .setValue(0.5)
    .setPosition(distBeeNode.x - 20, distBeeNode.y - 80)
    .setColorBackground(color(165, 125, 22))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40);
  distTpDepth = cp5.addKnob("distTpDepth")
    .setRange(0, 1)
    .setValue(0.5)
    .setPosition(distTpNode.x - 20, distTpNode.y + 40)
    .setColorBackground(color(36, 31, 203))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40);
    
  beeCallBeeChance = cp5.addKnob("chance B-B")
    .setRange(0,0.05)
    .setValue(0.025)
    .setPosition(beeBeeNode.x - 80, beeBeeNode.y - 30)
    .setColorBackground(color(232, 225, 14))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40)
    .setLabelVisible(true);
  beeCallBeeChance.setVisible(true);  
  beeCallBeeDepth = cp5.addKnob("depth B-B")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(beeBeeNode.x + 40, beeBeeNode.y - 30)
    .setColorBackground(color(232, 225, 14))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40)
    .setLabelVisible(true);
  beeCallBeeDepth.setVisible(true);
  beeBeeEnvAttack = cp5.addKnob("B-B-AT")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(20, sysCentre.y - 165)
    .setColorBackground(color(232, 225, 14))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(30, 30)
    .setDragDirection(Knob.VERTICAL)
    .setLabelVisible(true);
  beeBeeEnvRelease = cp5.addKnob("B-B-RE")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(20, sysCentre.y - 115)
    .setColorBackground(color(232, 225, 14))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(30, 30)
    .setDragDirection(Knob.VERTICAL)
    .setLabelVisible(true);
  
  tadpoleCalltadpoleChance = cp5.addKnob("chance TP-TP")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(tpTpNode.x - 80, tpTpNode.y - 10)
    .setColorBackground(color(32, 165, 245))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40)
    .setLabelVisible(true);
  tadpoleCalltadpoleChance.setVisible(true);
  tadpoleCalltadpoleDepth = cp5.addKnob("depth TP-TP")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(tpTpNode.x + 40, tpTpNode.y - 10)
    .setColorBackground(color(32, 165, 245))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40)
    .setLabelVisible(true);
  tadpoleCalltadpoleDepth.setVisible(true);
  
  tadpoleCallBeeChance = cp5.addKnob("chance TP-B")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(tpBeeNode.x - 45, tpBeeNode.y - 70)
    .setColorBackground(color(4, 108, 3))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40)
    .setLabelVisible(true);
  tadpoleCallBeeChance.setVisible(true);
  tadpoleCallBeeDepth = cp5.addKnob("depth TP-B")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(tpBeeNode.x - 45, tpBeeNode.y + 30)
    .setColorBackground(color(4, 108, 3))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40)
    .setLabelVisible(true);
  tadpoleCallBeeDepth.setVisible(true);
  tpBeeEnvAttack = cp5.addKnob("TP-B-ATT")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(20, sysCentre.y - 65)
    .setColorBackground(color(4, 108, 3))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(30, 30)
    .setDragDirection(Knob.VERTICAL)
    .setLabelVisible(true);
  tpBeeEnvRelease = cp5.addKnob("TP-B-RE")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(20, sysCentre.y - 15)
    .setColorBackground(color(4, 108, 3))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(30, 30)
    .setDragDirection(Knob.VERTICAL)
    .setLabelVisible(true);
  
  beeCallTadpoleChance = cp5.addKnob("chance B-TP")
    .setRange(0,0.05)
    .setValue(0.025)
    .setPosition(beeTpNode.x + 5, beeTpNode.y - 70)
    .setColorBackground(color(31, 232, 14))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40)
    .setLabelVisible(true);
  beeCallTadpoleChance.setVisible(true);
  beeCallTadpoleDepth = cp5.addKnob("depth B-TP")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(beeTpNode.x + 5, beeTpNode.y + 30)
    .setColorBackground(color(31, 232, 14))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(40, 40)
    .setLabelVisible(true);
  beeCallTadpoleDepth.setVisible(true);
  beeTpEnvAttack = cp5.addKnob("B-TP-ATT")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(20, sysCentre.y + 35)
    .setColorBackground(color(31, 232, 14))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(30, 30)
    .setDragDirection(Knob.VERTICAL)
    .setLabelVisible(true);
  beeTpEnvRelease = cp5.addKnob("B-TP-RE")
    .setRange(0,1)
    .setValue(0.5)
    .setPosition(20, sysCentre.y + 85)
    .setColorBackground(color(31, 232, 14))
    .setColorForeground(color(0))
    .setColorActive(color(255))
    .setSize(30, 30)
    .setDragDirection(Knob.VERTICAL)
    .setLabelVisible(true);
  
  tadpoleRespondDepth = cp5.addKnob("tadpoleRespondDepth")
    .setRange(0,1)
    .setValue(0)
    .setPosition(matrixWindowXOffset + 420, matrixWindowYOffset + 25)
    .setSize(50, 50)
    .setLabelVisible(true);
  tadpoleRespondDepth.setVisible(matrixVis);
  beeRespondDepth = cp5.addKnob("beeResondDepth")
    .setRange(0,1)
    .setValue(0)
    .setPosition(matrixWindowXOffset + 420, matrixWindowYOffset + 125)
    .setSize(50, 50)
    .setLabelVisible(true);
  beeRespondDepth.setVisible(matrixVis);
    
    //add Food
   addFood = cp5.addButton("addFood")
    .setPosition(width - 100, height - 120)
    .setSize(50, 50);
  addFood.setVisible(systemButVis);
   removeFood = cp5.addButton("removeFood")
    .setPosition(width - 100, height - 60)
    .setSize(50, 50);
  removeFood.setVisible(systemButVis);
  
  //sprayParticles
  for(int i = 0; i < 2; i++) {
    addTadpoles = cp5.addButton("tadpoleAdd")
    .setPosition(sysCentre.x + 25, sysCentre.y + sysWinRadius)
    .setSize(50, 50);
    addBees = cp5.addButton("beeAdd")
    .setPosition(sysCentre.x - 75, sysCentre.y - sysWinRadius - 50)
    .setSize(50, 50);
    removeTadpoles = cp5.addButton("tadpoleRemove")
    .setPosition(sysCentre.x - 75, sysCentre.y + sysWinRadius)
    .setSize(50, 50);
    removeBees = cp5.addButton("beeRemove")
    .setPosition(sysCentre.x + 25, sysCentre.y - sysWinRadius - 50)
    .setSize(50, 50);
  }
  addTadpoles.setVisible(true);
  addBees.setVisible(true);
  removeTadpoles.setVisible(true);
  removeBees.setVisible(true);
  
  //turnPathOnOff
 pathOnOff = cp5.addToggle("pathOnOff")
     .setPosition(width - 100, 100)
     .setSize(50,50)
     .setValue(false)
     .setMode(ControlP5.SWITCH);
   pathOnOff.setVisible(true);
   
  edgesOnOff = cp5.addToggle("edgesOnOff")
     .setPosition(width - 100, 200)
     .setSize(50,50)
     .setValue(false)
     .setMode(ControlP5.SWITCH);
   pathOnOff.setVisible(true);
   
  flockingOnOff = cp5.addToggle("flockingOnOff")
     .setPosition(width - 300, 0)
     .setSize(30,30)
     .setValue(false)
     .setMode(ControlP5.SWITCH);
   pathOnOff.setVisible(true);
   
   seperationWeight = cp5.addSlider("seperationWeight")
     .setPosition(width - 300, 50)
     .setSize(60, 30)
     .setValue(1)
     .setRange(0.5, 2);
   allignmentWeight = cp5.addSlider("allignmentWeight")
     .setPosition(width - 300, 90)
     .setSize(60, 30)
     .setValue(1)
     .setRange(0.5, 2);
   cohesionWeight = cp5.addSlider("cohesionWeight")
     .setPosition(width - 300, 130)
     .setSize(60, 30)
     .setValue(1)
     .setRange(0.5, 2);  
   
   
   
   
   ///CALC BEE IND POS
  for(int i = 0; i < 6; i++) {
    freqSlidIndPos[i] = new PVector(freqSlider.getPosition()[0] - 12 + (15 * i), freqSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 6; i++) {
    freqModFreqIndPos[i] = new PVector(freqModFreqSlider.getPosition()[0] - 12 + (15 * i), freqModFreqSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 6; i++) {
    freqModDepthIndPos[i] = new PVector(freqModDepthSlider.getPosition()[0] - 12 + (15 * i), freqModDepthSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 6; i++) {
    hpfBeeIndPos[i] = new PVector(hpfCutoffBeeSlider.getPosition()[0] - 12 + (15 * i), hpfCutoffBeeSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 6; i++) {
    lpfBeeIndPos[i] = new PVector(lpfCutoffBeeSlider.getPosition()[0] - 12 + (15 * i), lpfCutoffBeeSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 6; i++) {
    beeAmpIndPos[i] = new PVector(beeAmplitudeSlider.getPosition()[0] + (15 * i), beeAmplitudeSlider.getPosition()[1] + 120);
  }
  for(int i = 0; i < 6; i++) {
    ws1FreqIndPos[i] = new PVector(waveShaper1Freq.getPosition()[0] - 12 + (15 * i), waveShaper1Freq.getPosition()[1] - 30);
  }
  for(int i = 0; i < 6; i++) {
    ws1DepthIndPos[i] = new PVector(waveShaper1Depth.getPosition()[0] - 12 + (15 * i), waveShaper1Depth.getPosition()[1] - 30);
  }
  for(int i = 0; i < 6; i++) {
    ws2FreqIndPos[i] = new PVector(waveShaper2Freq.getPosition()[0] - 12 + (15 * i), waveShaper2Freq.getPosition()[1] - 30);
  }
  for(int i = 0; i < 6; i++) {
    ws2DepthIndPos[i] = new PVector(waveShaper2Depth.getPosition()[0] - 12 + (15 * i), waveShaper2Depth.getPosition()[1] - 30);
  }
  
  
  //CALC TADPOLE IND POS
  for(int i = 0; i < 5; i++) {
    fundFreqIndPos[i] = new PVector(fundFreqSlider.getPosition()[0] - 12 + (15 * i), fundFreqSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 5; i++) {
    formFreqIndPos[i] = new PVector(formFreqSlider.getPosition()[0] - 12 + (15 * i), formFreqSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 5; i++) {
    bodyFreqIndPos[i] = new PVector(bodyFreqSlider.getPosition()[0] - 12 + (15 * i), bodyFreqSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 5; i++) {
    grainSizeIndPos[i] = new PVector(grainSize.getPosition()[0] - 12 + (15 * i), grainSize.getPosition()[1] - 30);
  }
  for(int i = 0; i < 5; i++) {
    hpfTpIndPos[i] = new PVector(hpfCutoffTpSlider.getPosition()[0] - 12 + (15 * i), hpfCutoffTpSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 5; i++) {
    lpfTpIndPos[i] = new PVector(lpfCutoffTpSlider.getPosition()[0] - 12 + (15 * i), lpfCutoffTpSlider.getPosition()[1] - 30);
  }
  for(int i = 0; i < 5; i++) {
    wsTp1FreqIndPos[i] = new PVector(wsTp1Freq.getPosition()[0] - 12 + (15 * i), wsTp1Freq.getPosition()[1] - 30);
  }
  for(int i = 0; i < 5; i++) {
    wsTp1DepthIndPos[i] = new PVector(wsTp1Depth.getPosition()[0] - 12 + (15 * i), wsTp1Depth.getPosition()[1] - 30);
  }
  for(int i = 0; i < 5; i++) {
    wsTp2FreqIndPos[i] = new PVector(wsTp2Freq.getPosition()[0] - 12 + (15 * i), wsTp2Freq.getPosition()[1] - 30);
  }
  for(int i = 0; i < 5; i++) {
    wsTp2DepthIndPos[i] = new PVector(wsTp2Depth.getPosition()[0] - 12 + (15 * i), wsTp2Depth.getPosition()[1] - 30);
  }
  beeBeeEnvAttackIndPos = new PVector(beeBeeEnvAttack.getPosition()[0] - 5, beeBeeEnvAttack.getPosition()[1] - 10);
  beeBeeEnvReleaseIndPos = new PVector(beeBeeEnvRelease.getPosition()[0] - 5, beeBeeEnvRelease.getPosition()[1] - 10);
  tpBeeEnvAttackIndPos = new PVector(tpBeeEnvAttack.getPosition()[0] - 5, tpBeeEnvAttack.getPosition()[1] - 10);
  tpBeeEnvReleaseIndPos = new PVector(tpBeeEnvRelease.getPosition()[0] - 5, tpBeeEnvRelease.getPosition()[1] - 10);
  beeTpEnvAttackIndPos = new PVector(beeTpEnvAttack.getPosition()[0] - 5, beeTpEnvAttack.getPosition()[1] - 10);
  beeTpEnvReleaseIndPos = new PVector(beeTpEnvRelease.getPosition()[0] - 5, beeTpEnvRelease.getPosition()[1] - 10);
  //Make soundKnobArray
  //BEE KNOBS
  soundKnobs[0] = freqSlider;
  soundKnobs[1] = freqModFreqSlider;
  soundKnobs[2] = freqModDepthSlider;
  soundKnobs[3] = hpfCutoffBeeSlider;
  soundKnobs[4] = lpfCutoffBeeSlider;
  soundKnobs[5] = waveShaper1Freq;
  soundKnobs[6] = waveShaper1Depth;
  soundKnobs[7] = waveShaper2Freq;
  soundKnobs[8] = waveShaper2Depth;
  
  //TP KNOBS
  soundKnobs[9] = fundFreqSlider;
  soundKnobs[10] = formFreqSlider;
  soundKnobs[11] = bodyFreqSlider;
  soundKnobs[12] = grainSize;
  soundKnobs[13] = hpfCutoffTpSlider;
  soundKnobs[14] = lpfCutoffTpSlider;
  soundKnobs[15] = wsTp1Freq;
  soundKnobs[16] = wsTp1Depth;
  soundKnobs[17] = wsTp2Freq;
  soundKnobs[18] = wsTp2Depth;
  
  //ENV KNOBS
  envKnobs[0] = beeBeeEnvAttack;
  envKnobs[1] = beeBeeEnvRelease;
  envKnobs[2] = tpBeeEnvAttack;
  envKnobs[3] = tpBeeEnvRelease;
  envKnobs[4] = beeTpEnvAttack;
  envKnobs[5] = beeTpEnvRelease;
  
  //Make NodeArray
  allNodes[0] = distBeeNode;
  allNodes[1] = beeBeeNode;
  allNodes[2] = tpBeeNode;
  allNodes[3] = beeTpNode;
  allNodes[4] = tpTpNode;
  allNodes[5] = distTpNode;
  allNodes[6] = forcefieldNode;
  allNodes[7] = beeSpeedNode;
  
  //make color array
  allColors[0] = color(165, 125, 22);
  allColors[1] = color(232, 225, 14);
  allColors[2] = color(4, 108, 3);
  allColors[3] = color(31, 232, 14);
  allColors[4] = color(32, 165, 245);
  allColors[5] = color(36, 31, 203);
  allColors[6] = color(170);
  allColors[7] = color(245, 19, 7);
  
 
  
  beeSpeedNode = new PVector(maxSpeedSlider.getPosition()[0] + 25, maxSpeedSlider.getPosition()[1] - 20);
}

void drawInteractionWindow(int xPos, int yPos) {
  float radiusSelfArrow = 70;
  
    //Make NodeSelArray
  allNodesSel[0] = distBeeNodeSel;
  allNodesSel[1] = beeBeeNodeSel;
  allNodesSel[2] = tpBeeNodeSel;
  allNodesSel[3] = beeTpNodeSel;
  allNodesSel[4] = tpTpNodeSel;
  allNodesSel[5] = distTpNodeSel;
  allNodesSel[6] = forcefieldNodeSel;
  allNodesSel[7] = beeSpeedNodeSel;
  
  pushMatrix();
  fill(10);
  stroke(20);
  strokeWeight(3);
  rect(xPos, yPos, 200, 400);
  translate(xPos, yPos);
  strokeWeight(5);
  noFill();
  
  stroke(32, 165, 245);
  arc(100, 300, radiusSelfArrow, radiusSelfArrow, -0.25 * PI, 1.25 * PI); //TPTP
  ellipse(tpTpNode.x - xPos, tpTpNode.y - yPos, 40, 40);
  stroke(36, 31, 203);
  ellipse(distTpNode.x - xPos, distTpNode.y - yPos, 40, 40);
  
  stroke(232, 225, 14);
  arc(100, 100, radiusSelfArrow, radiusSelfArrow, 0.75 * PI, 2.25*PI); //BEBE
  ellipse(beeBeeNode.x - xPos, beeBeeNode.y - yPos, 40, 40);
  stroke(165, 125, 22);
  ellipse(distBeeNode.x - xPos, distBeeNode.y - yPos, 40, 40);
  
  stroke(4, 108, 3);
  arc(135, 200, radiusSelfArrow*2, radiusSelfArrow*2, 0.75*PI, 1.25*PI);//TPBE
  ellipse(tpBeeNode.x - xPos, tpBeeNode.y - yPos, 40, 40);
  
  stroke(31, 232, 14);
  arc(65, 200, radiusSelfArrow*2, radiusSelfArrow*2, -0.25*PI, 0.25*PI);//BETP
  ellipse(beeTpNode.x - xPos, beeTpNode.y - yPos, 40, 40);
    
  strokeWeight(2);
  stroke(32, 165, 245);
  ellipse(100 + (cos(0.25*PI) * (radiusSelfArrow/2)), 300 - (sin(0.25*PI) * (radiusSelfArrow/2)), 20, 20);
  stroke(232, 225, 14);
  ellipse(100 + (cos(1.25*PI) * (radiusSelfArrow/2)), 100 - (sin(1.25*PI) * (radiusSelfArrow/2)), 20, 20);
  stroke(4, 108, 3);
  ellipse(135 + (cos(0.75*PI) * (radiusSelfArrow)), 200 - (sin(0.75*PI) * (radiusSelfArrow)), 20, 20);
  stroke(31, 232, 14);
  ellipse(65 + (cos(-0.25*PI) * (radiusSelfArrow)), 200 - (sin(-0.25*PI) * (radiusSelfArrow)), 20, 20);
  stroke(150, 200, 5);
  


  
  
  //SELECTED NODES
  if(tpTpNodeSel) {
    fill(32, 165, 245);
    stroke(32, 165, 245);
    ellipse(tpTpNode.x - xPos, tpTpNode.y - yPos, 40, 40);
  }
  if(tpBeeNodeSel) {
    fill(4, 108, 3);
    stroke(4, 108, 3);
    ellipse(tpBeeNode.x - xPos, tpBeeNode.y - yPos, 40, 40);
  }
  if(beeTpNodeSel) {
    fill(31, 232, 14);
    stroke(31, 232, 14);
    ellipse(beeTpNode.x - xPos, beeTpNode.y - yPos, 40, 40);
  }
  if(beeBeeNodeSel) {
    fill(232, 225, 14);
    stroke(232, 225, 14);
    ellipse(beeBeeNode.x - xPos, beeBeeNode.y - yPos, 40, 40);
  }
  if(distTpNodeSel) {
    fill(36, 31, 203);
    stroke(36, 31, 203);
    ellipse(distTpNode.x - xPos, distTpNode.y - yPos, 40, 40);
  }
  if(distBeeNodeSel) {
    fill(165, 125, 22);
    stroke(165, 125, 22);
    ellipse(distBeeNode.x - xPos, distBeeNode.y - yPos, 40, 40);
  }
  if(beeSpeedNodeSel) {
    translate(-xPos, -yPos);
    stroke(245, 19, 7);
    fill(245, 19, 7);
    ellipse(beeSpeedNode.x, beeSpeedNode.y, 20, 20);
    translate(xPos, yPos);
  }
  
  //DRAW FAKE BEE
  pushMatrix();
  fill(255, 204, 0);
  stroke(255, 204, 30);
  translate(100,130);
  rotate(PI);
  beginShape();
  vertex(0, -7*2);
  vertex(-7, 7*2);
  vertex(7, 7*2);
  endShape(CLOSE);
  popMatrix();
  
  //DRAW FAKE TP
  fill(200);
  stroke(32, 165, 245);
  strokeWeight(2);
  ellipse(100, 270, 10, 10);
  
  for(int i = 1; i < 5; i++) {
    strokeWeight(4.0);
    stroke(200);
    line(100, 270 + (i*4), 100, 270 + ((i+1) * 4));
  }
  popMatrix();
  
  //DRAW KNOB CONNECTOR INDICATORS
  
  //Bee speed node
  stroke(245, 19, 7);
  noFill();
  strokeWeight(2);
  ellipse(beeSpeedNode.x, beeSpeedNode.y, 20, 20);
  
  //DIST BEE
  fill(165, 125, 22);
  stroke(165, 125, 22);
  if(distBeeNodeCon[0]==1) {
    ellipse(freqSlidIndPos[0].x, freqSlidIndPos[0].y, 8, 8);
  }
  if(distBeeNodeCon[1]==1) {
    ellipse(freqModFreqIndPos[0].x, freqModFreqIndPos[0].y, 8, 8);
  }
  if(distBeeNodeCon[2]==1) {
    ellipse(freqModDepthIndPos[0].x, freqModDepthIndPos[0].y, 8, 8);
  }
  if(distBeeNodeCon[3]==1) {
    ellipse(hpfBeeIndPos[0].x, hpfBeeIndPos[0].y, 8, 8);
  }
  if(distBeeNodeCon[4]==1) {
    ellipse(lpfBeeIndPos[0].x, lpfBeeIndPos[0].y, 8, 8);
  }
  if(distBeeNodeCon[5]==1) {
    ellipse(ws1FreqIndPos[0].x, ws1FreqIndPos[0].y, 8, 8);
  }
  if(distBeeNodeCon[6]==1) {
    ellipse(ws1DepthIndPos[0].x, ws1DepthIndPos[0].y, 8, 8);
  }
  if(distBeeNodeCon[7]==1) {
    ellipse(ws2FreqIndPos[0].x, ws2FreqIndPos[0].y, 8, 8);
  }
  if(distBeeNodeCon[8]==1) {
    ellipse(ws2DepthIndPos[0].x, ws2DepthIndPos[0].y, 8, 8);
  }
  
  //BEEFORCEFIELD
  fill(170);
  stroke(170);
  if(forceFieldNodeCon[0]==1) {
    ellipse(freqSlidIndPos[4].x, freqSlidIndPos[4].y, 8, 8);
  }
  if(forceFieldNodeCon[1]==1) {
    ellipse(freqModFreqIndPos[4].x, freqModFreqIndPos[4].y, 8, 8);
  }
  if(forceFieldNodeCon[2]==1) {
    ellipse(freqModDepthIndPos[4].x, freqModDepthIndPos[4].y, 8, 8);
  }
  if(forceFieldNodeCon[3]==1) {
    ellipse(hpfBeeIndPos[4].x, hpfBeeIndPos[4].y, 8, 8);
  }
  if(forceFieldNodeCon[4]==1) {
    ellipse(lpfBeeIndPos[4].x, lpfBeeIndPos[4].y, 8, 8);
  }
  if(forceFieldNodeCon[5]==1) {
    ellipse(ws1FreqIndPos[4].x, ws1FreqIndPos[4].y, 8, 8);
  }
  if(forceFieldNodeCon[6]==1) {
    ellipse(ws1DepthIndPos[4].x, ws1DepthIndPos[4].y, 8, 8);
  }
  if(forceFieldNodeCon[7]==1) {
    ellipse(ws2FreqIndPos[4].x, ws2FreqIndPos[4].y, 8, 8);
  }
  if(forceFieldNodeCon[8]==1) {
    ellipse(ws2DepthIndPos[4].x, ws2DepthIndPos[4].y, 8, 8);
  }
  
  //BEESPEED
  fill(245, 19, 7);
  stroke(245, 19, 7);
  if(beeSpeedNodeCon[0]==1) {
    ellipse(freqSlidIndPos[5].x, freqSlidIndPos[5].y, 8, 8);
  }
  if(beeSpeedNodeCon[1]==1) {
    ellipse(freqModFreqIndPos[5].x, freqModFreqIndPos[5].y, 8, 8);
  }
  if(beeSpeedNodeCon[2]==1) {
    ellipse(freqModDepthIndPos[5].x, freqModDepthIndPos[5].y, 8, 8);
  }
  if(beeSpeedNodeCon[3]==1) {
    ellipse(hpfBeeIndPos[5].x, hpfBeeIndPos[5].y, 8, 8);
  }
  if(beeSpeedNodeCon[4]==1) {
    ellipse(lpfBeeIndPos[5].x, lpfBeeIndPos[5].y, 8, 8);
  }
  if(beeSpeedNodeCon[5]==1) {
    ellipse(ws1FreqIndPos[5].x, ws1FreqIndPos[5].y, 8, 8);
  }
  if(beeSpeedNodeCon[6]==1) {
    ellipse(ws1DepthIndPos[5].x, ws1DepthIndPos[5].y, 8, 8);
  }
  if(beeSpeedNodeCon[7]==1) {
    ellipse(ws2FreqIndPos[5].x, ws2FreqIndPos[5].y, 8, 8);
  }
  if(beeSpeedNodeCon[8]==1) {
    ellipse(ws2DepthIndPos[5].x, ws2DepthIndPos[5].y, 8, 8);
  }
  
  //BEE-BEE
  fill(232, 225, 14);
  stroke(232, 225, 14);
  if(beeBeeNodeCon[0]==1) {
    ellipse(freqSlidIndPos[1].x, freqSlidIndPos[1].y, 8, 8);
  }
  if(beeBeeNodeCon[1]==1) {
    ellipse(freqModFreqIndPos[1].x, freqModFreqIndPos[1].y, 8, 8);
  }
  if(beeBeeNodeCon[2]==1) {
    ellipse(freqModDepthIndPos[1].x, freqModDepthIndPos[1].y, 8, 8);
  }
  if(beeBeeNodeCon[3]==1) {
    ellipse(hpfBeeIndPos[1].x, hpfBeeIndPos[1].y, 8, 8);
  }
  if(beeBeeNodeCon[4]==1) {
    ellipse(lpfBeeIndPos[1].x, lpfBeeIndPos[1].y, 8, 8);
  }
  if(beeBeeNodeCon[5]==1) {
    ellipse(ws1FreqIndPos[1].x, ws1FreqIndPos[1].y, 8, 8);
  }
  if(beeBeeNodeCon[6]==1) {
    ellipse(ws1DepthIndPos[1].x, ws1DepthIndPos[1].y, 8, 8);
  }
  if(beeBeeNodeCon[7]==1) {
    ellipse(ws2FreqIndPos[1].x, ws2FreqIndPos[1].y, 8, 8);
  }
  if(beeBeeNodeCon[8]==1) {
    ellipse(ws2DepthIndPos[1].x, ws2DepthIndPos[1].y, 8, 8);
  }
  
    //ENV NODE CON
  if(envNodeCon[0] == 1) {
    ellipse(beeBeeEnvAttackIndPos.x, beeBeeEnvAttackIndPos.y, 5, 5);
  }
  if(envNodeCon[1] == 1) {
    ellipse(beeBeeEnvReleaseIndPos.x, beeBeeEnvReleaseIndPos.y, 5, 5);
  }
  if(envNodeCon[2] == 1) {
    ellipse(tpBeeEnvAttackIndPos.x, tpBeeEnvAttackIndPos.y, 5, 5);
  }
  if(envNodeCon[3] == 1) {
    ellipse(tpBeeEnvReleaseIndPos.x, tpBeeEnvReleaseIndPos.y, 5, 5);
  }
  if(envNodeCon[4] == 1) {
    ellipse(beeTpEnvAttackIndPos.x, beeTpEnvAttackIndPos.y, 5, 5);
  }
  if(envNodeCon[5] == 1) {
    ellipse(beeTpEnvReleaseIndPos.x, beeTpEnvReleaseIndPos.y, 5, 5);
  }
  
  //TP-BEE
  fill(4, 108, 3);
  stroke(4, 108, 3);
  //BEE KNOBS
  if(tpBeeNodeCon[0]==1) {
    ellipse(freqSlidIndPos[2].x, freqSlidIndPos[2].y, 8, 8);
  }
  if(tpBeeNodeCon[1]==1) {
    ellipse(freqModFreqIndPos[2].x, freqModFreqIndPos[2].y, 8, 8);
  }
  if(tpBeeNodeCon[2]==1) {
    ellipse(freqModDepthIndPos[2].x, freqModDepthIndPos[2].y, 8, 8);
  }
  if(tpBeeNodeCon[3]==1) {
    ellipse(hpfBeeIndPos[2].x, hpfBeeIndPos[2].y, 8, 8);
  }
  if(tpBeeNodeCon[4]==1) {
    ellipse(lpfBeeIndPos[2].x, lpfBeeIndPos[2].y, 8, 8);
  }
  if(tpBeeNodeCon[5]==1) {
    ellipse(ws1FreqIndPos[2].x, ws1FreqIndPos[2].y, 8, 8);
  }
  if(tpBeeNodeCon[6]==1) {
    ellipse(ws1DepthIndPos[2].x, ws1DepthIndPos[2].y, 8, 8);
  }
  if(tpBeeNodeCon[7]==1) {
    ellipse(ws2FreqIndPos[2].x, ws2FreqIndPos[2].y, 8, 8);
  }
  if(tpBeeNodeCon[8]==1) {
    ellipse(ws2DepthIndPos[2].x, ws2DepthIndPos[2].y, 8, 8);
  }
  //TP KNOBS
  if(tpBeeNodeCon[9]==1) {
    ellipse(fundFreqIndPos[3].x, fundFreqIndPos[3].y, 8, 8);
  }
  if(tpBeeNodeCon[10]==1) {
    ellipse(formFreqIndPos[3].x, formFreqIndPos[3].y, 8, 8);
  }
  if(tpBeeNodeCon[11]==1) {
    ellipse(bodyFreqIndPos[3].x, bodyFreqIndPos[3].y, 8, 8);
  }
  if(tpBeeNodeCon[12]==1) {
    ellipse(grainSizeIndPos[3].x, grainSizeIndPos[3].y, 8, 8);
  }
  if(tpBeeNodeCon[13]==1) {
    ellipse(hpfTpIndPos[3].x, hpfTpIndPos[3].y, 8, 8);
  }
  if(tpBeeNodeCon[14]==1) {
    ellipse(lpfTpIndPos[3].x, lpfTpIndPos[3].y, 8, 8);
  }
  if(tpBeeNodeCon[15]==1) {
    ellipse(wsTp1FreqIndPos[3].x, wsTp1FreqIndPos[3].y, 8, 8);
  }
  if(tpBeeNodeCon[16]==1) {
    ellipse(wsTp1DepthIndPos[3].x, wsTp1DepthIndPos[3].y, 8, 8);
  }
  if(tpBeeNodeCon[17]==1) {
    ellipse(wsTp2FreqIndPos[3].x, wsTp2FreqIndPos[3].y, 8, 8);
  }
  if(tpBeeNodeCon[18]==1) {
    ellipse(wsTp2DepthIndPos[3].x, wsTp2DepthIndPos[3].y, 8, 8);
  }
  
  //BEE-TP
  fill(31, 232, 14);
  stroke(31, 232, 14);
  //BEE KNOBS
  if(beeTpNodeCon[0]==1) {
    ellipse(freqSlidIndPos[3].x, freqSlidIndPos[3].y, 8, 8);
  }
  if(beeTpNodeCon[1]==1) {
    ellipse(freqModFreqIndPos[3].x, freqModFreqIndPos[3].y, 8, 8);
  }
  if(beeTpNodeCon[2]==1) {
    ellipse(freqModDepthIndPos[3].x, freqModDepthIndPos[3].y, 8, 8);
  }
  if(beeTpNodeCon[3]==1) {
    ellipse(hpfBeeIndPos[3].x, hpfBeeIndPos[3].y, 8, 8);
  }
  if(beeTpNodeCon[4]==1) {
    ellipse(lpfBeeIndPos[3].x, lpfBeeIndPos[3].y, 8, 8);
  }
  if(beeTpNodeCon[5]==1) {
    ellipse(ws1FreqIndPos[3].x, ws1FreqIndPos[3].y, 8, 8);
  }
  if(beeTpNodeCon[6]==1) {
    ellipse(ws1DepthIndPos[3].x, ws1DepthIndPos[3].y, 8, 8);
  }
  if(beeTpNodeCon[7]==1) {
    ellipse(ws2FreqIndPos[3].x, ws2FreqIndPos[3].y, 8, 8);
  }
  if(beeTpNodeCon[8]==1) {
    ellipse(ws2DepthIndPos[3].x, ws2DepthIndPos[3].y, 8, 8);
  }
  //TP KNOBS
  if(beeTpNodeCon[9]==1) {
    ellipse(fundFreqIndPos[2].x, fundFreqIndPos[2].y, 8, 8);
  }
  if(beeTpNodeCon[10]==1) {
    ellipse(formFreqIndPos[2].x, formFreqIndPos[2].y, 8, 8);
  }
  if(beeTpNodeCon[11]==1) {
    ellipse(bodyFreqIndPos[2].x, bodyFreqIndPos[2].y, 8, 8);
  }
  if(beeTpNodeCon[12]==1) {
    ellipse(grainSizeIndPos[2].x, grainSizeIndPos[2].y, 8, 8);
  }
  if(beeTpNodeCon[13]==1) {
    ellipse(hpfTpIndPos[2].x, hpfTpIndPos[2].y, 8, 8);
  }
  if(beeTpNodeCon[14]==1) {
    ellipse(lpfTpIndPos[2].x, lpfTpIndPos[2].y, 8, 8);
  }
  if(beeTpNodeCon[15]==1) {
    ellipse(wsTp1FreqIndPos[2].x, wsTp1FreqIndPos[2].y, 8, 8);
  }
  if(beeTpNodeCon[16]==1) {
    ellipse(wsTp1DepthIndPos[2].x, wsTp1DepthIndPos[2].y, 8, 8);
  }
  if(beeTpNodeCon[17]==1) {
    ellipse(wsTp2FreqIndPos[2].x, wsTp2FreqIndPos[2].y, 8, 8);
  }
  if(beeTpNodeCon[18]==1) {
    ellipse(wsTp2DepthIndPos[2].x, wsTp2DepthIndPos[2].y, 8, 8);
  }
  
  //TP-TP
  fill(32, 165, 245);
  stroke(32, 165, 245);
  if(tpTpNodeCon[0]==1) {
    ellipse(fundFreqIndPos[1].x, fundFreqIndPos[1].y, 8, 8);
  }
  if(tpTpNodeCon[1]==1) {
    ellipse(formFreqIndPos[1].x, formFreqIndPos[1].y, 8, 8);
  }
  if(tpTpNodeCon[2]==1) {
    ellipse(bodyFreqIndPos[1].x, bodyFreqIndPos[1].y, 8, 8);
  }
  if(tpTpNodeCon[3]==1) {
    ellipse(grainSizeIndPos[1].x, grainSizeIndPos[1].y, 8, 8);
  }
  if(tpTpNodeCon[4]==1) {
    ellipse(hpfTpIndPos[1].x, hpfTpIndPos[1].y, 8, 8);
  }
  if(tpTpNodeCon[5]==1) {
    ellipse(lpfTpIndPos[1].x, lpfTpIndPos[1].y, 8, 8);
  }
  if(tpTpNodeCon[6]==1) {
    ellipse(wsTp1FreqIndPos[1].x, wsTp1FreqIndPos[1].y, 8, 8);
  }
  if(tpTpNodeCon[7]==1) {
    ellipse(wsTp1DepthIndPos[1].x, wsTp1DepthIndPos[1].y, 8, 8);
  }
  if(tpTpNodeCon[8]==1) {
    ellipse(wsTp2FreqIndPos[1].x, wsTp2FreqIndPos[1].y, 8, 8);
  }
  if(tpTpNodeCon[9]==1) {
    ellipse(wsTp2DepthIndPos[1].x, wsTp2DepthIndPos[1].y, 8, 8);
  }
  
  //DIST-TP
  fill(36, 31, 203);
  stroke(36, 31, 203);
  if(distTpNodeCon[0]==1) {
    ellipse(fundFreqIndPos[0].x, fundFreqIndPos[0].y, 8, 8);
  }
  if(distTpNodeCon[1]==1) {
    ellipse(formFreqIndPos[0].x, formFreqIndPos[0].y, 8, 8);
  }
  if(distTpNodeCon[2]==1) {
    ellipse(bodyFreqIndPos[0].x, bodyFreqIndPos[0].y, 8, 8);
  }
  if(distTpNodeCon[3]==1) {
    ellipse(grainSizeIndPos[0].x, grainSizeIndPos[0].y, 8, 8);
  }
  if(distTpNodeCon[4]==1) {
    ellipse(hpfTpIndPos[0].x, hpfTpIndPos[0].y, 8, 8);
  }
  if(distTpNodeCon[5]==1) {
    ellipse(lpfTpIndPos[0].x, lpfTpIndPos[0].y, 8, 8);
  }
  if(distTpNodeCon[6]==1) {
    ellipse(wsTp1FreqIndPos[0].x, wsTp1FreqIndPos[0].y, 8, 8);
  }
  if(distTpNodeCon[7]==1) {
    ellipse(wsTp1DepthIndPos[0].x, wsTp1DepthIndPos[0].y, 8, 8);
  }
  if(distTpNodeCon[8]==1) {
    ellipse(wsTp2FreqIndPos[0].x, wsTp2FreqIndPos[0].y, 8, 8);
  }
  if(distTpNodeCon[9]==1) {
    ellipse(wsTp2DepthIndPos[0].x, wsTp2DepthIndPos[0].y, 8, 8);
  }
  
  
    ///BEE-AMP
  for(int i = 0; i < 4; i++) {
    if(beeAmpNodeCon[i] == 1) {
      fill(allColors[i]);
      stroke(allColors[i]);
      ellipse(beeAmpIndPos[i].x, beeAmpIndPos[i].y, 8,8);
    }
  }
  for(int i = 0; i < 2; i++) {
    if(beeAmpNodeCon[i+4] == 1) {
      fill(allColors[i+6]);
      stroke(allColors[i+6]);
      ellipse(beeAmpIndPos[i+4].x, beeAmpIndPos[i+4].y, 8,8);
    }
  }
}









  
