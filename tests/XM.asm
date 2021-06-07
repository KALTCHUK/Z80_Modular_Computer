CCP			EQU	0D000h			; Base of CCP (or Monitor).
BIOS		EQU	0E620h			; Base of BIOS.
ROM_CCP		EQU	CCP-0C000h		; Base of CCP in ROM
ROM_BIOS	EQU	BIOS-0C000h		; Base of BIOS in ROM

IOBYTE		EQU	3
TPA			EQU	0100H			; Transient Programs Area
MONITOR		EQU	CCP				; Monitor entry point
DMA			EQU	0080H			; Buffer used by Monitor
DISKPAD		EQU	0E000H			; Draft area used by disk R/W ops
DISKBKUP	EQU	0E200H			; Backup area used by disk verify operation

;================================================================================================
; BIOS functions.
;================================================================================================
LEAP		EQU	3					; 3 bytes for each entry (JP aaaa)

BOOT:		EQU	BIOS				;  0 Initialize.
WBOOT:		EQU	BIOS+(LEAP*1)		;  1 Warm boot.
CONST:		EQU	BIOS+(LEAP*2)		;  2 Console status.
CONIN:		EQU	BIOS+(LEAP*3)		;  3 Console input.
CONOUT:		EQU	BIOS+(LEAP*4)		;  4 Console OUTput.
LIST:		EQU	BIOS+(LEAP*5)		;  5 List OUTput.
PUNCH:		EQU	BIOS+(LEAP*6)		;  6 Punch OUTput.
READER:		EQU	BIOS+(LEAP*7)		;  7 Reader input.
HOME:		EQU	BIOS+(LEAP*8)		;  8 Home disk.
SELDSK:		EQU	BIOS+(LEAP*9)		;  9 Select disk.
SETTRK:		EQU	BIOS+(LEAP*10)		; 10 Select track.
SETSEC:		EQU	BIOS+(LEAP*11)		; 11 Select sector.
SETDMA:		EQU	BIOS+(LEAP*12)		; 12 Set DMA ADDress.
READ:		EQU	BIOS+(LEAP*13)		; 13 Read 128 bytes.
WRITE:		EQU	BIOS+(LEAP*14)		; 14 Write 128 bytes.
LISTST:		EQU	BIOS+(LEAP*15)		; 15 List status.
SECTRAN:	EQU	BIOS+(LEAP*16)		; 16 Sector translate.
PRINTSEQ:	EQU	BIOS+(LEAP*17)		; not a BIOS function

;================================================================================================
; ASCII characters.
;================================================================================================
NUL			EQU	00H
SOH			EQU	01H
STX			EQU	02H
ETX			EQU	03H
EOT			EQU	04H
ENQ			EQU	05H
ACK			EQU	06H
BEL			EQU	07H
BS			EQU	08H			; ^H
HT			EQU	09H
LF			EQU	0AH
VT			EQU	0BH
FF			EQU	0CH
CR			EQU	0DH
SO			EQU	0EH
SI			EQU	0FH
DLE			EQU	10H
DC1			EQU	11H
DC2			EQU	12H
DC3			EQU	13H
DC4			EQU	14H
NAK			EQU	15H			; ^U
SYN			EQU	16H
ETB			EQU	17H
CAN			EQU	18H			; ^X
EM			EQU	19H
SUB			EQU	1AH
ESC			EQU	1BH
FS			EQU	1CH
GS			EQU	1DH
RS			EQU	1EH
US			EQU	1FH

			ORG	TPA

;================================================================================================
; Xmodem Command - XMODEM AAAA
;================================================================================================
XMODEM:		LD	A,0C0H
			LD	(IOBYTE),A			; Set LCD as LIST device.
			LD	C,DC1
			CALL LIST
			
			
			LD	DE,DMA+6
			CALL GETWORD		
			CP	1					; Is the argument OK?
			JP	NZ,CYCLE
			LD	(AAAA),BC			; Save address
			LD	A,0
			LD	(RETRY),A			; Init retry counter
			INC	A
			LD	(BLOCK),A			; Init block counter

ALIVE:		CALL SENDNAK
;***********************************
			LD	C,'A'
			CALL LIST
;***********************************			
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
OUT3:		
			CALL SENDCAN
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
			
;***********************************
			LD	C,'T'
			CALL LIST
			LD	B,5
;***********************************
			
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

;==================================================================================


			END