;----------------------------------------------------------
;
;----------------------------------------------------------

TTY			.EQU	0C0H
DATA		.EQU	TTY
STAT		.EQU	TTY+2
CMD			.EQU	TTY+2
;----------------------------------------------------------
; MAIN PROGRAM
;----------------------------------------------------------
			.ORG	0
			LD	HL,MYSTACK
			LD	SP,HL

START:		IN	A,(STAT)
			NOP
			IN	A,(0)
			NOP
			JR	START

			CP	0
			JR	Z,START
			HALT
			IN	A,(DATA)
			OUT	(DATA),A
			JR	START

MYSTACK		.EQU	$

			.END