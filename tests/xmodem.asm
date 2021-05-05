;================================================================================================
; XMODEM [drive:]filename r/s - Receive or send file using xmodem protocol.
;================================================================================================
BOOT		.EQU	0
BIOS		.EQU	0E600H				; BIOS entry point
LEAP		.EQU	3					; 3 bytes for each entry (JP aaaa)
BDOS		.EQU	5

FCB			.EQU	05CH
FCB2		.EQU	06CH
DMA			.EQU	080H
TPA			.EQU	100H

MAXTRY		.EQU	10

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
GET_IOB		.EQU	7
SET_IOB		.EQU	8
F_OPEN		.EQU	15
F_CLOSE		.EQU	16
F_DELETE	.EQU	19
F_READ		.EQU	20
F_WRITE		.EQU	21
F_MAKE		.EQU	22
F_DMA		.EQU	26

;================================================================================================
; ASCII characters.
;================================================================================================
NUL			.EQU	00H
SOH			.EQU	01H
STX			.EQU	02H
ETX			.EQU	03H
EOT			.EQU	04H
ENQ			.EQU	05H
ACK			.EQU	06H
BEL			.EQU	07H
BS			.EQU	08H	
HT			.EQU	09H
LF			.EQU	0AH
VT			.EQU	0BH
FF			.EQU	0CH
CR			.EQU	0DH
SO			.EQU	0EH
SI			.EQU	0FH
DLE			.EQU	10H
DC1			.EQU	11H
DC2			.EQU	12H
DC3			.EQU	13H
DC4			.EQU	14H
NAK			.EQU	15H
SYN			.EQU	16H
ETB			.EQU	17H
CAN			.EQU	18H
EM			.EQU	19H
SUB			.EQU	1AH
ESC			.EQU	1BH
FS			.EQU	1CH
GS			.EQU	1DH
RS			.EQU	1EH
US			.EQU	1FH

;================================================================================================
; PROGRAM STARTS HERE
;================================================================================================
			.ORG	TPA

START:		LD	A,(FCB+1)			; Check if we have filename.
			CP	' '
			JR	NZ,FNAMEOK
			CALL PRINTSEQ
			.DB	CR,LF,"Missing filename.",CR,LF,0
			JP	BOOT

FNAMEOK:	LD	C,GET_IOB
			CALL BDOS
			OR	0C0H
			LD	E,A					; Set LCD as LIST device.
			LD	C,SET_IOB
			CALL BDOS
			LD	C,DC1
			CALL LIST				; Init LCD
			LD	A,0
			LD	(RETRY),A			; Reset retry counter.
			LD	A,(FCB2)			; Check if it's a send or receive operation.		
			CP	'S'
			JP	Z,SENDOP
			CP	's'
			JP	Z,SENDOP
						
;================================================================================================
; RECEIVE FILE OPERATION
;================================================================================================
RECOP:		LD	C,F_DELETE			; Delete file.
			LD	DE,FCB
			CALL BDOS
			LD	C,F_MAKE			; Create file.
			LD	DE,FCB
			CALL BDOS
			CP	0					; Got error?
			JR	NZ,ALIVE
			LD	DE,MSGME
			JP	LEXIT
			
ALIVE:		CALL SENDNAK
GET1ST:		LD	B,5
			CALL TOCONIN			; 5s timeout
			JR	C,REPEAT			; Timed out?
			CP	EOT
			JR	Z,GOTEOT			; EOT?
			CP	CAN
			JP	Z,BOOT				; CAN?
			CP	SOH
			JR	Z,GOTSOH			; SOH?
REPEAT:		LD	A,(RETRY)
			INC	A
			LD	(RETRY),A
			CP	(MAXTRY)
			JR	NZ,ALIVE			; Try again?
OUT3:		CALL SENDCAN
			JP	BOOT
			
GOTEOT:		CALL SENDNAK
			LD	B,1
			CALL TOCONIN
			CALL SENDACK
			LD	C,F_CLOSE			; Create file.
			LD	DE,FCB
			CALL BDOS
			CP	0FFH				; Did we get an error while closing the file?
			JP	NZ,BOOT
			LD	DE,MSGCE
			CALL LISTSEQ
			JP	BOOT

GOTSOH:		LD	A,0
			LD	(CHKSUM),A			; Reset checksum
			LD	HL,DMA				; Reset byte counter
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
			JP	BOOT

RECPACK:	LD	B,1					; Start receiving data packet (128 bytes)
			CALL TOCONIN
			JR	C,OUT2				; Timed out?
			LD	(HL),A				; Put byte in buffer
			INC	HL					; Inc buffer pointer
			LD	C,A
			LD	A,(CHKSUM)
			ADD	A,C
			LD	(CHKSUM),A			; Update checksum
			LD	BC,DMA+128
			SCF
			CCF
			PUSH HL					; Save pointer/couter before checkpoint
			SBC	HL,BC				; do the math
			POP	HL					; Recover pointer/counter
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
			CALL SAVEBLK			; Save block
			CP	0
			JR	NZ,BWERR			; Oops, we got a block write error
			CALL VERBLK				; Verify block
			CP	0
			JR	NZ,BVERR			; Oops, we got a block verify error
			CALL SENDACK
			JP	GET1ST

BWERR:		LD	DE,MSGWE
LEXIT:		CALL LISTSEQ
			JP	OUT3

BVERR:		LD	DE,MSGVE
			JR	LEXIT

;================================================================================================
; SEND FILE OPERATION
;================================================================================================
SENDOP:		CALL PRINTSEQ
			.DB	CR,LF,"Send operation not implemented yet.",CR,LF,0
			JP	BOOT

;================================================================================================
; SEND ACK TO CONSOLE
;================================================================================================
SENDACK:	LD C,ACK
			CALL CONOUT
			RET

;================================================================================================
; SEND NAK TO CONSOLE
;================================================================================================
SENDNAK:	LD C,NAK
			CALL CONOUT
			RET

;================================================================================================
; SEND CAN TO CONSOLE
;================================================================================================
SENDCAN:	LD C,CAN
			CALL CONOUT
			RET

;================================================================================================
; SAVE BLOCK ON DISK (WRITE TO FILE)
;================================================================================================
SAVEBLK:	LD	A,(BLOCK)
			DEC	A
			LD	B,A
			CALL B2HL				; Convert block number to ASCII
			LD	A,H
			LD	(MSGBNUM),A
			LD	A,L
			LD	(MSGBNUM+1),A
			LD	DE,MSGBLK
			CALL LISTSEQ			; Send block number to LIST (LCD).
			LD	C,F_DMA
			LD	DE,DMA
			CALL BDOS				; Set DMA before file write.
			LD	C,F_WRITE
			LD	DE,FCB
			CALL BDOS				; Write block to file.
			RET
			
;================================================================================================
; VERIFY BLOCK ON DISK (COMPARE WRITTEN BLOCK TO SOURCE ON RAM)
;================================================================================================
VERBLK:		LD	C,F_DMA
			LD	DE,DMA4VER
			CALL BDOS				; Set DMA before file read.
			LD	C,F_READ
			LD	DE,FCB
			CALL BDOS				; Read block from file.
			LD	B,0
			LD	HL,DMA
			LD	DE,DMA4VER
VERNEXT:	LD	A,(DE)
			CP	(HL)				; Compare blocks.
			JR	NZ,VERR
			INC	DE
			INC HL
			DJNZ VERNEXT
			LD	A,0
			RET
VERR:		LD  A,0FFH
			RET

;==================================================================================
; List a string pointed by DE and ending with zero.
;==================================================================================
LISTSEQ:	LD	A,(DE)
			CP	0
			RET	Z
			LD	C,A
			CALL LIST
			INC DE
			JR	LISTSEQ
			
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

;==================================================================================
; Purge console input.
;==================================================================================
PURGE:		LD	B,3
			CALL TOCONIN
			JR	NC,PURGE
			RET

;================================================================================================
; Convert HEX to ASCII (B --> HL)
;================================================================================================
B2HL:		PUSH	BC
			LD	A,B
			AND	0FH
			LD	L,A
			SUB	0AH
			LD	C,030H
			JP	C,COMPENSE
			LD	C,037H
COMPENSE:	LD	A,L
			ADD	A,C
			LD	L,A
			LD	A,B
			AND	0F0H
			SRL	A
			SRL	A
			SRL	A
			SRL	A
			LD	H,A
			SUB	0AH
			LD	C,030H
			JP	C,COMPENSE2
			LD	C,037H
COMPENSE2:	LD	A,H
			ADD	A,C
			LD	H,A
			POP	BC
			RET

;==================================================================================
; MESSAGE STRINGS
;==================================================================================
MSGME		.DB	CR,LF,"MAKE ERROR",0
MSGCE		.DB	CR,LF,"CLOSE ERROR",0
MSGWE		.DB	CR,LF,"WRITE ERROR",0
MSGVE		.DB	CR,LF,"VERIFY ERROR",0
MSGBLK		.DB CR,LF,"BLOCK "
MSGBNUM		.DB	0,0,0

;==================================================================================
; VARIABLES AND BUFFERS
;==================================================================================
RETRY		.DB	0
CHKSUM		.DB	0
BLOCK		.DB	0
DMA4VER		.DS	128

			
			.END
