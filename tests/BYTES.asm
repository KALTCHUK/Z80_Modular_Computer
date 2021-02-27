;==================================================================================
; Receive version 1.4 - Kaltchuk, feb/2021
;
;==================================================================================
REBOOT		.EQU	0H
TPA			.EQU	0100H
BIOS		.EQU	0E600h			; Base of BIOS.

CONIN		.EQU	BIOS+(3*3)		; BIOS entry for Console Input (console --> regA)
CONOUT		.EQU	BIOS+(3*4)		; BIOS entry for Console Output (regC --> console)
C_STRING	.EQU	9

LOGPTR		.EQU	0300H
LOGBUF		.EQU	LOGPTR+2
;==================================================================================
			.ORG TPA

			LD	HL,LOGBUF

NEXT:		CALL CONIN				; Get 1st char
			LD	(HL),A				; Put byte in buffer
			INC	HL
			LD	(LOGPTR),HL
			JR	NEXT

			.END
