;==================================================================================
; Monitor 2.0 for Z80 Modular Computer by P.R.Kaltchuk mar/2021
;==================================================================================
TPA			.EQU	0100H		; Transient Programs Area
MONITOR		.EQU	0D000H		; Monitor entry point
BIOS		.EQU	0E600H		; BIOS entry point

;================================================================================================
; BIOS functions.
;================================================================================================
BOOT:		.EQU	BIOS				;  0 Initialize.
WBOOT:		.EQU	BIOS+(3*1)			;  1 Warm boot.
CONST:		.EQU	BIOS+(3*2)			;  2 Console status.
CONIN:		.EQU	BIOS+(3*3)			;  3 Console input.
CONOUT:		.EQU	BIOS+(3*4)			;  4 Console OUTput.
LIST:		.EQU	BIOS+(3*5)			;  5 List OUTput.
PUNCH:		.EQU	BIOS+(3*6)			;  6 Punch OUTput.
READER:		.EQU	BIOS+(3*7)			;  7 Reader input.
HOME:		.EQU	BIOS+(3*8)			;  8 Home disk.
SELDSK:		.EQU	BIOS+(3*9)			;  9 Select disk.
SETTRK:		.EQU	BIOS+(3*10)			; 10 Select track.
SETSEC:		.EQU	BIOS+(3*11)			; 11 Select sector.
SETDMA:		.EQU	BIOS+(3*12)			; 12 Set DMA ADDress.
READ:		.EQU	BIOS+(3*13)			; 13 Read 128 bytes.
WRITE:		.EQU	BIOS+(3*14)			; 14 Write 128 bytes.
LISTST:		.EQU	BIOS+(3*15)			; 15 List status.
SECTRAN:	.EQU	BIOS+(3*16)			; 16 Sector translate.
PRINTSEQ:	.EQU	BIOS+(3*17)			; not a BIOS function

;================================================================================================
; ASCII characters.
;================================================================================================
NUL			.EQU	00H
SOH			.EQU	01H
STX			.EQU	02H
ETX			.EQU	03H
EOT			.EQU	04H
ENQ			.EQU	05H
QCK			.EQU	06H
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
			.ORG MONITOR





;================================================================================================
; Convert ASCII to HEX (HL --> B)
;================================================================================================
HL2B:		PUSH	BC
			LD	A,060H
			SUB	H
			LD	C,057H
			JP	C,DISCOUNT
			LD	A,040H
			SUB	H
			LD	C,037H
			JP	C,DISCOUNT
			LD	C,030H
DISCOUNT:	LD	A,H
			SUB	C
CONVL:		LD	B,A
			SLA	B
			SLA	B
			SLA	B
			SLA	B
			LD	A,060H
			SUB	L
			LD	C,057H
			JP	C,DISCOUNT2
			LD	A,040H
			SUB	L
			LD	C,037H
			JP	C,DISCOUNT2
			LD	C,030H
DISCOUNT2:	LD	A,L
			SUB	C
			OR	B
			POP	BC
			LD	B,A
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

;================================================================================================

			.END
