;==================================================================================
; READ CONSOLE, ECHO AND WRITE TO FILE
;==================================================================================
REBOOT		.EQU	0H
BDOS		.EQU	5H
TPA			.EQU	0100H

C_READ		.EQU	1
C_WRITE		.EQU	2
C_RAWIO		.EQU	6
C_WRITESTR	.EQU	9
F_CLOSE		.EQU	16
F_DELETE	.EQU	19
F_WRITE		.EQU	21
F_MAKE		.EQU	22
F_DMAOFF	.EQU	26

CTRLC		.EQU	03H
EOT			.EQU	023H		;04H
ACK			.EQU	024H		;06H
LF			.EQU	0AH
CR			.EQU	0DH
NAK			.EQU	025H		;015H
EM			.EQU	026H		;019H
SUB			.EQU	01AH
		
FCB			.EQU	0005CH
FCBEX		.EQU	FCB+12
FCBCR		.EQU	FCB+32
DMA			.EQU	080H
;==================================================================================
			.ORG TPA

			LD	HL,DMA
			LD	(BUFFPTR),HL
			
			CALL SETDMA			; Set DMA
			CALL DELFILE		; Delete and create file
			CALL MAKEFILE

			LD	DE,MSGINI		; Greeting message
			LD	C,C_WRITESTR
			CALL BDOS

NEXTCHAR:	CALL GETCHAR		; Read console and echo it
			CP	CTRLC			; If char is CTRL-C, stop reading console
			JR	Z,DONE
NOTCR:		PUSH AF
			CALL WRBUFF
			POP	AF
			CP	CR
			JR	NZ,NEXTCHAR
			LD	A,LF
			CALL WRBUFF
			LD	A,LF
			CALL PUTCHAR
			JR	NEXTCHAR
			
DONE:		LD	A,SUB
			CALL WRBUFF
			LD	HL,DMA			; Check if buffer is empty
			EX	DE,HL
			LD	HL,(BUFFPTR)
			SCF
			CCF
			SBC	HL,DE
			JR	Z,JUSTCLOSE
			CALL WRITEBLK
			
JUSTCLOSE:	CALL CLOSEFILE
			LD	DE,MSGEND		; Exit message
			LD	C,C_WRITESTR
			CALL BDOS
			JP	REBOOT

;==================================================================================
; Wait for a char and return it on A (no echo)
;==================================================================================
GETCHAR:	LD	E,0FFH
			LD 	C,C_READ
			CALL BDOS
			CP	0
			JR	Z,GETCHAR
			RET

;==================================================================================
; Write A to output
;==================================================================================
PUTCHAR:	LD C,C_WRITE
			LD E,A
			CALL BDOS
			RET

;==================================================================================
; Write char in regA to Buffer
;==================================================================================
WRBUFF:		LD	HL,(BUFFPTR)	; Put char in buffer
			LD	(HL),A
			INC	HL
			LD	(BUFFPTR),HL
			LD	A,H
			CP	1
			RET NZ
			CALL WRITEBLK
			RET

;==================================================================================
; Set DMA
;==================================================================================
SETDMA:		LD	C,F_DMAOFF
			LD	DE,DMA
			CALL BDOS
			RET

;==================================================================================
; Delete file
;==================================================================================
DELFILE:	LD	DE,MSGDF		; message
			LD	C,C_WRITESTR
			CALL BDOS

			LD	C,F_DELETE
			LD	DE,FCB
			CALL BDOS
			
			LD	B,A
			CALL B2HL
			CALL PRTNUM
			RET

;==================================================================================
; Make file
;==================================================================================
MAKEFILE:	LD	DE,MSGMF		; message
			LD	C,C_WRITESTR
			CALL BDOS

			LD	C,F_MAKE
			LD	DE,FCB
			CALL BDOS

			LD	B,A
			CALL B2HL
			CALL PRTNUM
			RET

;==================================================================================
; Write block to file
;==================================================================================
WRITEBLK:	LD	C,F_WRITE
			LD	DE,FCB
			CALL BDOS
			LD	HL,DMA			; Restart buffer pointer 
			LD	(BUFFPTR),HL
			RET

;==================================================================================
; Close file
;==================================================================================
CLOSEFILE:	LD	DE,MSGCF		; message
			LD	C,C_WRITESTR
			CALL BDOS

			LD	C,F_CLOSE
			LD	DE,FCB
			CALL BDOS

			LD	B,A
			CALL B2HL
			CALL PRTNUM
			RET

;==================================================================================
; Print a 2-digit number + LF + CR (number in HL)
;==================================================================================
PRTNUM:		LD	A,H
			CALL PUTCHAR
			LD	A,L
			CALL PUTCHAR
			LD	A,CR
			CALL PUTCHAR
			LD	A,LF
			CALL PUTCHAR
			RET

;================================================================================================
; Convert HEX to ASCII (B --> HL)
;================================================================================================
B2HL:		PUSH	BC
			LD	A,B
			AND	0FH
			LD	L,A
			SUB	0AH
			LD	C,030H
			JP	C,COMP
			LD	C,037H
COMP:		LD	A,L
			ADD	A,C
			LD	L,A
			LD	A,B
			AND	0F0H
			SRL	A
			SRL	A
			SRL	A
			SRL	A
			LD	H,A
			SUB	0AH
			LD	C,030H
			JP	C,COMP2
			LD	C,037H
COMP2:		LD	A,H
			ADD	A,C
			LD	H,A
			POP	BC
			RET

;==================================================================================
MSGINI		.DB		"TYPE CTRL-C TO END PROGRAM.", CR, LF, "$"
MSGEND		.DB		CR, LF, "END OF PROGRAM. RETURNING TO CCP...", CR, LF, "$"
MSGDF		.DB		"DELETE FILE RETURN: $"
MSGMF		.DB		"MAKE FILE RETURN  : $"
MSGCF		.DB		"CLOSE FILE RETURN : $"
MSGWB		.DB		"WRITE BLOCK RETURN: $"

BUFFPTR		.DW	0000H

			.DS	020h			; Start of stack area.
STACK:		.EQU	$

			.END
