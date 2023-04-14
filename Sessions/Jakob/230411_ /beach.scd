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







(
~degdict = (
	\misi : Pseq([Pn(0, 3), Pn(2, 1), Pn(3, 2), Pn(5, 2), Pn(7, 3), Pn(8, 1), Pn(12, 2), Pn(8, 2), Pn(7, 16), Pn(8, 2), Pn(7, 1), Pn(8, 1) , Pn(7, 2), Pn(5, 2), Pn(7, 2), Pn(5, 1), Pn(7, 1), Pn(5, 2), Pn(4, 1) , Pn(0, 1), Pn(4, 16) , Pn(7, 2), Pn(5, 1), Pn(7, 1) , Pn(5, 2), Pn(4, 2), Pn(5, 2), Pn(4, 1), Pn(5, 1), Pn(4, 2), Pn(1, 2 ), Pn(0, 16) ], inf),
	\misiRand : Prand([Pn(0, 3), Pn(2, 1), Pn(3, 2), Pn(5, 2), Pn(7, 3), Pn(8, 1), Pn(12, 2), Pn(8, 2), Pn(7, 16), Pn(8, 2), Pn(7, 1), Pn(8, 1) , Pn(7, 2), Pn(5, 2), Pn(7, 2), Pn(5, 1), Pn(7, 1), Pn(5, 2), Pn(4, 1) , Pn(0, 1), Pn(4, 16) , Pn(7, 2), Pn(5, 1), Pn(7, 1) , Pn(5, 2), Pn(4, 2), Pn(5, 2), Pn(4, 1), Pn(5, 1), Pn(4, 2), Pn(1, 2 ), Pn(0, 16) ], inf),
	\misiFast : Pseq([Pn(0, 1), Pn(2, 1), Pn(3, 1), Pn(5, 1), Pn(7, 1), Pn(8, 1), Pn(12, 1), Pn(8, 1), Pn(7, 1), Pn(8,1), Pn(7, 1), Pn(8, 1) , Pn(7, 1), Pn(5, 1), Pn(7, 1), Pn(5, 1), Pn(7, 1), Pn(5, 1), Pn(4, 1) , Pn(0, 1), Pn(4, 1) , Pn(7, 1), Pn(5, 1), Pn(7, 1) , Pn(5, 1), Pn(4, 1), Pn(5, 1), Pn(4, 1), Pn(5, 1), Pn(4, 1), Pn(1, 1 ), Pn(0, 1) ], inf),
	\pipe :	Pseq([Pn(0, 4), Pn(3, 4), Pn(5, 4), Pn(3, 2), Pn(5, 2), Pn(7, 2), Pn(5, 2), Pn(3, 2),  Pn(5, 4),  Pn(7, 4),  Pn(5, 2),  Pn(7, 4),  Pn(5, 4),  Pn(3, 2),  Pn(5, 2),  Pn(3, 2),  Pn(0, 18)], inf),
		\pipeRand :	Prand([Pn(0, 4), Pn(3, 4), Pn(5, 4), Pn(3, 2), Pn(5, 2), Pn(7, 2), Pn(5, 2), Pn(3, 2),  Pn(5, 4),  Pn(7, 4),  Pn(5, 2),  Pn(7, 4),  Pn(5, 4),  Pn(3, 2),  Pn(5, 2),  Pn(3, 2),  Pn(0, 4)], inf),
	\bridge : Pseq([Pn(6, 16), Pn(7, 12), Pn(9, 2), Pn(7, 2)], inf),
)
)

TempoClock.default.tempo = 70/60;
(
Pdef(\git,
	Pbind(
		\instrument, \pluck,
		\amp, Prand([1, 0.9, 0.8, 0.7], inf) * 0.6 * Pseq([1, 0.9, 0.8, 0.7], inf),
		\amp, Pseq([0.4, 1], inf) * 0.6,
		\dur, Pwhite(0.999, 1.001, inf) /8,
		\degree, Prand([Pn(0, 2), Pn(1, 4), Pn(2, 4), Pn(3, 4), Pn(4, 4), Pn(5, 2), Pn(6, 4), Pn(7, 2)], inf) ,
		\degree, Pseq([Pn(6, 16), Pn(7, 12), Pn(9, 2), Pn(7, 2)], inf) ,
		\degree, Pn(0, inf),
		\degree, ~degdict.at(\misiRand).stutter(1) ,
		\degree, Pseq([0, 7, 0, 3], inf).stutter(3),
		\pm, Pseq([1, 0, 1, 0], inf) * Pbjorklund(3, 8, inf).stutter(2) ,
		\pm, Pseq([1, 0, 0, 0], inf),
		\pm,  Pbjorklund(3, 8, inf).stutter(2) ,
		\pm, [1,0],
		\root, Pfunc { ~lb[\root] },
		\octave, 4,
		\detune, Pwhite(0.0, 0.7, inf),
		\scale, Scale.chromatic,

//		Pn(,inf, \step),
		\release, 0.4,
)).quant = 4;

Pdef(\git).stop;
)