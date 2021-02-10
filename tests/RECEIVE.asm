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
; Otherwise, it sends a NAK (21).
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

STX			.EQU	02H
EOT			.EQU	04H
ACK			.EQU	06H
LF			.EQU	0AH
CR			.EQU	0DH
NAK			.EQU	015H
		
FCB			.EQU	060H
BUFF		.EQU	080H
;==================================================================================
			.ORG TPA
			LD	A,ACK				; Ok, I'm alive. You can start communication.
			CALL PUTCHAR

NEWFILE:	CALL GETCHAR			; Get Drive letter (A...P)
			SUB	040H				; convert from ASCII letter to byte (A=1, B=2...)
			LD	HL,FCB
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
			LD (HL),A				; Extension = 0

			LD	A,0					; Set initial parameters
			LD	(checkSum),A
			LD	HL,BUFF
			LD	(buffPtr),HL
			
			LD	C,F_DELETE			; Delete file
			LD	DE,FCB
			CALL BDOS

			LD	C,F_MAKE			; Create file
			LD	DE,FCB
			CALL BDOS
			
			LD	A,ACK				; Tell SEND to start xmit archive.
			CALL PUTCHAR

GETHEX:		CALL GETCHAR				; Start receiving the archive
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

			LD	C,F_WRITE			; We got a full buffer. Write it on disk.
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
