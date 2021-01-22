;================================================================================================
; Clears all memory from 0100h to BFFFh
; Clear means fill it with 00
;================================================================================================

PRINTSEQ		.EQU	0E633H			; Routine (located in the BIOS) to print a sequence of characters
WAITCMD			.EQU	0D131H			; Reentry point to Monitor

TOPMEM			.EQU	0C000H			; The program will reside here
TPA				.EQU	0100H			; Start of Transient Program Area fo CP/M 

LF				.EQU	0AH				; line feed
CR				.EQU	0DH				; carriage return
;================================================================================================

		.ORG TOPMEM
		
		LD		BC,TOPMEM-TPA-2
		LD		DE,TPA+1
		LD		HL,TPA
		LD		(HL),0
		LDIR

		CALL	PRINTSEQ
		.TEXT	"Memory cleared."
		.DB CR,LF,0

		JP	WAITCMD
		


		.END
