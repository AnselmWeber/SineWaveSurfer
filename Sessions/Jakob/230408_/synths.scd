(
~s0 = Buffer.read(s, "/Users/anselmweber/Desktop/SineWaveSurfer/Sessions/Anselm/Tremolo.wav");


SynthDef(\p_out, { |out = 0, in = 0|
	var snd;
	snd = In.ar(in, 2);
	ReplaceOut.ar(out, snd);
}).add;


Ndef(\p_out, { |in|

	In.ar(in, 2);

});


Ndef(\proto, { |inbus|

	In.ar(inbus, 2);

});

SynthDef(\sp, { |start = 0, end = 44100, index = 0, rate = 1.0, rel = 1.0, amp = 0.5, dist = 1, out = 0|

	var snd, phase, rd_0, rd_1, env;

	env = EnvGen.ar(Env([1, 1, 1], [0.001, rel]),doneAction: 2);

	start = 1 * 44100;
	end = BufFrames.kr(~s0);

	phase = Phasor.ar(0, rate, start, end);
	//phase = LFCub.ar(rate).range(start, end);

	snd = BufRd.ar(2, ~s0, phase).sum.dup;
	//rd_1 = BufRd.ar(2, ~s1, phase).sum.dup;

	//snd = Select.ar(index, [rd_0, rd_1]) * env;
	snd = Splay.ar(snd.scramble);
	snd = (snd * 2).tanh * 0.5;

	Out.ar(out, snd * amp);
}).add;


~sck = Bus.audio(s, 2);

SynthDef(\kck, {|out = 200, amp = 0.4, freq = 60, att = 0.01, rel = 0.4, hmul = 4|
	var snd, env;
	snd  = SinOsc.ar(freq * XLine.kr(hmul, 1, att * 4) * [1, 1.01], 0.4);
	env = EnvGen.ar(Env.perc(att, rel), doneAction:2);
	Out.ar(~sck, snd * env);
	Out.ar(out, snd * env * amp);

}).add;

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

//freq line deleted
SynthDef(\surfbass, { |freq = 50, in, out = 0, release = 0.5, amp = 0.2, cutoff = 4|

	var snd, trig, env;

	env = EnvGen.ar(Env([0, 1, 0], [0.0001, release]), doneAction: 2);
	trig = Line.ar(-1, 1, 1 / 44100);
	freq = freq + In.kr(202);
	freq = freq.lag(1) * [1, 1.01] ;

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





SynthDef(\jride, { arg out=0, gate=1, amp=0.1, pan=0, freq=300, rel = 1, att = 0.01;
	var sig;
	sig = SinOsc.ar(freq * [0.5, 0.51, 1,1.01, 1.03]) * 20;
	sig = Pan2.ar(sig, pan, amp);
	sig = ( WhiteNoise.ar(0.3) + 0.1 ) * LFSaw.ar({ exprand(2500, 2600) }!10 * ( 1 + ( SinOsc.ar((1..4).rand(0.0)/18 * XLine.kr(1,21200,80)) * 1/41 * XLine.kr(1,0.1,60) )));
	sig = BRF.ar(
		sig,
		{ ( exprand(9000,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.1,0.2) * LFNoise1.ar(1/100).range(1,2) ).clip(0.01,0.3) }!10
	);
	sig = sig + BPF.ar(sig, freq * [1,1.01, 1.03] * [0.5, 1, 2, 2.01, 3, 3.01, 4, 4.01], 0.001, 50);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 12000 * XLine.kr(1,1/100,4));
	sig = sig * 5 * 3;
	sig = sig.mean;
	sig = BPF.ar(sig, 2000 * [1, 2, 3, 5]) * [1, 0.7, 1, 0.7];
	sig = Limiter.ar(sig, 1);
	sig = sig * EnvGen.ar(Env.perc(att, rel), doneAction:2);
	sig = sig * amp;
	sig = Splay.ar(sig);
	Out.ar(out, sig);
}).add;

SynthDef(\sn, {|out = 0, amp = 0.7, att = 0.01,rel = 0.6, wn = 0.9, rFreq = 500|
	var snd, env;
	snd = WhiteNoise.ar();
	env = EnvGen.ar(Env.xyc([[0,0, -2],[att* 0.3,1,-2],[att* 0.6,0.6,-2],[att* 0.8,1,-2],[att* 0.3,0.4,-2],[0.07,0.2,-2], [rel,0,-2],]), doneAction:2);
	snd = RLPF.ar(snd, [1, 2, 3, 4, 5] * rFreq);
	snd = Splay.ar(snd);
	Out.ar(out, snd * env * amp);
}).add;



SynthDef(\snare, {
    |out = 0, pan = 0, amp = 0.3, popRatio = 4, filFreq = 1410, att = 0.001, rel = 0.15, sndFreq = 410, delSpread = 1|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    popFreq = EnvGen.ar(Env([ filFreq * popRatio, sndFreq, sndFreq /3], [0.005, rel * 0.02], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, rel * 0.6)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    noiseAmp = EnvGen.ar(Env.perc(0.001, rel), doneAction: 2) * 0.3;
	noise = BPF.ar(WhiteNoise.ar  * LFNoise1.ar(190).range(0.5, 1), filFreq, 1.6) * noiseAmp;
	noise = (noise * 10).tanh * 0.4;
    snd = (pop + noise) * 1.3;
	snd = snd + DelayC.ar(snd, 0.1, LFNoise0.kr().range(0.1, 1)*[0.01, 0.003, 0.02] * delSpread);
	snd = Mix.ar(snd/3);
    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;


SynthDef(\master, { |wetlevel = -0.8, dist = 2|

	var snd, wet, in;

	in  = In.ar(0, 2);
	snd = in;

	snd = BHiShelf.ar(snd, 1200, 1.0, 6.0);

	snd = DCompressor.ar(snd, 0, 0, 40, -20, 0.001, 100, 2).tanh * 0.9;

	wet = NHHall.ar(snd, 2.0, 1.0, 400, 0.5);
	//wet = GVerb.ar(wet, 2, 0.1, 0.5, 0.5, 15, 1.0);
	wet = HPF.ar(wet, 400);

	snd = XFade2.ar(snd, wet, wetlevel);

	ReplaceOut.ar(0, snd.clip(-1, 1));

}).add;
)



