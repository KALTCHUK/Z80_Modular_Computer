;==================================================================================
; Use Monitor to load this program to 0100h.
; Switch to CP/M
; SAVE 2 DOWNLOAD.COM
;
; What this program does:
;	- transfer itself to 0C000h
;	- receive a block os ASCII bytes starting with ':' and terminated with '#'
;	- convert the charcters to bytes and write them starting at 0300h
;	- print the number of pages (you'll need this info for the SAVE x command)
;	- transfer the block from 0300h to 0100h (beginning of TPA)
;	- return control to CCP
;==================================================================================

TPA		.EQU	0100H
PTPA	.EQU	0300H
NEWLOC	.EQU	0C000H
REBOOT	.EQU	0H
BDOS	.EQU	5H
CONIO	.EQU	6
CONINP	.EQU	1
CONOUT	.EQU	2
PSTRING	.EQU	9

CR		.EQU	0DH
LF		.EQU	0AH

	.ORG TPA
		LD	DE,msgInit
		LD	C,PSTRING
		CALL	BDOS
		CALL	CRLF
COLON:
		CALL	GETCHR
		CP	':'
		JR	NZ,COLON
		LD	DE,PTPA						; this is the addr to start writing the incoming block
GETHEX:
		CALL	GETCHR
		CP	'#'							; is it the end?
		JR	Z,CLOSE
		LD   H,A
		CALL	GETCHR
		LD   L,A
		CALL	ASCII2HEX
		LD	A,B
		LD	(DE),A
		INC	DE
		JR	GETHEX
CLOSE:	
		DEC	DE							; DE contains the last written address
		CALL	CRLF
		PUSH	DE
		LD		DE,msgPages
		LD		C,PSTRING
		CALL	BDOS
		POP		DE
		DEC		D
		DEC		D
		DEC		D
		LD		A,E
		CP		0
		LD		B,D
		JR		Z,NOINC
		INC		B
NOINC:
		CALL	HEX2ASCII
		LD	A,H
		CALL	PUTCHR
		LD	A,L
		CALL	PUTCHR
		CALL	CRLF

		LD		DE,msgTransf
		LD		C,PSTRING
		CALL	BDOS
		CALL	CRLF

		PUSH	DE

		LD	BC,EBLK-BBLK
		LD	DE,NEWLOC
		LD	HL,BBLK
		LDIR
		JP	NEWLOC
BBLK:
		POP		BC					; move loaded program from 0300h to 0100h
		LD	DE,TPA
		LD	HL,PTPA
		LDIR
		JP	REBOOT

EBLK:

;================================================================================================
; Send CR + LF to console
;================================================================================================
CRLF: 
		LD	A,CR
		CALL	PUTCHR
		LD	A,LF
		CALL	PUTCHR
		RET

;================================================================================================
; Get chat from console
;================================================================================================
GETCHR: 
		PUSH	DE
		LD	E,$FF
		LD 	C,CONIO
		CALL 	BDOS
		CP	0
		JR	Z,GETCHR
		POP		DE
		RET

;================================================================================================
; Send char to console
;================================================================================================
PUTCHR:
		PUSH	DE
		LD C,CONOUT
		LD E,A
		CALL BDOS
		POP		DE
		RET

;================================================================================================
; Convert HEX to ASCII (B --> HL)
;================================================================================================
HEX2ASCII:
		PUSH	BC
		LD	A,B
		AND	0FH
		LD	L,A
		SUB	0AH
		LD	C,030H
		JP	C,COMPENSATE
		LD	C,037H
COMPENSATE:
		LD	A,L
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
		JP	C,COMPENSATE2
		LD	C,037H
COMPENSATE2:
		LD	A,H
		ADD	A,C
		LD	H,A
		POP	BC
		RET

;================================================================================================
; Convert ASCII to HEX (HL --> B)
;================================================================================================
ASCII2HEX:	PUSH	BC
		LD	A,060H
		SUB	H
		LD	C,057H
		JP	C,DISCOUNT
		LD	A,040H
		SUB	H
		LD	C,037H
		JP	C,DISCOUNT
		LD	C,030H
DISCOUNT:
		LD	A,H
		SUB	C
CONVL:
		LD	B,A
		SLA	B
		SLA	B
		SLA	B
		SLA	B

		LD	A,060H
		SUB	L
		LD	C,057H
		JP	C,DISCOUNT2
		LD	A,040H
		SUB	L
		LD	C,037H
		JP	C,DISCOUNT2
		LD	C,030H
DISCOUNT2:
		LD	A,L
		SUB	C
		OR	B
		POP	BC
		LD	B,A
		RET

;================================================================================================
; Message area
;================================================================================================
msgInit	 		.BYTE	"Send ASCII block starting with ':' and ending with '#'$"
msgPages 		.BYTE	"Number of pages written: 0x$"
msgTransf 		.BYTE	"Transfering block to TPA... $"


		.END



