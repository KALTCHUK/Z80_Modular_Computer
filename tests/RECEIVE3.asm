;==================================================================================
; Receive version 3
;
; RECEIVE is a program that runs on CP/M. On the Windows console there's a 
; counterpart program called SEND.PY.
;
;==================================================================================
REBOOT		.EQU	0H
BDOS		.EQU	5H
TPA			.EQU	0100H

C_READ		.EQU	1
C_WRITE		.EQU	2
C_STRING	.EQU	9
F_CLOSE		.EQU	16
F_DELETE	.EQU	19
F_WRITE		.EQU	21
F_MAKE		.EQU	22
F_DMAOFF	.EQU	26

EOT			.EQU	04H
ACK			.EQU	06H
LF			.EQU	0AH
CR			.EQU	0DH
NAK			.EQU	015H
EM			.EQU	019H
		
FCB			.EQU	0005CH
DMA			.EQU	080H
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

START:		LD	HL,DMA
			LD	(buffPtr),HL
			
			LD	C,F_DELETE			; Delete file
			LD	DE,FCB
			CALL BDOS
			
			LD	C,F_MAKE			; Create file
			LD	DE,FCB
			CALL BDOS
			CP	0FFH				; Was file created ok?
			JR	NZ,GETHEX
			JP	REBOOT
		
GETHEX:		CALL GETCHAR			; Get 1st char
			CP	EOT
			JR	Z,CLOSE
			LD	B,A
			PUSH BC
			CALL GETCHAR			; Get 2nd char
			POP	BC
			LD	C,A
			CALL BC2A				; Convert ASCII to byte
			LD	HL,(buffPtr)
			LD	(HL),A
			INC	HL
			LD	(buffPtr),HL
			LD	A,H
			CP	1					; Check if we reached the end of the buffer
			JR	NZ,GETHEX
			LD	C,F_WRITE			; Write buffer to disk.
			LD	DE,FCB
			CALL BDOS
			LD	HL,DMA
			LD	(buffPtr),HL
			JR	GETHEX

CLOSE:		LD	BC,DMA				; Check if buffer is empty
			LD	HL,(buffPtr)
			SCF
			CCF
			SBC	HL,BC
			JR	Z,BUFVOID

			LD	C,F_WRITE			; Write the last block to file.
			LD	DE,FCB
			CALL BDOS

BUFVOID:	LD	C,F_CLOSE			; Close the file.
			LD	DE,FCB
			CALL BDOS
			JP	REBOOT

;==================================================================================
; Wait for a char and return it on A (no echo)
;==================================================================================
GETCHAR:	LD 	C,C_READ
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
BC2A:		LD   A,B				
			SUB  $30
			CP   $0A
			JR   C,BC2A1
			SUB  $07
BC2A1:		RLCA
			RLCA
			RLCA
			RLCA
			LD   B,A
			LD   A,C
			SUB  $30
			CP   $0A
			JR   C,BC2A2
			SUB  $07
BC2A2:		ADD  A,B
			RET
			
;==================================================================================
MSG:		.DB	"RECEIVE 2.0 - Receive file from console and store on disk."
			.DB	CR,LF
			.DB	"Use 'SEND.PY' on Windows console to start this program.$"
buffPtr		.DW	0000H
checkSum 	.DB	0H

			.DS	020h			; Start of stack area.
STACK		.EQU	$

			.END
