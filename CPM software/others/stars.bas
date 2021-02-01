REM Draw a frame 60 x 20 and randomly plot stars
REM *** Requires a VT100 compatible terminal ***

3 e$=chr$(27)				'Just the ESC character
5 clrscr$=chr$(27)+"[2J"	'Clear screen
7 revchr$=chr$(27)+"[7m"	'Reverse character
9 attoff$=chr$(27)+"[0m"	'Attribute off (for character)
11 curhom$=chr$(27)+"[H"	'Move cursor home (upper left corner)

20 randomize (peek(&h80)+peek(&h81)+peek(&h82)+peek(&h83))

REM draw top of the frame
50 print clrscr$;revchr$;curhom$;"+";
60 for i=1 to 58
70 print "-";
80 next i
90 print "+"

REM move cursor to bottom left of the frame and draw bottom line
140 print e$;"[20;1H";"|";
150 print "+";
160 for i=1 to 58
170 print "-";
180 next i
190 print "+"

REM draw vertical lines
250 for i=2 to 19
260 print e$;"[";i;";1H";"|"
260 print e$;"[";i;";60H";"|"
270 next i
280 print attoff$

REM start plotting the stars

500 goto 500
