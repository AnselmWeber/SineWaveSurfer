(
Ndef(\glis, {

	var snd;

	Out.kr(202, DC.kr(0));
	//Out.kr(202, XLine.kr(5000, 1, 32));

	0.0

}).play(group: 210, addAction: \addToHead);
)

Ndef(\glis).fadeTime = 16;

TempoClock.default.tempo = 120 / 60;


(
~x = {
	//Out.kr(201, DC.kr(5000));
	//Out.kr(201, XLine.kr(5000, 1, 32).poll);

}.play(target: 210, addAction: \addToHead);
)

s.latency = 1.0;

g.(\220);

Ndef(\220).quant = 1;
Ndef(\220).fadeTime = 2;

(
Ndef(\220)[1] = \filter -> { |in, freq = 940, room = 1.0|

	var snd, lfo, hsnd;

	lfo = LFSaw.kr([2, 3] * 2).range(0.5, 2.0);

	snd = in * 100;

	snd = MoogFF.ar(snd, freq.lag(0.1), 2.5);
	snd = MoogLadder.ar(snd, freq.lag(0.05) * 1 * lfo, 1.1).tanh * 0.9;

	//snd = Resonator.ar(snd, freq, 0.001, 24, 1.0) + snd * 0.5;

	hsnd = HPF.ar(snd, 1500);
	hsnd = JPverb.ar(snd, room, 0, 0.1);

	//hsnd = Compander.ar(hsnd, In.ar(~sck, 2) * 2, 0.2, 1.0, 0.01, 0.01);

	snd = snd + hsnd * 0.3;
	snd.tanh * 0.9;

}
)

(
Ndef(\220)[10] = \pset -> Pbind(

	\dur, 0.125,
	\freq, Prand([1000, 100, 500, 500, 500, 500] * 1, inf),
	\room, Pseq([100, 1.0, 100, 0.1], inf)

);
)

g.(\120);

(
Ndef(\120)[1] = \filter -> {|in, freq = 800|

	var snd, lfo, hsnd;

	snd = in;

	lfo = LFPulse.ar(8).range(10, 1).lag(0.1) * LFPulse.kr(8, 0.5);

	snd = snd * 20;

	snd = MoogLadder.ar(snd, freq.lag(0.05) * 1, 1.0);

	hsnd = Resonator.ar(snd * 0.25, freq * LFNoise1.ar(0.1).range(0.25, 2.5), 0.001, 24, 0.1, 1.0);
	//snd = JPverb.ar(hsnd, 1.0, 0, 0.1) + snd;

	snd.tanh * 0.7;

}
)

(
Ndef(\120)[10] = \pset -> Pbind(

	\dur, 0.25,
	\freq, Pseq([2000, 50, 500, 800, 100] * 1, inf),

)
)





s.plotTree;



s.meter(0,2);


~x.free;

P