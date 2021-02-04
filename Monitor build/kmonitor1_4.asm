;Monitor 1.0: Commands available: Read memory, Write to memory, Jump to address.
;Monitor 1.1: Commands added: write Hex to memory, Test memory range.
;Monitor 1.2: Commands modified: Read memory accepts multiple scrolls.
;Monitor 1.3: Improved version of H command.
;Monitor 1.4: No additional features, just cosmetics and prepared to use with PuTTY.
;
;==================================================================================
; Monitor for Z80 Modular Computer by P.R.Kaltchuk 2020
;==================================================================================
BIOS			.EQU	0E600H		; BIOS entry point
LF			.EQU	0AH			; line feed
FF			.EQU	0CH			; form feed
CR			.EQU	0DH			; carriage return
ESC			.EQU	01BH		; ESC 
SPACE			.EQU	020H			; space
COLON			.EQU	03AH			; colon

READCOLS		.EQU	010H			; parameters used for read memory command (READCMD)
READLINES		.EQU	010H

DRAFT			.EQU	0C000H		; draft area to write incoming HEX-format data

;================================================================================================
			.ORG 0D000H

MONITOR:
		CALL	PRINTSEQ
		.TEXT	"Z80 Modular Computer Monitor V1.4 by Kaltchuk, Feb/2021"
		.DB	CR,LF,CR,LF
		.TEXT	">Type ? for list of commands."
		.DB	CR,LF,0

		IM	1
		EI
		JP	WRITECMD
		
CMDLIST:
		CALL 	FLUSHBUF
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

;================================================================================================
; Wait for command
;================================================================================================
WAITCMD:	CALL	PRINTSEQ
		.DB	CR,LF,'>',0

		CALL CONIN

		CP	'?'
		JP	Z,CMDLIST

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
		CALL 	FLUSHBUF
		CALL	PRINTSEQ
		.DB	CR,LF
		.TEXT ">Unknown command."
		.DB	CR,LF,0
		JP	WAITCMD

;================================================================================================
; Read memory, starting at address aaaa
;================================================================================================
READCMD:
		CALL	GETADDR			; DE holds the address to start reading
		CP	0
		JP	Z,CMDLIST
PGDN:		LD	A,0F0H
		AND	E
		LD	E,A				; DE converted from AAAA to AAA0
		PUSH	DE
		POP	IX				; from now on, IX will hold the address
		CALL	PRINTSEQ			; print header
		.DB	CR,LF
		.TEXT "ADDR: 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  0123456789ABCDEF"
		.DB	CR,LF
		.TEXT "----- -----------------------------------------------  ----------------"
		.DB	CR,LF,0
		LD	D,READLINES		; lines
NEWL:		LD	E,READCOLS			; columns
		PUSH	IX				; prepare to print address
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
		POP	IY				; IY holds a copy of the 1st memory address from current line
NEWC:		LD	A,(IX)			; prepare to print memory contents
		LD	B,A
		CALL	HEX2ASCII			; now HL contains the ASCII exivalent of memory content
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
		LD	E,READCOLS			; now start doing the printables' area
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
		CALL	PRINTSEQ			; print options
		.TEXT ">[ENTER] = Read next page. [ESC] = Quit"
		.DB	CR,LF,'>',0
		CALL	CONIN				; What's your answer?
		CP	ESC
		JP	NZ,SCROLL
		CALL	FLUSHBUF
		JP	WAITCMD
SCROLL:	PUSH	IY
		POP	DE
		INC	DE
		CALL	FLUSHBUF
		JP	PGDN

;================================================================================================
; Write to memory, starting at address aaaa
;================================================================================================
WRITECMD:
		CALL	GETADDR			; DE holds the address to start writing
		CP	0
		JP	Z,CMDLIST
		CALL	PRINTSEQ
		.TEXT ">Send data to be written."
		.DB	CR,LF,'>',0

		CALL	SBRWR				; call the subroutine that does the dirty job

		CALL	PRINTSEQ
		.TEXT ">Write command completed."
		.DB	CR,LF,0
		JP	WAITCMD

;================================================================================================
; Subroutine that writes to memory. Used by WRITECMD and HEXCMD.
;================================================================================================
SBRWR:
NEXTWR:	CALL	CONIN
		LD	H,A
		CP	CR
		JR	Z,EOW
		CP	':'
		JR	NZ,GETL
		LD	A,':'
		JR	WRCOLON
GETL:		CALL	CONIN
		LD	L,A				; at this point HL holds the value to be written (ASCII)
		CP	CR
		JR	Z,EOW
		CALL	ASCII2HEX			; B holds the hex value
		LD	A,B
WRCOLON:	LD	(DE),A
		INC	DE
		JR	NEXTWR
EOW:		CALL	CONIN
		CP	LF
		RET	Z
		CALL	PRINTSEQ
		.DB	CR,LF
		.TEXT ">Syntax error. Incomplete ASCII pair."
		.DB	CR,LF,0
		RET

;================================================================================================
; Write to memory using Intel hex file format input.
;	1)read all HEX-format data and write it to draft area (DRAFT).
;	2)read each line from draft area, calculate checksum and write bytes
;	  to the designated area.
;	3)for each line, report if checksum is OK or ERROR
;
; Record structure:
;	<start_code> <byte_count> <address> <record_type> <data>...<data> <checksum>
;		':'		1 byte	2 bytes	00h or 01h		n bytes	    1 byte
;
; Register usage:
;	IX = source address (somewhere in draft area)
;	IY = target address
;	B  = byte count
;	C  = checksum accumulator
;================================================================================================
HEXCMD:
		CALL	PRINTSEQ
		.TEXT ">Send HEX-format data to be written."
		.DB CR,LF,'>',0
		LD	DE,DRAFT			; set the address of the draft area
		CALL FLUSHBUF
		CALL	SBRWR	

		LD	IX,DRAFT
NOTSC:	LD	A,(IX+0)			; search for start code ':'
		INC	IX
		CP	':'
		JR	NZ,NOTSC
		LD	A,(IX+0)			; read byte count
		INC	IX
		CP	0
		JP	Z,EOHF			; if byte count is zero, we've reached EOF
		LD	B,A				; now reg B holds byte count
		LD	D,(IX+0)			; read address
		INC	IX
		LD	E,(IX+0)
		INC	IX
		PUSH	DE
		POP	IY				; now IY contains target address
		ADD	A,D
		ADD	A,E
		LD	C,A				; update checksum acc
		INC	IX				; skip record type
NEXTD:	LD	A,(IX+0)			; read data
		LD	(IY+0),A			; write data
		INC	IX
		INC	IY 
		ADD	A,C
		LD	C,A				; update checksum acc
		DJNZ	NEXTD
		LD	A,(IX+0)			; read checksum byte
		INC	IX
		NEG
		CP	C				; compare with checksum acc
		JR	NZ,CSERR
		CALL PRINTSEQ
		.TEXT	">OK"
		.DB	CR,LF,0
		JP	NOTSC
CSERR:	CALL PRINTSEQ
		.TEXT	">ERROR"
		.DB	CR,LF,0
		JP	NOTSC

EOHF:		CALL	PRINTSEQ
		.TEXT ">Write command completed."
		.DB	CR,LF,0
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
; Test quality of RX. Count how many bytes are not equal to CHAR in the page starting at ATARGET
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
; Get CR + LF.
;================================================================================================
GETCRLF:
ISITCR:	CALL	CONIN				; ok, so now we expect to find <CR><LF> in the buffer
		CP	CR
		JR	NZ,ISITCR
ISITLF:	CALL	CONIN
		CP	LF
		JR	NZ,ISITLF
		RET

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

		.ORG	BIOS
;================================================================================================
; BIOS jump table.
;================================================================================================
BOOT:		JP	0			;  0 Initialize.
WBOOT:	JP	0			;  1 Warm boot.
CONST:	JP	0			;  2 Console status.
CONIN:	JP	0			;  3 Console input.
CONOUT:	JP	0			;  4 Console OUTput.
LIST:		JP	0			;  5 List OUTput.
PUNCH:	JP	0			;  6 Punch OUTput.
READER:	JP	0			;  7 Reader input.
HOME:		JP	0			;  8 Home disk.
SELDSK:	JP	0			;  9 Select disk.
SETTRK:	JP	0			; 10 Select track.
SETSEC:	JP	0			; 11 Select sector.
SETDMA:	JP	0			; 12 Set DMA ADDress.
READ:		JP	0			; 13 Read 128 bytes.
WRITE:	JP	0			; 14 Write 128 bytes.
LISTST:	JP	0			; 15 List status.
SECTRAN:	JP	0			; 16 Sector translate.
PRINTSEQ:	JP	0			; not a BIOS function

;================================================================================================

		.END
