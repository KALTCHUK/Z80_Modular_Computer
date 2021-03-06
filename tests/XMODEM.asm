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
			LD	B,10
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
			CALL DELFILE
			JR	OUT1


			LD	HL,DMA				; Initialize buffer pointer
			LD	(BUFPTR),HL
			LD	A,0
			LD	(RETRY),A			; Initialize retry counter
			INC	A
			LD	(BLOCK),A			; Initialize block counter
			CALL DELFILE			; Delete file
			CALL MAKEFILE			; Create file
			CP	4					; 0, 1, 2 or 3 = OK
			JP	M,ALIVE
CANCEL:		CALL SENDCAN
			JP	REBOOT

ALIVE:		CALL SENDNAK
GETCHAR:	CALL CONIN				; Get 1st char
			CP	EOT					; Is it the end?
			JP	Z,CLOSE
			CP	CAN					; Is it a cancel request?
			JP	Z,REBOOT
			CP	SOH					; Is a new block arriving?
			JR	NZ,GETCHAR
HEADER:		LD	A,0
			LD	(CHKSUM),A			; Reset checksum
			LD	HL,DMA
			LD	(BUFPTR),HL			; Reset buffer pointer
			CALL CONIN				; Get block number
			LD	B,A
			CALL CONIN				; Get /block number
			ADD	A,B
			CP	0FFH
			JR	NZ, CANCEL
			LD	A,(BLOCK)
			CPL
			CP	B
			JR	Z,GOOD2GO
			DEC	A
			CP	B					; Xmitter repeating last block?
			JR	NZ,CANCEL			; Probably he missed my ACK signal.
			CALL SENDACK			; Resend ACK and go wait for next SOH
			JR	GETCHAR
			
AGAIN:		LD	A,(RETRY)
			INC	A
			LD	(RETRY),A			; Increment retry counter
			CP	4
			JP	P,CANCEL
			JR	ALIVE

GOOD2GO:	CALL CONIN
			LD	HL,(BUFPTR)
			LD	(HL),A				; Put received byte in buffer
			INC	HL
			LD	(BUFPTR),HL			; Increment buffer pointer
			LD	B,A
			LD	A,(CHKSUM)
			ADD	A,B
			LD	(CHKSUM),A			; Update checksum
			LD	A,H
			CP	1					; Check if we reached the end of the buffer (0FFh is the last valid position)
			JR	NZ,GOOD2GO
			CALL CONIN				; Receive checksum
			LD	B,A
			LD	A,(CHKSUM)
			CP	B
			JR	NZ,AGAIN			; See if checksum is OK
			LD	A, (BLOCK)
			INC	A
			LD	(BLOCK),A			; Increment block counter
			LD	A,0
			LD	(RETRY),A			; Reset retry counter
			LD	HL,DMA
			LD	(BUFPTR),HL			; Reset buffer pointer
			CALL WRITEBLK
			CP	0
			JP	NZ,CANCEL
			CALL SENDACK
			JP	GETCHAR
			
CLOSE:		CALL SENDNAK
			CALL CONIN
			CP	EOT
			JP	NZ, CANCEL
			CALL SENDACK
			CALL CLOSFILE
			JP	REBOOT
			
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
			RET

;==================================================================================
; Timed Out Console Input - X seconds, with X passed on reg B
; Incoming byte, if any, returns in A
; Carry flag set if timed out.
;==================================================================================
TOCONIN:	PUSH	BC
			PUSH	HL
			LD		B,TIMEOUT
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
