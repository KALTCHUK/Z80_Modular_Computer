10 PRINT CHR$(26)
20 PRINT TAB(34);"AWARI":PRINT:PRINT
30 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
40 PRINT:PRINT
45 INPUT "DO YOU WANT INSTRUCTIONS ";RESP$
46 IF LEFT$(RESP$,1)="Y" OR LEFT$(RESP$,1)="y" THEN GOSUB 1000
50 DATA 0
60 DIM B(13),G(13),F(50):READ N
70 PRINT:PRINT:E=0
80 FOR I=0 TO 12:B(I)=3:NEXT I
90 C=0:F(N)=0:B(13)=0:B(6)=0
100 GOSUB 370
110 PRINT "YOUR MOVE";:GOSUB 240
120 IF E=0 THEN 190
130 IF M=H THEN GOSUB 230
140 IF E=0 THEN 190
150 PRINT "MY MOVE IS ";:GOSUB 530
160 IF E=0 THEN 190
170 IF M=H THEN PRINT ",";:GOSUB 530
180 IF E>0 THEN 100
190 PRINT:PRINT"GAME OVER."
200 D=B(6)-B(13):IF D<0 THEN PRINT "I WIN BY";-D;"POINTS.":GOTO 2000
210 N=N+1:IF D=0 THEN PRINT "DRAWN GAME":GOTO 2000
220 PRINT "YOU WIN BY";D;"POINTS":GOTO 2000
230 PRINT "AGAIN";
240 INPUT M:IF M<7 THEN IF M>0 THEN M=M-1:GOTO 260
250 PRINT "ILLEGAL MOVE":GOTO 230
260 IF B(M)=0 THEN 250
270 H=6:GOSUB 290
280 GOTO 370
290 K=M:GOSUB 470
300 E=0:IF K>6 THEN K=K-7
310 C=C+1:IF C<9 THEN F(N)=F(N)*6+K
320 FOR I=0 TO 5:IF B(I)<>0 THEN 350
330 NEXT I
340 RETURN
350 FOR I=7 TO 12:IF B(I)<>0 THEN E=1:RETURN
360 GOTO 330
370 PRINT:PRINT"   ";
380 FOR I=12 TO 7 STEP -1:GOSUB 450
390 NEXT I
400 PRINT:I=13:GOSUB 450
410 PRINT "                       ";:PRINT B(6):PRINT "   ";
420 FOR I=0 TO 5:GOSUB 450
430 NEXT I
440 PRINT:PRINT:RETURN
450 IF B(I)<10 THEN PRINT " ";
460 PRINT B(I);:RETURN
470 P=B(M):B(M)=0
480 FOR P=P TO 1 STEP -1:M=M+1:IF M>13 THEN M=M-14
490 B(M)=B(M)+1:NEXT P
500 IF B(M)=1 THEN IF M<>6 THEN IF M<>13 THEN IF B(12-M)<>0 THEN 520
510 RETURN
520 B(H)=B(H)+B(12-M)+1:B(M)=0:B(12-M)=0:RETURN
530 D=-99:H=13
540 FOR I=0 TO 13:G(I)=B(I):NEXT I
550 FOR J=7 TO 12:IF B(J)=0 THEN 690
560 G=0:M=J:GOSUB 470
570 FOR I=0 TO 5:IF B(I)=0 THEN 620
580 L=B(I)+I:R=0
590 IF L>13 THEN L=L-14:R=1:GOTO 590
600 IF B(L)=0 THEN IF L<>6 THEN IF L<>13 THEN R=B(12-L)+R
610 IF R>Q THEN Q=R
620 NEXT I
630 Q=B(13)-B(6)-Q:IF C>8 THEN 670
640 K=J:IF K>6 THEN K=K-7
650 FOR I=0 TO N-1:IF F(N)*6+K=INT(F(I)/6^(7-C)+.1) THEN Q=Q-2
660 NEXT I
670 FOR I=0 TO 13:B(I)=G(I):NEXT I
680 IF Q>=D THEN A=J:D=Q
690 NEXT J
700 M=A:PRINT CHR$(42+M);:GOTO 290
710 FOR I=0 TO N-1:PRINT B(I):NEXT I
720 RUN "MENU"
1000 '	***   INSTRUCTION SUBROUTINE   ***
1002 GOTO 1175
1010 PRINT CHR$(26)
1040 PRINT "                        My SIDE"
1050 PRINT
1060 PRINT "       |  6  |  5  |  4  |  3  |  2  |  1  |"
1070 PRINT "       |     |     |     |     |     |     |"
1080 PRINT "       | 000 | 000 | 000 | 000 | 000 | 000 |"
1100 PRINT "  My   |     |     |     |     |     |     |  Your"
1110 PRINT " HOME  |     |     |     |     |     |     |  HOME" 
1120 PRINT "       | 000 | 000 | 000 | 000 | 000 | 000 |"
1130 PRINT "       |     |     |     |     |     |     |"
1140 PRINT "       |  1  |  2  |  3  |  4  |  5  |  6  |"
1150 PRINT
1160 PRINT "                       Your SIDE"
1170 PRINT:PRINT
1171 RETURN
1175 GOSUB 1010
1180 PRINT "   AWARI is played with seven sticks and thirty-six stones (beans)"
1190 PRINT"laid out as shown above. The board is divided into six compartments"
1200 PRINT "(PITS) on 'My SIDE' and six on 'Your SIDE'. In addition, there are"
1210 PRINT "two special PITS at the ends: 'My HOME' and 'Your HOME'.":PRINT
1212 LINE INPUT "Enter 'RETURN' to continue.";RR$:GOSUB 1010
1220 PRINT "   A MOVE is made by taking all of the beans from any (non-empty)"
1230 PRINT "PIT on your own SIDE. Starting from the PIT to the right of this"
1240 PRINT "one, these beans are SOWN one in each PIT working around the board"
1250 PRINT "anti-clockwise.":PRINT
1260 PRINT 
     "   A TURN consists of one or two MOVEs. If the last bean of your MOVE"
1270 PRINT "is SOWN in your own HOME you may take a second MOVE.":PRINT
1275 LINE INPUT "Enter 'RETURN' to continue.";RR$:GOSUB 1010
1280 PRINT "   If the last bean SOWN in a MOVE lands in an empty PIT, provided"
1290 PRINT "that the opposite PIT is not empty, all the beans in the opposite"
1300 PRINT "PIT, together with the last bean SOWN are 'captured' and moved to"
1310 PRINT "the player's HOME.":PRINT
1320 PRINT 
     "   When either side is empty, the game is finished. The player with"
1330 PRINT "the most beans in his HOME has won.":PRINT
1340 LINE INPUT "Enter 'RETURN' to continue.";RR$:PRINT CHR$(26)
1350 PRINT "   In the computer version, the board is printed as 14 numbers"
1360 PRINT "representing the 14 PITS:"
1370 PRINT
1380 PRINT "    3  3  3  3  3  3  "
1390 PRINT " 0                    0"
1400 PRINT "    3  3  3  3  3  3":PRINT
1410 PRINT "   The PITS on your (lower) SIDE are numbered 1-6 from left to"
1420 PRINT "right. The PITS on my (the computer's) SIDE are numbered from my"
1430 PRINT "left (your right).":PRINT
1440 PRINT "   To make a MOVE you type in the number of a PIT. If the last bean"
1450 PRINT "lands in your HOME, the computer types 'AGAIN?' and you take your"
1460 PRINT "second move. The computer's move is typed, followed by a diagram"
1470 PRINT "of the board in its new state. You always go first, which is"
1480 PRINT "considered to be a slight advantage.":PRINT
1490 LINE INPUT "Enter 'RETURN' to start the game.";RR$:RETURN
2000 LINE INPUT "PLAY AGAIN? ";ANS$
2010 IF LEFT$(ANS$,1)="Y" THEN 70 ELSE RUN "MENU"
