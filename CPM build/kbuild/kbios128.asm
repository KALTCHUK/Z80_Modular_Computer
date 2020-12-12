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

BLKSIZ		.EQU	4096			;CP/M allocation size
HSTSIZ		.EQU	512			;host disk sector size
HSTSPT		.EQU	32			;host disk sectors/trk
HSTBLK		.EQU	HSTSIZ/128		;CP/M sects/host buff
CPMSPT		.EQU	HSTBLK * HSTSPT	;CP/M sectors/track
SECMSK		.EQU	HSTBLK-1		;sector mask
							;compute sector mask
;secshf		.EQU	2			;log2(HSTBLK)

WRALL			.EQU	0			;write to allocated
WRDIR			.EQU	1			;write to directory
WRUAL			.EQU	2			;write to unallocated

FLASH_ADDR		.EQU	0B0H			; Base I/O address for compact flash card
; CF registers
CF_DATA		.EQU	(FLASH_ADDR+0)
CF_FEATURES	.EQU	(FLASH_ADDR+1)
CF_ERROR		.EQU	(FLASH_ADDR+1)
CF_SECCOUNT	.EQU	(FLASH_ADDR+2)
CF_SECTOR		.EQU	(FLASH_ADDR+3)
CF_CYL_LOW		.EQU	(FLASH_ADDR+4)
CF_CYL_HI		.EQU	(FLASH_ADDR+5)
CF_HEAD		.EQU	(FLASH_ADDR+6)
CF_STATUS		.EQU	(FLASH_ADDR+7)
CF_COMMAND		.EQU	(FLASH_ADDR+7)
CF_LBA0		.EQU	(FLASH_ADDR+3)
CF_LBA1		.EQU	(FLASH_ADDR+4)
CF_LBA2		.EQU	(FLASH_ADDR+5)
CF_LBA3		.EQU	(FLASH_ADDR+6)

;CF Features
CF_8BIT		.EQU	1
CF_NOCACHE		.EQU	082H

;CF Commands
CF_READ_SEC	.EQU	020H
CF_WRITE_SEC	.EQU	030H
CF_SET_FEAT	.EQU 	0EFH

LF			.EQU	0AH		;line feed
FF			.EQU	0CH		;form feed
CR			.EQU	0DH		;carriage RETurn

;================================================================================================

			.ORG	BIOS		; BIOS origin.

;================================================================================================
; BIOS jump table.
;================================================================================================
		JP	BOOT			;  0 Initialize.
WBOOTE:	JP	WBOOT			;  1 Warm boot.
		JP	CONST			;  2 Console status.
		JP	CONIN			;  3 Console input.
		JP	CONOUT		;  4 Console OUTput.
		JP	LIST			;  5 List OUTput.
		JP	PUNCH			;  6 Punch OUTput.
		JP	READER		;  7 Reader input.
		JP	HOME			;  8 Home disk.
		JP	SELDSK		;  9 Select disk.
		JP	SETTRK		; 10 Select track.
		JP	SETSEC		; 11 Select sector.
		JP	SETDMA		; 12 Set DMA ADDress.
		JP	READ			; 13 Read 128 bytes.
		JP	WRITE			; 14 Write 128 bytes.
		JP	LISTST		; 15 List status.
		JP	SECTRAN		; 16 Sector translate.
		JP	PRINTSEQ		; not a BIOS function

;================================================================================================
; Disk parameter headers for disk 0 to 15
;================================================================================================
DPBASE:
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB0,0000h,ALV00
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV01
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV02
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV03
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV04
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV05
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV06
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV07
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV08
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV09
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV10
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV11
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV12
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV13
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB,0000h,ALV14
	 	.DW 0000h,0000h,0000h,0000h,DIRBUF,DPB15,0000h,ALV15

; First drive has a reserved track for CP/M
DPB0:
		.DW 128 	;SPT - sectors per track
		.DB 5   	;BSH - block shift factor
		.DB 31  	;BLM - block mask
		.DB 1   	;EXM - Extent mask
		.DW 2043	; (2047-4) DSM - Storage size (blocks - 1)
		.DW 511 	;DRM - Number of directory entries - 1
		.DB 240 	;AL0 - 1 bit set per directory block
		.DB 0   	;AL1 -            "
		.DW 0   	;CKS - DIR check vector size (DRM+1)/4 (0=fixed disk)
		.DW 1   	;OFF - Reserved tracks

DPB:
		.DW 128 	;SPT - sectors per track
		.DB 5   	;BSH - block shift factor
		.DB 31  	;BLM - block mask
		.DB 1   	;EXM - Extent mask
		.DW 2047	;DSM - Storage size (blocks - 1)
		.DW 511 	;DRM - Number of directory entries - 1
		.DB 240 	;AL0 - 1 bit set per directory block
		.DB 0   	;AL1 -            "
		.DW 0   	;CKS - DIR check vector size (DRM+1)/4 (0=fixed disk)
		.DW 0   	;OFF - Reserved tracks

; Last drive is smaller because CF is never full 64MB OR 128MB
DPB15:
		.DW 128 	;SPT - sectors per track
		.DB 5   	;BSH - block shift factor
		.DB 31  	;BLM - block mask
		.DB 1   	;EXM - Extent mask
		.DW 511 	;DSM - Storage size (blocks - 1)  ; 511 = 2MB (for 128MB card), 1279 = 5MB (for 64MB card)
		.DW 511 	;DRM - Number of directory entries - 1
		.DB 240 	;AL0 - 1 bit set per directory block
		.DB 0   	;AL1 -            "
		.DW 0   	;CKS - DIR check vector size (DRM+1)/4 (0=fixed disk)
		.DW 0   	;OFF - Reserved tracks

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
		.DB CR,LF,CR,LF
		.TEXT "CP/M 2.2 Copyright 1979 (c) by Digital Research"
		.DB CR,LF,CR,LF,0

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

		LD	BC,BIOS-CCP		; Copy Monitor from ROM (01000h) to RAM (0D000h)
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
; Interrupt routine for USART
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
; Initialize USART
;================================================================================================
USARTINIT:
		LD 	A,0				; Worst case init: put in SYNC mode, 
		OUT	(USART_CMD),A		; send 2 dummy 00 sync chars and reset
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
		JR	Z,listvoid
		LD	A,0FFh
listvoid:	RET


; *** DISK STUFF STARTS HERE ***
;================================================================================================
; Disk processing entry points
;================================================================================================
SELDSK:
		LD	HL,$0000
		LD	A,C
		CP	16			; 16 for 128MB disk, 8 for 64MB disk
		JR	C,CHGDSK		; if invalid drive will give BDOS error
		LD	A,(USERDRV)	; so set the drive back to a:
		CP	C			; If the default disk is not the same as the
		RET	NZ			; selected drive then return, 
		XOR	A			; else reset default back to a:
		LD	(USERDRV),A	; otherwise will be stuck in a loop
		LD	(SEKDSK),A
		RET

CHGDSK:	LD 	(SEKDSK),A
		RLC	A			;*2
		RLC	A			;*4
		RLC	A			;*8
		RLC	A			;*16
		LD 	HL,DPBASE
		LD	B,0
		LD	C,A	
		ADD	HL,BC

		RET

;------------------------------------------------------------------------------------------------
HOME:
		LD	A,(HSTWRT)		;check for pending write
		OR	A
		JR	NZ,HOMED
		LD	(HSTACT),a		;clear host active flag
HOMED:
		LD 	BC,0000h

;------------------------------------------------------------------------------------------------
SETTRK:	LD 	(SEKTRK),BC	; Set track passed from BDOS in register BC.
		RET

;------------------------------------------------------------------------------------------------
SETSEC:	LD 	(SEKSEC),BC	; Set sector passed from BDOS in register BC.
		RET

;------------------------------------------------------------------------------------------------
SETDMA:	LD 	(DMAADDR),BC	; Set DMA ADDress given by registers BC.
		RET

;------------------------------------------------------------------------------------------------
SECTRAN:	PUSH 	BC
		POP 	HL
		RET

;------------------------------------------------------------------------------------------------
READ:
		;read the selected CP/M sector
		XOR	A
		LD	(UNACNT),A
		LD	A,1
		LD	(READOP),A		;read operation
		LD	(RSFLAG),A		;must read data
		LD	A,WRUAL
		LD	(WRTYPE),A		;treat as unalloc
		JP	RWOPER		;to perform the read


;------------------------------------------------------------------------------------------------
WRITE:
		;write the selected CP/M sector
		XOR	A			;0 to accumulator
		LD	(READOP),A		;not a read operation
		LD	A,C			;write type in c
		LD	(WRTYPE),A
		CP	WRUAL			;write unallocated?
		JR	NZ,CHKUNA		;check for unalloc
;
;		write to unallocated, set parameters
		LD	A,BLKSIZ/128	;next unalloc recs
		LD	(UNACNT),A
		LD	A,(SEKDSK)		;disk to seek
		LD	(UNADSK),A		;UNADSK = SEKDSK
		LD	HL,(SEKTRK)
		LD	(UNATRK),HL	;UNATRK = sectrk
		LD	A,(SEKSEC)
		LD	(UNASEC),A		;UNASEC = SEKSEC
;
CHKUNA:
;		check for write to unallocated sector
		LD	A,(UNACNT)		;any unalloc remain?
		OR	A	
		JR	Z,ALLOC		;skip if not
;
;		more unallocated records remain
		DEC	A			;UNACNT = UNACNT-1
		LD	(UNACNT),A
		LD	A,(SEKDSK)		;same disk?
		LD	HL,UNADSK
		CP	(HL)			;SEKDSK = UNADSK?
		JP	NZ,ALLOC		;skip if not
;
;		disks are the same
		LD	HL,UNATRK
		CALL	SEKTRKCMP		;SEKTRK = UNATRK?
		JP	NZ,ALLOC		;skip if not
;
;		tracks are the same
		LD	A,(SEKSEC)		;same sector?
		LD	HL,UNASEC
		CP	(HL)			;SEKSEC = UNASEC?
		JP	NZ,ALLOC		;skip if not
;
;		match, move to next sector for future ref
		INC	(HL)			;UNASEC = UNASEC+1
		LD	A,(HL)		;end of track?
		CP	CPMSPT		;count CP/M sectors
		JR	C,NOOVF		;skip if no overflow
;
;		overflow to next track
		LD	(HL),0		;UNASEC = 0
		LD	HL,(UNATRK)
		INC	HL
		LD	(UNATRK),HL	;UNATRK = UNATRK+1
;
NOOVF:
		;match found, mark as unnecessary read
		XOR	A			;0 to accumulator
		LD	(RSFLAG),A		;RSFLAG = 0
		JR	RWOPER		;to perform the write
;
ALLOC:
		;not an unallocated record, requires pre-read
		XOR	A			;0 to accum
		LD	(UNACNT),A		;UNACNT = 0
		INC	A			;1 to accum
		LD	(RSFLAG),A		;RSFLAG = 1

;------------------------------------------------------------------------------------------------
RWOPER:
		;enter here to perform the read/write
		XOR	A			;zero to accum
		LD	(ERFLAG),A		;no errors (yet)
		LD	A,(SEKSEC)		;compute host sector
		OR	A			;carry = 0
		RRA				;shift right
		OR				;carry = 0
		RRA				;shift right
		LD	(SEKHST),A		;host sector to seek
;
;		active host sector?
		LD	HL,HSTACT		;host active flag
		LD	A,(HL)
		LD	(HL),1		;always becomes 1
		OR	A			;was it already?
		JR	Z,FILHST		;fill host if not
;
;		host buffer active, same as seek buffer?
		LD	A,(SEKDSK)
		LD	HL,HSTDSK		;same disk?
		CP	(HL)			;SEKDSK = HSTDSK?
		JR	NZ,NOMATCH
;
;		same disk, same track?
		LD	HL,HSTTRK
		CALL	SEKTRKCMP		;SEKTRK = HSTTRK?
		JR	NZ,NOMATCH
;
;		same disk, same track, same buffer?
		LD	A,(SEKHST)
		LD	HL,HSTSEC		;SEKHST = HSTSEC?
		CP	(HL)
		JR	Z,MATCH		;skip if MATCH
;
NOMATCH:
		;proper disk, but not correct sector
		LD	A,(HSTWRT)		;host written?
		OR	A
		CALL	NZ,WRITEHST	;clear host buff
;
FILHST:
		;may have to fill the host buffer
		LD	A,(SEKDSK)
		LD	(HSTDSK),A
		LD	HL,(SEKTRK)
		LD	(HSTTRK),HL
		LD	A,(SEKHST)
		LD	(HSTSEC),A
		LD	A,(RSFLAG)		;need to read?
		OR	A
		CALL	NZ,READHST		;yes, if 1
		XOR	A			;0 to accum
		LD	(HSTWRT),A		;no pending write
;
MATCH:
		;copy data to OR from buffer
		LD	A,(SEKSEC)		;mask buffer number
		and	SECMSK		;least signif bits
		LD	L,A			;ready to shift
		LD	H,0			;double count
		ADD	HL,HL
		ADD	HL,HL
		ADD	HL,HL
		ADD	HL,HL
		ADD	HL,HL
		ADD	HL,HL
		ADD	HL,HL
;		HL has relative host buffer address
		LD	DE,HSTBUF
		ADD	HL,DE			;HL = host address
		EX	DE,HL			;now in DE
		LD	HL,(DMAADDR)	;get/put CP/M data
		LD	C,128			;length of move
		LD	A,(READOP)		;which way?
		OR	A
		JR	NZ,RWMOVE		;skip if read
;
;	write operation, mark and switch direction
		LD	A,1
		LD	(HSTWRT),A		;HSTWRT = 1
		EX	DE,HL			;source/dest swap
;
RWMOVE:
		;C initially 128, DE is source, HL is dest
		LD	A,(DE)		;source character
		INC	DE
		LD	(HL),A		;to dest
		INC	HL
		DEC	C			;loop 128 times
		JR	NZ,RWMOVE
;
;		data has been moved to/from host buffer
		LD	A,(WRTYPE)		;write type
		CP	WRDIR			;to directory?
		LD	A,(ERFLAG)		;in case of errors
		RET	NZ			;no further processing
;
;		clear host buffer for directory write
		OR	A			;errors?
		RET	NZ			;skip if so
		XOR	A			;0 to accum
		LD	(HSTWRT),A		;buffer written
		CALL	WRITEHST
		LD	A,(ERFLAG)
		RET

;------------------------------------------------------------------------------------------------
;Utility subroutine for 16-bit compare
SEKTRKCMP:
		;HL = .UNATRK OR .HSTTRK, compare with SEKTRK
		EX	DE,HL
		LD	HL,SEKTRK
		LD	A,(DE)		;low byte compare
		CP	(HL)			;same?
		RET	NZ			;return if not
;		low bytes equal, test high 1s
		INC	DE
		INC	HL
		LD	A,(DE)
		CP	(HL)			;sets flags
		RET

;================================================================================================
; Convert track/head/sector into LBA for physical access to the disk
;================================================================================================
SETLBAADDR:	
		LD	HL,(HSTTRK)
		RLC	L
		RLC	L
		RLC	L
		RLC	L
		RLC	L
		LD	A,L
		AND	0E0h
		LD	L,A
		LD	A,(HSTSEC)
		ADD	A,L
		LD	(LBA0),A

		LD	HL,(HSTTRK)
		RRC	L
		RRC	L
		RRC	L
		LD	A,L
		AND	01Fh
		LD	L,A
		RLC	H
		RLC	H
		RLC	H
		RLC	H
		RLC	H
		LD	A,H
		AND	020h
		LD	H,A
		LD	A,(HSTDSK)
		RLC	A
		RLC	A
		RLC	A
		RLC	A
		RLC	A
		RLC	A
		AND	0C0h
		ADD	A,H
		ADD	A,L
		LD	(LBA1),A
		

		LD	A,(HSTDSK)
		RRC	A
		RRC	A
		AND	03h
		LD	(LBA2),A

; LBA Mode using drive 0 = E0
		LD	A,0E0H
		LD	(LBA3),A


		LD	A,(LBA0)
		OUT 	(CF_LBA0),A

		LD	A,(LBA1)
		OUT 	(CF_LBA1),A

		LD	A,(LBA2)
		OUT 	(CF_LBA2),A

		LD	A,(LBA3)
		OUT 	(CF_LBA3),A

		LD 	A,1
		OUT 	(CF_SECCOUNT),A

		RET				

;================================================================================================
; Read physical sector from host
;================================================================================================
READHST:
		PUSH 	AF
		PUSH 	BC
		PUSH 	HL

		CALL 	CFWAIT

		CALL 	SETLBAADDR

		LD 	A,CF_READ_SEC
		OUT 	(CF_COMMAND),A

		CALL 	CFWAIT

		LD 	C,4
		LD 	HL,HSTBUF
RD4SECS:
		LD 	B,128
RDBYTE:
		in 	A,(CF_DATA)
		LD 	(HL),A
		iNC 	HL
		DEC 	B
		JR 	NZ, RDBYTE
		DEC 	C
		JR 	NZ,RD4SECS

		POP 	HL
		POP 	BC
		POP 	AF

		XOR 	A
		LD	(ERFLAG),A
		RET

;================================================================================================
; Write physical sector to host
;================================================================================================
WRITEHST:
		PUSH 	AF
		PUSH 	BC
		PUSH 	HL

		CALL 	CFWAIT

		CALL 	SETLBAADDR

		LD 	A,CF_WRITE_SEC
		OUT 	(CF_COMMAND),A

		CALL 	CFWAIT

		LD 	C,4
		LD 	HL,HSTBUF
WR4SECS:
		LD 	B,128
WRBYTE:	LD 	A,(HL)
		OUT 	(CF_DATA),A
		INC 	HL
		DEC 	B
		JR 	NZ, WRBYTE

		DEC 	C
		JR 	NZ,WR4SECS

		POP 	HL
		POP 	BC
		POP 	AF

		XOR 	A
		LD	(ERFLAG),A
		RET

;================================================================================================
; Wait for disk to be ready (busy=0,ready=1)
;================================================================================================
CFWAIT:
		PUSH 	AF
CFWAIT1:
		IN 	A,(CF_STATUS)
		AND 	080H
		CP 	080H
		JR	Z,CFWAIT1
		POP 	AF
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
; Data storage
;================================================================================================

DIRBUF: 	.DS 128 			;scratch directory area
ALV00: 	.DS 257			;allocation vector 0
ALV01: 	.DS 257			;allocation vector 1
ALV02: 	.DS 257			;allocation vector 2
ALV03: 	.DS 257			;allocation vector 3
ALV04: 	.DS 257			;allocation vector 4
ALV05: 	.DS 257			;allocation vector 5
ALV06: 	.DS 257			;allocation vector 6
ALV07: 	.DS 257			;allocation vector 7
ALV08: 	.DS 257			;allocation vector 8
ALV09: 	.DS 257			;allocation vector 9
ALV10: 	.DS 257			;allocation vector 10
ALV11: 	.DS 257			;allocation vector 11
ALV12: 	.DS 257			;allocation vector 12
ALV13: 	.DS 257			;allocation vector 13
ALV14: 	.DS 257			;allocation vector 14
ALV15: 	.DS 257			;allocation vector 15

LBA0		.DB	00h
LBA1		.DB	00h
LBA2		.DB	00h
LBA3		.DB	00h

BUFINI	.EQU	$
		.DS	050H
BUFEND	.EQU	$
WRPTR:	.DS	2			; write pointer
RDPTR:	.DS	2			; read pointer
		.DS	020h			; Start of BIOS stack area.
BIOSSTACK:	.EQU	$

SEKDSK:	.DS	1			;seek disk number
SEKTRK:	.DS	2			;seek track number
SEKSEC:	.DS	2			;seek sector number
;
HSTDSK:	.DS	1			;host disk number
HSTTRK:	.DS	2			;host track number
HSTSEC:	.DS	1			;host sector number
;
SEKHST:	.DS	1			;seek shr secshf
HSTACT:	.DS	1			;host active flag
HSTWRT:	.DS	1			;host written flag
;
UNACNT:	.DS	1			;unalloc rec cnt
UNADSK:	.DS	1			;last unalloc disk
UNATRK:	.DS	2			;last unalloc track
UNASEC:	.DS	1			;last unalloc sector
;
ERFLAG:	.DS	1			;error reporting
RSFLAG:	.DS	1			;read sector flag
READOP:	.DS	1			;1 if read operation
WRTYPE:	.DS	1			;write operation type
DMAADDR:	.DS	2			;last dma address
HSTBUF:	.DS	512			;host buffer

HSTBUFEND:	.EQU	$

BIOSEND:	.EQU	$

		.END

