7  P$=" #*%HI&|;;:::......"
10 E$=CHR$(27)
20 CLRSCR$=E$+"[2J"
30 CURHOM$=E$+"[H"
40 PRINT CLRSCR$;CURHOM$
50 FOR I=0 TO 65
60 FOR J=43 TO 0 STEP -1
70 X=(I-52)/31:Y=(J-22)/31:XA=0:YA=0:ITER=0
120 XTEMP=XA*XA-YA*YA+X:YA=2*XA*YA+Y:XA=XTEMP:ITER=ITER+1:C=XA*XA+YA*YA
160 IF C<=4 AND ITER<200 THEN GOTO 120
162 K=1+CINT(C)
164 IF K>17 THEN K=17
210 T$=STR$(I+1)
220 P=1:IF I>=10 THEN P=2
230 X$=MID$(T$,2,P)
240 T$=STR$(J+1)
250 P=1:IF J>=10 THEN P=2
260 Y$=MID$(T$,2,P)
270 PRINT E$;"[";Y$;";";X$;"H";MID$(P$,K,1)
280 NEXT J
290 NEXT I
300 END
