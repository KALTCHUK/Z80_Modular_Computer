;===========================================================
; BIOS functions.
;===========================================================
LEAP		EQU	3		; 3 bytes for each entry
BIOS		EQU	0E620H

BOOT		EQU	BIOS		;  0 Initialize.
WBOOT		EQU	BIOS+(LEAP*1)	;  1 Warm boot.
CONST		EQU	BIOS+(LEAP*2)	;  2 Console status.
CONIN		EQU	BIOS+(LEAP*3)	;  3 Console input.
CONOUT		EQU	BIOS+(LEAP*4)	;  4 Console OUTput.
LIST		EQU	BIOS+(LEAP*5)	;  5 List OUTput.
PUNCH		EQU	BIOS+(LEAP*6)	;  6 Punch OUTput.
READER		EQU	BIOS+(LEAP*7)	;  7 Reader input.
HOME		EQU	BIOS+(LEAP*8)	;  8 Home disk.
SELDSK		EQU	BIOS+(LEAP*9)	;  9 Select disk.
SETTRK		EQU	BIOS+(LEAP*10)	; 10 Select track.
SETSEC		EQU	BIOS+(LEAP*11)	; 11 Select sector.
SETDMA		EQU	BIOS+(LEAP*12)	; 12 Set DMA ADDress.
READ		EQU	BIOS+(LEAP*13)	; 13 Read 128 bytes.
WRITE		EQU	BIOS+(LEAP*14)	; 14 Write 128 bytes.
LISTST		EQU	BIOS+(LEAP*15)	; 15 List status.
SECTRAN		EQU	BIOS+(LEAP*16)	; 16 Sector translate.
PRINTSEQ	EQU	BIOS+(LEAP*17)	; not a BIOS function

