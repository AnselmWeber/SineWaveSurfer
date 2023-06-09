// Out Synths / Ndefs + proto Ndef für die g function
(
//s.options.memSize_(65536 * 4);
//s.options.protocol = \tcp; // set to use tcp
//s.options.bindAddress = "0.0.0.0"; // allow connections from any address
//s.options.maxLogins = 4; // set to correct number of clients

s.latency = 1.0;


s.waitForBoot {
	var size, subSize, name, last_subId;
	"_synths.scd".loadRelative;

	s.sync;


	~check_list = List.new;
	~check = {|name, fun|

		var break = false;

		~check_list.do{|item ,i|
			if(item == name, {
				item.postln;
				break = true;
				"break !".postln;
			});
		};

		if(break == false, {
			"added !".postln;
			fun.();
			~check_list.add(name);

		})
	};



	//make group


	size = 7;
	subSize = 6;

	~gr = Array.fill(size, { |i|

		var id;

		id = (size * 100) -  (i * 100);

		e = Group.basicNew(0,  id);
		s.sendBundle(nil, e.newMsg(0));
		Bus.new('audio', id, 2, s);

		~subGr = Array.fill(subSize, { |j|

			var subId;

			subId = (subSize * 10) -  (j * 10) + id;

			g = Group.basicNew(id,  subId);
			//Synth(\p_out, [\out, subId + 10, \in, subId], target:subId, addAction:\addToTail);

			s.sendBundle(nil, g.newMsg(id));
		});

		~subSy = Array.fill(subSize, { |j|

			var subId;

			subId = (subSize * 10) -  (j * 10) + id;

			//g = Group.basicNew(id,  subId);
			if(j < (subSize - 1), {

				Synth(\p_out, [\out, subId + 10, \in, subId ], target:subId, addAction:\addToTail);
			});

			last_subId = subId;

		});

		name = \p_out ++ id.asString;
		Ndef(\p_out).copy(name);

		Ndef(name).set(\in, size * 10 + id);

		["_in :  " ++ (size * 10 + id)].postln;
		Ndef(name).play(0, 2, id);


	});

	a = (
		\110:  110,
		\120:  120,
		\130:  130,
		\140:  140,
		\150: 150,
		\160: 160,

		\210:  210,
		\220:  220,
		\230:  230,
		\240:  240,
		\250: 250,
		\260: 260,

		\310: 310,
		\320:  320,
		\330:  330,
		\340:  340,
		\350: 350,
		\360: 360,

		\410: 410,
		\420:  420,
		\430:  430,
		\440:  440,
		\450: 450,
		\460: 460,

		\510: 510,
		\520:  520,
		\530:  530,
		\540:  540,
		\550: 550,
		\560: 560,
	);

	// Neue g function mit safety check !

	g = { | name |

		var target, inbus, outbus, addfun;

		addfun = {
			target = a.at(name);
			inbus = a.at(name);
			outbus = a.at(name) + 10;

			["in: " ++ inbus].postln;
			["out: " ++ outbus].postln;
			["name: " ++ name].postln;

			Ndef(\proto).copy(name);
			// Aufbau der play function;
			//.play(out, numChannels, group, multi: false, vol, fadeTime, addAction)
			Ndef(name).play(outbus, 2, target, addAction: \addReplace);
			Ndef(name).set(\inbus, inbus);
		};

		~check.(name, addfun);
	};


	// r function wird nicht mehr benötgt
	// p + f  brauchen wir eigentlich auch nicht mehr oder ?

	/*
	p = {|name, args|

	var node, id;
	id = a.at(name) + 1;
	node = id.asNodeID;
	args.do({ |item, i|

	if(i % 2 == 0, {
	s.sendMsg(\n_set, node, item, args[i + 1]);
	});

	});

	};

	f = {|name|

	var node, id;

	id = a.at(name) + 1;

	node = id.asNodeID;

	s.sendMsg(\n_free, node);
	};
	*/
	~m = Synth(\master, addAction: \addToTail);
	s.plotTree
};
)


~trySub = { |array, find, replace|
	try {
		~inPlaceSub.(array, find, replace)
	} { |error|
		switch(error.species.name)
		{ 'PrimitiveFailedError' } {
			if(error.what.find("immutable").notNil) {
				"caught ImmutableError".postln;
				~inPlaceSub.(array.copy, find, replace)
			} { "unknown primitive exception".postln; error.throw; }
		}
		// default case: unhandled exception, should die so re-throw error
		{ "unknown exception".postln; error.throw; }
	};
};



(
Pdef(\ba, Pbind(
	\instrument, \surfbass,
	\amp, 0.1,
	\dur, Pseq([0.25] * 0.5, inf),
	\degree, Pn(Pseq([0, 0, 3, 0, 0, 0, 5, 0, 0] + 0), inf, \step),
	\octave, Prand([3, 4], inf),
	\release, Pseq([0.2, 0.09, 0.09] * 0.7, inf),
	\root, Pgate(Pseq([1, 1, 1, 0, 0, 1, 0, 0] + 0), inf, \step),
	\out, 220,
	\scale, Scale.minor,
	\group, 210,
	\cutoff, 10
)).play;
)


(
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



~x.set(\wetlevel, -0.8);
~x.free;

s.meter;

Shelf





Gverb



s.meter;

























