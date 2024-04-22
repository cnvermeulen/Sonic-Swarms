///BEE NODE CON INFO
int beeBeeNodePacked1 = 100000;
int beeBeeNodePacked2 = 10000;
int distBeeNodePacked1 = 100000;
int distBeeNodePacked2 = 10000;
int tpBeeNodeBeePacked1 = 100000;
int tpBeeNodeBeePacked2 = 10000;
int beeTpNodeBeePacked1 = 100000;
int beeTpNodeBeePacked2 = 10000;
int beeSpeedNodeConPacked1 = 100000;
int beeSpeedNodeConPacked2 = 10000;
int ffNodeBeePacked1 = 100000;
int ffNodeBeePacked2 = 10000;


///TP NODE CON INFO
int tpBeeNodeTpPacked1 = 100000;
int tpBeeNodeTpPacked2 = 100000;
int beeTpNodeTpPacked1 = 100000;
int beeTpNodeTpPacked2 = 100000;
int tpTpNodePacked1 = 100000;
int tpTpNodePacked2 = 100000;
int distTpNodePacked1 = 100000;
int distTpNodePacked2 = 100000;
int ffNodeTpPacked1 = 100000;
int ffNodeTpPacked2 = 100000;

int beeAmpNodeConPacked = 1000000;



boolean knobIndClicked[]= new boolean[88];

//Bee Mod Depths
float freqSlidModDepths[] = new float[4];
float freqModFreqDepths[] = new float[4];
float freqModDepthDepths[] = new float[4];
float hpfBeeModDepths[] = new float[4];
float lpfBeeModDepths[] = new float[4];
float beeAmpModDepths[] = new float[6];
float ws1FreqModDepths[] = new float[4];
float ws1DepthModDepths[] = new float[4];
float ws2FreqModDepths[] = new float[4];
float ws2DepthModDepths[] = new float[4];
float beeBeeEnvAttModDepths;
float beeBeeEnvRelModDepths;
float tpBeeEnvAttModDepths;
float tpBeeEnvRelModDepths;
float beeTpEnvAttModDepths;
float beeTpEnvRelModDepths;


//Tp Mod Depths
float fundFreqModDepths[] = new float[4];
float formFreqModDepths[] = new float[4];
float bodyFreqModDepths[] = new float[4];
float grainSizeModDepths[] = new float[4];
float hpfTpModDepths[] = new float[4];
float lpfTpModDepths[] = new float[4];
float tpAmpModDepths[] = new float[6];
float wsTp1FreqModDepths[] = new float[4];
float wsTp1DepthModDepths[] = new float[4];
float wsTp2FreqModDepths[] = new float[4];
float wsTp2DepthModDepths[] = new float[4];





void applyModulationDepths() {
  PVector mouseLoc = new PVector(mouseX, mouseY);
  //CALC BEE MOD DEPTHS
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i]) {
      freqSlidModDepths[i] = constrain(map(mouseLoc.x - freqSlidIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 4]) {
      freqModFreqDepths[i] = constrain(map(mouseLoc.x - freqModFreqIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 8]) {
      freqModDepthDepths[i] = constrain(map(mouseLoc.x - freqModDepthIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 12]) {
      hpfBeeModDepths[i] = constrain(map(mouseLoc.x - hpfBeeIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 16]) {
      lpfBeeModDepths[i] = constrain(map(mouseLoc.x - lpfBeeIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 20]) {
      ws1FreqModDepths[i] = constrain(map(mouseLoc.x - ws1FreqIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 24]) {
      ws1DepthModDepths[i] = constrain(map(mouseLoc.x - ws1DepthIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 28]) {
      ws2FreqModDepths[i] = constrain(map(mouseLoc.x - ws2FreqIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 32]) {
      ws2DepthModDepths[i] = constrain(map(mouseLoc.x - ws2DepthIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  //CALC TP MOD DEPTHS
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 36]) {
      fundFreqModDepths[i] = constrain(map(mouseLoc.x - fundFreqIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 40]) {
      formFreqModDepths[i] = constrain(map(mouseLoc.x - formFreqIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 44]) {
      bodyFreqModDepths[i] = constrain(map(mouseLoc.x - bodyFreqIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 48]) {
      grainSizeModDepths[i] = constrain(map(mouseLoc.x - grainSizeIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 52]) {
      hpfTpModDepths[i] = constrain(map(mouseLoc.x - hpfTpIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 56]) {
      lpfTpModDepths[i] = constrain(map(mouseLoc.x - lpfTpIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 60]) {
      wsTp1FreqModDepths[i] = constrain(map(mouseLoc.x - wsTp1FreqIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 64]) {
      wsTp1DepthModDepths[i] = constrain(map(mouseLoc.x - wsTp1DepthIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 68]) {
      wsTp2FreqModDepths[i] = constrain(map(mouseLoc.x - wsTp2FreqIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  for(int i = 0; i < 4; i++) {
    if(knobIndClicked[i + 72]) {
      wsTp2DepthModDepths[i] = constrain(map(mouseLoc.x - wsTp2DepthIndPos[i].x, -150, 150, -1, 1), -1, 1);
    }
  }
  
  if(knobIndClicked[76]) {
    beeBeeEnvAttModDepths = constrain(map(mouseLoc.y - beeBeeEnvAttackIndPos.y, -150, 150, 1, -1), -1, 1);
  }
  if(knobIndClicked[77]) {
    beeBeeEnvRelModDepths = constrain(map(mouseLoc.y - beeBeeEnvReleaseIndPos.y, -150, 150, -1, 1), -1, 1);
  }
  if(knobIndClicked[78]) {
    tpBeeEnvAttModDepths = constrain(map(mouseLoc.y - tpBeeEnvAttackIndPos.y, -150, 150, -1, 1), -1, 1);
  }
  if(knobIndClicked[79]) {
    tpBeeEnvRelModDepths = constrain(map(mouseLoc.y - tpBeeEnvReleaseIndPos.y, -150, 150, -1, 1), -1, 1);
  }
  if(knobIndClicked[80]) {
    beeTpEnvAttModDepths = constrain(map(mouseLoc.y - beeTpEnvAttackIndPos.y, -150, 150, -1, 1), -1, 1);
  }
  if(knobIndClicked[81]) {
    beeTpEnvRelModDepths = constrain(map(mouseLoc.y - beeTpEnvReleaseIndPos.y, -150, 150, -1, 1), -1, 1);
  }
  
  for(int i = 0; i < 6; i++) {
    if(knobIndClicked[i + 82]) {
      beeAmpModDepths[i] = constrain(map(mouseLoc.y - beeAmpIndPos[i].y, 100, -100, -1, 1), -1, 1);
    }
  }
}

void mouseClicked() {
  PVector mouseLoc = new PVector(mouseX, mouseY);
  /////NODE SELECTOR
 
  if(mouseLoc.dist(tpTpNode)<40) {
    tpTpNodeSel = true;
    tpBeeNodeSel = false;
    beeBeeNodeSel = false;
    beeTpNodeSel = false;  
    distBeeNodeSel = false;
    distTpNodeSel = false;
    forcefieldNodeSel = false;
    beeSpeedNodeSel = false;
  }
  if(mouseLoc.dist(tpBeeNode)<40) {
    tpTpNodeSel = false;
    tpBeeNodeSel = true;
    beeBeeNodeSel = false;
    beeTpNodeSel = false;
    distBeeNodeSel = false;
    distTpNodeSel = false;
    forcefieldNodeSel = false;
    beeSpeedNodeSel = false;
  }
  if(mouseLoc.dist(beeTpNode)<40) {
    tpTpNodeSel = false;
    tpBeeNodeSel = false;
    beeBeeNodeSel = false;
    beeTpNodeSel = true;
    distBeeNodeSel = false;
    distTpNodeSel = false;
    forcefieldNodeSel = false;
    beeSpeedNodeSel = false;
  }
  if(mouseLoc.dist(beeBeeNode)<40) {
    tpTpNodeSel = false;
    tpBeeNodeSel = false;
    beeBeeNodeSel = true;
    beeTpNodeSel = false;
    distBeeNodeSel = false;
    distTpNodeSel = false;
    forcefieldNodeSel = false;
    beeSpeedNodeSel = false;
  }
  if(mouseLoc.dist(distBeeNode)<40) {
    tpTpNodeSel = false;
    tpBeeNodeSel = false;
    beeBeeNodeSel = false;
    beeTpNodeSel = false;
    distBeeNodeSel = true;
    distTpNodeSel = false;
    forcefieldNodeSel = false;
    beeSpeedNodeSel = false;
  }
  if(mouseLoc.dist(distTpNode)<40) {
    tpTpNodeSel = false;
    tpBeeNodeSel = false;
    beeBeeNodeSel = false;
    beeTpNodeSel = false;
    distBeeNodeSel = false;
    distTpNodeSel = true;
    forcefieldNodeSel = false;
    beeSpeedNodeSel = false;
  }
  if(mouseLoc.dist(forcefieldNode) < 40) {
    tpTpNodeSel = false;
    tpBeeNodeSel = false;
    beeBeeNodeSel = false;
    beeTpNodeSel = false;
    distBeeNodeSel = false;
    distTpNodeSel = false;
    forcefieldNodeSel = true;
    beeSpeedNodeSel = false;
  }
  if(mouseLoc.dist(beeSpeedNode) < 40) {
    tpTpNodeSel = false;
    tpBeeNodeSel = false;
    beeBeeNodeSel = false;
    beeTpNodeSel = false;
    distBeeNodeSel = false;
    distTpNodeSel = false;
    forcefieldNodeSel = false;
    beeSpeedNodeSel = true;
  }
  if(mouseLoc.dist(sysCentre) < sysWinRadius) {
    tpTpNodeSel = false;
    tpBeeNodeSel = false;
    beeBeeNodeSel = false;
    beeTpNodeSel = false;
    distBeeNodeSel = false;
    distTpNodeSel = false;
    forcefieldNodeSel = false;
    beeSpeedNodeSel = false;
  }

  
  //CONNECT INTERACTION MATRIX WITH KNOBS THROUGH NODE CONNECTIONS
  
  //DIST BEE NODE SEL
  for(int i = 0; i < 9; i++) {
    if(distBeeNodeSel && soundKnobs[i].isMouseOver()) {
      if(distBeeNodeCon[i] == 1) {
        distBeeNodeCon[i] = 0;
      } else {
        distBeeNodeCon[i] = 1;
      }
    }
  }
  distBeeNodePacked1 = 100000;
  distBeeNodePacked2 = 10000;
  for(int i = 0; i < 5; i++) {
    distBeeNodePacked1 += round(pow(10, i) * distBeeNodeCon[i]);
  }
  for(int i = 0; i < 4; i++) {
    distBeeNodePacked2 += round(pow(10, i) * distBeeNodeCon[i + 5]);
  }
  
  ////ENV NODE SEL
  for(int i = 0; i < 6; i++) {
    if(distBeeNodeSel && envKnobs[i].isMouseOver()) {
      if(envNodeCon[i] == 1) {
        envNodeCon[i] = 0;
      } else {
        envNodeCon[i] = 1;
      }
    }
  }
  
  ////SPEED BEE NODE SEL
  for(int i = 0; i < 9; i++) {
    if(beeSpeedNodeSel && soundKnobs[i].isMouseOver()) {
      if(beeSpeedNodeCon[i] == 1) {
        beeSpeedNodeCon[i] = 0;
      } else {
        beeSpeedNodeCon[i] = 1;
      }
    }
  }
  beeSpeedNodeConPacked1 = 100000;
  beeSpeedNodeConPacked2 = 10000;
  for(int i = 0; i < 5; i++) {
    beeSpeedNodeConPacked1 += round(pow(10, i) * beeSpeedNodeCon[i]);
  }
  for(int i = 0; i < 4; i++) {
    beeSpeedNodeConPacked2 += round(pow(10, i) * beeSpeedNodeCon[i + 5]);
  }
  
   ////SPEED FORCEFIELD NODE SEL
  for(int i = 0; i < 9; i++) {
    if(forcefieldNodeSel && soundKnobs[i].isMouseOver()) {
      if(forceFieldNodeCon[i] == 1) {
        forceFieldNodeCon[i] = 0;
      } else {
        forceFieldNodeCon[i] = 1;
      }
    }
  }
  ffNodeBeePacked1 = 100000;
  ffNodeBeePacked2 = 10000;
  for(int i = 0; i < 5; i++) {
    ffNodeBeePacked1 += round(pow(10, i) * forceFieldNodeCon[i]);
  }
  for(int i = 0; i < 4; i++) {
    ffNodeBeePacked1 += round(pow(10, i) * forceFieldNodeCon[i + 5]);
  }
  
  //BEE-BEE NODE SEL
  for(int i = 0; i < 9; i++) {
    if(beeBeeNodeSel && soundKnobs[i].isMouseOver()) {
      if(beeBeeNodeCon[i] == 1) {
        beeBeeNodeCon[i] = 0;
      } else {
        beeBeeNodeCon[i] = 1;
      }
    }
  }
  beeBeeNodePacked1 = 100000;
  beeBeeNodePacked2 = 10000;
  for(int i = 0; i < 5; i++) {
    beeBeeNodePacked1 += round(pow(10, i) * beeBeeNodeCon[i]);
  }
  for(int i = 0; i < 4; i++) {
    beeBeeNodePacked2 += round(pow(10, i) * beeBeeNodeCon[i + 5]);
  }
  
  //TP-BEE NODE SEL
  for(int i = 0; i < 19; i++) {
    if(tpBeeNodeSel && soundKnobs[i].isMouseOver()) {
      if(tpBeeNodeCon[i] == 1) {
        tpBeeNodeCon[i] = 0;
      } else {
        tpBeeNodeCon[i] = 1;
      }
    }
  }
  tpBeeNodeBeePacked1 = 100000;
  tpBeeNodeBeePacked2 = 10000;
  for(int i = 0; i < 5; i++) {
    tpBeeNodeBeePacked1 += round(pow(10, i) * tpBeeNodeCon[i]);
  }
  for(int i = 0; i < 4; i++) {
    tpBeeNodeBeePacked2 += round(pow(10, i) * tpBeeNodeCon[i + 5]);
  }
  tpBeeNodeTpPacked1 = 100000;
  tpBeeNodeTpPacked2 = 100000;
  for(int i = 0; i < 5; i++) {
    tpBeeNodeTpPacked1 += round(pow(10, i) * tpBeeNodeCon[i + 9]);
    tpBeeNodeTpPacked2 += round(pow(10, i) * tpBeeNodeCon[i + 14]);
  }
  
  /////////BEE-TP NODE SEL
  for(int i = 0; i < 19; i++) {
    if(beeTpNodeSel && soundKnobs[i].isMouseOver()) {
      if(beeTpNodeCon[i] == 1) {
        beeTpNodeCon[i] = 0;
      } else {
        beeTpNodeCon[i] = 1;
      }
    }
  }
  beeTpNodeBeePacked1 = 100000;
  beeTpNodeBeePacked2 = 10000;
  for(int i = 0; i < 5; i++) {
    beeTpNodeBeePacked1 += round(pow(10, i) * beeTpNodeCon[i]);
  }
  for(int i = 0; i < 4; i++) {
    beeTpNodeBeePacked2 += round(pow(10, i) * beeTpNodeCon[i + 5]);
  }
  beeTpNodeTpPacked1 = 100000;
  beeTpNodeTpPacked2 = 100000;
  for(int i = 0; i < 5; i++) {
    beeTpNodeTpPacked1 += round(pow(10, i) * beeTpNodeCon[i + 9]);
    beeTpNodeTpPacked2 += round(pow(10, i) * beeTpNodeCon[i + 14]);
  }
  
  /////TP-TP NODE SEL
  for(int i = 0; i < 10; i++)  {
    if(tpTpNodeSel && soundKnobs[i + 9].isMouseOver()) {
      if(tpTpNodeCon[i] == 1) {
        tpTpNodeCon[i] = 0;
      } else {
        tpTpNodeCon[i] = 1;
      }
    }
  }
  tpTpNodePacked1 = 100000;
  tpTpNodePacked2 = 100000;
  for(int i = 0; i < 5; i++) {
    tpTpNodePacked1 += round(pow(10, i) * tpTpNodeCon[i]);
    tpTpNodePacked2 += round(pow(10, i) * tpTpNodeCon[i + 5]);
  }
  
  /////DIST-TP NODE SEL
  for(int i = 0; i < 10; i++) {
    if(distTpNodeSel && soundKnobs[i+9].isMouseOver()) {
      if(distTpNodeCon[i] == 1) {
        distTpNodeCon[i] = 0;
      } else {
        distTpNodeCon[i] = 1;
      }
    }
  }
  distTpNodePacked1 = 100000;
  distTpNodePacked2 = 100000;
  for(int i = 0; i < 5; i++) {
    distTpNodePacked1 += round(pow(10, i) * distTpNodeCon[i]);
    distTpNodePacked2 += round(pow(10, i) * distTpNodeCon[i + 5]);
  }
  
  /////BEEAMP NODE SEL
  for(int i = 0; i < 4; i++) {
    if(allNodesSel[i] && beeAmplitudeSlider.isMouseOver()) {
      if(beeAmpNodeCon[i] == 1) {
        beeAmpNodeCon[i] = 0;
      } else {
        beeAmpNodeCon[i] = 1;
      }
    }
  }
  for(int i = 0; i < 2; i++) {
    if(allNodesSel[i+6] && beeAmplitudeSlider.isMouseOver()) {
      if(beeAmpNodeCon[i+4] == 1) {
        beeAmpNodeCon[i+4] = 0;
      } else {
        beeAmpNodeCon[i+4] = 1;
      }
    }
  }
  beeAmpNodeConPacked = 1000000;
  for(int i = 0; i < 6; i++) {
    beeAmpNodeConPacked += round(pow(10, i) * beeAmpNodeCon[i]);
  }
  
  //////////MOD DEPTH ADJUSTMENT
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(freqSlidIndPos[i]) < 10) {
      knobIndClicked[i] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(freqModFreqIndPos[i]) < 10) {
      knobIndClicked[i + 4] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(freqModDepthIndPos[i]) < 10) {
      knobIndClicked[i + 8] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(hpfBeeIndPos[i]) < 10) {
      knobIndClicked[i + 12] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(lpfBeeIndPos[i]) < 10) {
      knobIndClicked[i + 16] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(ws1FreqIndPos[i]) < 10) {
      knobIndClicked[i + 20] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(ws1DepthIndPos[i]) < 10) {
      knobIndClicked[i + 24] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(ws2FreqIndPos[i]) < 10) {
      knobIndClicked[i + 28] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(ws2DepthIndPos[i]) < 10) {
      knobIndClicked[i + 32] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(fundFreqIndPos[i]) < 10) {
      knobIndClicked[i + 36] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(formFreqIndPos[i]) < 10) {
      knobIndClicked[i + 40] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(bodyFreqIndPos[i]) < 10) {
      knobIndClicked[i + 44] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(grainSizeIndPos[i]) < 10) {
      knobIndClicked[i + 48] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(hpfTpIndPos[i]) < 10) {
      knobIndClicked[i + 52] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(lpfTpIndPos[i]) < 10) {
      knobIndClicked[i + 56] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(wsTp1FreqIndPos[i]) < 10) {
      knobIndClicked[i + 60] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(wsTp1DepthIndPos[i]) < 10) {
      knobIndClicked[i + 64] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(wsTp2FreqIndPos[i]) < 10) {
      knobIndClicked[i + 68] = true;
    }
  }
  for(int i = 0; i < 4; i++) {
    if(mouseLoc.dist(wsTp2DepthIndPos[i]) < 10) {
      knobIndClicked[i + 72] = true;
    }
  }
  if(mouseLoc.dist(beeBeeEnvAttackIndPos) < 10) {
    knobIndClicked[76] = true;
  }
  if(mouseLoc.dist(beeBeeEnvReleaseIndPos) < 10) {
    knobIndClicked[77] = true;
  }
  if(mouseLoc.dist(tpBeeEnvAttackIndPos) < 10) {
    knobIndClicked[78] = true;
  }
  if(mouseLoc.dist(tpBeeEnvReleaseIndPos) < 10) {
    knobIndClicked[79] = true;
  }
  if(mouseLoc.dist(beeTpEnvAttackIndPos) < 10) {
    knobIndClicked[80] = true;
  }
  if(mouseLoc.dist(beeTpEnvReleaseIndPos) < 10) {
    knobIndClicked[81] = true;
  }
  
  for(int i = 0; i < 6; i++) {
    if(mouseLoc.dist(beeAmpIndPos[i]) < 10) {
      knobIndClicked[i + 82] = true;
    }
  }
  
}

void mouseReleased() {
  for(int i = 0; i < knobIndClicked.length; i++) {
    knobIndClicked[i] = false;
  }
  
  beeAttr.locked = false;
  for(int i = 0; i < bees.size(); i++) {
    bees.get(i).locked = false;
  }
  for(int i = 0; i < tadpoles.size(); i++) {
    tadpoles.get(i).locked = false;
  }
}
