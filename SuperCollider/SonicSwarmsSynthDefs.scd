//////////////////////
/////AGENT SYNTHDEFS
//////////////////////////
s.options.outDevice = "Soundflower (64ch)";
s.options.numOutputBusChannels = 32;

(

////////////////////////////////////////////////////////////////////////
//////SYNTH TEMPLATE FOR CONTINUOUS AGENT/////////////////////////
////////////////////////////////////////////////////////////////////////
SynthDef(\example, {
	arg beeParam1,beeParam2, beeParam3, beeParam4, beeParam5, beeParam6, beeParam7, beeParam8, beeParam9, velocity, forcefield, amp = 1, wrapAmp = 1, xPos = 0, yPos = 0, gate = 1,
	//Envelope triggers
	t_beeCallBeeTrig = 0, t_tpCallBeeTrig = 0, t_beeCallTpTrig = 0,
	//Envelope depths
	beeBeeP1EnvDepth = 0, beeBeeP2EnvDepth = 0, beeBeeP3EnvDepth = 0, beeBeeP4EnvDepth = 0, beeBeeP5EnvDepth = 0, beeBeeP6EnvDepth = 0, beeBeeP7EnvDepth = 0, beeBeeP8EnvDepth = 0, beeBeeP9EnvDepth = 0, beeBeeAttack = 0.5, beeBeeRelease = 0.5,

	tpBeeP1EnvDepth = 0, tpBeeP2EnvDepth = 0, tpBeeP3EnvDepth = 0, tpBeeP4EnvDepth = 0, tpBeeP5EnvDepth = 0, tpBeeP6EnvDepth = 0, tpBeeP7EnvDepth = 0, tpBeeP8EnvDepth = 0, tpBeeP9EnvDepth = 0, tpBeeAttack = 0.5, tpBeeRelease = 0.5,

	beeTpP1EnvDepth = 0, beeTpP2EnvDepth = 0, beeTpP3EnvDepth = 0, beeTpP4EnvDepth = 0, beeTpP5EnvDepth = 0, beeTpP6EnvDepth = 0, beeTpP7EnvDepth = 0, beeTpP8EnvDepth = 0, beeTpP9EnvDepth = 0, beeTpAttack = 0.5, beeTpRelease = 0.5, beeBeeAmpDepth = 0, tpBeeAmpDepth = 0, beeTpAmpDepth = 0,

	//Boundaries
	minP1, maxP1, minP2, maxP2, minP3, maxP3, minP4, maxP4, minP5, maxP5, minP6, maxP6, minP7, maxP7, minP8, maxP8, minP9, maxP9;
	//////////////////////////////////ADD STUFF HERE
	//Your paramaters with mapping
	// var name1 = LinExp.kr(beeParam1, 0, 1, minP1, maxP1);
	// var name2 = LinExp.kr(beeParam2, 0, 1, minP2, maxP2);
	///......
	//If you want to incorporate force fields
	// var force1 = LinLin.kr(forcefield, 0, 1, 1, 10);
	// var force2 = LinLin.kr(forcefield, 0, 1, 1, 0.5);

	//Your signals
	var sig, env;

	//Your call Envelopes
	var beeBeeCall, tpBeeCall, beeTpCall;
	var allCallP1, allCallP2, allCallP3, allCallP4, allCallP5, allCallP6, allCallP7, allCallP8, allCallP9, allCallAmp;

	beeBeeCall = EnvGen.kr(Env.perc(beeBeeAttack, beeBeeRelease), t_beeCallBeeTrig);
	tpBeeCall =  EnvGen.kr(Env.perc(tpBeeAttack, tpBeeRelease), t_tpCallBeeTrig);
	beeTpCall =  EnvGen.kr(Env.perc(beeTpAttack, beeTpRelease), t_beeCallTpTrig);

	//Your calls with mapping
	allCallAmp = Mix.ar([beeBeeCall * beeBeeAmpDepth, tpBeeCall * tpBeeAmpDepth, beeTpCall * beeTpAmpDepth]);
	allCallP1 = Mix.ar([beeBeeCall * beeBeeP1EnvDepth, tpBeeCall * tpBeeP1EnvDepth, beeTpCall * beeTpP1EnvDepth]);
	allCallP2 = Mix.ar([beeBeeCall * beeBeeP2EnvDepth, tpBeeCall * tpBeeP2EnvDepth, beeTpCall * beeTpP2EnvDepth]);
	allCallP3 = Mix.ar([beeBeeCall * beeBeeP3EnvDepth, tpBeeCall * tpBeeP3EnvDepth, beeTpCall * beeTpP3EnvDepth]);
	allCallP4 = Mix.ar([beeBeeCall * beeBeeP4EnvDepth, tpBeeCall * tpBeeP4EnvDepth, beeTpCall * beeTpP4EnvDepth]);
	allCallP5 = Mix.ar([beeBeeCall * beeBeeP5EnvDepth, tpBeeCall * tpBeeP5EnvDepth, beeTpCall * beeTpP5EnvDepth]);
	allCallP6 = Mix.ar([beeBeeCall * beeBeeP6EnvDepth, tpBeeCall * tpBeeP6EnvDepth, beeTpCall * beeTpP6EnvDepth]);
	allCallP7 = Mix.ar([beeBeeCall * beeBeeP7EnvDepth, tpBeeCall * tpBeeP7EnvDepth, beeTpCall * beeTpP7EnvDepth]);
	allCallP8 = Mix.ar([beeBeeCall * beeBeeP8EnvDepth, tpBeeCall * tpBeeP8EnvDepth, beeTpCall * beeTpP8EnvDepth]);
	allCallP9 = Mix.ar([beeBeeCall * beeBeeP9EnvDepth, tpBeeCall * tpBeeP9EnvDepth, beeTpCall * beeTpP9EnvDepth]);

	//signals
	env = EnvGen.kr(Env.asr(5), gate, doneAction:2);
	//////////And here comes your synthesis structure
	sig = Silent.ar();
	Out.ar(0, sig);
}).add;


SynthDef(\tadPole2, {
	arg tpParam1,tpParam2, tpParam3, tpParam4, tpParam5, tpParam6, tpParam7, tpParam8, tpParam9, tpParam10, bodySize, amp = 0.5, xPos = 0, yPos = 0, wrapAmp = 1, t_trig = 0, callDepth = 1;

	//Your parameters
	var fundFreq = LinExp.kr(tpParam1, 0, 1, 5, 100);
	var formFreq = LinExp.kr(tpParam2, 0, 1, 1, 1000);
	var bodyFreq = LinExp.kr(tpParam3, 0, 1, 40, 12000);
	var grainSize = LinExp.kr(tpParam4, 0, 1, 0.01, 0.99);
	var hpfCutoff = LinExp.kr(tpParam5, 0, 1, 40, 12000);
	var lpfCutoff = LinExp.kr(tpParam6, 0, 1, 40, 12000);
	var nPeriods = LinExp.kr(bodySize, 1, 15, 1, 15);

	//Your internal synth struct
	var sig, env, dutyCycle, timerEnv, callEnv;
	sig = GrainFM.ar(1, Impulse.kr(fundFreq), (1/fundFreq) * grainSize, bodyFreq, formFreq, 1);
	timerEnv = EnvGen.ar(Env.perc(0.001, nPeriods/fundFreq), doneAction:2);
	sig = LPF.ar(sig, lpfCutoff);
	sig = HPF.ar(sig, hpfCutoff);
	sig = sig * amp * timerEnv * wrapAmp;
	// sig = Pan4.ar(sig, xPos, yPos);
	sig = Pan2.ar(sig, xPos);
	Out.ar(0, sig);
}).add;

SynthDef(\tpNoise, {
	arg tpParam1,tpParam2, tpParam3, tpParam4, tpParam5, tpParam6, tpParam7, tpParam8, tpParam9, tpParam10, bodySize, amp = 0.5, xPos = 0, yPos = 0, wrapAmp = 1, t_trig = 0, callDepth = 1;

	//Your parameters
	var fundFreq = LinExp.kr(tpParam1, 0, 1, 5, 100);
	var attack = LinExp.kr(tpParam2, 0, 1, 0.01, 0.1);
	var release = LinExp.kr(tpParam3, 0, 1, 0.01, 0.5);
	var size = LinExp.kr(tpParam4, 0, 1, 0.01, 0.1);
	var hpfCutoff = LinExp.kr(tpParam5, 0, 1, 40, 12000);
	var lpfCutoff = LinExp.kr(tpParam6, 0, 1, 40, 12000);
	var curve1 = LinLin.kr(tpParam7, 0, 1, -10, 10);
	var curve2 = LinLin.kr(tpParam8, 0, 1, -10, 10);
	var curve3 = LinLin.kr(tpParam9, 0, 1, -10, 10);
	var curve4 = LinLin.kr(tpParam10, 0, 1, -10, 10);
	var nPeriods = LinExp.kr(bodySize, 1, 15, 15, 1);

	//Your internal synth struct
	var sig, trigger, env, dutyCycle, bodyEnv, timerEnv, callEnv;
	sig = GrayNoise.ar();
	trigger = Impulse.kr(fundFreq);
	bodyEnv = EnvGen.ar(Env([0.001, 0.5, 1, 0.5, 0.001], [attack/2, attack/2, release/2, release/2], [curve1, curve2, curve3, curve4]), trigger);
	timerEnv = EnvGen.ar(Env([0, 1, 1, 0], [0.01, size/nPeriods, 0.01]), doneAction:2);
	sig = LPF.ar(sig, lpfCutoff);
	sig = HPF.ar(sig, hpfCutoff);
	sig = sig * amp * timerEnv * wrapAmp * bodyEnv;
	// sig = Pan4.ar(sig, xPos, yPos);
	sig = Pan2.ar(sig, xPos);
	Out.ar(0, sig);
}).add;



SynthDef(\bee, {
	//Incoming Paramaters
	arg beeParam1,beeParam2, beeParam3, beeParam4, beeParam5, beeParam6, beeParam7, beeParam8, beeParam9, velocity, amp = 1, wrapAmp = 1, xPos = 0, yPos = 0, gate = 1,

	//Envelope triggers
	t_beeCallBeeTrig = 0, t_tpCallBeeTrig = 0, t_beeCallTpTrig = 0,
	//Envelope depths
	beeBeeP1EnvDepth = 0, beeBeeP2EnvDepth = 0, beeBeeP3EnvDepth = 0, beeBeeP4EnvDepth = 0, beeBeeP5EnvDepth = 0, beeBeeP6EnvDepth = 0, beeBeeP7EnvDepth = 0, beeBeeP8EnvDepth = 0, beeBeeP9EnvDepth = 0, beeBeeAttack = 0.5, beeBeeRelease = 0.5,

	tpBeeP1EnvDepth = 0, tpBeeP2EnvDepth = 0, tpBeeP3EnvDepth = 0, tpBeeP4EnvDepth = 0, tpBeeP5EnvDepth = 0, tpBeeP6EnvDepth = 0, tpBeeP7EnvDepth = 0, tpBeeP8EnvDepth = 0, tpBeeP9EnvDepth = 0, tpBeeAttack = 0.5, tpBeeRelease = 0.5,

	beeTpP1EnvDepth = 0, beeTpP2EnvDepth = 0, beeTpP3EnvDepth = 0, beeTpP4EnvDepth = 0, beeTpP5EnvDepth = 0, beeTpP6EnvDepth = 0, beeTpP7EnvDepth = 0, beeTpP8EnvDepth = 0, beeTpP9EnvDepth = 0, beeTpAttack = 0.5, beeTpRelease = 0.5, beeBeeAmpDepth = 0, tpBeeAmpDepth = 0, beeTpAmpDepth = 0;

	//Your paramaters
	var freq = LinExp.kr(beeParam1, 0, 1, 40, 10000);
	var freqModFreq = LinExp.kr(beeParam2, 0, 1, 0.0001, 200);
	var freqModDepth = LinExp.kr(beeParam3, 0, 1, 0.001, 1000);
	var hpfCutoff = LinExp.kr(beeParam4, 0, 1, 40, 10000);
	var lpfCutoff = LinExp.kr(beeParam5, 0, 1, 40, 10000);

	//Your signals
	var sig, env, freqMod;

	//Your call Envelopes
	var beeBeeCall, tpBeeCall, beeTpCall;
	var allCallP1, allCallP2, allCallP3, allCallP4, allCallP5, allCallP6, allCallP7, allCallP8, allCallP9, allCallAmp;

	beeBeeCall = EnvGen.kr(Env.perc(beeBeeAttack, beeBeeRelease), t_beeCallBeeTrig);
	tpBeeCall =  EnvGen.kr(Env.perc(tpBeeAttack, tpBeeRelease), t_tpCallBeeTrig);
	beeTpCall =  EnvGen.kr(Env.perc(beeTpAttack, beeTpRelease), t_beeCallTpTrig);

	allCallAmp = Mix.ar([beeBeeCall * beeBeeAmpDepth, tpBeeCall * tpBeeAmpDepth, beeTpCall * beeTpAmpDepth]);
	allCallP1 = Mix.ar([beeBeeCall * beeBeeP1EnvDepth, tpBeeCall * tpBeeP1EnvDepth, beeTpCall * beeTpP1EnvDepth]);
	allCallP2 = Mix.ar([beeBeeCall * beeBeeP2EnvDepth, tpBeeCall * tpBeeP2EnvDepth, beeTpCall * beeTpP2EnvDepth]);
	allCallP3 = Mix.ar([beeBeeCall * beeBeeP3EnvDepth, tpBeeCall * tpBeeP3EnvDepth, beeTpCall * beeTpP3EnvDepth]);
	allCallP4 = Mix.ar([beeBeeCall * beeBeeP4EnvDepth, tpBeeCall * tpBeeP4EnvDepth, beeTpCall * beeTpP4EnvDepth]);
	allCallP5 = Mix.ar([beeBeeCall * beeBeeP5EnvDepth, tpBeeCall * tpBeeP5EnvDepth, beeTpCall * beeTpP5EnvDepth]);
	allCallP6 = Mix.ar([beeBeeCall * beeBeeP6EnvDepth, tpBeeCall * tpBeeP6EnvDepth, beeTpCall * beeTpP6EnvDepth]);
	allCallP7 = Mix.ar([beeBeeCall * beeBeeP7EnvDepth, tpBeeCall * tpBeeP7EnvDepth, beeTpCall * beeTpP7EnvDepth]);
	allCallP8 = Mix.ar([beeBeeCall * beeBeeP8EnvDepth, tpBeeCall * tpBeeP8EnvDepth, beeTpCall * beeTpP8EnvDepth]);
	allCallP9 = Mix.ar([beeBeeCall * beeBeeP9EnvDepth, tpBeeCall * tpBeeP9EnvDepth, beeTpCall * beeTpP9EnvDepth]);
	freqMod = SinOsc.kr(freqModFreq + allCallP2, 0, freqModDepth + allCallP3);
	env = EnvGen.kr(Env.asr(5), gate, doneAction:2);
	sig = Saw.ar(abs(freq + freqMod + allCallP1)); //SAW
	allCallP4.poll;
	sig = LPF.ar(sig, 40 + ( (lpfCutoff + allCallP5) * env) ); //LPF
	allCallP5.poll;
	sig = HPF.ar(sig, 40 + ( (hpfCutoff + allCallP4)) ); //LPF
	allCallAmp.poll;
	sig = (sig * (amp + allCallAmp) * env)  * wrapAmp;
	sig = Pan2.ar(sig, xPos);
	// sig = Pan4.ar(sig, xPos, yPos);
	Out.ar(0, sig);
}).add;


SynthDef(\tonalNoise, {
	//Incoming Paramaters
	arg beeParam1,beeParam2, beeParam3, beeParam4, beeParam5, beeParam6, beeParam7, beeParam8, beeParam9, velocity, forcefield, amp = 1, wrapAmp = 1, xPos = 0, yPos = 0, gate = 1,

	//Envelope triggers
	t_beeCallBeeTrig = 0, t_tpCallBeeTrig = 0, t_beeCallTpTrig = 0,
	//Envelope depths
	beeBeeP1EnvDepth = 0, beeBeeP2EnvDepth = 0, beeBeeP3EnvDepth = 0, beeBeeP4EnvDepth = 0, beeBeeP5EnvDepth = 0, beeBeeP6EnvDepth = 0, beeBeeP7EnvDepth = 0, beeBeeP8EnvDepth = 0, beeBeeP9EnvDepth = 0, beeBeeAttack = 0.5, beeBeeRelease = 0.5,

	tpBeeP1EnvDepth = 0, tpBeeP2EnvDepth = 0, tpBeeP3EnvDepth = 0, tpBeeP4EnvDepth = 0, tpBeeP5EnvDepth = 0, tpBeeP6EnvDepth = 0, tpBeeP7EnvDepth = 0, tpBeeP8EnvDepth = 0, tpBeeP9EnvDepth = 0, tpBeeAttack = 0.5, tpBeeRelease = 0.5,

	beeTpP1EnvDepth = 0, beeTpP2EnvDepth = 0, beeTpP3EnvDepth = 0, beeTpP4EnvDepth = 0, beeTpP5EnvDepth = 0, beeTpP6EnvDepth = 0, beeTpP7EnvDepth = 0, beeTpP8EnvDepth = 0, beeTpP9EnvDepth = 0, beeTpAttack = 0.5, beeTpRelease = 0.5, beeBeeAmpDepth = 0, tpBeeAmpDepth = 0, beeTpAmpDepth = 0,

	//Boundaries
	minP1 = 1, maxP1 = 200, minP2 = 50, maxP2 = 10000, minP3 = 1, maxP3 = 1000, minP4 = 40, maxP4 = 10000, minP5 = 40, maxP5 = 10000, minP6 = 1, maxP6 = 10, minP7= 0.01, maxP7 = 0.99;
	//Your paramaters with mapping
	var trigFreq = LinExp.kr(beeParam1, 0, 1, minP1, maxP1);
	var carFreq = LinExp.kr(beeParam2, 0, 1, minP2, maxP2);
	var modFreq = LinExp.kr(beeParam3, 0, 1, minP3, maxP3);
	var hpfCutoff = LinExp.kr(beeParam4, 0, 1, minP4, maxP4);
	var lpfCutoff = LinExp.kr(beeParam5, 0, 1, minP5, maxP5);
	var index = round(LinLin.kr(beeParam6, 0, 1, minP6, maxP6));
	var propDens = LinExp.kr(beeParam7, 0, 1, minP7, maxP7);
	var force1 = LinLin.kr(forcefield, 0, 1, 1, 10);
	var force2 = LinLin.kr(forcefield, 0, 1, 1, 0.5);

	//Your signals
	var trigger, sig, env;

	//Your call Envelopes
	var beeBeeCall, tpBeeCall, beeTpCall;
	var allCallP1, allCallP2, allCallP3, allCallP4, allCallP5, allCallP6, allCallP7, allCallP8, allCallP9, allCallAmp;

	beeBeeCall = EnvGen.kr(Env.perc(beeBeeAttack, beeBeeRelease), t_beeCallBeeTrig);
	tpBeeCall =  EnvGen.kr(Env.perc(tpBeeAttack, tpBeeRelease), t_tpCallBeeTrig);
	beeTpCall =  EnvGen.kr(Env.perc(beeTpAttack, beeTpRelease), t_beeCallTpTrig);

	//Your calls with mapping
	allCallAmp = Mix.ar([beeBeeCall * beeBeeAmpDepth, tpBeeCall * tpBeeAmpDepth, beeTpCall * beeTpAmpDepth]);
	allCallP1 = Mix.ar([beeBeeCall * beeBeeP1EnvDepth, tpBeeCall * tpBeeP1EnvDepth, beeTpCall * beeTpP1EnvDepth]);
	allCallP2 = Mix.ar([beeBeeCall * beeBeeP2EnvDepth, tpBeeCall * tpBeeP2EnvDepth, beeTpCall * beeTpP2EnvDepth]);
	allCallP3 = Mix.ar([beeBeeCall * beeBeeP3EnvDepth, tpBeeCall * tpBeeP3EnvDepth, beeTpCall * beeTpP3EnvDepth]);
	allCallP4 = Mix.ar([beeBeeCall * beeBeeP4EnvDepth, tpBeeCall * tpBeeP4EnvDepth, beeTpCall * beeTpP4EnvDepth]);
	allCallP5 = Mix.ar([beeBeeCall * beeBeeP5EnvDepth, tpBeeCall * tpBeeP5EnvDepth, beeTpCall * beeTpP5EnvDepth]);
	allCallP6 = Mix.ar([beeBeeCall * beeBeeP6EnvDepth, tpBeeCall * tpBeeP6EnvDepth, beeTpCall * beeTpP6EnvDepth]);
	allCallP7 = Mix.ar([beeBeeCall * beeBeeP7EnvDepth, tpBeeCall * tpBeeP7EnvDepth, beeTpCall * beeTpP7EnvDepth]);
	allCallP8 = Mix.ar([beeBeeCall * beeBeeP8EnvDepth, tpBeeCall * tpBeeP8EnvDepth, beeTpCall * beeTpP8EnvDepth]);
	allCallP9 = Mix.ar([beeBeeCall * beeBeeP9EnvDepth, tpBeeCall * tpBeeP9EnvDepth, beeTpCall * beeTpP9EnvDepth]);

	//signals
	env = EnvGen.kr(Env.asr(5), gate, doneAction:2);
	trigger = Impulse.kr(trigFreq + allCallP1 * force1);
	sig = GrainFM.ar(1, trigger, propDens/(trigFreq + allCallP1), carFreq + allCallP2 * force1 * LinLin.kr(velocity, 0, 1, 1, 2), modFreq + allCallP3 * LinLin.kr(velocity, 0, 1, 1, 5), index + allCallP7);
	allCallP5.poll;
	sig = LPF.ar(sig, 40 + abs(lpfCutoff + allCallP5));
	sig = HPF.ar(sig, 40 + abs(hpfCutoff + allCallP4));
	sig = (sig * (amp + allCallAmp) * env)  * wrapAmp;
	sig = Pan2.ar(sig, xPos);
	// sig = Pan4.ar(sig, xPos, yPos);
	Out.ar(0, sig);
}).add;

SynthDef(\fbSine, {
	arg beeParam1,beeParam2, beeParam3, beeParam4, beeParam5, beeParam6, beeParam7, beeParam8, beeParam9, velocity, forcefield, amp = 1, wrapAmp = 1, xPos = 0, yPos = 0, gate = 1,
	//Envelope triggers
	t_beeCallBeeTrig = 0, t_tpCallBeeTrig = 0, t_beeCallTpTrig = 0,
	//Envelope depths
	beeBeeP1EnvDepth = 0, beeBeeP2EnvDepth = 0, beeBeeP3EnvDepth = 0, beeBeeP4EnvDepth = 0, beeBeeP5EnvDepth = 0, beeBeeP6EnvDepth = 0, beeBeeP7EnvDepth = 0, beeBeeP8EnvDepth = 0, beeBeeP9EnvDepth = 0, beeBeeAttack = 0.5, beeBeeRelease = 0.5,

	tpBeeP1EnvDepth = 0, tpBeeP2EnvDepth = 0, tpBeeP3EnvDepth = 0, tpBeeP4EnvDepth = 0, tpBeeP5EnvDepth = 0, tpBeeP6EnvDepth = 0, tpBeeP7EnvDepth = 0, tpBeeP8EnvDepth = 0, tpBeeP9EnvDepth = 0, tpBeeAttack = 0.5, tpBeeRelease = 0.5,

	beeTpP1EnvDepth = 0, beeTpP2EnvDepth = 0, beeTpP3EnvDepth = 0, beeTpP4EnvDepth = 0, beeTpP5EnvDepth = 0, beeTpP6EnvDepth = 0, beeTpP7EnvDepth = 0, beeTpP8EnvDepth = 0, beeTpP9EnvDepth = 0, beeTpAttack = 0.5, beeTpRelease = 0.5, beeBeeAmpDepth = 0, tpBeeAmpDepth = 0, beeTpAmpDepth = 0,

	//Boundaries
	minP1, maxP1, minP2, maxP2, minP3, maxP3, minP4, maxP4, minP5, maxP5, minP6, maxP6, minP7, maxP7, minP8, maxP8, minP9, maxP9;
	//Your paramaters with mapping
	var freq = LinExp.kr(beeParam1, 0, 1, minP1, maxP1);
	var im = LinExp.kr(beeParam2, 0, 1, minP2, maxP2);
	var fb = LinLin.kr(beeParam3, 0, 1, minP3, maxP3);
	var hpfCutoff = LinExp.kr(beeParam4, 0, 1, minP4, maxP4);
	var lpfCutoff = LinExp.kr(beeParam5, 0, 1, minP5, maxP5);
	var a = LinExp.kr(beeParam6, 0, 1, minP6, maxP6);
	var c = LinExp.kr(beeParam7, 0, 1, minP7, maxP7);
	var force1 = LinLin.kr(forcefield, 0, 1, 1, 2);
	var force2 = LinLin.kr(forcefield, 0, 1, 1.0, 10.0);
	var force3 = LinLin.kr(forcefield, 0, 1, 0.2, 0.8);

	//Your signals
	var sig, env;

	//Your call Envelopes
	var beeBeeCall, tpBeeCall, beeTpCall;
	var allCallP1, allCallP2, allCallP3, allCallP4, allCallP5, allCallP6, allCallP7, allCallP8, allCallP9, allCallAmp;

	beeBeeCall = EnvGen.kr(Env.perc(beeBeeAttack/force2, beeBeeRelease/force2), t_beeCallBeeTrig);
	tpBeeCall =  EnvGen.kr(Env.perc(tpBeeAttack, tpBeeRelease), t_tpCallBeeTrig);
	beeTpCall =  EnvGen.kr(Env.perc(beeTpAttack, beeTpRelease), t_beeCallTpTrig);

	//Your calls with mapping
	allCallAmp = Mix.ar([beeBeeCall * beeBeeAmpDepth, tpBeeCall * tpBeeAmpDepth, beeTpCall * beeTpAmpDepth]);
	allCallP1 = Mix.ar([beeBeeCall * beeBeeP1EnvDepth, tpBeeCall * tpBeeP1EnvDepth, beeTpCall * beeTpP1EnvDepth]);
	allCallP2 = Mix.ar([beeBeeCall * beeBeeP2EnvDepth, tpBeeCall * tpBeeP2EnvDepth, beeTpCall * beeTpP2EnvDepth]);
	allCallP3 = Mix.ar([beeBeeCall * beeBeeP3EnvDepth, tpBeeCall * tpBeeP3EnvDepth, beeTpCall * beeTpP3EnvDepth]);
	allCallP4 = Mix.ar([beeBeeCall * beeBeeP4EnvDepth, tpBeeCall * tpBeeP4EnvDepth, beeTpCall * beeTpP4EnvDepth]);
	allCallP5 = Mix.ar([beeBeeCall * beeBeeP5EnvDepth, tpBeeCall * tpBeeP5EnvDepth, beeTpCall * beeTpP5EnvDepth]);
	allCallP6 = Mix.ar([beeBeeCall * beeBeeP6EnvDepth, tpBeeCall * tpBeeP6EnvDepth, beeTpCall * beeTpP6EnvDepth]);
	allCallP7 = Mix.ar([beeBeeCall * beeBeeP7EnvDepth, tpBeeCall * tpBeeP7EnvDepth, beeTpCall * beeTpP7EnvDepth]);
	allCallP8 = Mix.ar([beeBeeCall * beeBeeP8EnvDepth, tpBeeCall * tpBeeP8EnvDepth, beeTpCall * beeTpP8EnvDepth]);
	allCallP9 = Mix.ar([beeBeeCall * beeBeeP9EnvDepth, tpBeeCall * tpBeeP9EnvDepth, beeTpCall * beeTpP9EnvDepth]);
	//signals
	env = EnvGen.kr(Env.asr(5), gate, doneAction:2);
	sig = FBSineC.ar((freq+allCallP1 * force2) * velocity, im+allCallP2 * force1, fb+allCallP3, a+allCallP6, c+allCallP7, mul:0.5);
	sig = LPF.ar(sig, 40 + (lpfCutoff + allCallP5));
	sig = HPF.ar(sig, 40 + (hpfCutoff + allCallP4));
	sig = (sig * (amp + allCallAmp) * env)  * wrapAmp * force3;
	sig = Pan2.ar(sig, xPos);
	// sig = Pan4.ar(sig, xPos, yPos);
	Out.ar(0, sig);
}).add;



)





////TEST LOUDSPEAKERS
(
Routine({
	var tonNoise = Synth(\tonalNoise);
	{
		tonNoise.set(\trigFreq, exprand(0.1, 2), \carFreq, exprand(50, 1000), \modFreq, exprand(1, 1000), \index, rrand(1, 10));
		0.25.yield;
	}.loop
}).play
)

(
Routine({
	var tonNoise = Synth(\tonalNoise);
	{
		tonNoise.set(\trigFreq, exprand(0.1, 2), \carFreq, exprand(50, 1000), \modFreq, exprand(1, 1000), \index, rrand(1, 10));
		0.25.yield;
	}.loop
}).play
)

(
SynthDef(\test, {
	arg bus;
	var env, sig;
	env = EnvGen.kr(Env.perc(0.01, 0.5), doneAction:2);
	sig = WhiteNoise.ar(0.1);
	sig = sig * env;
	Out.ar(bus, sig);
}).add
)

(
Routine({
	var busOut = 0;
	{
		Synth(\test, [\bus, busOut]);
		0.5.yield;
		busOut = (busOut + 1)%4;
	}.loop
}).play
)




(
SynthDef("help-Pan4", {
	// Out.ar(0, Pan4.ar(HPF.ar(Pulse.ar(10, 0.5, 0.5), 100),SinOsc.kr(0.5, 0), LFTri.kr(0.5, 0.5)) * 0.3);
	Out.ar(0, Pan4.ar(HPF.ar(Pulse.ar(10, 0.5, 0.5), 100), -1, 1));
	// Out.ar(0, Pan4.ar(HPF.ar(Pulse.ar(10, 0.5, 0.5) * 0.3, 1000), -1, -1));
}).play;
)

(
SynthDef("help-Pan4", {
    Out.ar(0, Pan4.ar(PinkNoise.ar, FSinOsc.kr(0.5), FSinOsc.kr(0.4), 0.3))
}).play;
)

s.options.outDevice =  "Soundflower (64ch)";
s.options.outDevice =  "Fireface 802 (23784291)";
s.options.sampleRate = 48000

s.options.numOutputBusChannels = 8

