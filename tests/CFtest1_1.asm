;================================================================================================
; Compact Flash Test Routines
;
; This version uses Matthew Cook's approach
;================================================================================================
CF_INIT			.EQU	0200H			; Routine to initialize the CF
DISK_TAB		.EQU	0280H			; Disk physical address table
;				disk	0280h
;				track 	0281h
;				sector	0283h
FILL_PAD		.EQU	0300H			; Fill scratch pad with content of addr SET_PAD+2 
FILL_PAD_PLAID	.EQU	0350H			; Fill scratch pad with plaid pattern (00 FF 00 FF...)
FILL_PAD_SAW	.EQU	0380H			; Fill scratch pad with saw tooth pattern
CF_RD			.EQU	0400H			; Routine to read from CF
CF_WR			.EQU	0500H			; Routine to write to CF
CF_VY			.EQU	0600H			; Routine to verify if CF sector is equal to scratch pad
SCRATCHPAD		.EQU	01000H			; 512 bytes (= 1 sector) read/write scratch pad

PRINTSEQ		.EQU	0E633H			; Routine (located in the BIOS) to print a sequence of characters
WAITCMD			.EQU	0D131H			; Reentry point to Monitor
CONST			.EQU	0E606H			; Entry point for BIOS function CONST
CONIN			.EQU	0E609H			; Entry point for BIOS function CONIN
CONOUT			.EQU	0E60CH			; Entry point for BIOS function CONOUT

FLASH_ADDR		.EQU	0B0H			; Base I/O address for compact flash card
; CF registers
CF_DATA			.EQU	(FLASH_ADDR+0)	; R/W
CF_FEATURES		.EQU	(FLASH_ADDR+1)	; W
CF_ERROR		.EQU	(FLASH_ADDR+1)	; R
CF_SECCOUNT		.EQU	(FLASH_ADDR+2)	; W

CF_SECTOR		.EQU	(FLASH_ADDR+3)	; W
CF_CYL_LOW		.EQU	(FLASH_ADDR+4)	; W
CF_CYL_HI		.EQU	(FLASH_ADDR+5)	; W
CF_HEAD			.EQU	(FLASH_ADDR+6)	; W

CF_LBA0			.EQU	(FLASH_ADDR+3)	; W
CF_LBA1			.EQU	(FLASH_ADDR+4)	; W
CF_LBA2			.EQU	(FLASH_ADDR+5)	; W
CF_LBA3			.EQU	(FLASH_ADDR+6)	; W

CF_STATUS		.EQU	(FLASH_ADDR+7)	; R
CF_COMMAND		.EQU	(FLASH_ADDR+7)	; W

;CF Features
CF_8BIT			.EQU	1
CF_NOCACHE		.EQU	082H

;CF Commands
CF_READ_SEC		.EQU	020H
CF_WRITE_SEC	.EQU	030H
CF_SET_FEAT		.EQU 	0EFH

LF				.EQU	0AH				; line feed
FF				.EQU	0CH				; form feed
CR				.EQU	0DH				; carriage return
SPACE			.EQU	020H			; space
COLON			.EQU	03AH			; colon

;================================================================================================
; Compact flash initialization
;================================================================================================
		.ORG CF_INIT

		CALL	CFWAIT
		LD 	A,CF_8BIT					; Set IDE to be 8bit
		OUT	(CF_FEATURES),A
		CALL	CFWAIT
		LD	A,CF_SET_FEAT
		OUT	(CF_COMMAND),A
		CALL	CFWAIT

;		LD 	A,CF_NOCACHE				; No write cache
;		OUT	(CF_FEATURES),A
;		LD	A,CF_SET_FEAT
;		OUT	(CF_COMMAND),A

		CALL	PRINTSEQ
		.TEXT	"Flash initialized."
		.DB CR,LF,0

		JP	WAITCMD
		
		.ORG	DISK_TAB
DISK	.DB		0
TRACK	.DW		0
SECTOR	.DB		0
		
LBA0	.DB		0
LBA1	.DB		0
LBA2	.DB		0

;================================================================================================
; Compact flash read 1 sector and write to SCRATCHPAD
;================================================================================================
		.ORG CF_RD
		CALL	DTS2LBA
		
		CALL 	CFWAIT
		LD	A,(LBA0)
		OUT 	(CF_LBA0),A
		CALL 	CFWAIT
		LD	A,(LBA1)
		OUT 	(CF_LBA1),A
		CALL 	CFWAIT
		LD	A,(LBA2)
		OUT 	(CF_LBA2),A
		CALL 	CFWAIT
		LD	A,0E0H
		OUT 	(CF_LBA3),A
		CALL 	CFWAIT
		LD 	A,1
		OUT 	(CF_SECCOUNT),A
		CALL	CFWAIT
		LD 	A,CF_READ_SEC
		OUT 	(CF_COMMAND),A
		CALL	CFDATRDY	

		LD	BC,0200H
		LD	DE,SCRATCHPAD
RDBYTE:	
		IN 	A,(CF_DATA)						;get byte of ide data	
		LD 	(DE),A
		INC	DE
		DEC	BC
		LD	A,B
		OR	C
		JR 	NZ, RDBYTE

		CALL	PRINTSEQ
		.TEXT	"Flash sector read completed."
		.DB CR,LF,0

		JP	WAITCMD

;================================================================================================
; Compact flash write 1 sector from SCRATCHPAD
;================================================================================================
		.ORG CF_WR
		CALL	DTS2LBA
		
		CALL 	CFWAIT
		LD	A,(LBA0)
		OUT 	(CF_LBA0),A
		CALL 	CFWAIT
		LD	A,(LBA1)
		OUT 	(CF_LBA1),A
		CALL 	CFWAIT
		LD	A,(LBA2)
		OUT 	(CF_LBA2),A
		CALL 	CFWAIT
		LD	A,0E0H
		OUT 	(CF_LBA3),A
		CALL 	CFWAIT
		LD 	A,1
		OUT 	(CF_SECCOUNT),A
		CALL	CFWAIT
		LD 	A,CF_WRITE_SEC
		OUT 	(CF_COMMAND),A
		CALL	CFDATRDY	

		LD	BC,0200H
		LD	DE,SCRATCHPAD
WRBYTE:	LD	A,(DE)
		NOP
		NOP
		OUT (CF_DATA),A
		INC	DE
		DEC	BC
		LD	A,B
		OR	C
		JR 	NZ, WRBYTE

		CALL	PRINTSEQ
		.TEXT	"Flash sector write completed."
		.DB CR,LF,0

		JP	WAITCMD

;================================================================================================
; Wait for disk to be ready
;================================================================================================
CFWAIT:
		PUSH 	AF
CFWAIT1:
		IN 	A,(CF_STATUS)
		AND 080H
		JR	NZ,CFWAIT1
		POP AF
		RET

;================================================================================================
; Originally LOOP_DAT_RDY by Matthew Cook.
; Loops until status register bit 7 (busy) is 0 and bit 3 (drq) is 1
;================================================================================================
CFDATRDY:
		PUSH 	AF
CFDATRDY1:
		IN	A,(CF_STATUS)					;Read status
		AND	%10001000						;mask off busy and drq bits
		XOR	%00001000						;we want busy(7) to be 0 and drq(3) to be 1
		JR	NZ,CFDATRDY1
		POP AF
		RET

;================================================================================================
; Convert physical address (disk, track, sector) to LBA address.
;
;	|      LBA2     |      LBA1     |      LBA0     |
;	|0 0 0 0 0 0 D D|D D T T T T T T|T T T S S S S S|
;               |3 2 1 0|8 7 6 5 4 3 2 1 0|4 3 2 1 0|
;				| DISK  |      TRACK      | SECTOR  |
;
;================================================================================================
DTS2LBA:
		LD	HL,(TRACK)
		RLC	L
		RLC	L
		RLC	L
		RLC	L
		RLC	L
		LD	A,L
		AND	0E0H
		LD	L,A
		LD	A,(SECTOR)
		ADD	A,L
		LD	(LBA0),A

		LD	HL,(TRACK)
		RRC	L
		RRC	L
		RRC	L
		LD	A,L
		AND	01FH
		LD	L,A
		RLC	H
		RLC	H
		RLC	H
		RLC	H
		RLC	H
		LD	A,H
		AND	020H
		LD	H,A
		LD	A,(DISK)
		RLC	a
		RLC	a
		RLC	a
		RLC	a
		RLC	a
		RLC	a
		AND	0C0H
		ADD	A,H
		ADD	A,L
		LD	(LBA1),A
		

		LD	A,(DISK)
		RRC	A
		RRC	A
		AND	03H
		LD	(LBA2),A

		RET

;================================================================================================
; Fill scratch pad with content of addr 'SET_PAD+2' 
;================================================================================================
		.ORG	FILL_PAD

		JR	SKIPBYTE

SET_BYTE	.DB	0						; this byte will be used to fill the scratch pad

SKIPBYTE:	LD	B,0
		LD	DE,SCRATCHPAD
		LD	A,(SET_BYTE)
SETNEXT:
		LD	(DE),A
		INC	DE
		LD	(DE),A
		INC	DE
		DJNZ	SETNEXT

		CALL	PRINTSEQ
		.TEXT	"Fill scratch pad completed."
		.DB CR,LF,0

		JP	WAITCMD

;================================================================================================
; Fill scratch pad with plaid pattern 
;================================================================================================
		.ORG	FILL_PAD_PLAID

		LD	B,0
		LD	DE,SCRATCHPAD
		LD	A,(SET_BYTE)
SETNEXT1:
		LD	(DE),A
		INC	DE
		CPL
		LD	(DE),A
		INC	DE
		CPL
		DJNZ	SETNEXT1

		CALL	PRINTSEQ
		.TEXT	"Fill scratch pad with plaid pattern completed."
		.DB CR,LF,0

		JP	WAITCMD

;================================================================================================
; Fill scratch pad with saw tooth pattern (00, FF, FE, FD, FC, FB, FA... 03, 02, 01, 00...)
;================================================================================================
		.ORG	FILL_PAD_SAW

		LD	BC,0200H
		LD	HL,SCRATCHPAD
SETNEXT2:
		LD	(HL),C
		INC	HL
		DEC	BC
		LD	A,B
		OR	C
		JR	NZ,SETNEXT2

		CALL	PRINTSEQ
		.TEXT	"Fill scratch pad saw tooth pattern completed."
		.DB CR,LF,0

		JP	WAITCMD
		.END
		
;================================================================================================
; Compact flash verify 1 sector (compare with SCRATCHPAD)
;================================================================================================
		.ORG CF_RD
		CALL	DTS2LBA
		
		CALL 	CFWAIT
		LD	A,(LBA0)
		OUT 	(CF_LBA0),A
		CALL 	CFWAIT
		LD	A,(LBA1)
		OUT 	(CF_LBA1),A
		CALL 	CFWAIT
		LD	A,(LBA2)
		OUT 	(CF_LBA2),A
		CALL 	CFWAIT
		LD	A,0E0H
		OUT 	(CF_LBA3),A
		CALL 	CFWAIT
		LD 	A,1
		OUT 	(CF_SECCOUNT),A
		CALL	CFWAIT
		LD 	A,CF_READ_SEC
		OUT 	(CF_COMMAND),A
		CALL	CFDATRDY	

		LD	BC,0200H
		LD	DE,SCRATCHPAD
RDBYTE1:	
		IN 	A,(CF_DATA)						;get byte of ide data
		LD	H,A
		LD 	A,(DE)
		CP	H
		JR	Z,ISEQUAL
		CALL	PRINTSEQ
		.TEXT	"ERROR"
		.DB CR,LF,0
ISEQUAL:
		INC	DE
		DEC	BC
		LD	A,B
		OR	C
		JR 	NZ, RDBYTE1

		CALL	PRINTSEQ
		.TEXT	"Flash sector verify completed."
		.DB CR,LF,0

		JP	WAITCMD

		

