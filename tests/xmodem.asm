;================================================================================================
; XMODEM [drive:]filename r/s - Receive or send file using xmodem protocol.
;================================================================================================

BOOT		.EQU	0
BIOS		.EQU	0E600H				; BIOS entry point
LEAP		.EQU	3					; 3 bytes for each entry (JP aaaa)
BDOS		.EQU	5

FCB			.EQU	05CH
DMA			.EQU	080H
TPA			.EQU	100H

;================================================================================================
; BIOS FUNCTIONS
;================================================================================================
CONST:		.EQU	BIOS+(LEAP*2)		; 2 Console status (regA).
CONIN:		.EQU	BIOS+(LEAP*3)		; 3 Console input (regA).
CONOUT:		.EQU	BIOS+(LEAP*4)		; 4 Console output (regC).
LIST:		.EQU	BIOS+(LEAP*5)		; 3 List output (regC).
LISTST:		.EQU	BIOS+(LEAP*15)		; 2 List status (regA).
PRINTSEQ:	.EQU	BIOS+(LEAP*17)		; 4 Print sequence of chars ending with zero.

;================================================================================================
; BDOS FUNCTIONS
;================================================================================================
F_OPEN		.EQU	15
F_CLOSE		.EQU	16
F_DELETE	.EQU	19
F_READ		.EQU	20
F_WRITE		.EQU	21
F_MAKE		.EQU	22
F_DMA		.EQU	26

;================================================================================================
; ASCII TABLE
;================================================================================================
LF			.EQU	0AH
CR			.EQU	0DH
ESC			.EQU	1BH

;================================================================================================
			.ORG	TPA


START:		LD	A,(FCB+1)			; Check if we have filename.
			CP	' '
			JR	NZ,FNAMEOK
			CALL PRINTSEQ
			.DB	CR,LF,">Missing filename.",CR,LF,0
			JP	BOOT
FNAMEOK:	LD	A,0C0H
			LD	(IOBYTE),A			; Set LCD as LIST device.
			LD	C,DC1
			CALL LIST
			LD	A,(FCB+11H)			; Check if it's a send or receive operation.		
			CP	'S'
			JP	Z,SENDOP
						
ALIVE:		CALL SENDNAK
GET1ST:		LD	B,5
			CALL TOCONIN			; 5s timeout
			JR	C,REPEAT			; Timed out?
			CP	EOT
			JR	Z,GOTEOT			; EOT?
			CP	CAN
			JP	Z,CYCLE				; CAN?
			CP	SOH
			JR	Z,GOTSOH			; SOH?
REPEAT:		LD	A,(RETRY)
			INC	A
			LD	(RETRY),A
			CP	MAXTRY
			JR	NZ,ALIVE			; Try again?
OUT3:		CALL SENDCAN
			JP	CYCLE
			
GOTEOT:		CALL SENDNAK
			LD	B,1
			CALL TOCONIN
			CALL SENDACK
			JP	CYCLE
			
GOTSOH:		LD	A,0
			LD	(CHKSUM),A			; Reset checksum
			LD	(BYTECNT),A			; Reset byte counter
			LD	B,1
			CALL TOCONIN			; Get incoming block number
			JR	C,OUT2				; Timed out?
			LD	C,A					; Save incoming block number
			LD	B,1
			CALL TOCONIN			; Get complement of incoming block number
			JR	C,OUT2				; Timed out?
			CPL
			CP	C
			JR	NZ,OUT2				; block = //block?
			LD	A,(BLOCK)
			CP	C					; Is block number what we expected?
			JR	Z,RECPACK
			DEC	A
			CP	C					; block number is the anterior? Probably sender missed our ACK.
			JR	NZ,OUT2
ANTBLK:		CALL PURGE				; Purge input buffer before sending ACK
			CALL SENDACK
			JP	GET1ST
OUT2:		CALL PURGE
			CALL SENDCAN
			JP	CYCLE
RECPACK:	LD	B,1					; Start receiving data packet (128 bytes)
			CALL TOCONIN
			JR	C,OUT2				; Timed out?
			LD	HL,(AAAA)
			LD	(HL),A				; Put byte in buffer
			INC	HL					; Inc buffer pointer
			LD	(AAAA),HL
			LD	C,A
			LD	A,(CHKSUM)
			ADD	A,C
			LD	(CHKSUM),A			; Update checksum
			LD	A,(BYTECNT)			; Inc byte counter
			INC	A
			LD	(BYTECNT),A
			CP	128					; Check if we received a full data packet
			JR	NZ,RECPACK
			LD	B,1
			CALL TOCONIN			; Get checksum
			JR	C,OUT2				; Timed out?
			LD	C,A
			LD	A,(CHKSUM)
			CP	C
			JP	NZ,REPEAT			; Checksum OK?
			LD	A,0
			LD	(RETRY),A			; Reset retry counter
			LD	A,(BLOCK)
			INC	A
			LD	(BLOCK),A			; Increment block counter

			CALL SENDACK
			JP	GET1ST

SENDOP:		CALL PRINTSEQ
			.DB	CR,LF,"Send operation not implemented yet.",CR,LF,0
			JP	BOOT

SENDACK:	LD C,ACK
			CALL CONOUT
			RET

SENDNAK:	LD C,NAK
			CALL CONOUT
			RET

SENDCAN:	LD C,CAN
			CALL CONOUT
			RET

;==================================================================================
; Timed Out Console Input - X seconds, with X passed on reg B
; Incoming byte, if any, returns in A
; Carry flag set if timed out.
;==================================================================================
TOCONIN:	PUSH	BC
			PUSH	HL
			
LOOP0:		LD	HL,685				;2.5					\
LOOP1:		LD	C,35				;1.75	\				|
LOOP2:		CALL CONST				;36.5	|t=41.5C+0.5	| 
			INC	A					;1		|				|
			JR	Z,BWAITING			;3/1.75	|				| t=HL(41.5C+6.5)+1.25
			LD	A,C					;1		|				|
			DEC	C					;1		|				|
			JR	NZ,LOOP2			;3/1.75	/				| with HL=685 and c=35,
			DEC	HL					;1						|  t=0.9994sec (WOW!!!)
			LD	A,H					;1						|
			OR	L					;1						|
			JR	NZ,LOOP1			;3/1.75					/
			DJNZ	LOOP0			;3.25/2
			SCF
			JR	TOUT
BWAITING:	CALL CONIN
			SCF						; Reset carry flag
			CCF
TOUT:		POP	HL
			POP	BC
			RET







			
			.END
