;================================================================================================
; Silly script to test HEX2COM.
;
;================================================================================================
PRINTSEQ		.EQU	0E633H			; Routine (located in the BIOS) to print a sequence of characters
CONST			.EQU	0E606H			; Entry point for BIOS function CONST
CONIN			.EQU	0E609H			; Entry point for BIOS function CONIN
CONOUT			.EQU	0E60CH			; Entry point for BIOS function CONOUT

LF				.EQU	0AH				; line feed
CR				.EQU	0DH				; carriage return

;================================================================================================
; Compact flash initialization
;================================================================================================
		.ORG 2000H

		CALL	PRINTSEQ
		.DB CR,LF,"ECHOES",CR,LF,CR,LF
		.DB "Overhead the albatross",CR,LF
		.DB "Hangs motionless upon the air",CR,LF
		.DB "And deep beneath the rolling waves",CR,LF
		.DB "In labyrinths of coral caves",CR,LF
		.DB "The echo of a distant time",CR,LF
		.DB "Comes willowing across the sand",CR,LF
		.DB CR,LF,0

		HALT

		.END
