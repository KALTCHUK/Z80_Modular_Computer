;==================================================================================
; Read chars coming from console and echo them back
;
;
;==================================================================================

; USART stuff
USART_DAT		.EQU	0D0H		; USART data addr
USART_CMD		.EQU	0D1H		; USART command addr
USART_STA		.EQU	0D1H		; USART status addr
UMODE			.EQU	06FH		; 8N1 (8 bit, no parity, 1 stop), baud=clock/64
UCMD0			.EQU	015H		; initial command: Rx enable, Tx enable, reset error flags

;================================================================================================
			.ORG 0
		JP	BOOT

			.ORG	038H
;================================================================================================
; Interrupt routine called by USART
;================================================================================================
UINT:
		PUSH	BC
		PUSH	HL

		IN	A,(USART_DAT)		; read incoming byte
		OUT	(USART_DAT),A		; send character
		LD	BC,(WRPTR)
		LD	(BC),A
		INC	BC
		LD	HL,BUFEND
		SCF
		CCF
		SBC	HL,BC
		JR	NZ,EOINT
		LD	BC,BUFINI
EOINT:	LD	(WRPTR),BC

		POP	HL
		POP	BC
		IM	1
		EI
		RETI

;================================================================================================
; Cold boot (/RESET = --\___/--)
;================================================================================================

BOOT:
		DI					; Disable interrupts.
		LD	SP,BIOSSTACK

		CALL USARTINIT

		IM	1
		EI

;================================================================================================
; Start Xmitting
;================================================================================================
LOOP:		NOP
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
			.ORG	04000H		; RAM starts here
BUFINI		.EQU	$
			.DS	050H
BUFEND		.EQU	$
WRPTR:		.DS	2			; write pointer
RDPTR:		.DS	2			; read pointer
			.DS	020h			; Start of BIOS stack area.
BIOSSTACK:		.EQU	$
			.END
