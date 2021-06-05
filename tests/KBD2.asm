#INCLUDE	"equates.h"

BOOT		.EQU	0
LEAP		.EQU	3					; 3 bytes for each entry (JP aaaa)

CONST:		.EQU	BIOS+(LEAP*2)		;  2 Console status.
CONIN:		.EQU	BIOS+(LEAP*3)		;  3 Console input.
CONOUT:		.EQU	BIOS+(LEAP*4)		;  4 Console OUTput.
LIST:		.EQU	BIOS+(LEAP*5)		;  3 Console input.
LISTST:		.EQU	BIOS+(LEAP*15)		;  2 Console status.
PRINTSEQ:	.EQU	BIOS+(LEAP*17)		;  4 Console OUTput.

LF			.EQU	0AH
CR			.EQU	0DH
;================================================================================================
			.ORG	0100H

			CALL CRLF
REPEAT:		CALL CONIN
			CP	01AH
			JR	Z,FINAL
			LD	B,A
			CALL B2HL
			LD	C,H
			CALL CONOUT
			LD	C,L
			CALL CONOUT
			LD	C,','
			CALL CONOUT
			JR	REPEAT

CRLF:		LD	C,CR
			CALL CONOUT
			LD	C,LF
			CALL CONOUT					; Output <CR><LF>.
			RET

FINAL:		CALL CRLF
			JP BOOT
			
;================================================================================================
; Convert HEX to ASCII (B --> HL)
;================================================================================================
B2HL:		PUSH	BC
			LD	A,B
			AND	0FH
			LD	L,A
			SUB	0AH
			LD	C,030H
			JP	C,COMPENSE
			LD	C,037H
COMPENSE:	LD	A,L
			ADD	A,C
			LD	L,A
			LD	A,B
			AND	0F0H
			SRL	A
			SRL	A
			SRL	A
			SRL	A
			LD	H,A
			SUB	0AH
			LD	C,030H
			JP	C,COMPENSE2
			LD	C,037H
COMPENSE2:	LD	A,H
			ADD	A,C
			LD	H,A
			POP	BC
			RET

;================================================================================================

			.END
