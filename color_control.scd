

(
Ndef(\colors, {
	var white, beachBlack, skyBlack, seaBlack, boardBlack, rotate;

	white = LFNoise0.kr(5.3).range(0, 1.0);

	white = Line.kr(1, 0, 40);
	white = 1.0;
	Out.kr(10, 	white);


	beachBlack = LFNoise0.kr(2.3).range(0, 0.0);
	Out.kr(11, 	beachBlack);

	skyBlack = LFNoise0.kr(7.9).range(0, 0);
	Out.kr(12, 	skyBlack);

	seaBlack = LFNoise0.kr(2.1).range(0, 0.0);
	Out.kr(13, 	seaBlack);

	boardBlack = LFNoise0.kr(2.1).range(0, 0);
	Out.kr(14, boardBlack);

	rotate  = LFNoise2.kr(2.1).range(0, 0);
	Out.kr(15, boardBlack);


}).play;
)
