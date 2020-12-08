; 0200h: Routine to initialize LCD 16x2
; 02E0h: LCDBUF. [02E0; 02EF] is 1st line, [02F0; 02FF] is 2nd line.
; 0300h: Routine to write content of LCDBUF to LCD
;
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

WAITCMD	.EQU	????			; return address inside kmonitor

;================================================================================================
;================================================================================================

		.ORG	0200h
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
		LD	C,20			; wait (5x20) 100us
		CALL	DELAY5US
		LD	A,030H		; write command 030h
		OUT	(CMD_WR),A
		LD	C,20			; wait (5x20) 100us
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

		LD	HL,INIMSG		; copy initial message to LCDBUF
		LD	DE,LCDBUF
		LD	B,32
		LDIR

		JP	LCDWRITE	

		.ORG	02E0h
LCDBUF	.EQU	$


;================================================================================================
;================================================================================================

		.ORG	0300h
;================================================================================================
; Wtite to LCD.
;================================================================================================
LCDWRITE:
		LD	A,080h		; position cursor at the beginning of 1st line
		OUT	(CMD_WR),A
		LD	B,16			; send 16 bytes (1st half of LCDBUF) to LCD
		LD	DE,LCDBUF
NXT:		CALL	BWAIT
		LD	A,(DE)
		OUT	(DAT_WR),A
		INC	DE
		DJNZ	NXT		

		LD	A,0C0h		; position cursor at the beginning of 2nd line
		OUT	(CMD_WR),A
		LD	B,16			; send 16 bytes (2nd half of LCDBUF) to LCD
NXT2:		CALL	BWAIT
		LD	A,(DE)
		OUT	(DAT_WR),A
		INC	DE
		DJNZ	NXT2		

		JP	WAITCMD

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
INIMSG:	.TEXT	"Z80 Modular Comp"
		.TEXT	"LCD initialized "

		.END
