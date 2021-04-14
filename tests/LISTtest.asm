BOOT		.EQU	0
BIOS		.EQU	0E600H				; BIOS entry point
LEAP		.EQU	3					; 3 bytes for each entry (JP aaaa)

CONST:		.EQU	BIOS+(LEAP*2)		;  2 Console status.
CONIN:		.EQU	BIOS+(LEAP*3)		;  3 Console input.
CONOUT:		.EQU	BIOS+(LEAP*4)		;  4 Console OUTput.
LIST:		.EQU	BIOS+(LEAP*5)		;  3 Console input.
LISTST:		.EQU	BIOS+(LEAP*15)		;  2 Console status.
PRINTSEQ:	.EQU	BIOS+(LEAP*17)		;  4 Console OUTput.
;================================================================================================
; ASCII characters.
;================================================================================================
LF			.EQU	0AH
FF			.EQU	0CH
CR			.EQU	0DH
DC1			.EQU	11H
DC2			.EQU	12H
DC3			.EQU	13H
DC4			.EQU	14H
ESC			.EQU	1BH
;================================================================================================
			.ORG	0100H

			LD	C,DC1			; Init LCD card
			CALL LIST
			
			CALL PRINTSEQ
			.DB "<ENTER>=LF, <ESC>=exit",CR,LF,0
			
REPEAT:		LD	C,FF
			CALL LIST
			CALL WAIT
			CALL LCDSEQ
			.DB	"Overhead the alb",0
			CALL WAIT
			CALL LCDSEQ
			.DB	CR,LF,"Hangs motionless",0
			CALL WAIT
			CALL LCDSEQ
			.DB	CR,LF,"And deep beneath",0
			CALL WAIT
			CALL LCDSEQ
			.DB	CR,LF,"In labyrinths of",0
			CALL WAIT
			CALL LCDSEQ
			.DB	CR,LF,"The echo of a di",0
			CALL WAIT
			CALL LCDSEQ
			.DB	CR,LF,"Comes willowing ",0
			CALL WAIT
			CALL LCDSEQ
			.DB	CR,LF,0
			CALL WAIT
			JP	REPEAT
			
;================================================================================================
; Wait for user hir <ENTER>
;================================================================================================
WAIT:		CALL CONIN
			CP	ESC
			JP	Z,BOOT
			CP	CR
			JR	NZ,WAIT
			RET
			
;================================================================================================
; Print (on console) a sequence of characters ending with zero
;================================================================================================
LCDSEQ:		EX 	(SP),HL 		; Push HL and put RET address into HL
			PUSH 	AF
			PUSH 	BC
NEXTCHAR:	LD 	A,(HL)
			CP	0
			JR	Z,ENDOFPRINT
			LD  	C,A
			CALL 	LIST		; Print to LCD
			INC 	HL
			JR	NEXTCHAR
ENDOFPRINT:	INC 	HL 			; Get past "null" terminator
			POP 	BC
			POP 	AF
			EX 	(SP),HL 		; Push new RET address on stack and restore HL
			RET

;================================================================================================

			.END
