;==================================================================================
; LINER.ASM = MONITOR 2.0 - USE WITH VT100 TERMINAL
; (Should behave like CCP on CP/M)
;
; Backspace = delete last character
;        ^X = delete all the line
;
;==================================================================================
TPA			.EQU	0100H		; Transient Programs Area
MONITOR		.EQU	0D000H		; Monitor entry point
BIOS		.EQU	0E600H		; BIOS entry point
DMA			.EQU	0080H		; Buffer used by Monitor

;================================================================================================
; BIOS functions.
;================================================================================================
LEAP		.EQU	3					; 3 bytes for each entry (JP aaaa)

BOOT:		.EQU	BIOS				;  0 Initialize.
WBOOT:		.EQU	BIOS+(LEAP*1)		;  1 Warm boot.
CONST:		.EQU	BIOS+(LEAP*2)		;  2 Console status.
CONIN:		.EQU	BIOS+(LEAP*3)		;  3 Console input.
CONOUT:		.EQU	BIOS+(LEAP*4)		;  4 Console OUTput.
LIST:		.EQU	BIOS+(LEAP*5)		;  5 List OUTput.
PUNCH:		.EQU	BIOS+(LEAP*6)		;  6 Punch OUTput.
READER:		.EQU	BIOS+(LEAP*7)		;  7 Reader input.
HOME:		.EQU	BIOS+(LEAP*8)		;  8 Home disk.
SELDSK:		.EQU	BIOS+(LEAP*9)		;  9 Select disk.
SETTRK:		.EQU	BIOS+(LEAP*10)		; 10 Select track.
SETSEC:		.EQU	BIOS+(LEAP*11)		; 11 Select sector.
SETDMA:		.EQU	BIOS+(LEAP*12)		; 12 Set DMA ADDress.
READ:		.EQU	BIOS+(LEAP*13)		; 13 Read 128 bytes.
WRITE:		.EQU	BIOS+(LEAP*14)		; 14 Write 128 bytes.
LISTST:		.EQU	BIOS+(LEAP*15)		; 15 List status.
SECTRAN:	.EQU	BIOS+(LEAP*16)		; 16 Sector translate.
PRINTSEQ:	.EQU	BIOS+(LEAP*17)		; not a BIOS function

;================================================================================================
; ASCII characters.
;================================================================================================
NUL			.EQU	00H
SOH			.EQU	01H
STX			.EQU	02H
ETX			.EQU	03H
EOT			.EQU	04H
ENQ			.EQU	05H
QCK			.EQU	06H
BEL			.EQU	07H
BS			.EQU	08H			; ^H
HT			.EQU	09H
LF			.EQU	0AH
VT			.EQU	0BH
FF			.EQU	0CH
CR			.EQU	0DH
SO			.EQU	0EH
SI			.EQU	0FH
DLE			.EQU	10H
DC1			.EQU	11H
DC2			.EQU	12H
DC3			.EQU	13H
DC4			.EQU	14H
NAK			.EQU	15H			; ^U
SYN			.EQU	16H
ETB			.EQU	17H
CAN			.EQU	18H			; ^X
EM			.EQU	19H
SUB			.EQU	1AH
ESC			.EQU	1BH
FS			.EQU	1CH
GS			.EQU	1DH
RS			.EQU	1EH
US			.EQU	1FH

;================================================================================================
; Some constants
;================================================================================================
MAXLBUF		.EQU	DMA+80
PROMPT		.EQU	'}'

;================================================================================================
; MAIN PROGRAM STARTS HERE
;================================================================================================
			.ORG TPA

			CALL PRINTSEQ
			.DB	"Z80 Modular Computer BIOS 1.0 by Kaltchuk - 2020",CR,LF
			.DB	"Monitor 2.0 - 2021",CR,LF,0
CYCLE:		LD	A,0
			LD	(ENVIR),A
			CALL PRINTENV
			CALL LINER					; Call the line manager
			CP	0FFH
			JP	Z,WBOOT					; User typed Ctrl-C or Ctrl-Z... Abort, abort!
			LD	A,(DMA)
			CP	0
			JR	Z,CYCLE					; User ENTERed an empty line. No need to parse.
			LD	HL,CMDTBL
			CALL PARSER					; Find command comparing buffer with Command Table.
			INC	A
			JR	Z,UNK					; No match found in command table.
			JP	(HL)					; Jump to Command Routine
UNK:		CALL UNKNOWN
			JR	CYCLE
			
;================================================================================================
; Memory Operations
;
; Options:	R aaaa					Read 1 page starting at aaaa. <ENTER>=next page, <ESC>=quit.
;			W aaaa,c1 c2 ... cN		Write at aaaa the sequence of characters.
;			C aaaa-bbbb,cccc		Copy [aaaa ~ bbbb] to cccc.
;			F aaaa-bbbb,cc			Fill [aaaa ~ bbbb] with cc.
;			V aaaa-bbbb				Verify area [aaaa ~ bbbb].
;			Ctrl-C					Return to Monitor.
;================================================================================================
MEMO:		LD	A,'M'
			LD	(ENVIR),A				; Set environment variable.
			CALL PRINTENV
			CALL LINER					; Call the line manager.
			CP	0FFH
			JP	Z,CYCLE					; User typed Ctrl-C or Ctrl-Z, return to Monitor.
			LD	A,(DMA)
			CP	0
			JR	Z,MEMO					; User ENTERed an empty line. No need to parse.
			LD	HL,MEMOCT				; Set Memory command table.
			CALL PARSER					; Find command comparing buffer with Command Table.
			INC	A
			JR	Z,MUNKNOWN				; No match found in command table.
			JP	(HL)					; Jump to Command Routine
MUNKNOWN:	CALL UNKNOWN
			JR	MEMO
			
;================================================================================================
; Quit memory operations
;================================================================================================
MQUIT:		JP	CYCLE					; Quit memory ops, return to monitor.

;================================================================================================
; Read memory operations
;================================================================================================
MREAD:		LD	DE,DMA+1
			CALL GETWORD		
			CP	1				; Is the argument OK?
			JP	NZ,MEMO
			PUSH BC
			POP	DE				; DE will be the address holder
			LD	A,E
			AND	0F0H
			LD	E,A				; trim addr (xxx0)
NEWHDR:		CALL PRINTHDR		; Print the header
			LD	A,16
			LD	(LINNUM),A
NEWLINE:	CALL CRLF
			CALL PRINTENV
			LD	B,D				; Print the address
			CALL B2HL
			LD	C,H
			CALL CONOUT
			LD	C,L
			CALL CONOUT
			LD	B,E
			CALL B2HL
			LD	C,H
			CALL CONOUT
			LD	C,L
			CALL CONOUT
			LD	C,':'
			CALL CONOUT
			LD	C,' '
			CALL CONOUT
			LD	B,16
NEWCOL:		PUSH BC
			LD	A,(DE)			; Start printing the memory content
			INC	DE
			LD	B,A
			CALL B2HL
			LD	C,H
			CALL CONOUT
			LD	C,L
			CALL CONOUT
			LD	C,' '
			CALL CONOUT
			POP	BC
			DJNZ NEWCOL
			LD	C,' '
			CALL CONOUT
			LD	HL,0FFF0H		; This is -10h
			ADD	HL,DE			; Go back to beginning of line
			PUSH HL
			POP	DE
			LD	B,16
NEWCOL2:	PUSH BC				; Start printing the printables
			LD	C,'.'
			LD	A,(DE)
			CP	20H
			JP	M,NOTPRTBL
			CP	7FH
			JP	P,NOTPRTBL
			LD	C,A
NOTPRTBL:	CALL CONOUT
			INC	DE
			POP	BC
			DJNZ NEWCOL2
			LD	A,(LINNUM)
			DEC	A
			LD	(LINNUM),A
			JR	NZ,NEWLINE
			CALL PRINTFTR		; Print footer message
			CALL CONIN			; Wait for user's decision
			CP	CR
TRYAGAIN:	JR	Z,NEWHDR
			CP	ESC
			JP	Z,MEMO
			JR	TRYAGAIN

PRINTHDR:	CALL PRINTENV
			CALL PRINTSEQ
			.DB "ADDR: 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  0123456789ABCDEF",CR,LF,0
			CALL PRINTENV
			CALL PRINTSEQ
			.DB "----- -----------------------------------------------  ----------------",0
			RET

PRINTFTR:	CALL CRLF
			CALL PRINTENV
			CALL CRLF
			CALL PRINTENV
			CALL PRINTSEQ
			.DB "                   <ENTER> = next page, <ESC> = quit.",CR,LF,0
			RET

;================================================================================================
; Write memory operations
;================================================================================================
MWRITE:		CALL PRINTENV
			CALL PRINTSEQ
			.DB	"W aaaa,c1...cN",CR,LF,0
			JP	MEMO

;================================================================================================
; Copy memory operations
;================================================================================================
MCOPY:		CALL PRINTENV
			CALL PRINTSEQ
			.DB	"C aaaa-bbbb,cccc",CR,LF,0
			JP	MEMO

;================================================================================================
; Fill memory operations
;================================================================================================
MFILL:		CALL PRINTENV
			CALL PRINTSEQ
			.DB	"F aaaa-bbbb,cc",CR,LF,0
			JP	MEMO

;================================================================================================
; Verify memory operations
;================================================================================================
MVERIFY:	CALL PRINTENV
			CALL PRINTSEQ
			.DB	"V aaaa-bbbb",CR,LF,0
			JP	MEMO

;================================================================================================
; Xmodem Command
;================================================================================================
XMODEM:		CALL PRINTSEQ
			.DB	"]XMODEM aaaa",CR,LF,0
			JP	CYCLE

;================================================================================================
; Hexadecimal to Executable conversion command.
;================================================================================================
HEX2COM:	CALL PRINTSEQ
			.DB	"]HEX2COM aaaa",CR,LF,0
			JP	CYCLE

;================================================================================================
; LCD Operations
;================================================================================================
LCD:		CALL PRINTSEQ
			.DB	"L]Ready for LCD Operations",CR,LF,0
			JP	CYCLE

;================================================================================================
; Disk Operations
;================================================================================================
DISK:		CALL PRINTSEQ
			.DB	"D]Ready for Disk Operations",CR,LF,0
			JP	CYCLE

;================================================================================================
; Execute Command
;================================================================================================
RUN:		LD	DE,DMA+3
			CALL GETWORD		
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			PUSH BC
			POP	HL
			JP	(HL)			; Continue execution where user requested. His responsability!

;================================================================================================
; Unknown Command message. HL has the address of the line buffer.
;================================================================================================
UNKNOWN:	CALL PRINTENV
			LD	HL,DMA
UNEXT:		LD	A,(HL)
			CP	0
			JR	Z,UEND
			LD	C,A
			CALL CONOUT
			INC	HL
			JR	UNEXT
UEND:		LD	C,'?'
			CALL CONOUT
			CALL CRLF
			RET

;================================================================================================
; Routine to manage line input from console. Returns A=0FFh if user typed Ctrl-Z (ETX).
;================================================================================================
LINER:		LD	HL,DMA
			LD	(LBUFPTR),HL			; Init line buffer pointer.
WAITCHAR:	CALL CONIN					; Wait till user types something.
			CP	ETX						; Is it Ctrl-C?
			JR	Z,GOTETX
			CP	SUB						; Is is Ctrl-Z?
			JR	Z,GOTSUB
			CP	CAN
			JR	Z,GOTCAN				; Is it <CAN>? (= delete line).
			CP	CR
			JR	Z,GOTCR					; Is it <ENTER>?
			CP	BS
			JR	Z,GOTBS					; Is it <BS>? (= backspace).
			LD	HL,(LBUFPTR)			; None of the above options, so let's put it in the buffer.
			LD	BC,MAXLBUF				; But 1st, we have to check if we still have space.
			SCF
			CCF
			SBC	HL,BC
			JR	Z,LBUFFULL				; Is buffer full?
			LD	HL,(LBUFPTR)
			LD	(HL),A
			INC	HL
			LD	(LBUFPTR),HL
			LD	C,A
OUTWAIT:	CALL CONOUT
			JR	WAITCHAR

LBUFFULL:	LD	C,BEL					; Buffer is full. Just ring the bell.
			JR	OUTWAIT

GOTBS:		LD	D,1						; We got a backspace.
AFTGOTBS:	CALL BSPROC
			JR	WAITCHAR

GOTCR:		LD	HL,(LBUFPTR)			; We got an ENTER, which means the the user
			LD	A,0						; has finished typing the command line.
			LD	(HL),A
			CALL CRLF
			CALL UPPER					; Convert line to uppercase before parsing.
			RET
GOTETX:
GOTSUB:		CALL CRLF					; User abort request (Ctrl-C or Ctrl-Z).
			LD	A,FF
			RET
			
GOTCAN:		LD	D,0						; We got a line delete.
			JR	AFTGOTBS
			
CRLF:		LD	C,CR
			CALL CONOUT
			LD	C,LF
			CALL CONOUT					; Output <CR><LF>.
			RET

;================================================================================================
; Routine to do the backspace and line delete. D=1, backspace; D=0, delete line.
;================================================================================================
BSPROC:		LD	HL,(LBUFPTR)
			LD	BC,DMA
			SCF
			CCF
			SBC	HL,BC
			JR	Z,LBUFEMPTY
			LD	HL,(LBUFPTR)
			DEC	HL
			LD	(LBUFPTR),HL
			LD	C,BS
			CALL CONOUT
			LD	C,' '
			CALL CONOUT
			LD	C,BS
			CALL CONOUT
			LD	A,D
			CP	1
			RET	Z
			JR	BSPROC

LBUFEMPTY:	LD	C,BEL
			CALL CONOUT
			RET
			
;================================================================================================
; Routine to convert line buffer content to upper case
;================================================================================================
UPPER:		LD	HL,DMA-1
NEXT2UP:	INC	HL
			LD	A,(HL)
			CP	0
			RET	Z
			CP	'a'
			JP	M,NEXT2UP
			CP	'{'
			JP	P,NEXT2UP
			SUB	20H
			LD	(HL),A
			JR	NEXT2UP
			
;================================================================================================
; Routine to parse command. HL=cmd_table_pointer.
; regA=cmd_num or FFh if no match. HL=jump_address or 0000 if no match.
;================================================================================================
PARSER:		PUSH BC
			PUSH DE
			LD	DE,DMA
			LD	A,0
			LD	(CMDNUM),A		; Init command number.
NEXT2PARS:	LD	A,(DE)
			CP	(HL)
			JR	NZ,NOTEQU
			INC	HL
			INC	DE
			JR	NEXT2PARS
NOTEQU:		LD	A,(HL)
			CP	RS
			JR	Z,ISRS
			CP	ETX
			JR	NZ,NEXTCMD
ISRS:		LD	A,(DE)
			CP	0
			JR	Z,ISZERO
			CP	' '
			JR	NZ,NEXTCMD
ISZERO:		LD	A,(HL)
			CP	ETX
			JR	Z,CMDMATCH
			INC	HL
			JR	ISZERO
CMDMATCH:	INC	HL
			PUSH HL
			POP	DE				; DE=addr of jump table
			LD	H,0
			LD	A,(CMDNUM)
			LD	L,A
			PUSH HL
			POP	BC
			ADD	HL,BC			; command_number * 2
			ADD	HL,BC			; command_number * 3
			ADD HL,DE
			POP	DE
			POP	BC
			RET					; A=command_number, HL=jump_address
NEXTCMD:	LD	A,(HL)
			CP	RS
			JR	Z,ISRS2
			CP	ETX
			JR	Z,NOMATCH
			INC	HL
			JR	NEXTCMD
ISRS2:		INC	HL
			LD	A,(CMDNUM)
			INC	A
			LD	(CMDNUM),A
			LD	DE,DMA
			JR	NEXT2PARS
NOMATCH:	LD	HL,0
			LD	A,0FFH
			POP	DE
			POP	BC
			RET

;================================================================================================
; Routine to get word from command line. DE=line_buf_ptr(should point to where word starts).
; If successfull, return word in BC. A=0 if missing arg, A=1 if OK, A=2 if invalid arg. 
;================================================================================================
GETWORD:	CALL GETBYTE
			CP	1
			RET	NZ
			LD	C,B
			INC	DE
			CALL GETBYTE
			CP	1
			RET NZ
			LD	A,B
			LD	B,C
			LD	C,A
			LD	A,1
			RET
			
;================================================================================================
; Routine to get byte from command line. DE=line_buf_ptr(should point to where byte starts).
; If successfull, return byte in regB. A=0 if missing arg, A=1 if OK, A=2 if invalid arg. 
;================================================================================================
GETBYTE:	LD	A,(DE)
			CP	0
			JR	Z,GBNA				; End of buffer and no arg found.
			CP	' '
			JR	Z,GBSPC				; Trim the space.
			LD	H,A
			CALL ISITHEX
			CP	1
			JR	NZ,GBIA				; Invalid arg.
			INC	DE
			LD	A,(DE)
			LD	L,A
			CALL ISITHEX
			CP	1
			JR	NZ,GBIA				; Invalid arg.
			CALL HL2B				; Convert ASCII pair to byte
			LD	A,1
			RET
GBNA:		CALL PRINTENV
			CALL PRINTSEQ
			.DB	"Missing argument.",CR,LF,0
			LD	A,0
			RET
GBSPC:		INC	DE
			JR	GETBYTE
GBIA:		CALL PRINTENV
			CALL PRINTSEQ
			.DB	"Invalid argument.",CR,LF,0
			LD	A,2
			RET

PRINTENV:	LD	A,(ENVIR)			; Print environment letter (M, L, D or none) before message.
			CP	0
			JR	Z,NOLETTER
			LD	C,A
			CALL CONOUT
NOLETTER:	LD	C,PROMPT
			CALL CONOUT
			RET

ISITHEX:	CP	'G'
			JP	P,NOTHEX
			CP	'A'
			JP	P,ISHEX
			CP	040H
			JP	P,NOTHEX
			CP	'0'
			JP	P,ISHEX
NOTHEX:		LD	A,0
			RET
ISHEX:		LD	A,1
			RET

;================================================================================================
; Convert ASCII to HEX (HL --> B)
;================================================================================================
HL2B:		PUSH BC
			LD	A,060H
			SUB	H
			LD	C,057H
			JP	C,DISCOUNT
			LD	A,040H
			SUB	H
			LD	C,037H
			JP	C,DISCOUNT
			LD	C,030H
DISCOUNT:	LD	A,H
			SUB	C
CONVL:		LD	B,A
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
DISCOUNT2:	LD	A,L
			SUB	C
			OR	B
			POP	BC
			LD	B,A
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
			JP	C,COMPENSE
			LD	C,037H
COMPENSE:	LD	A,L
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
			JP	C,COMPENSE2
			LD	C,037H
COMPENSE2:	LD	A,H
			ADD	A,C
			LD	H,A
			POP	BC
			RET

;*****************************************************
;********* Entry point for RUN command test **********
;*****************************************************
RUNCMDTST:	CALL PRINTSEQ
			.DB	CR,LF
			.DB	" *** RUN COMMAND TEST EXIT POINT ***"
			.DB	CR,LF,0
			HALT

;================================================================================================
CMDTBL:		.DB	"BOOT",RS
			.DB	"MEMO",RS
			.DB	"XMODEM",RS
			.DB	"HEX2COM",RS
			.DB	"LCD",RS
			.DB	"DISK",RS
			.DB	"RUN",ETX

JMPTBL:		JP	WBOOT
			JP	MEMO
			JP	XMODEM
			JP	HEX2COM
			JP	LCD
			JP	DISK
			JP	RUN
			
MEMOCT:		.DB	"Q",RS
			.DB	"R",RS
			.DB	"W",RS
			.DB	"C",RS
			.DB	"F",RS
			.DB	"V",ETX

MEMOJT:		JP	MQUIT
			JP	MREAD
			JP	MWRITE
			JP	MCOPY
			JP	MFILL
			JP	MVERIFY
			
CMDNUM		.DB	0
LBUFPTR		.DW	0
ENVIR		.DB	0			; 0=MONITOR, M=MEMO, L=LCD, D=DISK
LINNUM		.DB	0
COLNUM		.DB	0


			.END
