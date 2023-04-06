

(
Ndef(\colors, {
	var white, beachBlack, skyBlack, seaBlack, boardBlack;
//	white = Line.kr(1, 0, 20);
	white = LFNoise0.kr(0.3).range(0, 0);
	Out.kr(~whiteBus, 	white);


	beachBlack = LFNoise0.kr(2.3).range(0, 0.4);
	Out.kr(	~beachBlackBus, 	beachBlack);

	skyBlack = LFNoise0.kr(7.9).range(0, 1);
	Out.kr(~skyBlackBlackBus, 	skyBlack);

	seaBlack = LFNoise0.kr(2.1).range(0, 0.8);
	Out.kr(~seaBlackBlackBus, 	seaBlack);

	boardBlack = LFNoise0.kr(2.1).range(0, 1);
	Out.kr(~boardBlackBlackBus, boardBlack);

}).play;
)
