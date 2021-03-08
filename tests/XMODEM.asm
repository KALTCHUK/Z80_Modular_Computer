;==================================================================================
; XMODEM.ASM version 1 - Kaltchuk, feb/2021
;
; This program implements xmodem protocol on CP/M.
; (128byte data packets, 1byte CheckSum).
;
; <SOH> <BlkNum> </BlkNum> <byte1>...<byte128> <ChkSum>
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
;==================================================================================
			.ORG TPA

			LD	SP,STACK			; Set default stack.
			LD	A,(FCB+1)
			CP	' '					; Test if program has argument (file name)
			JR	NZ,START
			LD	DE,MSG
			LD	C,C_STRING
			CALL BDOS
			JP	REBOOT
			
START:		LD	A,0
			LD	(RETRY),A
			INC	A
			LD	(BLOCK),A
			CALL DELFILE			; Delete file
			CALL MAKEFILE			; Create file
			CP	4					; 0, 1, 2 or 3 = OK
			JP	M,ALIVE
OUT1:		CALL SENDCAN
			JP	REBOOT

ALIVE:		CALL SENDNAK
GET1ST:		LD	B,10
			CALL TOCONIN			;10s timeout
			JR	C,REPEAT
			CP	EOT
			JR	Z,GOTEOT
			CP	CAN
			JR	Z,GOTCAN
			CP	SOH
			JR	Z,GOTSOH
REPEAT:		LD	A,(RETRY)
			INC	A
			LD	(RETRY),A
			CP	MAXTRY
			JR	NZ,ALIVE
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
			LD	(CHKSUM),A
			LD	HL,DMA
			LD	(BUFPTR),HL
			LD	B,1
			CALL TOCONIN
			JR	C,OUT2
			LD	C,A
			CALL TOCONIN
			JR	C,OUT2
			CPL
			CP	C
			JR	NZ,OUT2
			LD	A,(BLOCK)
			CP	C
			JR	Z,RECBODY
			DEC	A
			CP	C
			JR	NZ,OUT2
ANTBLK:		CALL PURGE
			CALL SENDACK
			JP	GET1ST
OUT2:		CALL PURGE
			CALL SENDCAN
			JR	GOTCAN
RECBODY:	LD	B,1
			CALL TOCONIN
			JR	C,OUT2
			LD	HL,(BUFPTR)
			LD	(HL),A				; Put byte in buffer
			INC	HL
			LD	(BUFPTR),HL
			LD	C,A
			LD	A,(CHKSUM)
			ADD	A,C
			LD	(CHKSUM),A			; Update checksum
			PUSH HL
			POP	BC
			XOR	A					; Reset carry flag
			SBC	HL,BC
			JR	NZ,RECBODY
			JR	NZ,OUT3
			LD	B,1
			CALL TOCONIN
			JR	C,OUT2
			LD	C,A
			LD	A,(CHKSUM)
			CP	C
			JP	NZ,REPEAT
			LD	A,0
			LD	(RETRY),A			; Reset retry counter
			LD	A,(BLOCK)
			INC	A
			LD	(BLOCK),A			; Increment block counter
			CALL SENDACK
			JP	GET1ST
			
;==================================================================================
; Delete file. Returns 0, 1, 2 or 3 if successful.
;==================================================================================
DELFILE:	LD	C,F_DELETE			; Delete file
			LD	DE,FCB
			CALL BDOS
			RET
			
;==================================================================================
; Make file. Returns 0, 1, 2 or 3 if successful.
;==================================================================================
MAKEFILE:	LD	C,F_MAKE			; Create file
			LD	DE,FCB
			CALL BDOS
			RET

;==================================================================================
; Close file. Returns 0, 1, 2 or 3 if successful.
;==================================================================================
CLOSFILE:	LD	C,F_CLOSE			; Close file
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
; Write block to file. Returns 0 if successful.
;==================================================================================
WRITEBLK:	LD	C,F_WRITE			; Write buffer to disk.
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
LOOP0:		LD	HL,655		;2.5					\
LOOP1:		LD	C,255		;1.75	\				|
LOOP2:		DEC	C			;1		|				|
			CALL CONST		;36.5	|t=41.5C+0.5	| 
			INC	A			;1		|				|
			JR	Z,BWAITING	;3/1.75	|				| t=HL(41.5C+6.5)+1.25
			LD	A,C			;1		|				|
			JR	NZ,LOOP2	;3/1.75	/				| with HL=685 and c=35,
			DEC	HL			;1						|  t=0.9994sec (WOW!!!)
			LD	A,H			;1						|
			OR	L			;1						|
			JR	NZ,LOOP1	;3/1.75					/
			DJNZ	LOOP0	;3.25/2
			SCF
			JR	TOUT
BWAITING:	CALL CONIN
			XOR	A					; Reset carry flag
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

;==================================================================================
MSG:		.DB	"XMODEM 1.0 - Receive a file from console and store it on disk."
			.DB	CR,LF
			.DB	"Use: XMODEM [drive:]filename.$"

BUFPTR		.DW	0					; Buffer pointer
CHKSUM	 	.DB	0					; Checksum
RETRY		.DB 0					; Retry counter
BLOCK		.DB	0					; Block counter

			.DS	020h				; Start of stack area.
STACK		.EQU	$


			.END
