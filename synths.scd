
s.options.memSize_(65536 * 4);
s.boot;

(
~s0 = Buffer.read(s,"/Users/anselmweber/Downloads/Savegames/Dick Dale & The Del Tones ＂Misirlou＂ 1963.wav");
~s1 = Buffer.read(s, "/Users/anselmweber/Downloads/Savegames/Surfaris - Wipe Out.wav");

// sideChain for kick
~sck = Bus.audio(s, 2);

~b_arr = [~s0, ~s1];


p = (
	\dRoll: [\index, 1, \start, 10, \end, 12],
	\woo: [\index, 1, \start, 3.0, \end, 5.1],
	\trem: [\index, 0, \start, 3.0, \end, 6.0]
);
)

(
SynthDef(\sp, { |start = 0, end = 44100, index = 0, rate = 1.0, rel = 1.0, amp = 0.5, dist = 1, out = 0|

	var snd, phase, rd_0, rd_1, env;

	env = EnvGen.ar(Env([0, 1, 0], [0.001, rel]),doneAction: 2);

	start = start * 44100;
	end = end * 44100;

	phase = Phasor.ar(0, rate, start, end);

	rd_0 = BufRd.ar(2, ~s0, phase).sum.dup;
	rd_1 = BufRd.ar(2, ~s1, phase).sum.dup;

	snd = Select.ar(index, [rd_0, rd_1]) * env;
	snd = (snd * dist).tanh * 0.5;

	Out.ar(out, snd * amp);
}).add;


SynthDef(\kck, {|out = 200, amp = 0.4, freq = 60, att = 0.01, rel = 0.4, hmul = 4|
	var snd, env;
	snd  = SinOsc.ar(freq * XLine.kr(hmul, 1, att * 4) * [1, 1.01], 0.4);
	env = EnvGen.ar(Env.perc(att, rel), doneAction:2);
	Out.ar(~sck, snd * env);
	Out.ar(out, snd * env * amp);

}).add;

SynthDef(\surfbass, { |freq = 50, in, out = 0, release = 0.5, amp = 0.2, cutoff = 4|

	var snd, trig, env;

	env = EnvGen.ar(Env([0, 1, 0], [0.0001, release]), doneAction: 2);
	trig = Line.ar(-1, 1, 1 / 44100);
	freq = freq.lag(1) * [1, 1.01];

	snd = Pluck.ar(WhiteNoise.ar(0.1), trig, 0.2, 1 / freq, release * 0.5, 0.5);
	snd = Blip.ar(freq, 6, Decay2.ar(trig, 0.0001, 0.01) * 0.1) + snd;

	snd = MoogLadder.ar(snd * 10, freq * cutoff).tanh * 0.9;
	snd = LeakDC.ar(snd) * env;

	Out.ar(out, snd * amp);

}).add;

SynthDef(\pluck, { |freq = 440, in, out = 0, release = 1.0, amp = 1.0, dist = 10, pm = 0|

	var snd, env, trig, chord, muted, envmute, vib;

	vib = SinOsc.ar(16).range(0.99, 1.01);

	chord = freq * [0.5, 1.5, 1, 2.0];

	chord = freq;
	env =  EnvGen.ar(Env([0, 1, 0], [0.0001, release]), doneAction: 2);
	envmute = EnvGen.ar(Env([0, 1, 0], [0.0001, release * 0.2]));

	env = Select.ar(pm, [env, envmute]);

	trig = Line.ar(-1, 1, 1 / 44100);
	//trig = Impulse.ar(10);
	snd = Pluck.ar(WhiteNoise.ar(1.0) ,trig, 0.04, 1 / (chord * [1, 1.01] * vib), release, 0.7);
	//snd = CombC.ar(snd, 0.125, 1 / freq, release);
	//snd = DelayL.ar(snd, 0.5, [0.0, 0.25, 0.5, 1.0] * 0.25);
	snd = Splay.ar(snd.scramble);

	snd = (snd * dist).tanh * 0.85;

	muted = MoogFF.ar(snd * 10, freq * 3, 2.5).tanh;

	snd = Select.ar(pm, [snd, muted]);

	snd = LeakDC.ar(snd);

	snd = snd * env;

	Out.ar(out, snd * amp)

}).add;
)




