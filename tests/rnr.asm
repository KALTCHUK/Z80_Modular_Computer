;==================================================================================
; XMODEM.ASM version 1.0 - Kaltchuk, feb/2021
;
; This program implements xmodem protocol on CP/M. Only receive file.
; (3 bytes header, 128byte data packets, 1byte CheckSum).
;
; +-------- header --------+------- data packet -------+
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
F_OPEN		.EQU	15
F_CLOSE		.EQU	16
F_DELETE	.EQU	19
F_READ		.EQU	20
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
;==================================================================================

			.ORG TPA

			LD	SP,STACK			; Set default stack.
			CALL OPENFILE
			CP	4
			JP	M,OPENOK
			LD	DE,MSGERR
			LD	C,C_STRING
			CALL BDOS
			JP	REBOOT
			
OPENOK:		CALL SETDMA
			LD	A,0
			LD	(FCB_CR),A
			INC	A
			LD	(BLOCK),A
READREC:	CALL READSEQ
			LD	(REG_A),A
			
			LD	DE,MSGBLK
			LD	C,C_STRING
			CALL BDOS
			LD	A,(BLOCK)
			LD	B,A
			CALL B2HL
			LD	C,H
			CALL CONOUT
			LD	C,L
			CALL CONOUT
			
			LD	DE,MSGREG
			LD	C,C_STRING
			CALL BDOS
			LD	A,(REG_A)
			LD	B,A
			CALL B2HL
			LD	C,H
			CALL CONOUT
			LD	C,L
			CALL CONOUT
			
			LD	DE,MSGREC
			LD	C,C_STRING
			CALL BDOS



;==================================================================================
; Open file. RegA returns 0, 1, 2 or 3 if successful.
;==================================================================================
OPENFILE:	LD	C,F_OPEN
			LD	DE,FCB
			CALL BDOS
			RET
			
;==================================================================================
; Convert HEX to ASCII (B --> HL)
;==================================================================================
B2HL:		PUSH BC
			LD	A,B
			AND	0FH
			LD	L,A
			SUB	0AH
			LD	C,030H
			JP	C,COMPENS
			LD	C,037H
COMPENS:
			LD	A,L
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
			JP	C,COMPENS2
			LD	C,037H
COMPENS2:
			LD	A,H
			ADD	A,C
			LD	H,A
			POP	BC
			RET

;==================================================================================

MSGERR:		.DB	"BDOS error on file open.",CR,LF,"$"
MSGBLK:		.DB	"Block = $"
MSGREG:		.DB	", regA = $"
MSGREC:		.DB	", Record content...",CR,LF,"$"

REG_A		.DB 0					; regA
BLOCK		.DB	0					; Block counter

			.DS	0100h				; Start of stack area.
STACK		.EQU	$





			.END
