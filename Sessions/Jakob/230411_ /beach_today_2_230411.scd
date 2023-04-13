g.(\120)



(
Ndef(\gliss, {
	var sig;

						sig = 7000;
					sig = Line.ar(7000, 0.01, 40);
	Out.kr(202, sig);
}).play;
)


g.(\420)



Ndef(\420).fadeTime = 4;

(
Ndef(\420)[1] = \filter -> { |in, ffreq = 10|

	var snd, lfo;
	snd = in;
}
)
Synth(\snare, [\out, 120] ,target: 110, addAction: \addToHead);




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

TempoClock.default.tempo = 150/120;

x = Pn(Pdef(\git), inf).play;
(
Pdef(\git,
	Pbind(
		\instrument, \pluck,
		\amp, Prand([1, 0.9, 0.8, 0.7], 3) * 0.4 * Pseq([1, 0.9, 0.8, 0.7], 2),
		\dur, Pn(1/8, 14),
		\degree, Pseq([Pn(6, 16), Pn(7, 12), Pn(9, 2), Pn(7, 2)], 16) ,
		\degree, ~degdict.at(\misiRand).stutter(1) ,
		\degree, Pn(Pseq([0, 0, 0, 3], 8),16, \step) +  ~degdict.at(\pipe).stutter(4) ,
		\degree, Pn(0, 16),

		\degree, Pseq([0, 0, 7, 0], 16),

		\degree, 0,
				\degree, ~degdict.at(\misi).stutter(2) ,
		\pm, Pseq([1, 0, 0, 0], 16),
		\pm, 1,
		\pm,  Pbjorklund(3, 8, 16).stutter(2) ,
		\pm, Pseq([1, 0, 1, 0], 16) * Pbjorklund(3, 8, 16).stutter(2) ,
		\pm, 1,
		\pm, [1, 0],


				\root, 0,
		\octave, 4,
				\octave, Prand([4, 5], 16),
		\detune, Pwhite(0.0, 0.7, 16),
		\scale, Scale.chromatic,
		\release, 0.1,
		\out, 0,
)).quant = 4;


)


Pdef(\git).set(\root, 10)