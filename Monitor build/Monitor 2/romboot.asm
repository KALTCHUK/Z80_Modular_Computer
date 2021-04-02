;==================================================================================
; ROM Bootloader for CP/M and Monitor
;==================================================================================
CCP			.EQU	0D000h			; Base of CCP (or Monitor).
BIOS		.EQU	0E600h			; Base of BIOS.
ROM_CCP		.EQU	01000h			; Base of CCP in ROM
ROM_BIOS	.EQU	02600h			; Base of BIOS in ROM
;================================================================================================
			.ORG	0

			LD	BC,03000H			; Copy CP/M and BIOS from ROM (01000h) to RAM (0D000h)
			LD	DE,CCP
			LD	HL,ROM_CCP
			LDIR

			JP	BIOS

			.END