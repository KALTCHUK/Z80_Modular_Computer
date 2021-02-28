;==================================================================================
; XMODEM.ASM version 1 - Kaltchuk, feb/2021
;
; This program implements xmodem protocol on CP/M. 
; Only uploads (Windows --> CP/M)
;
; On the Windows console there's a counterpart program - XMODEM.PY, which starts
; the application on CP/M.
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

SOH			.EQU	01H
EOT			.EQU	04H
ACK			.EQU	06H
LF			.EQU	0AH
CR			.EQU	0DH
NAK			.EQU	015H
CAN			.EQU	018H
SUB			.EQU	01AH
		
FCB			.EQU	0005CH
DMA			.EQU	080H
;==================================================================================
			.ORG TPA

			LD	SP,STACK			; Set default stack.
			LD	A,(FCB+1)
			CP	' '					; Test if program has argument (file name)
			JR	NZ,START
			LD	DE,MSG
			LD	C,C_STRING
			CALL BDOS
			JP	REBOOT
START:		LD	HL,DMA				; Initialize buffer pointer
			LD	(BUFPTR),HL
			LD	A,0
			LD	(RETRY),A			; Initialize retry counter
			INC	A
			LD	(BLOCK),A			; Initialize block counter
			CALL DELFILE			; Delete file
			CALL MAKEFILE			; Create file
			CP	4					; 0, 1, 2 or 3 = OK
			JP	M,ALIVE
CANCEL:		CALL SENDCAN
			JP	REBOOT

ALIVE:		CALL SENDNAK
GETCHAR:	CALL CONIN				; Get 1st char
			CP	EOT					; Is it the end?
			JR	Z,CLOSE
			CP	SOH					; Is a new block arriving?
			JR	NZ,GETCHAR
			LD	A,0
			LD	(CHKSUM),A			; Reset checksum
			LD	HL,DMA
			LD	(BUFPTR),HL			; Reset buffer pointer
			CALL CONIN				; Get block number
			LD	B,A
			CALL CONIN				; Get /block number
			ADD	A,B
			CP	0FFH
			JR	NZ, CANCEL
			LD	A,(BLOCK)
			CPL
			CP	B
			JR	Z,GOOD2GO
			JR	CANCEL
			
AGAIN:		LD	A,(RETRY)
			INC	A
			LD	(RETRY),A			; Increment retry counter
			CP	4
			JP	P,CANCEL
			JR	ALIVE

GOOD2GO:	CALL CONIN
			LD	HL,(BUFPTR)
			LD	(HL),A				; Put received byte in buffer
			INC	HL
			LD	(BUFPTR),HL			; Increment buffer pointer
			LD	B,A
			LD	A,(CHKSUM)
			ADD	A,B
			LD	(CHKSUM),A			; Update checksum
			LD	A,H
			CP	1					; Check if we reached the end of the buffer (0FFh is the last valid position)
			JR	NZ,GOOD2GO
			CALL CONIN				; Receive checksum
			LD	B,A
			LD	A,(CHKSUM)
			CP	B
			JR	NZ,AGAIN			; See if checksum is OK
			LD	A, (BLOCK)
			INC	A
			LD	(BLOCK),A			; Increment block counter
			LD	A,0
			LD	(RETRY),A			; Reset retry counter
			LD	HL,DMA
			LD	(BUFPTR),HL			; Reset buffer pointer
			CALL WRITEBLK
			CP	0
			JR	NZ,CANCEL
			CALL SENDACK
			JR	GETCHAR
			
CLOSE:		CALL SENDACK
			CALL CLOSFILE
			JP	REBOOT
			
;==================================================================================
; Delete file. Returns 0, 1, 2 or 3 if successful.
;==================================================================================
DELFILE:	LD	C,F_DELETE			; Delete file
			LD	DE,FCB
			CALL BDOS
			RET
			
;==================================================================================
; Make file. Returns 0, 1, 2 or 3 if successful.
;==================================================================================
MAKEFILE:	LD	C,F_MAKE			; Create file
			LD	DE,FCB
			CALL BDOS
			RET

;==================================================================================
; Close file. Returns 0, 1, 2 or 3 if successful.
;==================================================================================
CLOSFILE:	LD	C,F_CLOSE			; Close file
			LD	DE,FCB
			CALL BDOS
			RET
			
;==================================================================================
; Send ACK
;==================================================================================
SENDACK:	LD C,ACK
			CALL CONOUT
			RET

;==================================================================================
; Send NAK
;==================================================================================
SENDNAK:	LD C,NAK
			CALL CONOUT
			RET

;==================================================================================
; Send CAN
;==================================================================================
SENDCAN:	LD C,CAN
			CALL CONOUT
			RET

;==================================================================================
; Write block to file. Returns 0 if successful.
;==================================================================================
WRITEBLK:	LD	C,F_WRITE			; Write buffer to disk.
			LD	DE,FCB
			CALL BDOS
			RET

;==================================================================================
; Convert ASCII characters in BC to a byte in A
;==================================================================================
BC2A:		LD   A,B				
			SUB  030H
			CP   0AH
			JR   C,BC2A1
			SUB  07H
BC2A1:		RLCA
			RLCA
			RLCA
			RLCA
			LD   B,A
			LD   A,C
			SUB  030H
			CP   0AH
			JR   C,BC2A2
			SUB  07H
BC2A2:		ADD  A,B
			RET
			
;==================================================================================
MSG:		.DB	"XMODEM 1.0 - Receive a file from console and store it on disk."
			.DB	CR,LF
			.DB	"Use 'XMODEM.PY' on Windows console to start this program.$"

BUFPTR		.DW	0
CHKSUM	 	.DB	0
RETRY		.DB 0
BLOCK		.DB	0

			.DS	020h			; Start of stack area.
STACK		.EQU	$


			.END
