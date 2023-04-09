beach _ today

s.boot


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
)).play;
)

s.meter;
// g function mit name == slot

g.(\120);


// add some wonkey FX

Ndef(\120).fadeTime = 4;

(
Ndef(\120)[1] = \filter -> { |in, ffreq = 640|

	var snd, lfo;


	snd = in;
	snd = snd * SinOsc.ar(20) * 2;
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


0.005/0.3




(
SynthDef(\kick, {
    |out = 0, pan = 0, amp = 0.3, rel = 0.3|
    var body, bodyFreq, bodyAmp;
    var pop, popFreq, popAmp;
    var click, clickAmp;
    var snd;

    // body starts midrange, quickly drops down to low freqs, and trails off
    bodyFreq = EnvGen.ar(Env([261, 120, 51], [0.035, 0.08], curve: \exp));
    bodyAmp = EnvGen.ar(Env.linen(0.005, rel/3, rel), doneAction: 2);
	body = SinOsc.ar(bodyFreq ) / 2 * bodyAmp;
    // pop sweeps over the midrange
    popFreq = XLine.kr(750, 261, 0.02);
    popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
    pop = SinOsc.ar(popFreq) * popAmp;
    // click is spectrally rich, covering the high-freq range
    // you can use Formant, FM, noise, whatever
    clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
    click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = Mix.ar((body + pop + click));
    snd = snd.tanh;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

Synth(\kick);
)
(
~degdict = (
	\misi : Pseq([Pn(0, 3), Pn(2, 1), Pn(3, 2), Pn(5, 2), Pn(7, 3), Pn(8, 1), Pn(12, 2), Pn(8, 2), Pn(7, 16), Pn(8, 2), Pn(7, 1), Pn(8, 1) , Pn(7, 2), Pn(5, 2), Pn(7, 2), Pn(5, 1), Pn(7, 1), Pn(5, 2), Pn(4, 1) , Pn(0, 1), Pn(4, 16) , Pn(7, 2), Pn(5, 1), Pn(7, 1) , Pn(5, 2), Pn(4, 2), Pn(5, 2), Pn(4, 1), Pn(5, 1), Pn(4, 2), Pn(1, 2 ), Pn(0, 16) ], inf),
	\misiRand : Prand([Pn(0, 3), Pn(2, 1), Pn(3, 2), Pn(5, 2), Pn(7, 3), Pn(8, 1), Pn(12, 2), Pn(8, 2), Pn(7, 16), Pn(8, 2), Pn(7, 1), Pn(8, 1) , Pn(7, 2), Pn(5, 2), Pn(7, 2), Pn(5, 1), Pn(7, 1), Pn(5, 2), Pn(4, 1) , Pn(0, 1), Pn(4, 16) , Pn(7, 2), Pn(5, 1), Pn(7, 1) , Pn(5, 2), Pn(4, 2), Pn(5, 2), Pn(4, 1), Pn(5, 1), Pn(4, 2), Pn(1, 2 ), Pn(0, 16) ], inf),
	\misiFast : Pseq([Pn(0, 1), Pn(2, 1), Pn(3, 1), Pn(5, 1), Pn(7, 1), Pn(8, 1), Pn(12, 1), Pn(8, 1), Pn(7, 1), Pn(8,1), Pn(7, 1), Pn(8, 1) , Pn(7, 1), Pn(5, 1), Pn(7, 1), Pn(5, 1), Pn(7, 1), Pn(5, 1), Pn(4, 1) , Pn(0, 1), Pn(4, 1) , Pn(7, 1), Pn(5, 1), Pn(7, 1) , Pn(5, 1), Pn(4, 1), Pn(5, 1), Pn(4, 1), Pn(5, 1), Pn(4, 1), Pn(1, 1 ), Pn(0, 1) ], inf),
	\pipe :	Pseq([Pn(0, 4), Pn(3, 4), Pn(5, 4), Pn(3, 2), Pn(5, 2), Pn(7, 2), Pn(5, 2), Pn(3, 2),  Pn(5, 4),  Pn(7, 4),  Pn(5, 2),  Pn(7, 4),  Pn(5, 4),  Pn(3, 2),  Pn(5, 2),  Pn(3, 2),  Pn(0, 8)], inf),
		\pipeRand :	Prand([Pn(0, 4), Pn(3, 4), Pn(5, 4), Pn(3, 2), Pn(5, 2), Pn(7, 2), Pn(5, 2), Pn(3, 2),  Pn(5, 4),  Pn(7, 4),  Pn(5, 2),  Pn(7, 4),  Pn(5, 4),  Pn(3, 2),  Pn(5, 2),  Pn(3, 2),  Pn(0, 4)], inf),
	\bridge : Pseq([Pn(6, 16), Pn(7, 12), Pn(9, 2), Pn(7, 2)], inf),
)
)

TempoClock.default.tempo = 150/60;
(
Pdef(\git,
	Pbind(
		\instrument, \pluck,
		\amp, Prand([1, 0.9, 0.8, 0.7], inf) * 0.9 * Pseq([1, 0.9, 0.8, 0.7], inf),
		\dur, Pwhite(0.999, 1.001, inf) /4,
		\pm, Pseq([0, 1, 1, 1], inf) ,
		\pm, 1 - Pbjorklund(3, 8, inf),
		\root, 4,
		\octave, 4,
		\detune, Pwhite(0.0, 0.7, inf),
		\scale, Scale.chromatic,
		\degree, Prand([Pn(0, 2), Pn(1, 4), Pn(2, 4), Pn(3, 4), Pn(4, 4), Pn(5, 2), Pn(6, 4), Pn(7, 2)], inf) ,
		\degree, Pseq([Pn(6, 16), Pn(7, 12), Pn(9, 2), Pn(7, 2)], inf) ,
		\degree, Pn(0, inf),
		\degree, ~degdict.at(\pipe),
)).quant = 4;

Pdef(\git).play;
)

Pbjorklund

TempoClock.default.tempo = 120/60;


(
Pdef(\kick, Pbind(
	\instrument, \kick,
	\freq, 70,
	\amp,  0.8,
	\amp, Pseq([Pseq([1, 0, 0, 0], 1), Pseq([1, 1, 0, 0], 1)], inf) * 0.2,
	\dur, Pwrand([Pn( 0.5, 4), Pn(0.125, 16)], [6, 1].normalizeSum , inf),
	\dur, 1/2,
	\release,  Pseq([1, 0, 0, 1], inf) * 0.81,
	\out, 0,
)).quant = 4;

Pdef(\kick).play;
)


TempoClock.default.tempo = 120/60

(
~snaredict = (
	\streightDur : Pwhite(0.999, 1.001, inf) /4,
	\streightAmp : Pseq([0, 0, 0.3, 1, 0, 0, 1, 0],   inf) * 0.6,
	\breakDur: Pwhite(0.994, 1.006, inf) /8,
	\breakAmp : Pseq([Pwhite(2, 1, 1), 1, 1, 1, Pwhite(2, 1, 1), 1, 1, 1],   inf)/4 * Pwhite(0.3, 0.5, inf),
	\sndFreq : Pwhite(600, 630, inf)
)
)
(
Pdef(\snare, Pbind(
	\instrument, \snare,
	\amp, Pwrand([Pseq([0, 0, 1, 1 ], 1), Pseq([0, 1, 0, 1], 1)], [4, 1].normalizeSum,  inf) * 0.6,
	\amp, Pseq([0, 0, 1, 1, 0, 0, 1, 0],   inf) * 0.6,
	\amp, Pseq([3, 1, 1, 1, 3, 1, 1, 1],   inf) * 0.2,
	\amp, ~snaredict.at(	\streightAmp),
	\sndFreq,~snaredict.at(\sndFreq),
	\filFreq, Prand([Pn(500, 1), Pn(700, 2), Pn(1100, 1), Pn(700, 1)], inf) + Pwhite(100, 300, inf),
	\dur, ~snaredict.at(\streightDur)*2,
	\delSpread, Pwhite(0.2, 2),
	\rel, ~snaredict.at(\streightDur),

)).quant = 4;

Pdef(\snare).play;
)






(
Pdef(\ride, Pbind(
	\instrument, \jride,
	\amp, Prand([1, 0.9, 0.8, 0.7], inf) * 0.1 * Pseq([1, 0.9, 0.8, 0.7], inf) ,
	\dur,~snaredict.at(\streightDur)*2,
	\freq, Pseq([Pn(1800, 8), Pn(2000, 8), Pn(2400, 8), Pn(1000, 8)], inf),
	\freq, Pwhite(1900, 2000, inf) * [0.5, 0.6, 1],
	\release, Pwhite(0.3, 0.5, inf),
	\out, 0,
)).play;
)