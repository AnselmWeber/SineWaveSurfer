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



