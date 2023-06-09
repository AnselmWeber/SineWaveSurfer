
~beachBuses = {


//white out everything
~white = 0;
~whiteBus = Bus.new(\control, 10, 1, s);
~whiteBus.set(1);


//Blacking out different parts
~beachBlackBus =Bus.new(\control, 11, 1, s);
~beachBlackBus.set(0);
~beachBlack = 0;

~skyBlackBlackBus = Bus.new(\control, 12, 1, s);
~skyBlackBlackBus.set(0);
~skyBlack = 0;

~seaBlackBlackBus = Bus.new(\control, 13, 1, s);
~seaBlackBlackBus.set(0);
~seaBlack = 0;

~boardBlackBlackBus = Bus.new(\control, 14, 1, s);
~boardBlackBlackBus.set(0);
~boardBlack = 0;

//rotate parts
~rotateBus = Bus.new(\control, 15, 1, s);
~rotateBus.set(0);
~rotate = 0.0;

~spec_seaGreen = ControlSpec(159, 255, \lin, 0.1, 159);
~spec_seaRed = ControlSpec(2, 255, \lin, 0.1, 159);


~boardNum = 1;
~boardFreq = 0.2;
//beachColor: Color.new255(red: 255, green: 205, blue: 20, alpha: 255);
~tideFreq = 0.1;

~getBackgroundColor = {|black= 0, white=0| Color.new255(red: ((1-black) * 255)  , green: ((1-black) * 115) +  (140 * white),
	blue: (255 * white), alpha: 255);};

~getBeachColor = {|black= 0, white=0| Color.new255(red: ((1-black) * 255)  , green: ((1-black) * 205) +  (50 * white),
	blue: ((1-black) * 20) +(235 * white), alpha: 255);};


~getSkyColor_2 = {|black= 0, white=0| Color.new255(red: ((1-black) * 255)  , green: ((1-black) * 205) +  (50 * white),
	blue: ((1-black) * 120) +(135 * white), alpha: 255);};


~getSkyColor_1 = {|black= 0, white=0| Color.new255(red: 255 * white, green: ((1-black) * 255),
	blue: ((1-black) * 255), alpha: 255);};


~getSeaColor = {|black= 0, white=0| Color.new255(red:  ((1-black) * 2)+ (253 * white), green: ((1-black) * 159)+ (96 * white),
	blue: ((1-black) * 255), alpha: 255);};

~getBoardColor_1 = {|black= 0, white=0| Color.new255(red:  ((1-black) * 255), green: (255 * white),
	blue: (255 * white), alpha: 255);};

~getBoardColor_2 = {|black= 0, white=0| Color.new255(red:  ((1-black) * 250) + (5 * white), green: ((1-black) * 163) + (91 * white),
	blue: ((1-black) * 57)+(198 * white), alpha: 255);};

~calcBoardTurn = {|int, velocity = 0.5| ((int * velocity / pi).sin + 1) / 2;};

~calcTide = {|int, velocity = 0.5| ((int * velocity / pi).sin + 1) / 2;};

i = 0;
};

~beachView= {
var screenDimensionX, screenDimensionY,
boardPosX = 100, boardPosY = 60, boardWidth = 5, boardHeight = 40, boardMaxWidth = 100,
sky_sea = 20, surfHeightPerc = 0.3,
sea_beach, sea_beach_min = 60,  sea_beach_amp = 20,
seaHeight, surfHeight;


screenDimensionX = 750;
screenDimensionY = 750;



~toYScreen = {|yVal| (yVal / 100) * screenDimensionY};

x = Window("BeachYeah" ,Rect (0, 0, screenDimensionX, screenDimensionY)).front;

r = Routine({ arg appClockTime;
//    ["AppClock has been playing for secs:",appClockTime].postln;
	i = 0;
    loop{
        0.034.yield;
		~whiteBus.get({|val| ~white = val;});

		~beachBlackBus.get({|val|~beachBlack = val;});

		~skyBlackBlackBus.get({|val| ~skyBlack = val;});

		~seaBlackBlackBus.get({|val| ~seaBlack = val;});

		~boardBlackBlackBus.get({|val| ~boardBlack = val;});

		~rotateBus.get({|val| ~rotate = val;});

		x.drawFunc= {|offset = 0|
			//BackGround
			Pen.fillColor= ~getBackgroundColor.value(0, 0);
			Pen.fillRect(Rect(0, 0 , screenDimensionX, screenDimensionY));  //10 pixels from left, 20 from


			//~seaColor = Color.newHex("#32a7fa");
			~seaColor =~getSeaColor.value(~seaBlack, ~white);
			sea_beach = sea_beach_min + (~calcTide.value(i, ~tideFreq) * sea_beach_amp) ;

			Pen.rotate(~rotate, screenDimensionX/2, ~toYScreen.value(sky_sea)/2);
			//Himmel
			Pen.addRect(Rect(0, 0, screenDimensionX, ~toYScreen.value(sky_sea)));
			Pen.fillAxialGradient(Point(0, 0), Point(screenDimensionX, 0) , ~getSkyColor_1.value(~skyBlack, ~white), ~getSkyColor_2.value(~skyBlack, ~white));
			//Pen.fillColor= Color.cyan;  //set fill color

			Pen.rotate(~rotate * -1, screenDimensionX/2, ~toYScreen.value(sky_sea)/2);
			Pen.rotate( ~rotate * -2, screenDimensionX/2, ~toYScreen.value(sky_sea + ((sea_beach - sky_sea)/2) )/2);
			//Sea
			Pen.fillColor= ~seaColor;
			Pen.fillRect(Rect(0, ~toYScreen.value(sky_sea) , screenDimensionX, ~toYScreen.value((sea_beach - sky_sea) * (1 - surfHeightPerc))));  //10 pixels from left, 20 from

			//Transition

			Pen.addRect(Rect(0, ~toYScreen.value(sky_sea + ((sea_beach - sky_sea) * (1 - surfHeightPerc))), screenDimensionX, ~toYScreen.value((sea_beach - sky_sea) * surfHeightPerc)));
			Pen.fillAxialGradient(Point(screenDimensionX/2, ~toYScreen.value(sky_sea + ((sea_beach - sky_sea) * (1 - surfHeightPerc)))), Point(screenDimensionX/2, ~toYScreen.value(sea_beach)) , ~seaColor,  ~getBeachColor.value(~beachBlack, ~white));

			Pen.rotate( ~rotate * 2, screenDimensionX/2, ~toYScreen.value(sky_sea + ((sea_beach - sky_sea)/2) )/2);
			Pen.rotate( ~rotate , screenDimensionX/2, ~toYScreen.value(sea_beach + ((100- sea_beach)/2) )/2);
			//Beach
			Pen.fillColor= ~getBeachColor.value(~beachBlack, ~white);
			Pen.fillRect(Rect(0, ~toYScreen.value(sea_beach), screenDimensionX, ~toYScreen.value(100 - sea_beach)));

			~boardNum.do{|boardIndex|
				//Board
				Pen.fillColor= ~getBoardColor_1.value(~boardBlack, ~white);
				boardWidth = boardMaxWidth * (0.05 + ~calcBoardTurn.value(i, ~boardFreq));
				Pen.fillOval(Rect(((boardPosX * (1 + boardIndex) *2) - (boardWidth * 0.5)), ~toYScreen.value(boardPosY ), boardWidth, ~toYScreen.value(boardHeight)));  //180 pixels wide, 80 high
				Pen.fillColor= ~getBoardColor_2.value(~boardBlack, ~white);
				Pen.fillOval(Rect(((boardPosX * (1 + boardIndex) *2) - (boardWidth * 0.5)) + (boardWidth*0.2), ~toYScreen.value(boardPosY  + (boardHeight*0.1)), boardWidth*0.6, ~toYScreen.value(boardHeight*0.8)));  //180 pixels wide, 80 high
			}

		};
		i = i+ 1;
		x.refresh;
    };
    1.yield;
    w.close;
});
AppClock.play(r);
}





