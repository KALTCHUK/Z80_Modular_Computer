;==================================================================================
; RECEIVE is a program that runs on CP/M. On the Windows console there's a 
; counterpart program called SEND.PY.
;
; How it works? SEND sends an archive, converting each byte into a pair of
; ASCII characters. For example, byte 0x2F will be transmitted as 0x32 0x46.
; After all archive has been xmitted, SEND sends the checksum (also ASCII pair).
;==================================================================================
REBOOT		.EQU	0H
BDOS		.EQU	5H
TPA			.EQU	0100H

C_READ		.EQU	1
C_WRITE		.EQU	2
C_RAWIO		.EQU	6
C_WRITESTR	.EQU	9
F_CLOSE		.EQU	16
F_DELETE	.EQU	19
F_WRITE		.EQU	21
F_MAKE		.EQU	22
F_DMAOFF	.EQU	26

ETX			.EQU	03H
ACK			.EQU	06H
LF			.EQU	0AH
CR			.EQU	0DH
NAK			.EQU	015H
EM			.EQU	019H
		
FCB			.EQU	05CH
FCBEX		.EQU	FCB+12
FCBCR		.EQU	FCB+32
DMA			.EQU	080H
;==================================================================================
			.ORG TPA
			
			LD	A,ACK				; Ok, I'm alive. You can start communication.
			CALL PUTCHAR

NEWFILE:	LD	HL,FCB
			CALL GETCHAR			; Get Drive letter (A...P)
			SUB	040H				; convert from ASCII letter to byte (A=1, B=2...)
			LD	(HL),A
			INC	HL
			LD	B,11
NEXT1:		PUSH BC
			CALL GETCHAR			; Get 11 chars,8 from name + 3 type (NNNNNNNN.TTT)
			LD	(HL),A
			INC	HL
			POP	BC
			DEC	B
			JR	NZ,NEXT1
			
			LD	A,0
			LD	HL,FCBEX
			LD (HL),A				; EX = 0
			LD	HL,FCBCR
			LD (HL),A				; CR = 0

			LD	C,F_DELETE			; Delete file
			LD	DE,FCB
			CALL BDOS

			LD	C,F_MAKE			; Create file
			LD	DE,FCB
			CALL BDOS
			
			LD	A,0					; Set initial parameters
			LD	(checkSum),A
			LD	HL,DMA
			LD	(buffPtr),HL
			
GETHEX:		LD	A,ACK				; Tell SEND to start xmit archive.
			CALL PUTCHAR

			CALL GETCHAR			; Start receiving the archive
			CP	EOT
			JR	Z,CLOSE
			LD	B,A
			PUSH BC
			CALL GETCHAR
			POP	BC
			LD	C,A
			CALL BCTOA
			LD	B,A					; Update checksum
			LD	A,(checkSum)
			ADD	A,B
			LD	(checkSum),A
			LD	A,B					; Put received byte in buffer
			LD	HL,(buffPtr)
			LD	(HL),A
			INC	HL
			LD	(buffPtr),HL
			LD	A,H
			CP	1					; Check if we reached the end of the buffer
			JR	NZ,GETHEX
			LD	A,EM				; Tell SEND to pause, because we got a full buffer. 
			CALL PUTCHAR
			LD	C,F_WRITE			; Write it on disk.
			LD	DE,FCB
			CALL BDOS

			LD	HL,BUFF				; Reset buffer.
			LD	(buffPtr),HL
			
			LD	A,ACK				; Tell SEND to resume transmission.
			CALL PUTCHAR
			JR	GETHEX

CLOSE:		LD	BC,BUFF				; Check if buffer is empty
			LD	HL,(buffPtr)
			SCF
			CCF
			SBC	HL,BC
			JR	Z,BEMPTY

			LD	C,F_WRITE			; Write the last block to file.
			LD	DE,FCB
			CALL BDOS

BEMPTY:		LD	C,F_CLOSE			; Close the file.
			LD	DE,FCB
			CALL BDOS

			CALL GETCHAR			; Get checksum
			LD   B,A
			PUSH BC
			CALL GETCHAR
			POP BC
			LD   C,A
			CALL BCTOA
			LD	B,A
			LD	A,(checkSum)
			SUB	B
			CP	0
			LD	A,ACK
			JR	Z,CHECKOK
			LD	A,NAK
CHECKOK:	CALL PUTCHAR

			CALL GETCHAR
			CP	STX
			JP	Z,NEWFILE

			JP	REBOOT

;==================================================================================
; Wait for a char into A (no echo)
;==================================================================================
GETCHAR:	LD	E,$FF
			LD 	C,C_RAWIO
			CALL BDOS
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
; Convert ASCII characters in BC to a byte in A
;==================================================================================
BCTOA:		LD   A,B				
			SUB  $30
			CP   $0A
			JR   C,BCTOA1
			SUB  $07
BCTOA1:		RLCA
			RLCA
			RLCA
			RLCA
			LD   B,A
			LD   A,C
			SUB  $30
			CP   $0A
			JR   C,BCTOA2
			SUB  $07
BCTOA2:		ADD  A,B
			RET
			
;==================================================================================
buffPtr		.DW	0000H
checkSum 	.DB	0H

			.END
