// Out Synths / Ndefs + proto Ndef für die g function
(
~setup = {

	var size, subSize, name, last_subId;

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
s.options.memSize_(65536 * 8);

//s.options.protocol = \tcp; // set to use tcp
//s.options.bindAddress = "0.0.0.0"; // allow connections from any address
//s.options.maxLogins = 4; // set to correct number of clients

s.latency = 0.1;


s.waitForBoot {

	"synths.scd".loadRelative;

	s.sync;

	//~setup.();
	ServerTree.add(~setup, s);


};
)

().play;

~m.set(\dist, 2);

Synth(\kck)

s.meter(0,2);
s.scope;























