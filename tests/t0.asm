BOOT		.EQU	0
BIOS		.EQU	0E600H				; BIOS entry point
LEAP		.EQU	3					; 3 bytes for each entry (JP aaaa)

CONST:		.EQU	BIOS+(LEAP*2)		;  2 Console status.
CONIN:		.EQU	BIOS+(LEAP*3)		;  3 Console input.
CONOUT:		.EQU	BIOS+(LEAP*4)		;  4 Console OUTput.
LIST:		.EQU	BIOS+(LEAP*5)		;  3 Console input.
LISTST:		.EQU	BIOS+(LEAP*15)		;  2 Console status.
PRINTSEQ:	.EQU	BIOS+(LEAP*17)		;  4 Console OUTput.

LF			.EQU	0AH
CR			.EQU	0DH
ESC			.EQU	1BH
;================================================================================================
			.ORG	0100H

START:		CALL PRINTSEQ
			.DB	CR,LF," || TEST 0"
			.DB	CR,LF," || CALL PRINTSEQ"
			.DB	CR,LF," || BOOT",CR,LF,CR,LF,0
			
			CALL CONIN
			CP	ESC
			JP	Z,BOOT
			JR	START
			
			.END
