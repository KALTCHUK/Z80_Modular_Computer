;================================================================================================
; Compact Flash Routines
;
;================================================================================================
CF_INIT		.EQU	0200H			; Routine to initialize the CF
CF_RD			.EQU	0300H			; Routine to read a sector of the CF
CF_WT			.EQU	0400H			; Routine to wait till CF isn't busy
CF_WR			.EQU	0500H			; Routine to write a sector of the CF
PRINTSEQ		.EQU	0E633H		; Routine (located in the BIOS) to print a sequence of characters
WAITCMD		.EQU	0D131H		; Reentry point to Monitor
CONIN			.EQU	0E609H		; Entry point for BIOS function CONIN
CONOUT		.EQU	0E60CH		; Entry point for BIOS function CONOUT

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

LF			.EQU	0AH			; line feed
FF			.EQU	0CH			; form feed
CR			.EQU	0DH			; carriage return
SPACE			.EQU	020H			; space
COLON			.EQU	03AH			; colon

;================================================================================================
; Compact flash initialization
;================================================================================================
		.ORG CF_INIT

		CALL	CFWAIT
		LD 	A,CF_8BIT			; Set IDE to be 8bit
		OUT	(CF_FEATURES),A
		LD	A,CF_SET_FEAT
		OUT	(CF_COMMAND),A


		CALL	CFWAIT
		LD 	A,CF_NOCACHE		; No write cache
		OUT	(CF_FEATURES),A
		LD	A,CF_SET_FEAT
		OUT	(CF_COMMAND),A

		CALL	PRINTSEQ
		.TEXT	"Flash initialized."
		.DB CR,LF,0

		JP	WAITCMD

;================================================================================================
; Compact flash read a sector and write to RAM @04000H
;================================================================================================
		.ORG CF_RD

		PUSH 	AF
		PUSH 	BC
		PUSH 	HL

		CALL 	CFWAIT
;
		LD	A,0
		OUT 	(CF_LBA0),A
		OUT 	(CF_LBA1),A
		OUT 	(CF_LBA2),A
		LD	A,0E0H
		OUT 	(CF_LBA3),A
		LD 	A,1
		OUT 	(CF_SECCOUNT),A
;
		LD 	A,CF_READ_SEC
		OUT 	(CF_COMMAND),A

		CALL 	CFWAIT

		LD 	HL,05000H
		LD	C,CF_DATA
		LD 	B,0
		INIR
		LD 	B,0
		INIR

		POP 	HL
		POP 	BC
		POP 	AF

		JP	WAITCMD

;================================================================================================
; Wait for disk to be ready (busy=0,ready=1)
;================================================================================================
CFWAIT:
		PUSH 	AF
		PUSH 	BC
CFWAIT1:
		IN 	A,(CF_STATUS)
		LD	C,A
		CALL	CONOUT
		LD	A,C
		AND 	080H
		JR	NZ,CFWAIT1
		POP 	BC
		POP 	AF
		RET

;================================================================================================
; Compact flash write a sector from RAM @05000H
;================================================================================================
		.ORG CF_WR

		PUSH 	AF
		PUSH 	BC
		PUSH 	HL

		CALL 	CFWAIT
;
		LD	A,0
		OUT 	(CF_LBA0),A
		OUT 	(CF_LBA1),A
		OUT 	(CF_LBA2),A
		LD	A,0E0H
		OUT 	(CF_LBA3),A
		LD 	A,1
		OUT 	(CF_SECCOUNT),A
;
		LD 	A,CF_WRITE_SEC
		OUT 	(CF_COMMAND),A

		CALL 	CFWAIT

		LD 	HL,05000H
		LD	C,CF_DATA
		LD 	B,0
		OTIR
		LD 	B,0
		OTIR

		POP 	HL
		POP 	BC
		POP 	AF

		JP	WAITCMD



		.END
