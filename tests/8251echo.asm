;==================================================================================
; Xmit chars to console, read the echo and send to LCD. The echo is provided by:
;
;	- connect pins 2 (RX) and 3 (TX) on the DB9 or,		<-------------------------+
;	- remove IC MAX232 and connect pins TxD and RxD from 8251.					|
;																|
; 8251 is supposed to work on full-duplex mode, so is should be able to perform		|
; this task.														|
;																|
; Sequence that is xmitted:											|
;																|
; A																|
; BB																|
; CCC																|
; DDDD															|
; ...																|
; OOOOOOOOOOOOOOO													|
; PPPPPPPPPPPPPPPP													|
;																|
; one second interval between each line and repeat.							|
;																|
; ******** Tested successfuffy with CPU_clk = 4MHz and 8251_clk = 2MHz ******** -----+
;==================================================================================

; USART stuff
USART_DAT		.EQU	0D0H		; USART data addr
USART_CMD		.EQU	0D1H		; USART command addr
USART_STA		.EQU	0D1H		; USART status addr
UMODE			.EQU	06DH		; 8N1 (8 bit, no parity, 1 stop), baud=clock (9600bps)
UCMD0			.EQU	015H		; initial command: Rx enable, Tx enable, reset error flags

LF			.EQU	0AH		; line feed
FF			.EQU	0CH		; form feed
CR			.EQU	0DH		; carriage return
SPACE			.EQU	020H		; space
COLON			.EQU	03AH		; colon

EON			.EQU	0		; console echo off

; LCD issues...
; CPU @ 4.0MHz (this is important for the delay routines)
;
; RS  = A0 from CPU
; R/W = A1 from CPU
; E   = 74LS85 output pin 'A=B'
;  

LCD_DAT_WR		.EQU	0E1H		; LCD data write addr
LCD_DAT_RD		.EQU	0E3H		; LCD data read addr 
LCD_CMD_WR		.EQU	0E0H		; LCD command write addr
LCD_CMD_RD		.EQU	0E2H		; LCD command read addr

;================================================================================================
			.ORG 0
		JP	BOOT

			.ORG	038H
;================================================================================================
; Interrupt routine called by USART
;================================================================================================
UINT:
		IN	A,(USART_DAT)		; read incoming byte
		LD	C,A
		CALL	LCDPUT

		IM	1
		EI
		RETI

;================================================================================================
; Cold boot (/RESET = --\___/--)
;================================================================================================

BOOT:
		DI					; Disable interrupts.
		LD	SP,MSTACK

		CALL USARTINIT

		CALL	LCDINIT
		CALL LCDCLEAR
		CALL	LCDPRINT
		.TEXT	"  Z80  Modular  "
		.DB	0
		LD	HL,0201H
		CALL	LCDPOS
		CALL	LCDPRINT
		.TEXT	"    Computer    "
		.DB	0

		LD	B,5				; wait 5sec till Arduino is ready
		CALL	DELAYS
		CALL LCDCLEAR

		IM	1
		EI

;================================================================================================
; Start Xmitting
;================================================================================================
LOOP:		LD	D,0
NEXTD:	INC	D
		LD	A,D
		ADD	A,040H
		LD	C,A

		LD	B,D	
NEXTB:	CALL	UPUT
		DJNZ	NEXTB

		LD	B,1
		CALL	DELAYS

		CALL LCDCLEAR

		LD	A,D
		CP	16
		JR	NZ,NEXTD

		JR	LOOP

;================================================================================================
; Initialize USART
;================================================================================================
USARTINIT:
		LD 	A,0				; Worst case init: put in SYNC mode, send 2 dummy 00 sync chars and reset
		OUT	(USART_CMD),A
		NOP
		OUT	(USART_CMD),A
		NOP
		OUT	(USART_CMD),A
		LD 	A,040H			; Reset USART
		OUT	(USART_CMD),A
		LD 	A,UMODE			; Set USART mode
		OUT	(USART_CMD),A
		LD 	A,UCMD0			; Set USART initial command
		OUT	(USART_CMD),A
		RET

;================================================================================================
; Put reg C character on USART
;================================================================================================
UPUT:
		IN	A,(USART_STA)		; read USART status byte
		AND	04H				; get only the TxEMPTY bit
		JR	Z,UPUT
		LD	A,C
		OUT	(USART_DAT),A		; send character
		RET

;================================================================================================
; Initialize LCD
;================================================================================================
LCDINIT:
		LD	B,15			; wait 15ms
		CALL	DELAYMS
		LD	A,030H		; write command 030h
		OUT	(LCD_CMD_WR),A
		LD	B,5			; wait 5ms
		CALL	DELAYMS
		LD	A,030H		; write command 030h
		OUT	(LCD_CMD_WR),A
		LD	C,20			; wait (5X20) 100us
		CALL	DELAY5US
		LD	A,030H		; write command 030h
		OUT	(LCD_CMD_WR),A
		LD	C,20			; wait (5X20) 100us
		CALL	DELAY5US
		LD	A,038H		; write command 038h = function set (8-bits, 2-lines, 5x7dots)
		OUT	(LCD_CMD_WR),A
		CALL	BWAIT	
		LD	A,08H			; write command 08h = display (off)
		OUT	(LCD_CMD_WR),A
		CALL	BWAIT
		LD	A,01H			; write command 01h = clear display
		OUT	(LCD_CMD_WR),A
		CALL	BWAIT	
		LD	A,06H			; write command 06h = entry mode (increment)
		OUT	(LCD_CMD_WR),A
		CALL	BWAIT
		LD	A,0CH			; write command 0Ch = display (on)
		OUT	(LCD_CMD_WR),A
		RET

;================================================================================================
; Clear LCD and goto line 1, column 1.
;================================================================================================
LCDCLEAR:
		CALL	BWAIT
		LD	A,01H			; write command 01h = clear display
		OUT	(LCD_CMD_WR),A
		RET

;================================================================================================
; Send to LCD char in regC. Print at current position (what ever it is)
;================================================================================================
LCDPUT:
		CALL	BWAIT
		LD	A,C			; write command 01h = clear display
		OUT	(LCD_DAT_WR),A
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
		OUT	(LCD_CMD_WR),A
		RET

;================================================================================================
; Wait until Busy flag = 0
;================================================================================================
BWAIT:	IN A,(LCD_CMD_RD)
		RLCA
		JR	C,BWAIT
		RET

;================================================================================================
; Send to LCD a sequence of characters ending with zero
;================================================================================================
LCDPRINT:
		EX 	(SP),HL 		; Push HL and put RET address into HL
		PUSH 	AF
		PUSH 	BC
NEXTLCHAR:
		LD 	A,(HL)
		CP	0
		JR	Z,EOLPRINT
		LD	C,A
		CALL	BWAIT
		LD	A,C
		OUT	(LCD_DAT_WR),A
		INC 	HL
		JR	NEXTLCHAR
EOLPRINT:
		INC 	HL 			; Get past "null" terminator
		POP 	BC
		POP 	AF
		EX 	(SP),HL 		; Push new RET address on stack and restore HL
		RET

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
			.ORG	04000H		; RAM starts here
BUFLEN		.EQU	050H			; buffer length
			.DS	BUFLEN
WRPTR:		.DB	0			; write pointer
RDPTR:		.DB	0			; read pointer
ECHO:			.DB	EON			; if ECHO=1, all incoming chars will be echoed back
			.DS	020h			; Start of Monitor stack area.
MSTACK		.EQU	$
		.END
