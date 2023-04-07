(
Pdef(\k, {

	Pbind(
		\instrument, \kck,
		\rel, 0.5,
		\octave, 3,
		\dur, Pseq([1.0, 1.5, 0.5, 1.0] * 4.0, inf),
		\hmul, Pwhite(6, 8, inf),
		\amp, 0.45,
		\group, 110,
		\out, 120,

	)

}).quant = 1;
)

Pdef(\k).play;

(
Pdef(\snare, {

	Pbind(
		\instrument, \sn,
		\rel, Pwhite(0.001, 0.1, inf),
		\octave, 3,
		\dur, Pseq([1.5, 0.125, 0.125, 0.125, 0.125, 1.0, 1.0, 2.0]*  1/3, inf),
		//\dur, 0.25,
		\amp, 0.4,
		\group, 110,
		\out, 120,
	)

}).quant = 1;
)

Pdef(\snare).play;
Pdef(\snare).play;
Pdef(\b).stop;



Pdef(\k).quant = 1;

(
Pdef(\b, {

	Pbind(
		\instrument, \surfbass,
		//\release, Pwhite(0.1, 0.3, inf),
		\relase, 2.0,
		\octave, 3,
		\degree, Pseq([0, 1,  5, 0], inf),
		\scale, Scale.chromatic,
		\dur, 2.0,
		\amp, 0.9,
		\group, 210,
		\out, 220,
	)

}).quant = 1;

Pdef(\b).play;
)

TempoClock.default.tempo = 180 / 120;


g.(\220);

Ndef(\220).fadeTime = 2;
Ndef(\220).quant = 1;

(
Ndef(\220)[1] = \filter -> {|in, freq = 440, size = 5.0|

	var snd, lfo;

	lfo = LFCub.ar([2, 3] * 3).range(1.0, 2.0);

	snd = in * 1000;
	snd = JPverb.ar(HPF.ar(snd, 1500), size, 0, 0.1) + snd * 0.7;
	snd = Compander.ar(snd, In.ar(~sck, 4) * 2, 0.2, 1.0, 0.1, 0.001);
	snd = MoogFF.ar(snd, freq.lag(0.1) * lfo, 2.5);
	snd = MoogLadder.ar(snd, freq.lag(0.1) * 6, 1.0).tanh * 0.6;
	snd = RHPF.ar(snd, 100);


	//snd = Compander.ar(snd)

}
)

(
Ndef(\220)[10] = \pset -> Pbind(

	\dur, 0.5,
	\freq, Pseq([1000, 500, 500, 700, 1900] * 0.5, inf),
	\size, Pwhite(0.1, 100.0, inf)
)
)


(
SynthDef(\master, { |wetlevel = -0.85, dist = 1, hidb = 5.0|

	var snd, wet, in;

	in  = In.ar(0, 2);
	snd = in * 1.1;

	snd = snd * dist;

	snd = BHiShelf.ar(snd, 1200, 1.0, hidb);

	snd = DCompressor.ar(snd, 0, 0, 40, -20, 0.001, 100, 2).tanh * 0.9;

	wet = NHHall.ar(snd, 2.0, 1.0, 400, 0.5);
	//wet = GVerb.ar(wet, 2, 0.1, 0.5, 0.5, 15, 1.0);
	wet = HPF.ar(wet, 400);

	snd = XFade2.ar(snd, wet, wetlevel);

	ReplaceOut.ar(0, snd.clip(-1, 1) * 0.9);

}).add;
)

~m = Synth(\master, addAction: \addToTail);
~m.set(\dist, 100);

~m.set(\hidb, 5);
~m.free;
s.meter;


s.record;

// bass release, dur koppeln !
s.meter;