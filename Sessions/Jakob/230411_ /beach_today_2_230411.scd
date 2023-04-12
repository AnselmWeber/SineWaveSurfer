g.(\120)




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

TempoClock.default.tempo = 60/60;
(
Pdef(\git,
	Pbind(
		\instrument, \pluck,
		\amp, Prand([1, 0.9, 0.8, 0.7], inf) * 0.1 * Pseq([1, 0.9, 0.8, 0.7], inf),
		\amp, (Pbjorklund(3, 8, inf).stutter(2) * 0.2) + 0.2,
		\amp, Prand([1, 0.9, 0.8, 0.7], inf) * 0.4 * Pseq([1, 0.9, 0.8, 0.7], inf),
		\dur, Pwhite(0.999, 1.001, inf) /8,
		\dur, 1/8,
		\degree, Prand([Pn(0, 2), Pn(1, 4), Pn(2, 4), Pn(3, 4), Pn(4, 4), Pn(5, 2), Pn(6, 4), Pn(7, 2)], inf) ,
		\degree, Pseq([Pn(6, 16), Pn(7, 12), Pn(9, 2), Pn(7, 2)], inf) ,

		\degree, ~degdict.at(\misiRand).stutter(1) ,
		\degree, Pn(Pseq([0, 0, 0, 3], 8),inf, \step) +  ~degdict.at(\pipe).stutter(4) ,
		\degree, Pn(0, inf),

		\degree, ~degdict.at(\misi).stutter(2) ,
		\degree, Pseq([0, 0, 7, 0], inf),
		\pm, Pseq([1, 0, 0, 0], inf),
		\pm, 1,
		\pm,  Pbjorklund(3, 8, inf).stutter(2) ,


		\pm, Pseq([1, 0, 1, 0], inf) * Pbjorklund(3, 8, inf).stutter(2) ,
		\pm, [1, 0],
		\root, Pgate(Pseq([0, 0, 1, 0, 0, 5, 4, 1]), inf, \step),
		\octave, Prand([4, 5], inf),
		\detune, Pwhite(0.0, 0.7, inf),
		\scale, Scale.chromatic,

//		Pn(,inf, \step),
		\release, 0.2,
		\group, 310,
		\out, 320,
)).quant = 4;

Pdef(\git).play;
)