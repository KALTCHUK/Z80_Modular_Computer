;==================================================================================
; Xmit chars to console and LCD
;
; A
; BB
; CCC
; DDDD
; ...
; OOOOOOOOOOOOOOO
; PPPPPPPPPPPPPPPP
;
; one second interval between each line and repeat
;
; ******** Tested successfuffy with CPU_clk = 4MHz and 8251_clk = 2MHz ********
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

READCOLS		.EQU	010H		; parameters used for read memory command (READCMD)
READLINES		.EQU	010H

EON			.EQU	01H		; console echo on
;================================================================================================
			.ORG 0
;================================================================================================
; Cold boot (/RESET = --\___/--)
;================================================================================================

BOOT:
		DI					; Disable interrupts.
		LD	SP,MSTACK
		LD	B,1
		CALL	DELAYS
		CALL USARTINIT
		LD	B,3				; wait 3sec till Arduino is ready
		CALL	DELAYS

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

;		LD	C,LF
;		CALL	UPUT
		LD	C,CR
		CALL	UPUT

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
		LD 	A,06DH			; Set USART mode
		OUT	(USART_CMD),A
		LD 	A,015H			; Set USART initial command
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
			.DS	020h			; Start of Monitor stack area.
MSTACK		.EQU	$
		.END
