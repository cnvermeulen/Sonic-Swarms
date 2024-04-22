void drawModulationDepthsBee() {
  float angleKnob, angleLeft, angleRight, angleEnd;
  float selectedDepths[];
  int selectedNodeCon[];
  for(int i = 0; i < 4; i++) {
    selectedNodeCon = distBeeNodeCon;
    if(i == 0) {
      selectedNodeCon = distBeeNodeCon;
      stroke(165, 125, 22);
    }
    if(i == 1) {
      selectedNodeCon = beeBeeNodeCon;
      stroke(232, 225, 14);
    }
    if(i == 2) {
      selectedNodeCon = tpBeeNodeCon;
      stroke(4, 108, 3);
    }
    if(i == 3) {
      selectedNodeCon = beeTpNodeCon;
      stroke(31, 232, 14);
    }
    for(int j = 0; j < 9; j++) {
      selectedDepths = freqSlidModDepths;
      if(j == 0) {
        selectedDepths = freqSlidModDepths;
      }
      if(j == 1) {
        selectedDepths = freqModFreqDepths;
      }
      if(j == 2) {
        selectedDepths = freqModDepthDepths;
      }
      if(j == 3) {
        selectedDepths = hpfBeeModDepths;
      }
      if(j == 4) {
        selectedDepths = lpfBeeModDepths;
      }
      if(j == 5) {
        selectedDepths = ws1FreqModDepths;
      }
      if(j == 6) {
        selectedDepths = ws1DepthModDepths;
      }
      if(j == 7) {
        selectedDepths = ws2FreqModDepths;
      }
      if(j == 8) {
        selectedDepths = ws2DepthModDepths;
      }
      if(selectedNodeCon[j] == 1) {
        angleKnob = map(soundKnobs[j].getValue(), 0, 1, -1.25 * PI, 0.25 * PI);
        angleLeft = abs((-1.25 * PI) - angleKnob);
        angleRight = abs((-0.25 * PI) + angleKnob);
        angleEnd = angleKnob;
        strokeWeight(3);
        noFill();
      if(selectedDepths[i] < 0) {
        angleEnd = angleKnob - (angleLeft * abs(selectedDepths[i%4]));
        arc(soundKnobs[j].getPosition()[0] + 25, soundKnobs[j].getPosition()[1] + 25, 55 + (i * 8), 55 + (i * 8), angleEnd , angleKnob);
      } 
      if(selectedDepths[i] >= 0) {
        angleEnd = angleKnob + (angleRight * selectedDepths[i%4]);
        arc(soundKnobs[j].getPosition()[0] + 25, soundKnobs[j].getPosition()[1] + 25, 55 + (i * 8), 55 + (i * 8), angleKnob , angleEnd);
      } 
    }
  }
  } 
}

void drawModulationDepthsBeeAmp() {
  float sliderValue, valuePos, upLeft, bottomLeft;
  for(int i = 0; i < 6; i++) {
    
    if(beeAmpNodeCon[i] == 1) {
      sliderValue = beeAmplitudeSlider.getValue();
      valuePos = map(sliderValue, 0, 1, 100, 0);
      upLeft = valuePos;
      bottomLeft = 100 - valuePos;
      stroke(allColors[i]);
      if(i == 4) {stroke(allColors[i+2]);}
      if(i == 5) {stroke(allColors[i+2]);}
      strokeWeight(3);
      noFill();
      if(beeAmpModDepths[i] > 0) {
        line(35 + (5 * i), 10 + valuePos, 35 + (5*i), 10 + valuePos - (upLeft * beeAmpModDepths[i]));
      } 
      if(beeAmpModDepths[i] <= 0) {
        line(35 + (5 * i), 10 + valuePos, 35 + (5*i), 10 + valuePos - (bottomLeft * beeAmpModDepths[i]));
      }
    }
  } 
}


void drawModulationDepthsEnvs() {
  float angleKnob, angleLeft, angleRight, angleEnd;
  float selectedDepths;
  int selectedNodeCon[];
  stroke(165, 125, 22);
  for(int i = 0; i < 6; i++) {
    selectedDepths = beeBeeEnvAttModDepths;
    if(i == 0) {
      selectedDepths = beeBeeEnvAttModDepths;
    }
    if(i == 1) {
      selectedDepths = beeBeeEnvRelModDepths;
    }
    if(i == 2) {
      selectedDepths = tpBeeEnvAttModDepths;
    }
    if(i == 3) {
      selectedDepths = tpBeeEnvRelModDepths;
    }
    if(i == 4) {
      selectedDepths = beeTpEnvAttModDepths;
    }
    if(i == 5) {
      selectedDepths = beeTpEnvRelModDepths;
    }
    if(envNodeCon[i] == 1) {
       
        angleKnob = map(envKnobs[i].getValue(), 0, 1, -1.25 * PI, 0.25 * PI);
        angleLeft = abs((-1.25 * PI) - angleKnob);
        angleRight = abs((-0.25 * PI) + angleKnob);
        angleEnd = angleKnob;
        strokeWeight(3);
        noFill();
      if(selectedDepths < 0) {
        angleEnd = angleKnob - (angleLeft * abs(selectedDepths));
        arc(envKnobs[i].getPosition()[0] + 15, envKnobs[i].getPosition()[1] + 15, 35, 35, angleEnd , angleKnob);
      } 
      if(selectedDepths >= 0) {
        angleEnd = angleKnob + (angleRight * selectedDepths);
        arc(envKnobs[i].getPosition()[0] + 15, envKnobs[i].getPosition()[1] + 15, 35, 35, angleKnob , angleEnd);
      } 
    }
  }
}

void drawModulationDepthsTp() {
  float angleKnob, angleLeft, angleRight, angleEnd;
  float selectedDepths[];
  int selectedNodeCon[];
  int addedIndex;
  addedIndex = 0;
  for(int i = 0; i < 4; i++) {
    selectedNodeCon = distTpNodeCon;
    if(i == 0) {
      selectedNodeCon = distTpNodeCon;
      addedIndex = 0;
      stroke(36, 31, 203);
    }
    if(i == 1) {
      selectedNodeCon = tpTpNodeCon;
      addedIndex = 0;
      stroke(32, 165, 245);
    }
    if(i == 2) {
      selectedNodeCon = beeTpNodeCon;
      addedIndex = 9;
      stroke(31, 232, 14); 
    }
    if(i == 3) {
      selectedNodeCon = tpBeeNodeCon;
      addedIndex = 9;
      stroke(4, 108, 3);
    }
    for(int j = 0; j < 10; j++) {
      selectedDepths = fundFreqModDepths;
      if(j == 0) {
        selectedDepths = fundFreqModDepths;
      }
      if(j == 1) {
        selectedDepths = formFreqModDepths;
      }
      if(j == 2) {
        selectedDepths = bodyFreqModDepths;
      }
      if(j == 3) {
        selectedDepths = grainSizeModDepths;
      }
      if(j == 4) {
        selectedDepths = hpfTpModDepths;
      }
      if(j == 5) {
        selectedDepths = lpfTpModDepths;
      }
      if(j == 6) {
        selectedDepths = wsTp1FreqModDepths;
      }
      if(j == 7) {
        selectedDepths = wsTp1DepthModDepths;
      }
      if(j == 8) {
        selectedDepths = wsTp2FreqModDepths;
      }
      if(j == 9) {
        selectedDepths = wsTp2DepthModDepths;
      }
      if(selectedNodeCon[j + addedIndex] == 1) {
       
        angleKnob = map(soundKnobs[j + 9].getValue(), 0, 1, -1.25 * PI, 0.25 * PI);
        angleLeft = abs((-1.25 * PI) - angleKnob);
        angleRight = abs((-0.25 * PI) + angleKnob);
        angleEnd = angleKnob;
        strokeWeight(3);
        noFill();
      if(selectedDepths[i] < 0) {
        angleEnd = angleKnob - (angleLeft * abs(selectedDepths[i]));
        arc(soundKnobs[j + 9].getPosition()[0] + 25, soundKnobs[j + 9].getPosition()[1] + 25, 55 + (i * 8), 55 + (i * 8), angleEnd , angleKnob);
      } 
      if(selectedDepths[i] >= 0) {
        angleEnd = angleKnob + (angleRight * selectedDepths[i]);
        arc(soundKnobs[j + 9].getPosition()[0] + 25, soundKnobs[j + 9].getPosition()[1] + 25, 55 + (i * 8), 55 + (i * 8), angleKnob , angleEnd);
      } 
    }
  }
  }
  
}