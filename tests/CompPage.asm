;==================================================================================
; What this routine does: Fill a page, starting at a specific address, with 0x1A.
; 
; This routine is used to complete text files sent to Z80MC that will be
; saved with "SAVE XX..." command. For example, if a .BAS file is sent
; without performing this operation, MBASIC will not load the .BAS file.
;
; So the complete operation should be like this:
;
;	1) on Monitor: H
;	2) send CompPage.OBJ (which will be written at 0C000H).
;	1) on Monitor: W0100
;	2) on cmd: xmit.py (input file name, e.g. KKK.BAS)
;	3) on Monitor, read the last page received (using the result from xmit.py)
;	4) find the next address after the last "0x0D 0x0A" sequence.
;	5) write this address to SADDR (ORG+2=0C002H).
;	6) execute CompPage routine (JC000).
;	7) on CCP: SAVE xx... (xx is supplied by xmit.py).
; 
;==================================================================================
WAITCMD		.EQU	0D131H			; Reentry point to Monitor
FILLBYTE	.EQU	01AH

;================================================================================================
			.ORG 0C000H
		JR	HOP
SADDR	.DB	0,0
HOP:	LD	HL,(SADDR)
		LD	(HL),FILLBYTE
		PUSH	HL
		POP DE
		INC	DE
		LD	B,0
		LD	A,E
		NEG
		LD	C,A
		LDIR
		JP	WAITCMD

		.END
