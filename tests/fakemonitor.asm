;==================================================================================
; Monitor for Z80 Modular Computer by P.R.Kaltchuk 2020
;==================================================================================
BIOS			.EQU	0E600H		; BIOS entry point
LF			.EQU	0AH			; line feed
FF			.EQU	0CH			; form feed
CR			.EQU	0DH			; carriage return
SPACE			.EQU	020H			; space
COLON			.EQU	03AH			; colon

READCOLS		.EQU	010H			; parameters used for read memory command (READCMD)
READLINES		.EQU	010H

; USART card stuff
USART_DAT		.EQU	0D0H			; USART data addr
USART_CMD		.EQU	0D1H			; USART command addr
USART_STA		.EQU	0D1H			; USART status addr
UMODE			.EQU	06DH			; 8N1 (8 bit, no parity, 1 stop), baud=clock (9600bps)
UCMD0			.EQU	015H			; initial command: Rx enable, Tx enable, reset error flags

;================================================================================================
			.ORG 0
		JP	WAITCMD
MONITOR:
		CALL	PRINTSEQ
		.TEXT	"Z80 Modular Computer Monitor V.1 by Kaltchuk, Sep/2020"
		.DB	CR,LF,CR,LF,0
CMDLIST:
		CALL	PRINTSEQ
		.TEXT	"Valid commands:"
		.DB	CR,LF
		.TEXT	"   Raaaa   read memory starting at aaaa"
		.DB	CR,LF
		.TEXT	"   Waaaa   write to memory starting at aaaa"
		.DB	CR,LF
		.TEXT	"   H       write intel hex format to memory"
		.DB	CR,LF
		.TEXT	"   Jaaaa   jump to address aaaa"
		.DB	CR,LF,CR,LF
		.TEXT	"   * Where aaaa is always a 4-character hex value."
		.DB	CR,LF,0

		IM	1
		EI

;================================================================================================
; Wait for command
;================================================================================================
WAITCMD:	CALL	PRINTSEQ
		.DB	CR,LF,03EH,0

		CALL CONIN

		CP	'R'
		JP	Z,READCMD
		CP	'r'
		JP	Z,READCMD

		CP	'W'
		JP	Z,WRITECMD
		CP	'w'
		JP	Z,WRITECMD

		CP	'H'
		JP	Z,HEXCMD
		CP	'h'
		JP	Z,HEXCMD

		CP	'J'
		JP	Z,JUMPCMD
		CP	'j'
		JP	Z,JUMPCMD

		CP	'T'
		JP	Z,TESTCMD
		CP	't'
		JP	Z,TESTCMD

UNKNOWNCMD:
		CALL FLUSHBUF
		CALL	PRINTSEQ
		.DB CR,LF
		.TEXT "Unknown command."
		.DB CR,LF,CR,LF,0
		JP	CMDLIST

;================================================================================================
; Read memory, starting at address aaaa
;================================================================================================
READCMD:
		CALL	GETADDR		; DE holds the address to start reading
		CP	0
		JP	Z,CMDLIST
		LD	A,0F0H
		AND	E
		LD	E,A			; DE converted from AAAA to AAA0
		PUSH	DE
		POP	IX			; from now on, IX will hold the address
		CALL	PRINTSEQ		; print header
		.TEXT "ADDR: 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  0123456789ABCDEF"
		.DB CR,LF
		.TEXT "----- -----------------------------------------------  ----------------"
		.DB CR,LF,0
		LD	D,READLINES	; lines
NEWL:		LD	E,READCOLS		; columns
		PUSH	IX			; prepare to print address
		POP	HL
		LD	B,H
		CALL	HEX2ASCII
		LD	C,H
		CALL	CONOUT
		LD	C,L
		CALL	CONOUT
		PUSH	IX
		POP	HL
		LD	B,L
		CALL	HEX2ASCII
		LD	C,H
		CALL	CONOUT
		LD	C,L
		CALL	CONOUT
		LD	C,COLON
		CALL	CONOUT
		LD	C,SPACE
		CALL	CONOUT
		PUSH	IX
		POP	IY			; IY holds a copy of the 1st memory address from current line
NEWC:		LD	A,(IX)		; prepare to print memory contents
		LD	B,A
		CALL	HEX2ASCII		; now HL contains the ASCII exivalent of memory content
		LD	C,H
		CALL	CONOUT
		LD	C,L
		CALL	CONOUT
		LD	C,SPACE
		CALL	CONOUT
		INC	IX
		DEC	E
		JR	NZ,NEWC
		LD	C,SPACE
		CALL CONOUT
		LD	E,READCOLS		; now start doing the printables' area
NEWCP:	LD	A,(IY)
		CP	020H
		JP	M,NOTPTBL
		LD	C,A
		JP 	CONTCP
NOTPTBL:	LD	C,'.'
CONTCP:	CALL	CONOUT
		INC	IY
		DEC	E
		JR	NZ,NEWCP
		LD	C,CR
		CALL	CONOUT
		LD	C,LF
		CALL	CONOUT
		DEC	D
		JR	NZ,NEWL
		LD	C,CR
		CALL	CONOUT
		LD	C,LF
		CALL	CONOUT
		JP	WAITCMD

;================================================================================================
; Write to memory, starting at address aaaa
;================================================================================================
WRITECMD:
		CALL	GETADDR		; DE holds the address to start writing
		CP	0
		JP	Z,CMDLIST
		CALL	PRINTSEQ
		.TEXT "Send data to be written."
		.DB CR,LF,0
NEXTWR:	CALL	CONIN
		LD	H,A
		CP	CR
		JR	Z,EOW
		CALL	CONIN
		LD	L,A			; at this point HL holds the value to be written (ASCII)
		CP	CR
		JR	Z,EOW
		CALL	ASCII2HEX		; B holds the hex value
		LD	A,B
		LD	(DE),A
		INC	DE
		JR	NEXTWR
EOW:		CALL	CONIN
		CP	LF
		JP	Z,TRUEEOW
		CALL	PRINTSEQ
		.DB CR,LF
		.TEXT "Syntax error. Incomplete ASCII pair."
		.DB CR,LF,CR,LF,0
		JP	WAITCMD
TRUEEOW:
		CALL	PRINTSEQ
		.TEXT "Memory write complete."
		.DB CR,LF,CR,LF,0
		JP	WAITCMD

;================================================================================================
; Write to memory using Intel hex file format input
;================================================================================================
HEXCMD:
		CALL	PRINTSEQ
		.TEXT "Send HEX-format data to be written."
		.DB CR,LF,0
NEWHLINE:
		LD	IX,0				; IX will be the accumulator for checksum
		CALL	CONIN				; get the start code ':'
		CP	':'
		JR	NZ,NEWHLINE
		CALL	CONIN				; get byte count
		LD	H,A
		CALL	CONIN
		LD	L,A
		CALL	ASCII2HEX
		LD	C,B				; C = byte count
		LD	A,0
		CP	C
		JP	Z,EOHF			; if byte count = 0, we reached the end of write operation
		LD	B,0
		ADD	IX,BC				; update checksum with byte count
		PUSH	BC				; save byte counter on the stack
		LD	C,':'				; start printing ":addr "
		CALL	CONOUT
		CALL	CONIN				; get address
		LD	H,A
		LD	C,A
		CALL	CONOUT
		CALL	CONIN
		LD	L,A
		LD	C,A
		CALL	CONOUT
		CALL	ASCII2HEX
		LD	D,B				
		CALL	CONIN	
		LD	H,A
		LD	C,A
		CALL	CONOUT
		CALL	CONIN
		LD	L,A
		LD	C,A
		CALL	CONOUT
		CALL	ASCII2HEX
		LD	E,B				; DE = start addr 
		LD	B,0
		LD	C,D
		ADD	IX,BC				; update checksum with addr HI
		LD	C,E
		ADD	IX,BC				; update checksum with addr LO
		CALL	CONIN				; get record type
		LD	H,A
		CALL	CONIN
		LD	L,A
		CALL	ASCII2HEX
		LD	C,B
		LD	B,0
		ADD	IX,BC				; update checksum with record type
NEXTD:	CALL	CONIN				; start reading data
		LD	H,A
		CALL	CONIN
		LD	L,A
		CALL	ASCII2HEX
		LD	C,B
		LD	B,0
		ADD	IX,BC				; update checksum data byte
		LD	A,C
		LD	(DE),A			; write data to memory
		INC	DE				; increment memory addr for next write
		POP	BC				; pop byte count from stack
		DEC	C				; decrement byte counter
		PUSH	BC				; save byte counter on the stack
		JP	NZ,NEXTD
		CALL	CONIN				; get checksum
		LD	H,A
		CALL	CONIN
		LD	L,A
		CALL	ASCII2HEX			; B = checksum
		PUSH	IX
		POP	DE
		LD	A,E
		NEG
		CP	B
		JR	Z,CHECKOK
		CALL	PRINTSEQ
		.TEXT	"checksum error!"
		.DB CR,LF,0
		JP	NEWHLINE
CHECKOK:	CALL	PRINTSEQ
		.TEXT	"OK"
		.DB CR,LF,0
		JP	NEWHLINE

EOHF:		CALL	FLUSHBUF
		CALL	PRINTSEQ
		.TEXT "Memory write complete."
		.DB CR,LF,CR,LF,0
		JP	WAITCMD

;================================================================================================
; Jump to address aaaa
;================================================================================================
JUMPCMD:
		CALL	GETADDR
		CP	0
		JP	Z,CMDLIST
		PUSH	DE
		POP	HL
		JP	(HL)

;================================================================================================
; Test quality of RX. Count how many bytes are not zero in the range f000-f0ff
;================================================================================================
COUNTER	.EQU	05000H
CHAR		.EQU	05001H
ATARGET	.EQU	04000H

TESTCMD:	CALL	CONIN				; get CR + LF
		CALL	CONIN


		LD	A,0
		LD	B,A
		LD	(COUNTER),A
		LD	A,(CHAR)
		LD	C,A
		LD	DE,ATARGET
		LD	HL,COUNTER

REPT:		LD	A,(DE)
		CP	C
		JR	Z,EQUAL
		INC	(HL)
EQUAL:	INC	DE
		DJNZ	REPT
		LD	A,(COUNTER)
		LD	B,A
		CALL	HEX2ASCII
		LD	C,H
		CALL	CONOUT
		LD	C,L
		CALL	CONOUT
		JP	WAITCMD

;================================================================================================
; Get address parameter from command line and return it in DE. If error, A=0.
;================================================================================================
GETADDR:	PUSH	BC
		PUSH	HL
		CALL	CONIN
		LD	H,A
		CALL	CONIN
		LD	L,A
		CALL	ASCII2HEX
		LD	D,B
		CALL	CONIN
		LD	H,A
		CALL	CONIN
		LD	L,A
		CALL	ASCII2HEX
		LD	E,B				; now DE contains the address
		CALL	CONIN				; ok, so now we expect to find <CR><LF> in the buffer
		CP	CR
		JR	NZ,SYNERR
		CALL	CONIN
		CP	LF
		JR	NZ,SYNERR
		LD	A,0FFH
		POP	HL
		POP	BC
		RET
SYNERR:	CALL	FLUSHBUF
		CALL	PRINTSEQ
		.DB CR,LF
		.TEXT "Syntax error. aaaa must be a 4-character hex number."
		.DB CR,LF
		.DB CR,LF,0
		XOR	A
		POP	HL
		POP	BC
		RET

;================================================================================================
; Flush serial input buffer
;================================================================================================
FLUSHBUF:
		CALL	CONST
		CP	0
		RET	Z
		CALL	CONIN
		JR	FLUSHBUF

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
; Convert HEX to ASCII (B --> HL)
;================================================================================================
HEX2ASCII:	PUSH	BC
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
; Delay X seconds, with X passed on reg B
;================================================================================================
DELAYS:
		PUSH	BC
		PUSH	HL
LOOP0:	LD	HL,655
LOOP1:	LD	C,255		;1.75					\
LOOP2:	DEC	C		;1		\			|
		NOP			;1		| t=6(X-1)+1.75	| (7.75+t)(y-1)
		LD	A,C		;1		|			|
		JR	NZ,LOOP2	;3/1.75	/			|
		DEC	HL		;1					|
		LD	A,H		;1					|
		OR	L		;1					|
		JR	NZ,LOOP1	;3/1.75				/
		DJNZ	LOOP0
		POP	HL
		POP	BC
		RET

;================================================================================================
; Console Status (Return A=0FFh if character waiting. Otherwise, A=0)
;================================================================================================
CONST:
		PUSH	BC
		PUSH	HL
		LD	BC,(WRPTR)
		LD	HL,(RDPTR)
		XOR	A
		SBC	HL,BC
		JR	Z,CONVOID
		LD	A,0FFH
CONVOID:
		POP	HL
		POP	BC
	  	RET

;================================================================================================
; Console Input (Wait for input and return character in A)
;================================================================================================
CONIN:
		PUSH	BC	
		PUSH	HL	
AGAIN:	CALL	CONST
		CP	0
		JR	Z,AGAIN			; Keep trying till we receive something
		LD	BC,(RDPTR)
		LD	A,(BC)
		INC	BC
		LD	HL,BUFEND
		SCF
		CCF
		SBC	HL,BC
		JR	NZ,EOCONIN
		LD	BC,BUFINI
EOCONIN:	LD	(RDPTR),BC
		POP	HL
		POP	BC
		RET					; Char read returns in A

;================================================================================================
; Console Output (Send character in reg C)
;================================================================================================
CONOUT:
		IN	A,(USART_STA)		; read USART status byte
		AND	04H				; get only the TxEMPTY bit
		JR	Z,CONOUT
		LD	A,C
		OUT	(USART_DAT),A		; send character
		RET

;================================================================================================
; Print (on console) a sequence of characters ending with zero
;================================================================================================
PRINTSEQ:
		EX 	(SP),HL 		; Push HL and put RET address into HL
		PUSH 	AF
		PUSH 	BC
NEXTCHAR:
		LD 	A,(HL)
		CP	0
		JR	Z,ENDOFPRINT
		LD  	C,A
		CALL 	CONOUT		; Print to console
		INC 	HL
		JR	NEXTCHAR
ENDOFPRINT:
		INC 	HL 			; Get past "null" terminator
		POP 	BC
		POP 	AF
		EX 	(SP),HL 		; Push new RET address on stack and restore HL
		RET




		.ORG	04000H
BUFINI	.EQU	$
		.DB	'H',LF,CR
		.TEXT	":0A053000C1F10E77CD89E8C330D188"
		.TEXT	":00000001FF"
		.DB	LF,CR,0,0,0,0,0
BUFEND	.EQU	$
WRPTR:	.DS	2			; write pointer
RDPTR:	.DS	2			; read pointer




		.END
