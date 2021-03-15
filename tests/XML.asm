;==================================================================================
; XML.ASM version 1 - Kaltchuk, feb/2021
;
; This program implements xmodem protocol on CP/M.
; (3 bytes header, 128byte data packets, 1byte CheckSum).
;
: +-------- header --------+------- data packet -------+
; |                        |                           |
;  <SOH> <BlkNum> </BlkNum> <byte1> <byte2>...<byte128> <ChkSum>
;==================================================================================
REBOOT		.EQU	0H
BDOS		.EQU	5H
TPA			.EQU	0100H
BIOS		.EQU	0E600h			; Base of BIOS.

FCB			.EQU	0005CH
DMA			.EQU	080H

CONST		.EQU	BIOS+(3*2)		; BIOS entry for Console Status (regA=0FFh, char waiting. regA=0, buff empty)
CONIN		.EQU	BIOS+(3*3)		; BIOS entry for Console Input (console --> regA)
CONOUT		.EQU	BIOS+(3*4)		; BIOS entry for Console Output (regC --> console)

C_STRING	.EQU	9				; BDOS functions
F_CLOSE		.EQU	16
F_DELETE	.EQU	19
F_WRITE		.EQU	21
F_MAKE		.EQU	22
F_DMAOFF	.EQU	26

SOH			.EQU	01H				; ASCII characters
EOT			.EQU	04H
ACK			.EQU	06H
LF			.EQU	0AH
CR			.EQU	0DH
NAK			.EQU	015H
CAN			.EQU	018H
SUB			.EQU	01AH

MAXTRY		.EQU	10

LCD_CARD	.EQU	0E0H			; LCD card base address
DAT_WR		.EQU	LCD_CARD+1
DAT_RD		.EQU	LCD_CARD+3
CMD_WR		.EQU	LCD_CARD
CMD_RD		.EQU	LCD_CARD+2
;==================================================================================
			.ORG TPA

			LD	SP,STACK			; Set default stack.
			LD	A,(FCB+1)
			CP	' '					; Test if program has argument (file name)
			JR	NZ,START
			LD	DE,MSGNOARG
			LD	C,C_STRING
			CALL BDOS
			JP	REBOOT
			
START:		LD	DE,MSGOK
			LD	C,C_STRING
			CALL BDOS
			CALL LCDINIT
			CALL LCDCLEAR
			CALL LCDPRINT
			.DB	"START",0
			
			LD	A,0
			LD	(RETRY),A			; Init retry counter
			INC	A
			LD	(BLOCK),A			; Init block counter
			CALL DELFILE			; Delete file
			CALL MAKEFILE			; Create file
			CP	4					; 0, 1, 2 or 3 = OK
			JP	M,ALIVE				; File created OK?
OUT1:		CALL SENDCAN
			JP	REBOOT

ALIVE:		CALL SENDNAK
GET1ST:		LD	B,5
			CALL TOCONIN			; 5s timeout
			JR	C,REPEAT			; Timed out?
			CP	EOT
			JR	Z,GOTEOT			; EOT?
			CP	CAN
			JR	Z,GOTCAN			; CAN?
			CP	SOH
			JR	Z,GOTSOH			; SOH?
REPEAT:		LD	A,(RETRY)
			INC	A
			LD	(RETRY),A
			CP	MAXTRY
			JR	NZ,ALIVE			; Try again?
OUT3:		CALL DELFILE
			JR	OUT1
GOTEOT:		CALL SENDNAK
			LD	B,1
			CALL TOCONIN
			CALL SENDACK
			CALL CLOSFILE
			JP	REBOOT
GOTCAN:		CALL DELFILE
			JP	REBOOT
GOTSOH:		LD	A,0
			LD	(CHKSUM),A			; Reset checksum
			LD	HL,DMA
			LD	(BUFPTR),HL			; Reset buffer pointer
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
			JR	GOTCAN
RECPACK:	LD	B,1					; Start receiving data packet (128 bytes)
			CALL TOCONIN
			JR	C,OUT2				; Timed out?
			LD	HL,(BUFPTR)
			LD	(HL),A				; Put byte in buffer
			INC	HL					; Inc buffer pointer
			LD	(BUFPTR),HL
			LD	C,A
			LD	A,(CHKSUM)
			ADD	A,C
			LD	(CHKSUM),A			; Update checksum
			LD	BC,TPA
			XOR	A					; Reset carry flag
			SBC	HL,BC				; If buffer pointer = TPA, we got a full buffer 
			JR	NZ,RECPACK
			CALL WRITEBLK
			CP	0
			JP	NZ,OUT3				; Write op OK?
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
			
;==================================================================================
; Delete file. RegA returns 0, 1, 2 or 3 if successful.
;==================================================================================
DELFILE:	LD	C,F_DELETE
			LD	DE,FCB
			CALL BDOS
			RET
			
;==================================================================================
; Make file. RegA returns 0, 1, 2 or 3 if successful.
;==================================================================================
MAKEFILE:	LD	C,F_MAKE
			LD	DE,FCB
			CALL BDOS
			RET

;==================================================================================
; Close file. RegA returns 0, 1, 2 or 3 if successful.
;==================================================================================
CLOSFILE:	LD	C,F_CLOSE
			LD	DE,FCB
			CALL BDOS
			RET
			
;==================================================================================
; Send ACK
;==================================================================================
SENDACK:	LD C,ACK
			CALL CONOUT
			RET

;==================================================================================
; Send NAK
;==================================================================================
SENDNAK:	LD C,NAK
			CALL CONOUT
			RET

;==================================================================================
; Send CAN
;==================================================================================
SENDCAN:	LD C,CAN
			CALL CONOUT
			RET

;==================================================================================
; Write block to file. RegA returns 0 if successful.
;==================================================================================
WRITEBLK:	CALL LCDPRINT
			.DB	"BLOCK ",0
			LD	A,(BLOCK)
			LD	B,A
			CALL B2HL
			LD	C,H
			CALL LCDPUT
			LD	C,L
			CALL LCDPUT
			
			LD	C,F_DMAOFF			; Set DMA before writing.
			LD	DE,DMA
			CALL BDOS
			LD	C,F_WRITE			; Write buffer to disk.
			LD	DE,FCB
			CALL BDOS
			LD	HL,DMA
			LD	(BUFPTR),HL			; Reset buffer pointer
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
B2HL:		PUSH BC
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

;**********************************************************************************
;                                  LCD STUFF
;**********************************************************************************
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
; Wait until Busy flag = 0
;================================================================================================
BWAIT:	IN A,(CMD_RD)
		RLCA
		JR	C,BWAIT
		RET

;================================================================================================
; Initialize LCD
;================================================================================================
LCDINIT:
		LD	B,15			; wait 15ms
		CALL	DELAYMS
		LD	A,030H		; write command 030h
		OUT	(CMD_WR),A
		LD	B,5			; wait 5ms
		CALL	DELAYMS
		LD	A,030H		; write command 030h
		OUT	(CMD_WR),A
		LD	C,20			; wait (5X20) 100us
		CALL	DELAY5US
		LD	A,030H		; write command 030h
		OUT	(CMD_WR),A
		LD	C,20			; wait (5X20) 100us
		CALL	DELAY5US
		LD	A,038H		; write command 038h = function set (8-bits, 2-lines, 5x7dots)
		OUT	(CMD_WR),A
		CALL	BWAIT
		LD	A,08H			; write command 08h = display (off)
		OUT	(CMD_WR),A
		CALL	BWAIT
		LD	A,01H			; write command 01h = clear display
		OUT	(CMD_WR),A
		CALL	BWAIT
		LD	A,06H			; write command 06h = entry mode (increment)
		OUT	(CMD_WR),A
		CALL	BWAIT
		LD	A,0CH			; write command 0Ch = display (on)
		OUT	(CMD_WR),A
		RET

;================================================================================================
; Clear LCD and goto line 1, column 1.
;================================================================================================
LCDCLEAR:
		CALL	BWAIT
		LD	A,01H			; write command 01h = clear display
		OUT	(CMD_WR),A
		RET

;================================================================================================
; Send to LCD char in regC. Print at current position (what ever it is)
;================================================================================================
LCDPUT:
		CALL	BWAIT
		LD	A,C			; write command 01h = clear display
		OUT	(DAT_WR),A
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
		OUT	(CMD_WR),A
		RET

;================================================================================================
; Send to LCD a sequence of characters ending with zero
;================================================================================================
LCDPRINT:
		CALL LCDCLEAR
		EX 	(SP),HL 		; Push HL and put RET address into HL
		PUSH 	AF
		PUSH 	BC
NEXTCHAR:
		LD 	A,(HL)
		CP	0
		JR	Z,ENDOFPRINT
		LD	C,A
		CALL	BWAIT
		LD	A,C
		OUT	(DAT_WR),A
		INC 	HL
		JR	NEXTCHAR
ENDOFPRINT:
		INC 	HL 			; Get past "null" terminator
		POP 	BC
		POP 	AF
		EX 	(SP),HL 		; Push new RET address on stack and restore HL
		RET

;==================================================================================
MSGOK:		.DB	"XMODEM 1.0 - Receiving file..."
			.DB	CR,LF,"$"
			
MSGNOARG:	.DB	"XMODEM 1.0 - Receive a file from console and store it on disk."
			.DB	CR,LF,
			.DB	"Use: XMODEM [drive:]filename.$"

BUFPTR		.DW	0					; Buffer pointer
CHKSUM	 	.DB	0					; Checksum
RETRY		.DB 0					; Retry counter
BLOCK		.DB	0					; Block counter
USELCD		.DB	0					; Use LCD? 1=yes

			.DS	0100h				; Start of stack area.
STACK		.EQU	$





			.END
