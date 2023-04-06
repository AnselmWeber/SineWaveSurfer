(
Pdef(\bass, Pbind(
	\instrument, \surfbass,
	\amp, 0.25,
	\dur, 0.25,
	\degree, Pn(Pseq([0, 0, 2, 2, 4, 4, 5,4]), inf, \step),
	\octave, 3,
	\release, 0.25,
	\root, Pgate(Pseq([0, 0, 5, 5]), inf, \step),
	\out, 220,
	\group, 210
)).stop;
)


TempoClock.default.tempo = 75/60;
(
Pdef(\surfbass, Pbind(
	\instrument, \surfbass,
	\amp, Pseq([2, 1, 1, 1], inf) *0.25 * Prand([0.8, 0.9, 0.7, 0.6], inf) * Pwrand([0, 1], [1, 6].normalizeSum, inf),
	\dur, Pseq([1, 1, 1, 1], inf)/8,
	\scale, Scale.chromatic,

	\degree, Pseq([Pn(0, 4), Pn(3, 4), Pn(7, 4), Pn(3, 4)], inf) + Pseq([ Pn(0, 16), Pn(3, 16), Pn(6, 16), Pn(8, 16)], inf),

	\degree, Pseq([Pn(0, 4), Pn(3, 4), Pn(7, 4), Pn(3, 4)], inf) + Pseq([ Pn(0, 16), Pn(3, 16), Pn(6, 16), Pn(8, 16)], inf),
	\degree, Pn([0, 3, 7, 8], inf) + 0,
	\detune, Pwhite(-0.1, 0.1, inf),
	\octave, Pwrand([3, 4],[9, 1].normalizeSum, inf),
	\release, Prand([0.8, 0.9, 0.7, 0.6], inf) * 0.25,
	//\root, Pgate(Pseq([0, 0, 5, 5]), inf, \step),
	\out, 220,
	\group, 210,
	\addAction, \addToTail
)).play;
)


(
Pdef(\snare, Pbind(
	\instrument, \sn,
	\dur, Pseq([1, 1, 1, 1], inf)/4,
	\amp, Pseq([0, 0, 1, 1, 0, 0, 1, 0 ], inf) /2,
	//\degree, Pn(0, inf),
	//\detune, Pwhite(-0.1, 0.1, inf),
	//\octave, Pwrand([3, 5],[9, 1].normalizeSum, inf),
	\rel, Prand([0.8, 0.9, 0.7, 0.6], inf) * 0.1,
	\rFreq, Pwhite(1000, 2000, inf),
	//\root, Pgate(Pseq([0, 0, 5, 5]), inf, \step),
	\out, 320,
	\group, 310,
)).play;
)

(
Pdef(\kick, Pbind(
	\instrument, \kck,
	\dur, Pseq([1, 1, 1, 1], inf)/2,
	\dur, Pwrand([Pn(1, 2)/4, Pn(1, 1)/2], [1, 4].normalizeSum, inf),
	\dur, Pseq([1, 1, 1, 1], inf)/4,
	\amp, Pseq([1, 0, 0, 1, 1, 1, 0, 1], inf)/1,
	\freq, 60,
	\rel, Prand([0.8, 0.9], inf) * 0.1,
	//\root, Pgate(Pseq([0, 0, 5, 5]), inf, \step),
	\out, 120,
	\group, 110,
	\addAction, \addToTail
)).play;
)

(
Pdef(\kick_2, Pbind(
	\instrument, \kck,
	\dur, Pseq([1, 1, 1, 1], inf)/2,
	\dur, Pwrand([Pn(1, 2)/4, Pn(1, 1)/2], [1, 4].normalizeSum, inf),
	\dur, Pseq([1, 1, 1, 1], inf)/4,
	\amp, Pseq([0, 1, 1, 1, 0, 0, 0, 1], inf)/1,
	\freq, 100,
	\rel, Prand([0.8, 0.9], inf) * 0.03,
	//\root, Pgate(Pseq([0, 0, 5, 5]), inf, \step),
	\out, 120,
	\group, 110,
	\addAction, \addToTail
)).play;
)
s.plotTree

g.(\230);
(
Ndef(\230)[1] = \filter -> {|in, lfFreq = 2|
	var snd, lfo;
	snd = in;
	lfo = LFNoise2.ar(lfFreq).range(2, 5);
	snd = BPF.ar(snd,lfo * 100* [1, 2, 3, 4, 5, 6, 7, 8, 10, 13]);
	snd = Mix.ar(snd);
	snd = in;
};

)
Ndef(\230).fadeTime = 10;



g.(\240);
(
Ndef(\240)[1] = \filter -> {|in, lfFreq = 10|
	var snd, lfo;
	snd = in;
	lfo = LFNoise2.ar(lfFreq).range(1.0, 6.1);
	snd = BPF.ar(snd,lfo * 100* [1, 2, 3, 4, 5, 6, 7, 8, 10, 13]);
	snd = Splay.ar(snd/ 5);
	snd = in;
};
)

Ndef(\240).fadeTime = 20;



s.meter;
// g function mit name == slot

g.(\220);


// add some wonkey FX

Ndef(\220).fadeTime = 4;

(
Ndef(\220)[1] = \filter -> { |in, ffreq = 440|

	var snd, lfo;

	lfo = LFCub.kr([3, 8] * 0.5).range(0.5 , 2);

	snd = in * 100.0;
	snd = snd.tanh * 0.75;

	snd = MoogLadder.ar(in, lfo  * ffreq, 0.1);
	snd.tanh * 0.5;
}
)

// pset tryout

(
Ndef(\220)[10] = \pset -> Pbind(

	\dur, 0.25,
	\ffreq, Pwhite(100, 1500, inf)

)
)


// Jetzt ist momentan noch ein Problem:
// Wenn man den Ndef freet, muss man ihn danach wieder mit dem richtigen target out usw. abpielen
// Außerdem müsste dann auch wieder ein bus synth für die I/O erstellt wird
// Ist etwas umständlich, stadtdessen besser snd auf in setzten und es wird wieder nur durchgeschleust:

(
Ndef(\220)[1] = \filter -> { |in|

	var snd;

	snd = in * 100.0;
	snd = snd.tanh * 0.75;

	snd = MoogLadder.ar(in, LFCub.kr([3, 8] * 0.5).range(50, 1000), 0.1);
	snd.tanh * 0.5;
	snd = in;
}
)



