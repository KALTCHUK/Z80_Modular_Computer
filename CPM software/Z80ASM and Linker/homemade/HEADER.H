;----------------------------------------------------------
;
;TTYTERM.Z80 -	Comunicate with preTTY card (0C0h).
; 		Emulates a terminal.
;		
;----------------------------------------------------------

TPA		EQU	0100H

BIOS		EQU	0E620H
WBOOT		EQU	BIOS+3
CONST		EQU	BIOS+6
CONIN		EQU	BIOS+9
CONOUT		EQU	BIOS+12

TTY		EQU	0C0H
DATA		EQU	TTY
STAT		EQU	TTY+2
CMD		EQU	TTY+2

CTRLC		EQU	03H
LF		EQU	0AH
CR		EQU	0DH
;----------------------------------------------------------
; MAIN PROGRAM
;----------------------------------------------------------
		ORG	TPA
		LD	HL,MYSTACK
		LD	SP,HL
