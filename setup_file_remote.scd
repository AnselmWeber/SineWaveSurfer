// on remote machine connecting to server
(
o = ServerOptions.new;
o.protocol_(\tcp);
s = Server.remote(\remote, NetAddr("172.20.10.7", 57110), o); // set to correct address and port
s.addr.connect;
s.startAliveThread( 0 );
s.doWhenBooted({ "remote tcp server started".postln; s.notify; s.initTree });
Server.default = s;
)


// Out Synths / Ndefs + proto Ndef für die g function
(
~check_list = List.new;

~check_list.add(\test);

~check = {|name, fun|

	~check_list.do{|item ,i|
	if(item != name, {
			fun.()
		});
};
};

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
)



(
//make group
var size, subSize, name, last_subId;

size = 7;
subSize = 6;





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

// Neue g function mit slot der als name verwendet wird

g = { | name |

	var target, inbus, outbus, addfun;

	// safety !
	//~index = ~index + 1;
	//name = name ++ ~index.asString;

	target = a.at(name);
	inbus = a.at(name);
	outbus = a.at(name) + 10;

	Ndef(\proto).copy(name);


	// debug
	["in: " ++ inbus].postln;
	["out: " ++ outbus].postln;
	["name: " ++ name].postln;

	// Aufbau der play function;
	//.play(out, numChannels, group, multi: false, vol, fadeTime, addAction)


	addfun = {
		Ndef(name).play(outbus, 2, target, addAction: \addReplace);
		Ndef(name).set(\inbus, inbus);
	};

	~check.(name, addfun);

	~check_list.add(name);

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

s.plotTree
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


