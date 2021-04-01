


			.ORG	0100h


;================================================================================================
; LCD STATUS. Return A=LCD_card_addr. A=0 if no card initialized.
;================================================================================================
LCDST:		LD	A,(LCD_ADDR)
			RET

;================================================================================================
; LCD OUTPUT. Send C to LCD, if C>1FH. Accepts also LF, CR and FF (=clear LCD).
; If C=DC1, init LCD card with address in B.
; If C=DC2, position cursor at line and column in DE. D=line, E=column.
;================================================================================================
LCD:		LD	A,C
			CP	20
			JP	M,ASCIILO
			CALL LCDPUT
			RET
ASCIILO:	CP	LF
			JR	Z,LCDLF
			CP	CR
			JR	Z,LCDCR
			CP	FF
			JR	Z,LCDCLEAR
			CP	DC1
			JR	Z,LCDINIT
			CP	DC2
			JR	Z,LCDPOS
			RET

LCDLF:

LCDCR:



;================================================================================================
; Delay X seconds, with X passed on reg B
;================================================================================================
DELAYS:		PUSH BC
			PUSH HL
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
			DJNZ LOOP0		;3.25/2
			POP	HL
			POP	BC
			RET

;================================================================================================
; Delay X miliseconds, with X passed on reg B
;================================================================================================
DELAYMS:	PUSH BC
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
DELAY5US:	PUSH BC
DEC:		NOP
			DEC	C
			JR	NZ,DEC
			POP	BC
			RET

;================================================================================================
; Wait until Busy flag = 0
;================================================================================================
BWAIT:		CALL LCDRDCMD
			RLCA
			JR	C,BWAIT
			RET
			
;================================================================================================
; Initialize LCD
;================================================================================================
LCDINIT:	LD	A,B				; Init all addresses
			LD	(LCD_ADDR),A
			LD	(CMD_WR),A
			INC	A
			LD	(DAT_WR),A
			INC	A
			LD	(CMD_RD),A
			INC	A
			LD	(DAT_RD),A
			
			LD	B,15			; wait 15ms
			CALL DELAYMS
			LD	A,030H			; write command 030h
			CALL LCDWRCMD
			LD	B,5				; wait 5ms
			CALL DELAYMS
			LD	A,030H			; write command 030h
			CALL LCDWRCMD
			LD	C,20			; wait (5X20) 100us
			CALL DELAY5US
			LD	A,030H			; write command 030h
			CALL LCDWRCMD
			LD	C,20			; wait (5X20) 100us
			CALL DELAY5US
			LD	A,038H			; write command 038h = function set (8-bits, 2-lines, 5x7dots)
			CALL LCDWRCMD
			CALL BWAIT
			LD	A,08H			; write command 08h = display (off)
			CALL LCDWRCMD
			CALL BWAIT
			LD	A,01H			; write command 01h = clear display
			CALL LCDWRCMD
			CALL BWAIT
			LD	A,06H			; write command 06h = entry mode (increment)
			CALL LCDWRCMD
			CALL BWAIT
			LD	A,0CH			; write command 0Ch = display (on)
			CALL LCDWRCMD
			RET

;================================================================================================
; Clear LCD and goto line 1, column 1.
;================================================================================================
LCDCLEAR:	CALL BWAIT
			LD	A,01H			; write command 01h = clear display
			CALL LCDWRCMD
			RET

;================================================================================================
; Send to LCD char in regC. Print at current position (what ever it is)
;================================================================================================
LCDPUT:		CALL BWAIT
			LD	A,C				; write command 01h = clear display
			CALL LCDWRDAT
			RET

;================================================================================================
; Position LCD cursor at line regD, column regE.
;================================================================================================
LCDPOS:		LD	A,80H
			DEC	D
			JR	Z,LINE1
			LD	A,0C0H
LINE1:		DEC	E
			OR	E
.
			LD	D,A
			CALL BWAIT
			LD	A,D
			CALL LCDWRCMD
			RET

;================================================================================================
; 
; 
;================================================================================================
LCDRDPOS:	CALL BWAIT
			AND	3FH
			



			LD	B,0				; initialize position counter
NEWSRC:		CALL BWAIT
			LD	A,B
			OR	0C0H
			CALL LCDWRCMD		; set addr counter to source position
			CALL BWAIT
			CALL LCDRDDAT		; get data from source position
			LD	C,A
			CALL BWAIT
			LD	A,B
			OR	080H
			CALL LCDWRCMD		; set addr counter to target position
			CALL BWAIT
			LD	A,C
			CALL LCDWRDAT		; put data in target position
			CALL BWAIT
			LD	A,B
			OR	0C0H
			CALL LCDWRCMD		; set addr counter back to source position
			CALL BWAIT
			LD	A,SPACE
			CALL LCDWRDAT		; put blank space in source position
			INC	B
			LD	A,B
			SUB	010H
			JR	NZ,NEWSRC

LINEONE:	LD	DE,0201H
			CALL LCDPOS

			POP	BC
			RET

;================================================================================================
; ROUTINES FOR READ/WRITE DATA/COMMAND.
;================================================================================================
LCDWRDAT:	LD	C,(DAT_WR)
			OUT	(C),A
			RET

LCDDRDAT:	LD	C,(DAT_RD)
			IN	A,(C)
			RET

LCDWRCMD:	LD	C,(CMD_WR)
			OUT	(C),A
			RET

LCDRDCMD:	LD	C,(CMD_RD)
			IN	A,(C)
			RET




;================================================================================================
LCD_ADDR	.DB	0
DAT_WR		.DB	0			;
DAT_RD		.DB	0			;
CMD_WR		.DB	0			;
CMD_RD		.DB	0			;



			.END
