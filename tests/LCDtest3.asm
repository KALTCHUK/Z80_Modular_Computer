; Initialize LCD and write something
; CPU @ 4.0MHz (this is important for the delay routines)
;
; RS  = A0 from CPU
; R/W = A1 from CPU
; E   = 74LS85 output pin 'A=B'
;  

DAT_WR	.EQU	0E1H			; 
DAT_RD	.EQU	0E3H			; 
CMD_WR	.EQU	0E0H			; 
CMD_RD	.EQU	0E2H			; 

DT		.EQU	1			; delta t (s)

SPACE		.EQU	020H

		.ORG	0

		CALL	LCDINIT
AGAIN:
		CALL LCDCLEAR

		CALL	LCDPRINT
		.TEXT	"Batatinha"
		.DB	0

		LD 	B,DT
		CALL	DELAYS

		CALL LCDLFCR
		CALL	LCDPRINT
		.TEXT	"quando nasce"
		.DB	0

		LD 	B,DT
		CALL	DELAYS

		CALL LCDLFCR
		CALL	LCDPRINT
		.TEXT	"se esparrama"
		.DB	0

		LD 	B,DT
		CALL	DELAYS

		CALL LCDLFCR
		CALL	LCDPRINT
		.TEXT	"pelo chao..."
		.DB	0

		LD 	B,DT
		CALL	DELAYS

		CALL LCDLFCR
		CALL	LCDPRINT
		.TEXT	" "
		.DB	0

		LD 	B,DT
		CALL	DELAYS

		CALL LCDLFCR

		JP	AGAIN

;================================================================================================
; Delay X seconds, with X passed on reg B
;================================================================================================
DELAYS:
		PUSH	BC
		PUSH	HL
LOOP0:	LD	HL,655
LOOP1:	LD	C,255		;1.75					\
LOOP2:	DEC	C		;1		\			|
		NOP			;1		| t=6(X-1)+1.75	| (7.75+t)(y-1)
		LD	A,C		;1		|			|
		JR	NZ,LOOP2	;3/1.75	/			| 
		DEC	HL		;1					|
		LD	A,H		;1					|
		OR	L		;1					|
		JR	NZ,LOOP1	;3/1.75				/
		DJNZ	LOOP0
		POP	HL
		POP	BC
		RET

;================================================================================================
; Delay X miliseconds, with X passed on reg B
;================================================================================================
DELAYMS:
		PUSH	BC
DECB:		LD	C,0C8H
DECC:		NOP
		DEC	C
		JR	NZ,DECC
		DEC	B
		JR	NZ,DECB
		POP	BC
		RET

;================================================================================================
; Delay 5*X microseconds, with X passed on reg C
;================================================================================================
DELAY5US:
		PUSH	BC
DEC:		NOP
		DEC	C
		JR	NZ,DEC
		POP	BC
		RET

;================================================================================================
; Wait until Busy flag = 0
;================================================================================================
BWAIT:	IN A,(CMD_RD)
		RLCA
		JR	C,BWAIT
		RET

;================================================================================================
; Initialize LCD
;================================================================================================
LCDINIT:
		LD	B,15			; wait 15ms
		CALL	DELAYMS
		LD	A,030H		; write command 030h
		OUT	(CMD_WR),A
		LD	B,5			; wait 5ms
		CALL	DELAYMS
		LD	A,030H		; write command 030h
		OUT	(CMD_WR),A
		LD	C,20			; wait (5X20) 100us
		CALL	DELAY5US
		LD	A,030H		; write command 030h
		OUT	(CMD_WR),A
		LD	C,20			; wait (5X20) 100us
		CALL	DELAY5US
		LD	A,038H		; write command 038h = function set (8-bits, 2-lines, 5x7dots)
		OUT	(CMD_WR),A
		CALL	BWAIT	
		LD	A,08H			; write command 08h = display (off)
		OUT	(CMD_WR),A
		CALL	BWAIT
		LD	A,01H			; write command 01h = clear display
		OUT	(CMD_WR),A
		CALL	BWAIT	
		LD	A,06H			; write command 06h = entry mode (increment)
		OUT	(CMD_WR),A
		CALL	BWAIT
		LD	A,0CH			; write command 0Ch = display (on)
		OUT	(CMD_WR),A
		RET

;================================================================================================
; Clear LCD and goto line 1, column 1.
;================================================================================================
LCDCLEAR:
		CALL	BWAIT
		LD	A,01H			; write command 01h = clear display
		OUT	(CMD_WR),A
		RET

;================================================================================================
; Send to LCD char in regC. Print at current position (what ever it is)
;================================================================================================
LCDPUT:
		CALL	BWAIT
		LD	A,C			; write command 01h = clear display
		OUT	(DAT_WR),A
		RET

;================================================================================================
; Position LCD cursor at line regH, column regL.
;================================================================================================
LCDPOS:
		DEC	H
		SLA	H
		SLA	H
		SLA	H
		SLA	H
		SLA	H
		SLA	H
		LD	A,H
		DEC	L
		OR	L
		OR	080H
		LD	H,A
		CALL	BWAIT
		LD	A,H
		OUT	(CMD_WR),A
		RET

;================================================================================================
; Send to LCD a sequence of characters ending with zero
;================================================================================================
LCDPRINT:
		EX 	(SP),HL 		; Push HL and put RET address into HL
		PUSH 	AF
		PUSH 	BC
NEXTCHAR:
		LD 	A,(HL)
		CP	0
		JR	Z,ENDOFPRINT
		LD	C,A
		CALL	BWAIT
		LD	A,C
		OUT	(DAT_WR),A
		INC 	HL
		JR	NEXTCHAR
ENDOFPRINT:
		INC 	HL 			; Get past "null" terminator
		POP 	BC
		POP 	AF
		EX 	(SP),HL 		; Push new RET address on stack and restore HL
		RET





;================================================================================================
; LF + CR for LCD. Copies line #2 to line #1, Cleans line #2 and puts the cursor at the 
; beginning of line #2.
;================================================================================================
LCDLFCR:
		PUSH 	BC
		CALL	BWAIT
		IN A,(CMD_RD)
		RLCA
		RLCA
		JR	NC,LINEONE

		LD	B,0			; initialize position counter
NEWSRC:	CALL	BWAIT
		LD	A,B
		OR	0C0H
		OUT	(CMD_WR),A		; set addr counter to source position
		CALL	BWAIT
		IN	A,(DAT_RD)		; get data from source position
		LD	C,A
		CALL	BWAIT
		LD	A,B
		OR	080H
		OUT	(CMD_WR),A		; set addr counter to target position
		CALL	BWAIT
		LD	A,C
		OUT	(DAT_WR),A		; put data in target position		
		CALL	BWAIT
		LD	A,B
		OR	0C0H
		OUT	(CMD_WR),A		; set addr counter back to source position
		CALL	BWAIT
		LD	A,SPACE
		OUT	(DAT_WR),A		; put blank space in source position
		INC	B
		LD	A,B
		SUB	010H
		JR	NZ,NEWSRC		

LINEONE:
		LD	HL,0201H
		CALL	LCDPOS

		POP 	BC
		RET


		.END
