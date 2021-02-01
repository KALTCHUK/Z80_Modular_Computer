REM Draw a frame 60 x 20 and randomly plot stars
5 clrscr$=chr$(27)+"[2J"
7 revchr$=chr$(27)+"[7m"
9 curhom$=chr$(27)+"[H"
11 attoff$=chr$(27)+"[m"


REM draw frame
10 print clrscr$;revchr$

