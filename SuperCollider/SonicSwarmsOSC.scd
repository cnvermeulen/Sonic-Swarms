(
////////////////////////////////////////////////////////////
/////TEST DATA COMING FROM PROCESSING//////////////////
///////////////////////////////////////////////////////////

n = NetAddr("127.0.0.1", 57120); // local machine

~testTadpoleData = {
	var tadpoleData = List();
	OSCdef(\tadpoleMsg, {arg msg; tadpoleData = msg[1]}, "/tadPoleMove");
	Routine({
		{
			tadpoleData.postln;
			3.yield;
		}.loop
	}).play
};
~testBeeData = {
	var beeData = List();
	OSCdef(\beeCreated, {"beeCreated".postln}, "/beeCreated");
	OSCdef(\beeDeleted, {arg msg; ("bee" + msg[1].asString + "Deleted").postln}, "/beeDeleted");
	OSCdef(\beeData, {arg msg; beeData = msg}, "/beeData");
	Routine({
		{
			beeData.postln;
			3.yield;
		}.loop
	}).play
};
~testInterfaceData = {
	var interfaceData = List();
	OSCdef(\interfaceData, {arg msg; interfaceData = Array.fill(4, {arg i; msg})}, "/interfaceData");
	Routine({
		{
			interfaceData.postln;
			3.yield;
		}.loop
	}).play
}
)

~testTadpoleData.();
~testBeeData.();
~testInterfaceData.();


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////AGENT SYNTHESIS
///////////////////////////////////////
( ///////////////////////////////////////////////////// EVALUATE HERE
var beeInstrument = \bee; ///choose instrument for continuous agents
var tpInstrument = \tadPole2; //////choose instrument for discrete agents


///TONAL NOISE
var toNoMinP1 = 1, toNomaxP1 = 200, toNoMinP2 = 50, toNomaxP2 = 10000, toNoMinP3 = 1, toNomaxP3 = 1000, toNoMinP4 = 40, toNomaxP4 = 10000, toNoMinP5 = 40, toNomaxP5 = 10000, toNoMinP6 = 1, toNomaxP6 = 10, toNoMinP7 = 0.01, toNomaxP7 = 0.99, toNoMinP8 = 0, toNomaxP8 = 1, toNoMinP9 = 0, toNomaxP9 = 1;

var toNoMins = [toNoMinP1, toNoMinP2, toNoMinP3, toNoMinP4, toNoMinP5, toNoMinP6, toNoMinP7, toNoMinP8, toNoMinP9];
var toNoMaxs= [toNomaxP1, toNomaxP2, toNomaxP3, toNomaxP4, toNomaxP5, toNomaxP6, toNomaxP7, toNomaxP8, toNomaxP9];

///FM-SAW
var fmSawMinP1 = 40, fmSawMaxP1 = 13000, fmSawMinP2 = 1, fmSawMaxP2 = 1000, fmSawMinP3 = 0, fmSawMaxP3 = 1000, fmSawMinP4 = 40, fmSawMaxP4 = 12000, fmSawMinP5 = 40, fmSawMaxP5 = 12000, fmSawMinP6 = 0, fmSawMaxP6 = 1, fmSawMinP7 = 0, fmSawMaxP7 = 1, fmSawMinP8 = 0, fmSawMaxP8 = 1, fmSawMinP9 = 0, fmSawMaxP9 = 1;

var fmSawMins = [fmSawMinP1, fmSawMinP2, fmSawMinP3, fmSawMinP4, fmSawMinP5, fmSawMinP6, fmSawMinP7, fmSawMinP8, fmSawMinP9];
var fmSawMaxs= [fmSawMaxP1, fmSawMaxP2, fmSawMaxP3, fmSawMaxP4, fmSawMaxP5, fmSawMaxP6, fmSawMaxP7, fmSawMaxP8, fmSawMaxP9];

///FEEDBACK-SINE
var fbSineMinP1 = 1e4 * 1.5, fbSineMaxP1 = 1e4 * 2, fbSineMinP2 = 1, fbSineMaxP2 = 65, fbSineMinP3 = -0.5, fbSineMaxP3 = 0.5, fbSineMinP4 = 40, fbSineMaxP4 = 12000, fbSineMinP5 = 40, fbSineMaxP5 = 12000, fbSineMinP6 = 1, fbSineMaxP6 = 1.10, fbSineMinP7 = 0.001, fbSineMaxP7 = 0.6, fbSineMinP8 = 0, fbSineMaxP8 = 0, fbSineMinP9 = 0, fbSineMaxP9 = 0;
var fbSineMins = [fbSineMinP1, fbSineMinP2, fbSineMinP3, fbSineMinP4, fbSineMinP5, fbSineMinP6, fbSineMinP7, fbSineMinP8, fbSineMinP9];
var fbSineMaxs = [fbSineMaxP1, fbSineMaxP2, fbSineMaxP3, fbSineMaxP4, fbSineMaxP5, fbSineMaxP6, fbSineMaxP7, fbSineMaxP8, fbSineMaxP9];

////////////////////////////////////////////
//Add parameter boundaries of instrument object here
// var yourInstrumentNameMaxP1 = ....., yourInstrumentNameMinP1 = ....., yourInstrumentNameMaxP2 = .....

///////////////////////////////////////////

var minAmp = 0, maxAmp = 1.0;

var tpAmp, tpAmpLfto;
var paramsTp = Array.newClear(10), paramsTpLfto = Array.newClear(10);

var beeAmp, beeAmpLfto;
var paramsBee = Array.newClear(9), paramsBeeLfto = Array.newClear(9),  interactionEnvPara;

var beeAmpModDepths, beeAmpNode;

var tadpoleCalltadpoleDepth, tadpoleCallBeeDepth, beeCallTadpoleDepth, beeCallBeeDepth, tadpoleRespondDepth, beeRespondDepth, distBeeNode, distBeeDepths, beeBeeNode, beeBeeDepths, tpBeeNodeBee, tpBeeNodeTp, tpBeeNode, tpBeeDepths, beeTpNode, beeTpNodeBee, beeTpNodeTp, beeTpDepths, tpTpNode, tpTpDepths, distTpNode, distTpDepths, maxSpeedBeeNode, forceFieldBeeNode, forceFieldTpNode;

var beeSynths = List();

///////////////
/////INTERFACE
//////////////////////////

OSCdef(\interfaceData, {arg msg;
	//TP KNOBS
	paramsTp[0] = msg[1];
	paramsTpLfto[0] = 1 - msg[1];
	paramsTp[1] = msg[2];
	paramsTpLfto[1] = 1 - msg[2];
	paramsTp[2] = msg[3];
	paramsTpLfto[2] = 1 - msg[3];
	paramsTp[3] = msg[4];
	paramsTpLfto[3] = 1 - msg[4];
	paramsTp[4] = msg[5];
	paramsTpLfto[4] = 1 - msg[5];
	paramsTp[5] = msg[6];
	paramsTpLfto[5] = 1 - msg[6];
	paramsTp[6] = msg[7];
	paramsTpLfto[6] = 1 - msg[7];
	paramsTp[7] = msg[8];
	paramsTpLfto[7] = 1 - msg[8];
	paramsTp[8] = msg[9];
	paramsTpLfto[8] = 1 - msg[9];
	paramsTp[9] = msg[10];
	paramsTpLfto[9] = 1 - msg[10];
	//BEE KNOBS
	9.do({arg i; paramsBee[i] = msg[i+11]; paramsBeeLfto[i] = 1 - msg[i+11]});
	tadpoleCalltadpoleDepth = linexp(msg[20], 0, 1, 0.001, 1);
	tadpoleCallBeeDepth = linexp(msg[21], 0, 1, 0.001, 1);
	beeCallTadpoleDepth = linexp(msg[22], 0, 1, 0.001, 1);
	beeCallBeeDepth = linexp(msg[23], 0, 1, 0.001, 1);
	tadpoleRespondDepth = linexp(msg[24], 0, 1, 0.001, 1);
	beeRespondDepth = linexp(msg[25], 0, 1, 0.001, 1);
	tpAmp = msg[26];
	tpAmpLfto = 1.0 - tpAmp;
	beeAmp = msg[27];
	beeAmpLfto = 1.0 - beeAmp;


	distBeeNode = Array.fill(5, {arg i; msg[28].asString[i+1].asString.asInteger}).reverse ++ Array.fill(4, {arg i; msg[29].asString[i+1].asString.asInteger}).reverse;
	// distBeeNode.postln;

	beeBeeNode = Array.fill(5, {arg i; msg[30].asString[i+1].asString.asInteger}).reverse ++ Array.fill(4, {arg i; msg[31].asString[i+1].asString.asInteger}).reverse;
	// beeBeeNode.postln;

	tpBeeNodeBee = Array.fill(5, {arg i; msg[32].asString[i+1].asString.asInteger}).reverse ++ Array.fill(4, {arg i; msg[33].asString[i+1].asString.asInteger}).reverse;
	tpBeeNodeTp = Array.fill(5, {arg i; msg[34].asString[i+1].asString.asInteger}).reverse ++ Array.fill(5, {arg i; msg[35].asString[i+1].asString.asInteger}).reverse;
	tpBeeNode = tpBeeNodeBee ++ tpBeeNodeTp;
	// tpBeeNode.postln;

	beeTpNodeBee = Array.fill(5, {arg i; msg[36].asString [i+1].asString.asInteger}).reverse ++ Array.fill(4, {arg i; msg[37].asString[i+1].asString.asInteger}).reverse;
	beeTpNodeTp = Array.fill(5, {arg i; msg[38].asString [i+1].asString.asInteger}).reverse ++ Array.fill(5, {arg i; msg[39].asString [i+1].asString.asInteger}).reverse;
	beeTpNode = beeTpNodeBee ++ beeTpNodeTp;
	// beeTpNode.postln;

	tpTpNode = Array.fill(5, {arg i; msg[40].asString[i+1].asString.asInteger}).reverse ++ Array.fill(5, {arg i; msg[41].asString[i+1].asString.asInteger}).reverse;
	// tpTpNode.postln;

	distTpNode = Array.fill(5, {arg i; msg[42].asString[i+1].asString.asInteger}).reverse ++ Array.fill(5, {arg i; msg[43].asString[i+1].asString.asInteger}).reverse;
	// distTpNode.postln;

	distBeeDepths = Array.fill(9, {arg i; msg[44 + i]});
	// distBeeDepths.postln;
	beeBeeDepths = Array.fill(9, {arg i; msg[53 + i]});
	// beeBeeDepths.postln;
	tpBeeDepths = Array.fill(9, {arg i; msg[62 + i]}) ++ Array.fill(10, {arg i; msg[110 + i]});
	// tpBeeDepths.postln;
	beeTpDepths = Array.fill(9, {arg i; msg[71 + i]}) ++ Array.fill(10, {arg i; msg[100 + i]});
	// beeTpDepths.postln;
	tpTpDepths = Array.fill(10, {arg i; msg[90 + i]});
	// tpTpDepths.postln;
	distTpDepths = Array.fill(10, {arg i; msg[80 + i]});
	// distTpDepths.postln;
	interactionEnvPara = Array.fill(6, {arg i; linexp(msg[i + 120], 0, 1, 0.01, 5)});

	beeAmpNode = Array.fill(6, {arg i; msg[126].asString[i+1].asString.asInteger}).reverse;
	// beeAmpNode.postln;
	beeAmpModDepths = Array.fill(6, {arg i; msg[127 + i]});
	// beeAmpModDepths.postln;
}, "/interfaceData");


///////////////
/////TADPOLES
//////////////////////////
////1 nTadpoles, 2 sysWinRadius, 3 distGlobeHor, 4 thetaCentre, 5 distCentre, 6 vision, 7 velocity, 8 bodySize, 9 movekind
OSCdef(\tadPoleMove, {arg msg;
	var sysWinRadius, distGlobeHorizon, wrapAmp, xPos, yPos, velocity, bodySize, vision, distToNeighbourTp, fleeMove, distTpMod, tpTpMod, beeTpMod, tpBeeMod, callsTp, callsBee;
	xPos = cos(msg[4]) * linlin(msg[5], 0, msg[5], -1, 1);
	yPos = sin(msg[4]) * linlin(msg[5], 0, msg[5], -1, 1);
	wrapAmp =  ~calculateWrappingAmp.(msg[4], msg[5], msg[2], msg[3]);
    velocity = linlin(msg[7], 0, 15, 40, 15000);
	bodySize = msg[8];
	vision = msg[9];
	distToNeighbourTp = linlin(msg[10], 0, vision, 1.0, 0);
	fleeMove = msg[11];
	if(msg[12], {callsTp = 1}, {callsTp = 0});
	if(msg[13], {callsBee = 1}, {callsBee = 0});
	distTpMod = (0!10);
	tpTpMod = (0!10);
	beeTpMod = (0!10);
	tpBeeMod = (0!10);

	10.do({arg i;
		if(distTpDepths[i] < 0, {
			distTpMod[i] = distTpNode[i] * paramsTp[i] * distTpDepths[i];
		}, {
			distTpMod[i] = distTpNode[i] * paramsTpLfto[i] * distTpDepths[i];
		});
	});
	10.do({arg i;
		if(tpTpDepths[i] < 0, {
			tpTpMod[i] = tpTpNode[i] * paramsTp[i] * tpTpDepths[i];
		}, {
			tpTpMod[i] = tpTpNode[i] * paramsTpLfto[i] * tpTpDepths[i];
		});
	});
	10.do({arg i;
		if(beeTpDepths[i + 9] < 0, {
			beeTpMod[i] = beeTpNode[i + 9] * paramsTp[i] * beeTpDepths[i + 9];
		}, {
			beeTpMod[i] = beeTpNode[i + 9] * paramsTpLfto[i] * beeTpDepths[i + 9];
		});
	});
	10.do({arg i;
		if(tpBeeDepths[i + 9] < 0, {
			tpBeeMod[i] = tpBeeNode[i + 9] * paramsTp[i] * tpBeeDepths[i + 9];
		}, {
			tpBeeMod[i] = tpBeeNode[i + 9] * paramsTpLfto[i] * tpBeeDepths[i + 9];
		});
	});
	Synth(tpInstrument, [
		 \tpParam1, paramsTp[0] + (distTpMod[0] * distToNeighbourTp) + (tpTpMod[0] * callsTp) + (beeTpMod[0] * fleeMove) + (tpBeeMod[0] * callsBee),
		\tpParam2, paramsTp[1] + (distTpMod[1] * distToNeighbourTp) + (tpTpMod[1] * callsTp) + (beeTpMod[1] * fleeMove) + (tpBeeMod[1] * callsBee),
		\tpParam3, paramsTp[2] + (distTpMod[2] * distToNeighbourTp) + (tpTpMod[2] * callsTp) + (beeTpMod[2] * fleeMove) + (tpBeeMod[2] * callsBee),
		\tpParam4, paramsTp[3] + (distTpMod[3] * distToNeighbourTp) + (tpTpMod[3] * callsTp) + (beeTpMod[3] * fleeMove) + (tpBeeMod[3] * callsBee),
		\tpParam5,  paramsTp[4] + (distTpMod[4] * distToNeighbourTp) + (tpTpMod[4] * callsTp) + (beeTpMod[4] * fleeMove) + (tpBeeMod[4] * callsBee),
		\tpParam6, paramsTp[5] + (distTpMod[5] * distToNeighbourTp) + (tpTpMod[5] * callsTp) + (beeTpMod[5] * fleeMove) + (tpBeeMod[5] * callsBee),
		\tpParam7, paramsTp[6],
		\tpParam8, paramsTp[7],
		\tpParam8Lfto, paramsTpLfto[7],
		\tpParam9, paramsTp[8],
		\tpParam10, paramsTp[9],
		\tpParam10Lfto, paramsTpLfto[9],
		\bodySize, bodySize,
		\xPos, xPos,
		\yPos, yPos,
		\wrapAmp, wrapAmp,
		\t_trig, fleeMove,
		\callDepth, tadpoleRespondDepth,
		\amp, tpAmp
	])
}, "/tadPoleMove");

///////////////
/////BEES
//////////////////////////
////////////////////////
////1 nBees, 2, sysWinRadius, 3 distGlobeHor, 4++ thetaCentre, 5++ distCentre, 6++ vision, 7++ velocity, 8++ distNeighb, 9++ callsBee, 10++ callsTadpole, 11++ mass, 12++ receivedForce
//nData = 8
OSCdef(\beeData, {arg msg;
	var sysWinRadius, distGlobeHorizon, wrapAmps, xPos, yPos, velocities, visions, distToOthers, callsBee, callsTadpole, respondsToTp, masses, nBees, nData, receivedForces, distBeeMod, beeBeeMod, tpBeeMod, beeTpMod, minsBee, maxsBee;
	if(beeInstrument == \bee, {minsBee = fmSawMins; maxsBee = toNoMaxs});
	if(beeInstrument == \tonalNoise, {minsBee = toNoMins; maxsBee = toNoMaxs});
	if(beeInstrument == \fbSine, {minsBee = fbSineMins; maxsBee = fbSineMaxs});
	//ADD NEW INSTRUMENT HERE<-------------


	nBees = msg[1];
	sysWinRadius = msg[2];
	distGlobeHorizon = msg[3];
	nData = 10;
	wrapAmps = Array.fill(nBees, {arg i; ~calculateWrappingAmp.(msg[4 + (nData*i)], msg[5 + (nData*i)], msg[2], msg[3])});
	// wrapAmps[0].postln;
	xPos = Array.fill(nBees, {arg i; cos(msg[4 + (nData*i)]) * linlin(msg[5 + (nData*i)], 0, sysWinRadius, 0, 2) });
	yPos = Array.fill(nBees, {arg i; sin(msg[4 + (nData*i)]) * linlin(msg[5 + (nData*i)], 0, sysWinRadius, 0, 2) });
	velocities = Array.fill(nBees, {arg i; linexp(msg[7 + (nData*i)], 0, 15, 0.2, 2)});
	visions = Array.fill(nBees, {arg i; msg[6 + (nData*i)]});
	distToOthers = Array.fill(nBees, {arg i; linlin(msg[8 + (nData*i)], 0, visions[i], 1.0, 0)});
	callsBee = Array.fill(nBees, {arg i; msg[9 + (i*nData)]});
	callsTadpole = Array.fill(nBees, {arg i; msg[10 + (i*nData)]});
	respondsToTp = Array.fill(nBees, {arg i; msg[11 + (i*nData)]});
	// respondsToTp.postln;
	masses = Array.fill(nBees, {arg i; linlin(msg[12 + (i*nData)], 1, 10, 1.05, 0.95)});
	receivedForces = Array.fill(nBees, {arg i; msg[13 + (nData*i)]});
	distBeeMod = (0!9);
	beeBeeMod = (0!9);
	tpBeeMod = (0!13);
	beeTpMod = (0!13);

	9.do({arg i;
		if(distBeeDepths[i] < 0, {
			distBeeMod[i] = distBeeNode[i] * paramsBee[i] * distBeeDepths[i];
		}, {
			distBeeMod[i] = distBeeNode[i] * paramsBeeLfto[i] * distBeeDepths[i];
		});
	});
	9.do({arg i;
		if(beeBeeDepths[i] < 0, {
			beeBeeMod[i] = beeBeeNode[i] * linlin(paramsBee[i], 0, 1, minsBee[i], maxsBee[i]) * beeBeeDepths[i];
		}, {
			beeBeeMod[i] = beeBeeNode[i] * linlin(paramsBeeLfto[i], 0, 1, minsBee[i], maxsBee[i]) * beeBeeDepths[i];
		});
	});
	9.do({arg i;
		if(tpBeeDepths[i] < 0, {
			tpBeeMod[i] = tpBeeNode[i] * linlin(paramsBee[i], 0, 1, minsBee[i], maxsBee[i]) * tpBeeDepths[i];
		}, {
			tpBeeMod[i] = tpBeeNode[i] * linlin(paramsBeeLfto[i], 0, 1, minsBee[i], maxsBee[i]) * tpBeeDepths[i];
		});
	});
	9.do({arg i;
		if(beeTpDepths[i] < 0, {
			beeTpMod[i] = beeTpNode[i] * linlin(paramsBee[i], 0, 1, minsBee[i], maxsBee[i]) * beeTpDepths[i];
		}, {
			beeTpMod[i] = beeTpNode[i] * linlin(paramsBeeLfto[i], 0, 1, minsBee[i], maxsBee[i]) * beeTpDepths[i];
		});
	});

	// beeBeeMod.postln;
	~beeCallBee.(callsBee, nBees, distToOthers, beeSynths);
	~beeCallTadpole.(callsTadpole, nBees, beeSynths);
	~respondsToTp.(respondsToTp, nBees, beeSynths);
	// ~tadpoleCallBee.(respondsTadpole, nBees, beeSynths);
	beeSynths.do({arg item, i;
		item.set(
			\xPos, xPos[i],
			\yPos, yPos[i],
			\wrapAmp, wrapAmps[i],
			\velocity, velocities[i],
			\forcefield, receivedForces[i],
			\amp, (0.9/nBees + 0.2) * (beeAmp + (distToOthers[i] * beeAmpModDepths[0] * beeAmpNode[0])),
			\beeParam1,(paramsBee[0] * masses[i]) + (distBeeMod[0] * distToOthers[i] * wrapAmps[i]),
			\beeParam2, paramsBee[1] + (distBeeMod[1] * distToOthers[i] * wrapAmps[i]),
			\beeParam3, paramsBee[2] + (distBeeMod[2] * distToOthers[i] * wrapAmps[i]),
			\beeParam4, paramsBee[3] + (distBeeMod[3] * distToOthers[i] * wrapAmps[i]),
			\beeParam5, paramsBee[4] + (distBeeMod[4] * distToOthers[i] * wrapAmps[i]),
			\beeParam6, paramsBee[5] + (distBeeMod[5] * distToOthers[i] * wrapAmps[i]),
			\beeParam7, paramsBee[6] + (distBeeMod[6] * distToOthers[i] * wrapAmps[i]) ,
			\beeParam8, paramsBee[7] + (distBeeMod[7] * distToOthers[i] * wrapAmps[i]),
			\beeParam9, paramsBee[8] + (distBeeMod[8] * distToOthers[i] * wrapAmps[i]),
			\beeBeeP1EnvDepth, beeBeeMod[0],
			\beeBeeP2EnvDepth, beeBeeMod[1],
			\beeBeeP3EnvDepth, beeBeeMod[2],
			\beeBeeP4EnvDepth, beeBeeMod[3],
			\beeBeeP5EnvDepth, beeBeeMod[4],
			\beeBeeP6EnvDepth, beeBeeMod[5],
			\beeBeeP7EnvDepth, beeBeeMod[6],
			\beeBeeP8EnvDepth, beeBeeMod[7],
			\beeBeeP9EnvDepth, beeBeeMod[8],
			\beeBeeAttack, interactionEnvPara[0],
			\beeBeeRelease, interactionEnvPara[1],
			\beeBeeAmpDepth, beeAmpModDepths[1] * beeAmpNode[1],
			\tpBeeP1EnvDepth, tpBeeMod[0],
			\tpBeeP2EnvDepth, tpBeeMod[1],
			\tpBeeP3EnvDepth, tpBeeMod[2],
			\tpBeeP4EnvDepth, tpBeeMod[3],
			\tpBeeP5EnvDepth, tpBeeMod[4],
			\tpBeeP6EnvDepth, tpBeeMod[5],
			\tpBeeP7EnvDepth, tpBeeMod[6],
			\tpBeeP8EnvDepth, tpBeeMod[7],
			\tpBeeP9EnvDepth, tpBeeMod[8],
			\tpBeeAttack, interactionEnvPara[2],
			\tpBeeRelease, interactionEnvPara[3],
			\tpBeeAmpDepth, beeAmpModDepths[2] * beeAmpNode[2],
			\beeTpP1EnvDepth, beeTpMod[0],
			\beeTpP2EnvDepth, beeTpMod[1],
			\beeTpP3EnvDepth, beeTpMod[2],
			\beeTpP4EnvDepth, beeTpMod[3],
			\beeTpP5EnvDepth, beeTpMod[4],
			\beeTpP6EnvDepth, beeTpMod[5],
			\beeTpP7EnvDepth, beeTpMod[6],
			\beeTpP8EnvDepth, beeTpMod[7],
			\beeTpP9EnvDepth, beeTpMod[8],
			\beeTpAttack, interactionEnvPara[4],
			\beeTpRelease, interactionEnvPara[5],
			\beeTpAmpDepth, beeAmpModDepths[3] * beeAmpNode[3],
			\minP1, minsBee[0], \maxP1, maxsBee[0],
			\minP2, minsBee[1], \maxP2, maxsBee[1],
			\minP3, minsBee[2], \maxP3, maxsBee[2],
			\minP4, minsBee[3], \maxP4, maxsBee[3],
			\minP5, minsBee[4], \maxP5, maxsBee[4],
			\minP6, minsBee[5], \maxP6, maxsBee[5],
			\minP7, minsBee[6], \maxP7, maxsBee[6],
			\minAmp, minAmp, \maxAmp, maxAmp;
		)
	});
}, "/beeData");
OSCdef(\beeCreated, {beeSynths.add(Synth(beeInstrument)); "beeCreated".postln}, "/beeCreated");
OSCdef(\beeDeleted, {arg msg; "1".postln; beeSynths.postln; ~beeRemoved.(msg[1]); ("bee" + msg[1].asString + "Deleted").postln}, "/beeDeleted");

//////////////////////////
/////HANDLE AGENT PRESENCE AND INTERACTIONS
//////////////////////////

~beeRemoved = {
	arg index;
	beeSynths[index].set(\gate, 0);
	beeSynths.removeAt(index);
};

~beeCallBee = {arg callsBee, nBees, distToOthers, beeSynths;
	callsBee.do({arg item, i;
		if(item) {
			// ("bee" ++ i.asString + "callsBee").postln;
			// beeCallBeeDepth.postln;
			beeSynths[i].set(\t_beeCallBeeTrig, 1);
		}
	})
};
~beeCallTadpole = {arg callsTadpole, nBees, beeSynths;
	callsTadpole.do({arg item, i;
		if(item) {
			("bee" ++ i.asString + "callsTadpole").postln;
			// beeCallTadpoleDepth.postln;
			beeSynths[i].set(\t_beeCallTpTrig, 1);
		}
	})
};
~respondsToTp = {arg respondsToTp, nBees, beeSynths;
	respondsToTp.do({arg item, i;
		if(item) {
			("bee" ++ i.asString + "responds to Tp").postln;
			// beeCallTadpoleDepth.postln;
			beeSynths[i].set(\t_tpCallBeeTrig, 1);
		}
	})
};

//////////////////////////
/////WRAPAMP FUNCTION
//////////////////////////

~calculateWrappingAmp = {
	arg angleCentre, distCentre, systemWindowRadius = 350, distGlobeHorizon = 175;
	var edgeFunction1, edgeFunction2, edgeFunction3, wrapAmp;
	edgeFunction1 = (Array.fill(systemWindowRadius, {arg i; ((-1/distGlobeHorizon) * ((i - distGlobeHorizon).pow(2))) + distGlobeHorizon }) ++ [0, 0, 0, 0]).normalize;
	edgeFunction2 = ([0, 0, 0, 0] ++ Array.fill(distGlobeHorizon, {arg i; ((1/distGlobeHorizon) * i) })).normalize;
	edgeFunction3 = (Array.fill(distGlobeHorizon, {arg i; ((1/(i+1))) }) ++ [0, 0, 0, 0]).reverse.normalize;
	if(distCentre > distGlobeHorizon, {
		wrapAmp = edgeFunction2[abs(systemWindowRadius - round(distCentre))];
	});
	if(distCentre <= distGlobeHorizon, {
		wrapAmp = 1;
	});
	wrapAmp;
}
)
