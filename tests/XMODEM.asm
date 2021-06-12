;===========================================================
; XMODEM.Z80 - Xmodem File Transfer Protocol
;
;===========================================================

MAXTRY		EQU	10
FCBCR		EQU	FCB+32

			ORG	TPA
			
XMODEM:		LD	(OLDSTACK),SP
			LD	SP,XMSTACK

			LD	A,(FCB+1)	; CHECK IF ARGUMENTS ARE OK
			CP	' '
			JR	Z,NOFILE
			LD	A,(FCB2)
			CP	'-'
			JR	NZ,ARGERR
			LD	A,(FCB2+1)
			CP	'R'
			JR	Z,RECOP
			CP	'S'
			JP	Z,SENDOP
ARGERR:		CALL	PRINTSEQ
			DB	CR,LF,"INVALID OR MISSING ARGUMENT",CR,LF,CR,LF,0
HOW2USE:	CALL	PRINTSEQ
			DB	"USE: XMODEM <file_name> -opt",CR,LF
			DB	"            -R to receive file",CR,LF
			DB	"            -S to send file",CR,LF,CR,LF,0
EXIT:		LD	SP,(OLDSTACK)
			RET
			
NOFILE:		CALL	PRINTSEQ
			DB	"MISSING FILE NAME",CR,LF,CR,LF,0
			JR	HOW2USE

;===========================================================
; RECEIVE OPERATION STARTS HERE
;===========================================================
RECOP:		CALL	DELETEFILE
			CALL	CREATEFILE
			INC	A
			JP	NZ,FCREATOK
			CALL	PRINTSEQ
			DB	"FILE CREATE ERROR",CR,LF,CR,LF,0
			JR	EXIT

FCREATOK:	LD	A,0
			LD	(RETRY),A		; Init retry counter
			INC	A
			LD	(BLOCK),A		; Init block counter
ALIVE:		CALL SENDNAK
GET1ST:		LD	B,5
			CALL TOCONIN			; 5s timeout
			JR	C,REPEAT			; Timed out?
			CP	EOT
			JR	Z,GOTEOT			; EOT? WRAP IT UP
			CP	CAN
			JR	Z,EXIT				; CAN? EXIT
			CP	SOH
			JR	Z,GOTSOH			; SOH? GET NEXT BLOCK
			JR	GET1ST
			
REPEAT:		LD	A,(RETRY)
			INC	A
			LD	(RETRY),A
			CP	MAXTRY
			JR	NZ,ALIVE			; Try again?
			CALL SENDCAN
			JR	EXIT
			
GOTEOT:		CALL SENDNAK
			LD	B,1
			CALL TOCONIN
			CALL SENDACK
			CALL	PRINTSEQ
			DB	"FILE RECEIVED",CR,LF,0
			CALL	CLOSEFILE	; CLOSE THE FILE
			INC	A
			JR	Z,CLOSERR
			JP	EXIT
			
CLOSERR:	CALL	PRINTSEQ
			DB	"FILE CLOSE ERROR",CR,LF,0
			JP	EXIT

GOTSOH:		LD	B,131
			LD	HL,BUFFER
GETBYTE:	PUSH	BC
			LD	B,1
			CALL TOCONIN			; Get incoming block number
			JR	C,EXIT				; Timed out?
			LD	(HL),A				; STORE BYTE IN BUFFER
			INC	HL
			POP	BC
			DJNZ	GETBYTE
			LD	HL,BUFFER
			LD	A,(HL)				; PICK RECEIVED BLOCK NUMBER
			CP	(BLOCK)
			JR	Z,BLKNUMOK
BLKERR:		CALL	SENDNAK
			JR	GET1ST
			
BLKNUMOK:	LD	B,A
			INC	HL
			LD	A,(HL)				; PICK RECEIVED /BLOCK NUMBER
			ADD	A,B
			INC	A
			JR	NZ,BLKERR
			XOR	A					; DO THE CHECKSUM
			LD	HL,BUFFER+2
			LD	B,128
SUMBYTE:	ADD	A,(HL)
			INC	HL
			DJNZ	SUMBYTE
			CP	(HL)
			JR	NZ,BLKERR
			CALL	WRITEFILE
			CP	0
			JR	NZ,FWRERR
			LD	A,0
			LD	(RETRY),A			; Reset retry counter
			LD	A,(BLOCK)
			INC	A
			LD	(BLOCK),A			; Increment block counter
			CALL SENDACK
			JP	GET1ST
			
FWRERR:		CALL	SENDCAN
			CALL	PRINTSEQ
			DB	"FILE WRITE ERROR",CR,LF,0
			JP	EXIT

;===========================================================
; SEND OPERATION STARTS HERE
;===========================================================
SENDOP:		CALL PRINTSEQ
			DB	"SORRY, NOT IMPLEMENTED YET",CR,LF,0
			JP	EXIT
			
;===========================================================
; Timed Out Console Input - X seconds, with X passed on regB
; Incoming byte, if any, returns in A
; Carry flag set if timed out.
;===========================================================
TOCONIN:	PUSH	BC
			PUSH	HL
			
LOOP0:		LD	HL,685
LOOP1:		LD	C,35
LOOP2:		CALL CONST
			INC	A
			JR	Z,BWAITING
			LD	A,C
			DEC	C
			JR	NZ,LOOP2
			DEC	HL
			LD	A,H
			OR	L
			JR	NZ,LOOP1
			DJNZ	LOOP0
			SCF
			JR	TOUT
BWAITING:	CALL CONIN
			SCF				; Reset carry flag
			CCF
TOUT:		POP	HL
			POP	BC
			RET

;===========================================================
; DELETE FILE. RETURNS 0FFH IF ERROR
;===========================================================
DELETEFILE:	LD	DE,FCB
			LD	C,DELFILE
			CALL	BDOS
			RET

;===========================================================
; CREATE FILE. RETURNS 0FFH IF ERROR
;===========================================================
CREATEFILE:	LD	DE,FCB
			LD	A,0				; START AT BLOCK 0
			LD	(FCBCR),A
			LD	C,CREFILE
			CALL	BDOS
			RET

;===========================================================
; CLOSE FILE. RETURNS 0FFH IF ERROR
;===========================================================
CLOSEFILE:	LD	DE,FCB
			LD	C,CLOSEFILE
			CALL	BDOS
			RET

;===========================================================
; WRITE FILE. RETURNS 0 IF OK
;===========================================================
WRITEFILE:	LD	DE,BUFFER+2
			LD	C,SETDMA
			CALL	BDOS
			LD	DE,FCB
			LD	C,WRITESEQ
			CALL	BDOS
			RET

;===========================================================
; SEND ACK
;===========================================================
SENDACK:	LD C,ACK
			CALL CONOUT
			RET

;===========================================================
; SEND NAK
;===========================================================
SENDNAK:	LD C,NAK
			CALL CONOUT
			RET

;===========================================================
; SEND CAN
;===========================================================
SENDCAN:	LD C,CAN
			CALL CONOUT
			RET

;===========================================================
;===========================================================
RETRY		DB	0		; Retry counter
BLOCK		DB	0		; Block counter
BUFFER:		DS	131		; BUFFER TO STORE BLOCK
						; <BLK> </BLK> 128X <BYTE> <CHKSUM>
OLDSTACK:	DS	2
STACK:		DS	256
XMSTACK		EQU $

			END



