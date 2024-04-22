int time = 0;

void setup() {
  fullScreen();
  sysCentre = new PVector(width/2, height/2);

  //initiate systemWindow
  initSystemWindow();  
    
  //initate a path
  newPath();
  
  initInterface(50, height/2-200);
  
    
  //setup OSC
  osc = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57121);
}

void draw() {   
  background(0);
  drawSystemWindow();
  drawInteractionWindow(50, height/2 - 200);
  drawForcefieldWindow();
  //drawForcefield();
  applyModulationDepths();
  drawModulationDepthsBee();
  drawModulationDepthsEnvs();
  drawModulationDepthsTp();
  drawModulationDepthsBeeAmp();
  //drawMatrixWindow();
  //drawText();
  
  //function which checks the path
  pathManagement();

  //loop through all food
  for(int i = 0; i < food.size(); i++) {
    food.get(i).display();
  }
  
  //loop through the tadPoles
  tpMovementButt();
  tpAttr.drawAttractor();
  tpAttr.checkMouseOver();
  tpAttr.updateAttractLoc(time);
  for(int i = 0; i < tadpoles.size(); i++) { 
    //move the particle
    tadpoles.get(i).observe(i, tadpoles, bees, food);
    tadpoles.get(i).think();
    tadpoles.get(i).decide();
    tadpoles.get(i).run();
  }
  
  //loop through the bees
  beeAttr.drawAttractor();
  beeAttr.checkMouseOver();
  beeAttr.updateAttractLoc(time);
  makeMirrorList();
  for(int i = 0; i < bees.size(); i++) {
    bees.get(i).observe(i, bees, tadpoles, path);
    bees.get(i).think();
    bees.get(i).decide();
    bees.get(i).run();
  } 
  
  //particleAmountManagement
  particleSprayer();
  particleRemover();
  
  //function which checks the food 
  foodManagement();
  
  //functions which sends the continuous OSC data
  ////Bees
  if(bees.size() > 0) {
    sendBeeData();
  }
  ////Interface
  sendInterfaceOSC(
  fundFreqSlider.getValue(), formFreqSlider.getValue(), bodyFreqSlider.getValue(), lpfCutoffTpSlider.getValue(),
  freqSlider.getValue(), hpfCutoffBeeSlider.getValue(), lpfCutoffBeeSlider.getValue(), freqModFreqSlider.getValue(), freqModDepthSlider.getValue(), waveShaper1Freq.getValue(), waveShaper1Depth.getValue(), waveShaper2Freq.getValue(), waveShaper2Depth.getValue(),
  tadpoleCalltadpoleDepth.getValue(), tadpoleCallBeeDepth.getValue(), beeCallTadpoleDepth.getValue(), beeCallBeeDepth.getValue(), tadpoleRespondDepth.getValue(), beeRespondDepth.getValue(),
  tadpoleAmplitudeSlider.getValue(), beeAmplitudeSlider.getValue());
  
  time += 1;
}




  
