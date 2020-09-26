COUNTER	.EQU	05000H
CHAR		.EQU	05001H
ATARGET	.EQU	0F000H

;================================================================================================
		.ORG 0
		LD	A,0
		LD	B,A
		LD	(COUNTER),A
		LD	A,(CHAR)
		LD	C,A
		LD	DE,ATARGET
		LD	HL,COUNTER

REPT:		LD	A,(DE)
		CP	C
		JR	Z,EQUAL
		INC	(HL)
EQUAL:	INC	DE
		DJNZ	REPT
		HALT

		.END
