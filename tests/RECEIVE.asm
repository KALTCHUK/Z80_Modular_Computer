;==================================================================================
; RECEIVE is a program that runs on CP/M. On the Windows console the is a 
; counterpart program called SEND.PY.
;
; How it works? SEND sends an archive, converting each byte into a pair of
; ASCII characters. For example, byte 0x2F will be transmitted as 0x32 0x46.
; Packets of 128 bytes (256 characters) are transmitted. This gives time to the 
; receiver to save a block on disk. After completing the disk write operation,
; the reciver sends an ACK (6) to the transmitter so it can continue transmitting.
; When the end of file has been reached, an EOT (4) is sent, followed by the CRC,
; also in ASCII (2 bytes).
; RECEIVE writes the last block, closes the file and sends an ACK if all went OK.
; Otherwise, it sends a NAK (21) followed by the error code. 
;
; 	01 = CRC error
;	02 = disk error
;==================================================================================
TPA			.EQU	100H
REBOOT		.EQU	0H
BDOS		.EQU	5H

C_RAWIO		.EQU	6
C_READ		.EQU	1
C_WRITE		.EQU	2
C_WRITESTR	.EQU	9
F_MAKE		.EQU	22
F_CLOSE		.EQU	16
F_WRITE		.EQU	21
F_DELETE	.EQU	19

CR			.EQU	0DH
LF			.EQU	0AH
EOT			.EQU	04H
ACK			.EQU	06H
NAK			.EQU	015H
		
FCB			.EQU	05CH
BUFF		.EQU	080H
;==================================================================================
			.ORG TPA
			
			CALL GETCHAR			; Get Drive letter (A...P)
			SUB	040H				; convert from ASCII letter to byte
			LD	HL,FCB
			LD	(HL),A
			INC	HL
			LD	B,11
NEXT1:		CALL GETCHAR			; Get 11 chars (8 from name + 3 type = NNNNNNNN.TTT)
			LD	(HL),A
			INC	HL
			DEC	B
			JR	NZ,NEXT1
			LD	A,0
			LD (HL),A				; Extension = 0

			LD	A,0					; Set initial parameters
			LD	(buffPos),A
			LD	(checkSum),A
			LD	(byteCount),A
			LD	HL,BUFF
			LD	(buffPtr),HL
			
			LD	C,F_DELETE			; Delete file
			LD	DE,FCB
			CALL	BDOS

			LD	C,F_MAKE			; Create file
			LD	DE,FCB
			CALL	BDOS
;==================================================================================
; Start debugging from here >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;==================================================================================

									; Start receiving the archive
GETHEX:		CALL GETCHR
			CP	EOT
			JR	Z,CLOSE
			LD   B,A
			PUSH BC
			CALL GETCHR
			POP BC
			LD   C,A

			CALL BCTOA

	LD	B,A
	LD	A,(checkSum)
	ADD	A,B
	LD	(checkSum),A
	LD	A,(byteCount)
	INC	A
	LD	(byteCount),A

	LD	A,B

	LD	HL,(buffPtr)

	LD	(HL),A
	INC	HL
	LD	(buffPtr),HL

	LD	A,(buffPos)
	INC	A
	LD	(buffPos),A
	CP	80H

	JR	NZ,NOWRITE

	LD	C,WRITES
	LD	DE,FCB
	CALL	BDOS
	LD	A,'.'
	CALL	PUTCHR

        ; New line every 8K (64 dots)
	LD	A,(printCount)
	INC	A
	CP	64
	JR	NZ,noCRLF
	LD	(printCount),A
	LD	A,CR
	CALL	PUTCHR
	LD	A,LF
	CALL	PUTCHR
	LD	A,0
noCRLF:	LD	(printCount),A

	LD	HL,BUFF
	LD	(buffPtr),HL

	LD	A,0
	LD	(buffPos),A
NOWRITE:
	JR	GETHEX
	

CLOSE:

	LD	A,(buffPos)
	CP	0
	JR	Z,NOWRITE2

	LD	C,WRITES
	LD	DE,FCB
	CALL	BDOS
	LD	A,'.'
	CALL	PUTCHR

NOWRITE2:
	LD	C,CLOSEF
	LD	DE,FCB
	CALL	BDOS

; Byte count (lower 8 bits)
	CALL 	GETCHR
	LD   B,A
	PUSH BC
	CALL GETCHR
	POP BC
	LD   C,A

	CALL BCTOA
	LD	B,A
	LD	A,(byteCount)
	SUB	B
	CP	0
	JR	Z,byteCountOK

	LD	A,CR
	CALL	PUTCHR
	LD	A,LF
	CALL	PUTCHR

	LD	DE,countErrMess
	LD	C,PSTRING
	CALL	BDOS

	; Sink remaining 2 bytes
	CALL GETCHR
	CALL GETCHR

	JR	FINISH

byteCountOK:

; Checksum
	CALL 	GETCHR
	LD   B,A
	PUSH BC
	CALL GETCHR
	POP BC
	LD   C,A

	CALL BCTOA
	LD	B,A
	LD	A,(checkSum)
	SUB	B
	CP	0
	JR	Z,checksumOK

	LD	A,CR
	CALL	PUTCHR
	LD	A,LF
	CALL	PUTCHR

	LD	DE,chkErrMess
	LD	C,PSTRING
	CALL	BDOS
	JR	FINISH

checksumOK:
	LD	A,CR
	CALL	PUTCHR
	LD	A,LF
	CALL	PUTCHR

	LD	DE,OKMess
	LD	C,PSTRING
	CALL	BDOS
		


FINISH:
	LD	C,SETUSR
	LD	E,0
	CALL	BDOS

	JP	REBOOT




;==================================================================================
; Send [CR][LF] to console
;==================================================================================
CRLF:		LD	C,C_WRITE
			LD	E,CR
			CALL BDOS
			LD	C,C_WRITE
			LD	E,LF
			CALL BDOS
			RET
			
;==================================================================================
; Wait for a char into A (no echo)
;==================================================================================
GETCHAR:	LD	E,$FF
			LD 	C,C_RAWIO
			CALL 	BDOS
			CP	0
			JR	Z,GETCHAR
			RET

;==================================================================================
; Write A to output
;==================================================================================
PUTCHAR:	LD C,C_WRITE
			LD E,A
			CALL BDOS
			RET



;==================================================================================

buffPos		.DB	0H
buffPtr		.DW	0000H
checkSum 	.DB	0H
byteCount 	.DB	0H

			.END
