; USE Z80ASM WSKT/H ?


CCP			EQU	0D000h				; Base of CCP (or Monitor).
BIOS		EQU	0E620h				; Base of BIOS.

BOOT		EQU	0
LEAP		EQU	3					; 3 bytes for each entry (JP aaaa)

CONST:		EQU	BIOS+(LEAP*2)		;  2 Console status.
CONIN:		EQU	BIOS+(LEAP*3)		;  3 Console input.
CONOUT:		EQU	BIOS+(LEAP*4)		;  4 Console output.
LIST:		EQU	BIOS+(LEAP*5)		;  3 Console input.
LISTST:		EQU	BIOS+(LEAP*15)		;  2 Console status.
PRINTSEQ:	EQU	BIOS+(LEAP*17)		;  4 Console output.

LF			EQU	0AH
CR			EQU	0DH

TARGET		EQU	5000H
SOURCELEN	EQU	SOURCEEND-SOURCE
;================================================================================================
			ORG	0100H

START:		LD	HL,SOURCE
			LD	DE,TARGET
			LD	BC,SOURCELEN
			LDIR
			JP	TARGET
			
SOURCE:		.PHASE	TARGET
			CALL	PRINTSEQ
			DB	"IT WORKS!", CR, LF, 0
			JP	BOOT
			.DEPHASE
SOURCEEND:	$
