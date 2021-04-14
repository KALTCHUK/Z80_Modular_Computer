; Initialize LCD and write something
; CPU @ 4.0MHz (this is important for the delay routines)
;
; RS  = A0 from CPU
; R/W = A1 from CPU
; E   = 74LS85 output pin 'A=B'
;

IOBYTE		.EQU	3
DT			.EQU	1			; delta t (s)

LF			.EQU	0AH
FF			.EQU	0CH
CR			.EQU	0DH
DC1			.EQU	11H
DC2			.EQU	12H

BIOS		.EQU	0E600H
LIST		.EQU	BIOS+15
;*******************************************************************************
			.ORG	0100h
			
			CALL LCDINIT

AGAIN:		CALL LCDCLEAR
			CALL LCDPRINT
			.DB	"Z80 Modular     ",0
			LD 	B,DT
			CALL DELAYS
			CALL LCDPRINT
			.DB	CR,LF,"Computer        ",0
			LD 	B,DT
			CALL DELAYS
			CALL LCDPRINT
			.DB	CR,LF,"by Kaltchuk     ",0
			LD 	B,DT
			CALL DELAYS
			LD	C,40H
			CALL LCDPOS
			CALL LCDPRINT
			.DB	CR,LF,"December/2020   ",0
			LD 	B,DT
			CALL DELAYS
			JP	AGAIN

;================================================================================================
; Delay X seconds, with X passed on reg B
;================================================================================================
DELAYS:
			PUSH	BC
			PUSH	HL
LOOP0:		LD	HL,655		;2.5				\
LOOP1:		LD	C,255		;1.75	\			|
LOOP2:		DEC	C			;1		|			|
			NOP				;1		| t=6C+0.5	| 
			LD	A,C			;1		|			| t=HL(6C+6.5)+1.25
			JR	NZ,LOOP2	;3/1.75	/			|
			DEC	HL			;1					| with HL=655 and c=255, t=1.006sec (WOW!!!)
			LD	A,H			;1					|
			OR	L			;1					|
			JR	NZ,LOOP1	;3/1.75				/
			DJNZ	LOOP0	;3.25/2
			POP	HL
			POP	BC
			RET

;================================================================================================
; Init IOBYTE and LCD card.
;================================================================================================
LCDINIT:	LD	A,0C0H
			LD	(IOBYTE),A
			LD	C,DC1
			CALL LIST
			RET

;================================================================================================
; Clear LCD and goto line 1, column 1.
;================================================================================================
LCDCLEAR:	LD	C,FF
			CALL LIST
			RET

;================================================================================================
; Position LCD cursor
;================================================================================================
LCDPOS:		PUSH BC
			LD	C,DC2
			CALL LIST
			POP	BC
			CALL LIST
			RET

;================================================================================================
; Send to LCD a sequence of characters ending with zero
;================================================================================================
LCDPRINT:	EX 	(SP),HL 		; Push HL and put RET address into HL
			PUSH AF
			PUSH BC
NEXTCHAR:	LD 	A,(HL)
			CP	0
			JR	Z,ENDOFPRINT
			LD	C,A
			CALL LIST
			INC HL
			JR	NEXTCHAR
ENDOFPRINT:	INC HL 			; Get past "null" terminator
			POP BC
			POP AF
			EX 	(SP),HL 		; Push new RET address on stack and restore HL
			RET







			.END
