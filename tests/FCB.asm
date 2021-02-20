;==================================================================================
; Read FCB and send to console
;
;==================================================================================
REBOOT		.EQU	0H
BDOS		.EQU	5H
TPA			.EQU	0100H

C_READ		.EQU	1
C_WRITE		.EQU	2
C_STRING	.EQU	9
F_CLOSE		.EQU	16
F_DELETE	.EQU	19
F_WRITE		.EQU	21
F_MAKE		.EQU	22
F_DMAOFF	.EQU	26

EOT			.EQU	023H		;04H
ACK			.EQU	024H		;06H
LF			.EQU	0AH
CR			.EQU	0DH
NAK			.EQU	025H		;015H
EM			.EQU	026H		;019H
		
FCB			.EQU	0005CH
DMA			.EQU	080H
;==================================================================================
			.ORG TPA
			LD	SP,STACK
			
			LD	HL,FCB+1
			LD	DE,FCB2
			LD	BC,11
			LDIR
			LD	C,C_STRING
			LD	DE,MSG
			CALL BDOS
			JP	REBOOT

;==================================================================================
MSG:		.DB	"FCB="
FCB2		.DS	11
			.DB	".",CR,LF,"$"

			.DS	020h			; Start of stack area.
STACK		.EQU	$

			.END
