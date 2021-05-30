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

REPEAT:		CALL CRLF
			CALL CONIN
			LD	B,A
			PUSH BC
			CALL B2HL
			LD	C,H
			CALL CONOUT
			LD	C,L
			CALL CONOUT
			
			LD	C,' '
			CALL CONOUT
			LD	C,'='
			CALL CONOUT
			LD	C,' '
			CALL CONOUT
			
			POP	BC
			LD	A,B
			CP	20H
			JP	M,SPEC
			LD	C,A
			CALL CONOUT
			JR	REPEAT
SPEC:		ADD	A,B
			ADD	A,B
			LD	C,A
			LD	B,0
			LD	HL,ASCII
			ADD	HL,BC
			LD	C,(HL)
			CALL CONOUT
			INC	HL
			LD	C,(HL)
			CALL CONOUT
			INC	HL
			LD	C,(HL)
			CALL CONOUT
			JP	REPEAT
			
CRLF:		LD	C,CR
			CALL CONOUT
			LD	C,LF
			CALL CONOUT					; Output <CR><LF>.
			RET


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
ASCII:		.DB	"NUL","SOH","STX","ETX","EOT","ENQ","ACK","BEL"
			.DB	"BS ","HT ","LF ","VT ","FF ","CR ","SO ","SI "
			.DB	"DLE","DC1","DC2","DC3","DC4","NAK","SYN","ETB"
			.DB	"CAN","EM ","SUB","ESC","FS ","GS ","RS ","US "

			.END
