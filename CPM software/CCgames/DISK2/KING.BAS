0 RANDOMIZE:REM Corrected by Jim Woolley, FOG Disk Librarian, 8/82
1 PRINT CHR$(26):WIDTH 80:PRINT TAB(34);"KING":PRINT
2 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
3 PRINT:PRINT
4 PRINT "Do you want instructions";
5 INPUT Z$
6 N5=8
7 ANS$=""
10 IF LEFT$(Z$,1)="N" OR LEFT$(Z$,1)="n" THEN 49
11 IF Z$="AGAIN" OR Z$="Again" OR Z$="again" THEN 1960
12 PRINT CHR$(26)
20 PRINT "  Congratulations! You've just been elected premier of Setats"
22 PRINT "Detinu, a small Communist island 30 by 70 miles long. Your"
24 PRINT "job is to decide upon the contry's budget and distribute"
26 PRINT "money to your countrymen from the communal treasury.":PRINT
28 PRINT "  The money system is Rallods, and each person needs 100"
30 PRINT "Rallods per year to survive. Your country's income comes"
32 PRINT "from farm produce and tourists visiting your magnificent"
34 PRINT "forests, hunting, fishing, etc. Half your land is farm land"
36 PRINT "which also has an excellent mineral content and may be sold"
38 PRINT "to foreign industry for strip mining. They import and support"
40 PRINT "their own workers. Crops cost between 10 and 15 Rallods per"
42 PRINT "square mile to plant.":PRINT
44 PRINT "  Your goal is to complete your";N5;"year term of office.":PRINT
46 PRINT "GOOD LUCK!":PRINT:PRINT"(Note: Pressing 'RETURN' at each question will permit suspension"
47 PRINT"of the game until a later date.)":PRINT
48 LINE INPUT "Enter 'RETURN' to start the game.";ANS$
49 PRINT CHR$(26)
50 A=INT(60000!+(1000*RND(1))-(1000*RND(1)))
55 B=INT(500+(10*RND(1))-(10*RND(1)))
65 D=2000
100 W=INT(10*RND(1)+95)
102 PRINT
105 PRINT "You now have ";:PRINT USING "#########,###";A;:
    PRINT " Rallods in the Treasury,"
110 PRINT TAB(19);:PRINT USING "###,###";INT(B);:PRINT " countrymen, "
115 V9=INT(((RND(1)/2)*10+10))
120 IF C=0 THEN 140
130 PRINT TAB(19);:PRINT USING "###,###";INT(C);:PRINT " foreign workers, ";
140 PRINT TAB(17);"and ";:PRINT USING "##,##";INT(D);:
    PRINT " Square Miles of land.":PRINT
150 PRINT "This year industry will buy land for";W;
152 PRINT "Rallods per square mile.":PRINT
155 PRINT "Land currently costs";V9;"Rallods per square mile to plant."
162 PRINT
200 PRINT "How many square miles do you wish to sell to Industry";
210 INPUT H
215 IF H<0 THEN 200
220 IF H<=D-1000 THEN 300
230 PRINT "***  Think again. You only have";D-1000;"square miles of farm land."
240 IF X<>0 THEN 200
250 PRINT:PRINT "(Foreign Industry will only buy farm land because"
260 PRINT "forest land is uneconomical to strip mine due to trees,"
270 PRINT "thicker top soil, etc.)":PRINT
280 X=1
299 GOTO 200
300 D=INT(D-H)
310 A=INT(A+(H*W))
320 PRINT "How many Rallods (in total) will you distribute among your countrymen";
340 INPUT I
342 IF I<0 THEN 320
350 IF I<A THEN 400
360 IF I=A THEN 380
370 PRINT "***  Think again. You only have ";:PRINT USING "###,###";A;:
    PRINT " Rallods in the Treasury."
375 GOTO 320
380 J=0
390 K=0
395 A=0
399 GOTO 1000
400 A=INT(A-I)
410 PRINT "How many square miles do you wish to plant";
420 INPUT J
421 IF J<0 THEN 410
422 IF J<=B*2 THEN 426
423 PRINT "***  Sorry, but each countryman can only plant 2 square miles."
424 GOTO 410
426 IF J<=D-1000 THEN 430
427 PRINT "***  Sorry, but you only have";D-1000;"square miles of farm land."
428 GOTO 410
430 U1=INT(J*V9)
435 IF U1<A THEN 500
440 IF U1=A THEN 490
450 PRINT "***  Think again. You only have ";:PRINT USING "###,###";A;:
    PRINT " Rallods left in the Treasury."
460 GOTO 410
490 K=0
495 A=0
499 GOTO 1000
500 A=A-U1
510 PRINT "How many Rallods do you wish to spend on pollution control";
520 INPUT K
522 IF K<0 THEN 510
530 IF K<=A THEN 1000
540 PRINT "***  Think again. You only have ";:PRINT USING "###,###";A;:
    PRINT " Rallods remaining."
550 GOTO 510
600 IF H<>0 THEN 1002
602 IF I<>0 THEN 1002
604 IF J<>0 THEN 1002
606 IF K<>0 THEN 1002
609 PRINT
612 PRINT "Goodbye.":PRINT
614 PRINT "(If you wish to continue this game at a later date, answer"
616 PRINT "'AGAIN' when asked if you want instructions at the start"
617 PRINT "of the game)."
618 IF LEFT$(ANS$,1)="Y" OR LEFT$(ANS$,1)="y" THEN X5=0:GOTO 3 ELSE RUN "MENU"
1000 GOTO 600
1002 PRINT
1003 PRINT
1010 A=INT(A-K)
1020 A4=A
1100 IF INT(I/100-B)>=0 THEN 1120
1105 IF I/100<50 THEN 1700
1110 PRINT USING "##,##";INT(B-(I/100));:PRINT " countrymen died of starvation."
1120 F1=INT(RND(1)*(2000-D))
1122 IF K<25 THEN 1130
1125 F1=INT(F1/(K/25))
1130 IF F1<=0 THEN 1150
1140 PRINT USING "##,##";F1;:
     PRINT " countrymen died of Carbon-Monoxide and dust inhalation."
1150 IF INT((I/100)-B)<0 THEN 1170
1160 IF F1>0 THEN 1180
1165 GOTO 1200
1170 PRINT "***   You were forced to spend";:
     PRINT USING "##,###";INT((F1+(B-(I/100)))*9);
1172 PRINT " Rallods on funeral expenses."
1174 B5=INT(F1+(B-(I/100)))
1175 A=INT(A-((F1+(B-(I/100)))*9))
1176 GOTO 1185
1180 PRINT "***  You were forced to spend ";:PRINT USING "##,###";INT(F1*9);:
     PRINT " Rallods on funeral expenses."
1182 B5=F1
1183 A=INT(A-(F1*9))
1185 IF A>=0 THEN 1194
1187 PRINT "***  Insufficient reserves to cover cost - land was sold."
1189 D=INT(D+(A/W))
1190 A=0
1194 B=INT(B-B5)
1200 IF H=0 THEN 1250
1220 C1=INT(H+(RND(1)*10)-(RND(1)*20))
1224 IF C>0 THEN 1230
1226 C1=C1+20
1230 PRINT USING "###";C1;:PRINT " workers came to the country and";
1250 P1=INT(((I/100-B)/10)+(K/25)-((2000-D)/50)-(F1/2))
1255 PRINT USING "###";ABS(P1);:PRINT " countrymen ";
1260 IF P1<0 THEN 1275
1265 PRINT "came to";
1270 GOTO 1280
1275 PRINT "left";
1280 PRINT " the island."
1290 B=INT(B+P1)
1292 C=INT(C+C1)
1305 U2=INT(((2000-D)*((RND(1)+1.5)/2)))
1310 IF C=0 THEN 1324
1320 PRINT "Of ";:PRINT USING "##,##";INT(J);:PRINT " square miles planted, ";
1324 IF J>U2 THEN 1330
1326 U2=J
1330 PRINT "You harvested ";:PRINT USING "##,##";INT(J-U2);:
     PRINT " square miles of crops,"
1340 IF U2=0 THEN 1370
1344 IF T1>=2 THEN 1370
1350 PRINT "***  (Due to ";
1355 IF T1=0 THEN 1365
1360 PRINT "increased ";
1365 PRINT "air and water pollution from foreign industry.)"
1370 Q=INT((J-U2)*(W/2))
1380 PRINT "making ";:PRINT USING "####,###";INT(Q);:PRINT " Rallods."
1390 A=INT(A+Q)
1400 V1=INT(((B-P1)*22)+(RND(1)*500))
1405 V2=INT((2000-D)*15)
1410 PRINT "You made ";:PRINT USING "##,###";ABS(INT(V1-V2));:
     PRINT " Rallods from tourist trade."
1420 IF V2=0 THEN 1450
1425 IF V1-V2>=V3 THEN 1450
1430 PRINT "***  Decrease because ";
1435 G1=10*RND(1)
1440 IF G1<=2 THEN 1460
1442 IF G1<=4 THEN 1465
1444 IF G1<=6 THEN 1470
1446 IF G1<=8 THEN 1475
1448 IF G1<=10 THEN 1480
1450 V3=INT(A+V3)
1451 A=INT(A+V3)
1452 GOTO 1500
1460 PRINT "fish population has dwindled due to water pollution."
1462 GOTO 1450
1465 PRINT "air pollution is killing game bird population."
1467 GOTO 1450
1470 PRINT "mineral baths are being ruined by water pollution."
1472 GOTO 1450
1475 PRINT "unpleasant smog is discouraging sun bathers."
1477 GOTO 1450
1480 PRINT "Hotels are looking shabby due to smog grit."
1482 GOTO 1450
1500 IF B5>200 THEN 1600
1505 IF B<343 THEN 1700
1510 IF (A4/100)>5 THEN 1800
1515 IF C>B THEN 1550
1520 IF N5-1=X5 THEN 1900
1545 GOTO 2000
1550 PRINT
1552 PRINT
1560 PRINT "The number of foreign workers has exceeded the number"
1562 PRINT "of countrymen. As a minority, they have revolted and"
1564 PRINT "taken over the country."
1570 IF RND(1)<=.5 THEN 1580
1574 PRINT "You have been thrown out of office and are now"
1576 PRINT "residing in prison."
1578 GOTO 1590
1580 PRINT "You have been assassinated."
1590 PRINT
1592 PRINT
1596 PRINT:INPUT "Do you want to try again";ANS$
1597 IF LEFT$(ANS$,1)="Y" OR LEFT$(ANS$,1)="y" THEN X5=0:GOTO 3 ELSE RUN "MENU"
1600 PRINT
1602 PRINT
1610 PRINT USING "##,##";B5;:PRINT " countrymen died in one year!!"
1615 PRINT "Due to this extreme mismanagement, you have not only"
1620 PRINT "been impeached and thrown out of office, but you"
1622 M6=INT(RND(1)*10)
1625 IF M6<=3 THEN 1670
1630 IF M6<=6 THEN 1680
1635 IF M6<=10 THEN 1690
1670 PRINT "also had your left eye gouged out!"
1672 GOTO 1590
1680 PRINT "have also gained a very bad reputation."
1682 GOTO 1590
1690 PRINT "have also been declared National Fink."
1692 GOTO 1590
1700 PRINT
1702 PRINT
1710 PRINT "Over one third of the popultation has died since you"
1715 PRINT "were elected to office. The people (remaining)"
1720 PRINT "hate your guts."
1730 GOTO 1570
1800 IF B5-F1<2 THEN 1515
1807 PRINT
1815 PRINT "Money was left over in the Treasury which you did"
1820 PRINT "not spend. As a result, some of your countrymen died"
1825 PRINT "of starvation. The public is enraged and you have"
1830 PRINT "been forced to either resign or commit suicide."
1835 PRINT "The choice is yours."
1840 PRINT "If you choose the latter, please turn off your computer"
1845 PRINT "before proceeding."
1850 GOTO 1590
1900 PRINT
1902 PRINT
1920 PRINT "CONGRATULATIONS!!!!!!!!!!!!!!!!!!"
1925 PRINT "You have succesfully completed your";N5;"year term"
1930 PRINT "of office. You were, of course, extremely lucky, but"
1935 PRINT "nevertheless, it's quite an achievement. Goodbye and good"
1940 PRINT "luck - you'll probably need it if you're the type that"
1945 PRINT "plays this game."
1950 GOTO 1590
1960 PRINT "How many years had you been in office when interrupted";
1961 INPUT X5
1962 IF X5<0 THEN 1590
1963 IF X5<8 THEN 1969
1965 PRINT "  Come on, your term in office is only";N5;"years."
1967 GOTO 1960
1969 PRINT "How much did you have in the Treasury";
1970 INPUT A
1971 IF A<0 THEN 1590
1975 PRINT "How many countrymen";    
1976 INPUT B
1977 IF B<0 THEN 1590
1980 PRINT "How many workers";
1981 INPUT C
1982 IF C<0 THEN 1590
1990 PRINT "How many square miles of land";
1991 INPUT D
1992 IF D<0 THEN 1590
1993 IF D>2000 THEN 1996
1994 IF D>1000 THEN 100
1996 PRINT "  Come on, you started with 1000 square miles of farm land"
1997 PRINT "  and 10,000 square miles of forest land."
1998 GOTO 1990
2000 X5=X5+1
2020 B5=0
2040 GOTO 100
2046 PRINT:INPUT "Do you want to try again";ANS$
2047 IF LEFT$(ANS$,1)="Y" OR LEFT$(ANS$,1)="y" THEN X5=0:GOTO 3 ELSE RUN "MENU"
