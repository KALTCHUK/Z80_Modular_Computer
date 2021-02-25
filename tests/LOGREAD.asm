;==================================================================================
; READ DEBUG LOG AND SHOW ON CONSOLE
;==================================================================================
REBOOT		.EQU	0H
BDOS		.EQU	5H
TPA			.EQU	0100H
BIOS		.EQU	0E600h			; Base of BIOS.

CONIN		.EQU	BIOS+(3*3)		; BIOS entry for Console Input (console --> regA)
CONOUT		.EQU	BIOS+(3*4)		; BIOS entry for Console Output (regC --> console)
C_STRING	.EQU	9
F_CLOSE		.EQU	16
F_DELETE	.EQU	19
F_WRITE		.EQU	21
F_MAKE		.EQU	22
F_DMAOFF	.EQU	26

EOT			.EQU	04H
ACK			.EQU	06H
LF			.EQU	0AH
CR			.EQU	0DH
NAK			.EQU	015H
EM			.EQU	019H
RS			.EQU	01EH
		
FCB			.EQU	0005CH
DMA			.EQU	080H
LOGPTR		.EQU	0300H
LOGBUF		.EQU	LOGPTR+2
;==================================================================================
			.ORG TPA

			LD	SP,STACK			; Set default stack.
			LD	BC,(LOGPTR)
			LD	HL,LOGBUF
			
			LD	A,(HL)
			CP	EOT
			JR	Z,CEOT
			CP	EOT
			JR	Z,CACK
			CP	EOT
			JR	Z,CLF
			CP	EOT
			JR	Z,CCR
			CP	EOT
			JR	Z,CNAK
			CP	EOT
			JR	Z,CEM
			CP	EOT
			JR	Z,CRS
			LD	C,A
			CALL CONOUT
			

			SCF
			CCF
			LD	BC,(LOGPTR)
			SBC	HL,BC
			JP	Z,FINISH

			
;==================================================================================
; Initialize debug log
;==================================================================================
LOGINI:		LD	HL,LOGBUF
			LD	(LOGPTR),HL
			RET

;==================================================================================
; Write regA to Log
;==================================================================================
LOG:		LD	HL,(LOGPTR)
			LD	(HL),A
			INC	HL
			LD	(LOGPTR),HL
			RET

;==================================================================================
SYMEOT		.DB	"<EOT>$"
SYMACK		.DB	"<ACK>$"
SYMLF		.DB	"<LF>$"
SYMCR		.DB	"<CR>$"
SYMNAK		.DB	"<NAK>$"
SYMEM		.DB	"<EM>$"
SYMRS		.DB	"<RS>$"

			.DS	020h			; Start of stack area.
STACK		.EQU	$


			.END
