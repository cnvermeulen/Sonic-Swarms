
import oscP5.*;
import netP5.*;

//initialize OSC stuff
OscP5 osc;
NetAddress supercollider;


////////////
////INTERFACE
/////////////////////
void sendInterfaceOSC(float tadPoleFundFreq, float tadPoleFormFreq, float tadPoleBodyFreq, float lpfCutoffTp, float beeFreq, float hpfCutoffBee, float lpfCutoffBee,
float freqModFreq, float freqModDepth, float waveShaperBee1Freq, float waveShaperBee1Depth, float waveShaperBee2Freq, float waveShaperBee2Depth, float tadpoleCalltadpoleDepth, float tadpoleCallBeeDepth, float beeCalltadpoleDepth, float beeCallBeeDepth, float tadpoleRespondDepth, float beeRespondDepth,
float tadpoleAmp, float beeAmp) {
  OscMessage interFaceValues = new OscMessage("/interfaceData");
  //0
  interFaceValues.add(tadPoleFundFreq);
  interFaceValues.add(tadPoleFormFreq); 
  interFaceValues.add(tadPoleBodyFreq); 
  interFaceValues.add(grainSize.getValue());
  interFaceValues.add(hpfCutoffTpSlider.getValue());
  //5
  interFaceValues.add(lpfCutoffTpSlider.getValue());
  interFaceValues.add(wsTp1Freq.getValue());
  interFaceValues.add(wsTp1Depth.getValue());
  interFaceValues.add(wsTp2Freq.getValue());
  interFaceValues.add(wsTp2Depth.getValue());
  //10
  interFaceValues.add(beeFreq);
  interFaceValues.add(freqModFreq);  
  interFaceValues.add(freqModDepth);
  interFaceValues.add(hpfCutoffBee);  
  interFaceValues.add(lpfCutoffBee);  
  //15
  interFaceValues.add(waveShaperBee1Freq);
  interFaceValues.add(waveShaperBee1Depth);
  interFaceValues.add(waveShaperBee2Freq);
  interFaceValues.add(waveShaperBee2Depth);
  interFaceValues.add(tadpoleCalltadpoleDepth);
  //20
  interFaceValues.add(tadpoleCallBeeDepth);
  interFaceValues.add(beeCalltadpoleDepth);
  interFaceValues.add(beeCallBeeDepth);
  interFaceValues.add(tadpoleRespondDepth);
  interFaceValues.add(beeRespondDepth);
  //25
  interFaceValues.add(tadpoleAmp);
  interFaceValues.add(beeAmp);
  interFaceValues.add(distBeeNodePacked1);
  interFaceValues.add(distBeeNodePacked2);
  interFaceValues.add(beeBeeNodePacked1);
  //30
  interFaceValues.add(beeBeeNodePacked2);
  interFaceValues.add(tpBeeNodeBeePacked1);
  interFaceValues.add(tpBeeNodeBeePacked2);
  interFaceValues.add(tpBeeNodeTpPacked1);
  interFaceValues.add(tpBeeNodeTpPacked2);
  //35
  interFaceValues.add(beeTpNodeBeePacked1);
  interFaceValues.add(beeTpNodeBeePacked2);
  interFaceValues.add(beeTpNodeTpPacked1);
  interFaceValues.add(beeTpNodeTpPacked2);
  interFaceValues.add(tpTpNodePacked1);
  //40
  interFaceValues.add(tpTpNodePacked2);
  interFaceValues.add(distTpNodePacked1);
  interFaceValues.add(distTpNodePacked2);
  //43
  for(int i = 0; i < 4; i++) {
    interFaceValues.add(freqSlidModDepths[i]);
    interFaceValues.add(freqModFreqDepths[i]);
    interFaceValues.add(freqModDepthDepths[i]);
    interFaceValues.add(hpfBeeModDepths[i]);
    interFaceValues.add(lpfBeeModDepths[i]);
    interFaceValues.add(ws1FreqModDepths[i]);
    interFaceValues.add(ws1DepthModDepths[i]);
    interFaceValues.add(ws2FreqModDepths[i]);
    interFaceValues.add(ws2DepthModDepths[i]);
  }
  
  //79
  for(int i = 0; i < 4; i++) {
    interFaceValues.add(fundFreqModDepths[i]);
    interFaceValues.add(formFreqModDepths[i]);
    interFaceValues.add(bodyFreqModDepths[i]);
    interFaceValues.add(grainSizeModDepths[i]);
    interFaceValues.add(hpfTpModDepths[i]);
    interFaceValues.add(lpfTpModDepths[i]);
    interFaceValues.add(wsTp1FreqModDepths[i]);
    interFaceValues.add(wsTp1DepthModDepths[i]);
    interFaceValues.add(wsTp2FreqModDepths[i]);
    interFaceValues.add(wsTp2DepthModDepths[i]);
    
  }
  //119
  interFaceValues.add(beeBeeEnvAttack.getValue());
  interFaceValues.add(beeBeeEnvRelease.getValue());
  interFaceValues.add(tpBeeEnvAttack.getValue());
  interFaceValues.add(tpBeeEnvRelease.getValue());
  interFaceValues.add(beeTpEnvAttack.getValue());
  interFaceValues.add(beeTpEnvRelease.getValue());
  
  interFaceValues.add(beeAmpNodeConPacked);
  for(int i = 0; i < 6; i++) {
    interFaceValues.add(beeAmpModDepths[i]);
  }
  
  osc.send(interFaceValues, supercollider);
}

////////////
////TADPOLES
/////////////////////

void sendTadpoleData(Tadpole tadpoleIn, int moveKind) {
  OscMessage tadPoleMsg = new OscMessage("/tadPoleMove");
  tadPoleMsg.add(tadpoles.size());
  tadPoleMsg.add(sysWinRadius);
  tadPoleMsg.add(distGlobeHorizon);
  tadPoleMsg.add(tadpoleIn.thetaCentre);
  tadPoleMsg.add(tadpoleIn.distCentre);
  tadPoleMsg.add(tadpoleIn.vision);
  tadPoleMsg.add(tadpoleIn.velocity.mag());
  tadPoleMsg.add(tadpoleIn.bodySize);
  tadPoleMsg.add(tadpoleIn.vision);
  tadPoleMsg.add(tadpoleIn.distToNeighbourTadpole);
  tadPoleMsg.add(moveKind);
  tadPoleMsg.add(tadpoleIn.callsTadpole);
  tadPoleMsg.add(tadpoleIn.callsBee);

  osc.send(tadPoleMsg, supercollider);  
}
////////////
////BEES
/////////////////////
void sendBeeData() {
  OscMessage beeData = new OscMessage("/beeData");
  beeData.add(bees.size());
  beeData.add(sysWinRadius);
  beeData.add(distGlobeHorizon);
  for(int i = 0; i < bees.size(); i++) {
    beeData.add(bees.get(i).thetaCentre);
    beeData.add(bees.get(i).distCentre);
    beeData.add(bees.get(i).vision);
    beeData.add(bees.get(i).velocity.mag());
    beeData.add(bees.get(i).distToNeighbourBee);
    beeData.add(bees.get(i).callsBee);
    beeData.add(bees.get(i).callsTadpole);
    beeData.add(bees.get(i).neighbourTadpoleCalls);
    beeData.add(bees.get(i).mass);
    beeData.add(bees.get(i).receivedForce);
  }
  osc.send(beeData, supercollider);
}


void beeCreated() {
  OscMessage beeCreated = new OscMessage("/beeCreated");
  osc.send(beeCreated, supercollider);
}

void beeDeleted(int beeIndex) {
  OscMessage beeDeleted = new OscMessage("/beeDeleted");
  beeDeleted.add(beeIndex);
  osc.send(beeDeleted, supercollider);
}