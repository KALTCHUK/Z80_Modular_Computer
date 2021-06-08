;
; WSKT.Z80 - KEY SEQUENCE TRANSLATOR FOR WORDSTAR.
;
; USE Z80ASM WSKT/H ?

CCP			EQU	0D000h				; Base of CCP (or Monitor).
BIOS		EQU	0E620h				; Base of BIOS.
FCB			EQU	05CH
UINT		EQU	0E88FH
INTADDR		EQU	039H

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

SOURCELEN	EQU	SOURCEEND-SOURCE
TARGET		EQU	CCP-SOURCELEN
;================================================================================================
			ORG	0100H

			DI
			LD	A,(FCB+1)
			CP	'+'
			JR	Z,ACTIV
			CP	'-'
			JR	Z,DEACTIV
			CALL	PRINTSEQ
			DB	"WSKT - Key sequence translator for WordStar.", CR, LF
			DB	"Use: WSKT + or - to activate or deactivate key translation.", CR, LF, 0
FINAL:		IM	1
			EI
			JP	CCP
			
DEACTIV:	LD	HL,UINT
			LD	(INTADDR),HL
			CALL	PRINTSEQ
			DB	"Key translation OFF.", CR, LF,0
			JR	FINAL
			
			
			
ACTIV:		LD	HL,SOURCE
			LD	DE,TARGET
			LD	BC,SOURCELEN
			LDIR
			LD	HL,TARGET
			LD	(INTADDR),HL
			CALL	PRINTSEQ
			DB	"Key translation ON.", CR, LF,0
			JR	FINAL
			
SOURCE:		.PHASE	TARGET
			NOP			; INTERRUPT ROUTINE GOES HERE
			NOP			; INTERRUPT ROUTINE GOES HERE
			NOP			; INTERRUPT ROUTINE GOES HERE
			.DEPHASE
SOURCEEND:	$
