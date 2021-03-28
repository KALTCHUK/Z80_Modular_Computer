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
;DMA			.EQU	0080H		; Buffer used by Monitor

;================================================================================================
; BIOS functions.
;================================================================================================
;LEAP		.EQU	3					; 3 bytes for each entry (JP aaaa)

;BOOT:		.EQU	BIOS				;  0 Initialize.
;WBOOT:		.EQU	BIOS+(LEAP*1)		;  1 Warm boot.
;CONST:		.EQU	BIOS+(LEAP*2)		;  2 Console status.
;CONIN:		.EQU	BIOS+(LEAP*3)		;  3 Console input.
;CONOUT:		.EQU	BIOS+(LEAP*4)		;  4 Console OUTput.
;LIST:		.EQU	BIOS+(LEAP*5)		;  5 List OUTput.
;PUNCH:		.EQU	BIOS+(LEAP*6)		;  6 Punch OUTput.
;READER:		.EQU	BIOS+(LEAP*7)		;  7 Reader input.
;HOME:		.EQU	BIOS+(LEAP*8)		;  8 Home disk.
;SELDSK:		.EQU	BIOS+(LEAP*9)		;  9 Select disk.
;SETTRK:		.EQU	BIOS+(LEAP*10)		; 10 Select track.
;SETSEC:		.EQU	BIOS+(LEAP*11)		; 11 Select sector.
;SETDMA:		.EQU	BIOS+(LEAP*12)		; 12 Set DMA ADDress.
;READ:		.EQU	BIOS+(LEAP*13)		; 13 Read 128 bytes.
;WRITE:		.EQU	BIOS+(LEAP*14)		; 14 Write 128 bytes.
;LISTST:		.EQU	BIOS+(LEAP*15)		; 15 List status.
;SECTRAN:	.EQU	BIOS+(LEAP*16)		; 16 Sector translate.
;PRINTSEQ:	.EQU	BIOS+(LEAP*17)		; not a BIOS function

;================================================================================================
; ASCII characters.
;================================================================================================
NUL			.EQU	00H
SOH			.EQU	01H
STX			.EQU	02H
ETX			.EQU	03H
EOT			.EQU	04H
ENQ			.EQU	05H
ACK			.EQU	06H
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
;MAXLBUF		.EQU	DMA+80
PROMPT		.EQU	'>'
MAXTRY		.EQU	10

;================================================================================================
; MAIN PROGRAM STARTS HERE
;================================================================================================
			.ORG 0
			JP	TPA

CYCLE:		HALT

			.ORG 80H
DMA:		.DB "HEX2COM 3000",0


			.ORG TPA

;================================================================================================
; Hexadecimal to Executable conversion command.
; Record structure:
;	<start_code> <byte_count> <address> <record_type> <data>...<data> <checksum>
;		':'	        1 byte     2 bytes    00h or 01h       n bytes	    1 byte
;
; Register usage:
;	IX = source address
;	IY = target address
;================================================================================================
HEX2COM:	LD	DE,DMA+8
			CALL GETWORD
			CP	1					; Is the argument OK?
			JP	NZ,CYCLE
			PUSH BC					; IX holds the source address
			POP	IX

FINDSC:		LD	A,(IX+0)
			INC IX
			CP	':'					; Do we have a start code?
			JR	NZ,FINDSC
			LD	A,0
			LD	(CHKSUM),A
			CALL HGB			; Get byte count
			LD	A,B
			CP	0
			JP	Z,CYCLE				; If byte count=0, we're done.
			LD	(BYTECNT),A			; Save byte count
			CALL UPCHKSUM			; Update checksum
			INC	IX
			CALL HGW			; Get target address
			PUSH BC
			POP IY					; IY holds the target address
			CALL UPCHKSUM			; Update checksum
			LD	B,C
			CALL UPCHKSUM			; Update checksum
			CALL PRTADDR			; Print target address
			CALL HGB			; Get record type (just for checksum update)
			CALL UPCHKSUM			; Update checksum
			INC	IX
			LD	A,(BYTECNT)
			LD	B,A
GETDATA:	PUSH BC
			CALL HGB			; Get data byte
			LD	(IY+0),B
			CALL UPCHKSUM			; Update checksum
			INC	IY
			INC IX
			POP BC
			DJNZ GETDATA
			CALL HGB			; Get checksum
			LD	A,(CHKSUM)
			NEG
			CP	B
			JR	NZ,CHKSUMER
			LD	C,'+'
			CALL CONOUT
			CALL CRLF
			JR	FINDSC
CHKSUMER:	LD	C,'-'
			CALL CONOUT
			CALL CRLF
			;CALL PRINTSEQ
			;.DB	" Checksum Error.",CR,LF,0
			JR	FINDSC

UPCHKSUM:	LD	A,(CHKSUM)
			ADD	A,B
			LD	(CHKSUM),A
			RET

PRTADDR:	CALL PRINTENV
			DEC IX
			DEC IX
			DEC IX
			LD	B,4
NXTA:		LD	C,(IX+0)
			CALL CONOUT
			INC	IX
			DJNZ NXTA
			RET

HGB:		PUSH IX
			POP	DE
			CALL GETBYTE
			PUSH DE
			POP IX
			RET

HGW:		PUSH IX
			POP	DE
			CALL GETWORD
			PUSH DE
			POP IX
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
			;CALL PRINTSEQ
			;.DB	"Missing argument.",CR,LF,0
			LD	A,0
			RET
GBSPC:		INC	DE
			JR	GETBYTE
GBIA:		CALL PRINTENV
			;CALL PRINTSEQ
			;.DB	"Invalid argument.",CR,LF,0
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

CRLF:		LD	C,CR
			CALL CONOUT
			LD	C,LF
			CALL CONOUT					; Output <CR><LF>.
			RET
;================================================================================================
; Console Output (Send character in reg C)
;================================================================================================
CONOUT:		LD	A,C
			OUT	(80H),A		; send character
			RET

;================================================================================================

CMDNUM		.DB	0
LBUFPTR		.DW	0
ENVIR		.DB	0			; 0=MONITOR, M=MEMO, L=LCD, D=DISK
LINNUM		.DB	0
COLNUM		.DB	0
AAAA		.DW	0
BBBB		.DW	0
CCCC		.DW	0
CHKSUM	 	.DB	0					; Checksum for xmodem
BYTECNT		.DB	0					; Byte counter for xmodem and hex2com
RETRY		.DB 0					; Retry counter for xmodem
BLOCK		.DB	0					; Block counter for xmodem

			.DS 20
MSTACK		.EQU $

			.ORG 3000H
			.DB ":18200000CD33E60D0A4543484F45530D0A0D0A4F766572686561642098",CR,LF
			.DB ":1820180074686520616C626174726F73730D0A48616E6773206D6F740C",CR,LF
			.DB ":18203000696F6E6C6573732075706F6E20746865206169720D0A416E36",CR,LF
			.DB ":182048006420646565702062656E656174682074686520726F6C6C69C4",CR,LF
			.DB ":00000001FF",CR,LF

			.END
