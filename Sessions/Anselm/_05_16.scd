Server Guide

// on machine running the server
(
s.options.memSize_(65536 * 4);
s.options.protocol = \tcp; // set to use tcp
s.options.bindAddress = "0.0.0.0"; // allow connections from any address
s.options.maxLogins = 4; // set to correct number of clients
s.boot;
)


s.meter;


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


// Start
// sample raussuchen / schneiden

// Drums vorproduzieren
// Setup als Routine / oneClick Setup
// 