;==================================================================================
; Customized CP/M BIOS for Z80 Modular Computer by P.R.Kaltchuk 2020
; This version has no disk, only ROM and RAM.
;==================================================================================

CCP			.EQU	0D000h		; Base of CCP.
BIOS			.EQU	0E600h		; Base of BIOS.
ROM_CCP		.EQU	01000h		; Base of CCP in ROM
ROM_BIOS		.EQU	02600h		; Base of BIOS in ROM
BDOS_PTR		.EQU	BIOS-2		; pointer to BDOS entry point.

; Set CP/M page 0, vector and buffer addresses.

IOBYTE		.EQU	03h			; Intel standard I/O definition byte.
USERDRV		.EQU	04h			; Current user number and drive.
TPABUF		.EQU	80h			; Default I/O buffer and command line storage.

; Memory card stuff
ROM_RAM0		.EQU	0F0H			; ROM + RAM bank 0
NOROM_RAM0		.EQU	0F1H			; no ROM + RAM bank 0 (full RAM)
ROM_RAM1		.EQU	0F2H			; ROM + RAM bank 1
NOROM_RAM1		.EQU	0F3H			; no ROM + RAM bank 1 (full RAM)

; USART card stuff
USART_DAT		.EQU	0D0H			; USART data addr
USART_CMD		.EQU	0D1H			; USART command addr
USART_STA		.EQU	0D1H			; USART status addr
UMODE			.EQU	06FH			; 8N1 (8 bit, no parity, 1 stop), baud=clock/64
UCMD0			.EQU	015H			; initial command: Rx enable, Tx enable, reset error flags

LF			.EQU	0AH			;line feed
FF			.EQU	0CH			;form feed
CR			.EQU	0DH			;carriage RETurn

;================================================================================================

			.ORG	BIOS			; BIOS origin.

;================================================================================================
; BIOS jump table.
;================================================================================================
		JP	BOOT				;  0 Initialize.
WBOOTE:	JP	WBOOT				;  1 Warm boot.
		JP	CONST				;  2 Console status.
		JP	CONIN				;  3 Console input.
		JP	CONOUT			;  4 Console OUTput.
		JP	LIST				;  5 List OUTput.
		JP	PUNCH				;  6 Punch OUTput.
		JP	READER			;  7 Reader input.
		JP	HOME				;  8 Home disk.
		JP	SELDSK			;  9 Select disk.
		JP	SETTRK			; 10 Select track.
		JP	SETSEC			; 11 Select sector.
		JP	SETDMA			; 12 Set DMA ADDress.
		JP	READ				; 13 Read 128 bytes.
		JP	WRITE				; 14 Write 128 bytes.
		JP	LISTST			; 15 List status.
		JP	SECTRAN			; 16 Sector translate.

;================================================================================================
; Cold boot (/RESET = --\___/--)
;================================================================================================

BOOT:
		DI					; Disable interrupts.
		LD	SP,BIOSSTACK		; Set default stack.

; Turn off ROM
		OUT (NOROM_RAM0),A		; doesn't matter what we output

		CALL USARTINIT			; Initialize USART

		LD	BC,BUFINI			; Initialize pointers for USART buffer
		LD	(WRPTR),BC
		LD	(RDPTR),BC

		CALL	PRINTSEQ
		.TEXT "Z80 Modular Computer BIOS 1.0 by Kaltchuk 2020"
		.DB CR,LF
;		.TEXT "*** This version does NOT support disk functions ***"
;		.DB CR,LF
;		.DB CR,LF
;		.TEXT "CP/M 2.2 "
;		.TEXT	"Copyright"
;		.TEXT	" 1979 (c) by Digital Research"
;		.DB CR,LF
		.DB CR,LF,0

		JP	GOCPM

;================================================================================================
; Warm boot (no CPU reset)
;================================================================================================

WBOOT:
		DI					; Disable interrupts.
		LD	SP,BIOSSTACK		; Set default stack.

; Turn on ROM
		OUT (ROM_RAM0),A		; doesn't matter what we output
							; as long as we use this address

		LD	BC,BIOS-CCP		; Copy CP/M (01600h bytes) from ROM (01000h) to RAM (0D000h)
		LD	DE,CCP
		LD	HL,ROM_CCP
		LDIR

; Turn off ROM
		OUT (NOROM_RAM0),A		; doesn't matter what we output

;================================================================================================
; Common code for cold and warm boot
;================================================================================================

GOCPM:
		LD	A,0C3h			; Opcode for 'JP'.
		LD	(00h),A			; Load at start of RAM.
		LD	HL,WBOOTE			; Address of jump for a warm boot.
		LD	(01h),HL
		LD	(05h),A			; Opcode for 'JP'.
		LD	HL,(BDOS_PTR)		; Address of jump for the BDOS (entry point).
		LD	(06h),HL
		LD	(038H),A			; at 038h write "JP UINT"
		LD	HL,UINT			; which is the interrupt routine to catch incoming
		LD	(039H),HL			; character on the USART
		LD	A,(USERDRV)		; Save new drive number (0).
		LD	C,A				; Pass drive number in C.

		JP	CCP				; Start CP/M by jumping to the CCP.

;================================================================================================
; Console Status (Return A=0FFh if character waiting. Otherwise, A=0)
;================================================================================================
CONST:
		PUSH	BC
		PUSH	HL
		LD	BC,(WRPTR)
		LD	HL,(RDPTR)
		XOR	A
		SBC	HL,BC
		JR	Z,CONVOID
		LD	A,0FFH
CONVOID:
		POP	HL
		POP	BC
	  	RET

;================================================================================================
; Console Input (Wait for input and return character in A)
;================================================================================================
CONIN:
		PUSH	BC
		PUSH	HL
AGAIN:	CALL	CONST
		CP	0
		JR	Z,AGAIN			; Keep trying till we receive something
		LD	BC,(RDPTR)
		LD	A,(BC)
		INC	BC
		LD	HL,BUFEND
		SCF
		CCF
		SBC	HL,BC
		JR	NZ,EOCONIN
		LD	BC,BUFINI
EOCONIN:	LD	(RDPTR),BC
		POP	HL
		POP	BC
		RET					; Char read returns in A

;================================================================================================
; Console Output (Send character in reg C)
;================================================================================================
CONOUT:
		IN	A,(USART_STA)		; read USART status byte
		AND	04H				; get only the TxEMPTY bit
		JR	Z,CONOUT
		LD	A,C
		OUT	(USART_DAT),A		; send character
		RET

;================================================================================================
; Reader Input
;================================================================================================
READER:	JP CONIN

;================================================================================================
; List Output
;================================================================================================
LIST:		JP CONOUT

;================================================================================================
; Punch Output
;================================================================================================
PUNCH:	JP CONOUT

;================================================================================================
; List Status (List = Console)
;================================================================================================
LISTST:	IN	A,(USART_CMD)
		AND	00000001b			; Get the TxReady bit
		JR	NZ,LISTVOID
		LD	A,0FFh
		RET
LISTVOID:	LD	A,0
		RET

;================================================================================================
; Disk processing entry points
;================================================================================================

SELDSK:
		RET

;------------------------------------------------------------------------------------------------
CHGDSK:
		RET

;------------------------------------------------------------------------------------------------
HOME:
		RET
;------------------------------------------------------------------------------------------------
SETTRK:
		RET

;------------------------------------------------------------------------------------------------
SETSEC:
		RET

;------------------------------------------------------------------------------------------------
SETDMA:
		RET

;------------------------------------------------------------------------------------------------
SECTRAN:
		RET

;------------------------------------------------------------------------------------------------
READ:
		RET

;------------------------------------------------------------------------------------------------
WRITE:
		RET

;================================================================================================
; Interrupt routine for USART
;================================================================================================
UINT:
		PUSH	BC
		PUSH	HL

		IN	A,(USART_DAT)		; fetch the character
		AND	01111111b			; Zero msb (we use 7 bit ASCII)
		LD	C,A
		CALL	CONOUT			; echo the incoming character
		LD	A,C
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
; Print (on console) a sequence of characters ending with zero
;================================================================================================
PRINTSEQ:
		EX 	(SP),HL 		; Push HL and put RET address into HL
		PUSH 	AF
		PUSH 	BC
NEXTCHAR:
		LD 	A,(HL)
		CP	0
		JR	Z,ENDOFPRINT
		LD  	C,A
		CALL 	CONOUT		; Print to console
		INC 	HL
		JR	NEXTCHAR
ENDOFPRINT:
		INC 	HL 			; Get past "null" terminator
		POP 	BC
		POP 	AF
		EX 	(SP),HL 		; Push new RET address on stack and restore HL
		RET

;================================================================================================
BUFINI	.EQU	$
		.DS	050H
BUFEND	.EQU	$
WRPTR:	.DS	2			; write pointer
RDPTR:	.DS	2			; read pointer
		.DS	020h			; Start of BIOS stack area.
BIOSSTACK:	.EQU	$

		.END

