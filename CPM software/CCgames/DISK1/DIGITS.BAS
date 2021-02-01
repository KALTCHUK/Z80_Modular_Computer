5 PRINT CHR$(26):WIDTH 80
10 PRINT TAB(33);"DIGITS":PRINT
20 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
30 PRINT:PRINT:PRINT
210 PRINT "This is a game of guessing."
215 PRINT
220 INPUT "Do you want instructions";E$
230 IF LEFT$(E$,1)="N" OR LEFT$(E$,1)="n" THEN 360
250 PRINT
260 PRINT "  Please take a piece of paper and write down"
270 PRINT "the digits '0', '1', or '2' thirty times at random."
280 PRINT "Arrange them in three lines of ten digits each.":PRINT
290 PRINT "  I will ask for then ten at a time. Enter each digit"
295 PRINT "separated by commas.":PRINT
300 PRINT "  I will always guess them first and then look at your"
310 PRINT "next number to see if I was right. By pure luck,"
320 PRINT "I ought to be right ten times. But I hope to do better"
330 PRINT "than that....."
340 PRINT:PRINT
360 READ A,B,C
370 DATA 0,1,3
380 DIM M(26,2),K(2,2),L(8,2)
400 FOR I=0 TO 26: FOR J=0 TO 2: M(I,J)=1: NEXT J: NEXT I
410 FOR I=0 TO 2: FOR J=0 TO 2: K(I,J)=9: NEXT J: NEXT I
420 FOR I=0 TO 8: FOR J=0 TO 2: L(I,J)=3: NEXT J: NEXT I
450 L(0,0)=2: L(4,1)=2: L(8,2)=2
480 Z=26: Z1=8: Z2=2
510 X=0
520 FOR T=1 TO 3
530 PRINT
540 PRINT "Ten numbers, please";
550 INPUT N(1),N(2),N(3),N(4),N(5),N(6),N(7),N(8),N(9),N(10)
560 FOR I=1 TO 10
570 W=N(I)-1
580 IF W=SGN(W) THEN 620
590 PRINT "Only use the digits '0', '1', or '2'."
600 PRINT "Let's try again.":GOTO 530
620 NEXT I
630 PRINT: PRINT "MY GUESS","YOUR NO.","RESULT","NO. RIGHT"
640 PRINT "--------","--------","------","---------":PRINT
660 FOR U=1 TO 10
670 N=N(U): S=0
690 FOR J=0 TO 2
700 S1=A*K(Z2,J)+B*L(Z1,J)+C*M(Z,J)
710 IF S>S1 THEN 760
720 IF S<S1 THEN 740
730 IF RND(1)<.5 THEN 760
740 S=S1: G=J
760 NEXT J
770 PRINT "  ";G,"   ";N(U),
780 IF G=N(U) THEN 810
790 PRINT " WRONG",:PRINT USING "   ##";X
800 GOTO 880
810 X=X+1
820 PRINT " RIGHT",:PRINT USING "   ##";X
830 M(Z,N)=M(Z,N)+1
840 L(Z1,N)=L(Z1,N)+1
850 K(Z2,N)=K(Z2,N)+1
860 Z=Z-INT(Z/9)*9
870 Z=3*Z+N(U)
880 Z1=Z-INT(Z/9)*9
890 Z2=N(U)
900 NEXT U
910 NEXT T
920 PRINT
930 IF X>10 THEN 980
940 IF X<10 THEN 1010
950 PRINT "I guessed exactly 1/3 of your numbers."
960 PRINT "It's a tie game."
970 GOTO 1030
980 PRINT "I guessed more than 1/3 of your numbers."
990 PRINT "I win."
1000 GOTO 1030
1010 PRINT "I guessed less than 1/3 of your numbers."
1020 PRINT "Congratulations! You beat me."
1030 PRINT
1040 INPUT "Do you want to try again";X$
1060 IF LEFT$(X$,1)="Y" OR LEFT$(X$,1)="y" THEN 400 THEN 400
1080 PRINT:PRINT "Thanks for the game.":PRINT
1090 RUN "MENU"

