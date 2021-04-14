;==================================================================================
; DISK ROUTINES
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
MAXLBUF		.EQU	DMA+80
PROMPT		.EQU	'>'
MAXTRY		.EQU	10

DAREA		.EQU	0CE00H		; Draft area user by disk R/W ops (512 bytes)
;================================================================================================
; Disk Operations
;================================================================================================
DISK:		LD	A,'D'
			LD	(ENVIR),A				; Set environment variable.
			CALL PRINTENV
			CALL LINER					; Call the line manager.
			LD	A,(DMA)
			CP	0
			JR	Z,DISK					; User ENTERed an empty line. No need to parse.
			LD	HL,DISKCT				; Set Memory command table.
			CALL PARSER					; Find command comparing buffer with Command Table.
			INC	A
			JR	Z,DUNKNOWN				; No match found in command table.
			JP	(HL)					; Jump to Command Routine
DUNKNOWN:	CALL UNKNOWN
			JR	DISK
			
;================================================================================================
; Help for disk operations
;================================================================================================
DHELP:		CALL CRLF
			CALL PRINTSEQ
			.DB	" Options:   READ d,ttt,ss",CR,LF
			.DB "            DOWN d,ttt,ss-aaaa",CR,LF
			.DB "            UP aaaa-d,ttt,ss",CR,LF
			.DB "            VERIFY d,ttt,ss",CR,LF
			.DB "            QUIT",CR,LF,0
			JP	DISK
			
;================================================================================================
; Quit disk operations
;================================================================================================
DQUIT:		JP	CYCLE					; Quit disk ops, return to monitor.

;================================================================================================
; Read disk operation (READ D,TTT,SS)
;================================================================================================
DREAD:		LD	DE,DMA+4
			CALL GETDSK			; Get disk [A,P]
			CP	1				; Is the argument OK?
			JP	NZ,DISK
			LD	DE,DMA+7
			CALL GETTRK			; Get track [0,1FF]
			CP	1				; Is the argument OK?
			JP	NZ,DISK
			CALL GETSEC			; Get sector [0,1F]
			CP	1				; Is the argument OK?
			JP	NZ,DISK
			CALL DTS2LBA		; Convert disk/track/sector to LBA (3 bytes)
			CALL READLBA		; Read 1 sector addressed by LBA and put it on draft area (DAREA)
			LD	HL,DAREA
			CALL MEMPRT			; Print 1st page of draft area
			LD	HL,DAREA+100H
			CALL MEMPRT			; Print 2nd page of draft area
			
			
			
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
			CALL PRINTSEQ
			.DB "================== <ENTER> = next page, <ESC> = quit ==================",CR,LF,0
			RET



DISKEXT		.EQU	0C000H
DDOWN:		JP	DISKEXT+3
DUP			JP	DISKEXT+6
DVERIFY		JP	DISKEXT+9

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

;================================================================================================
CMDNUM		.DB	0
LBUFPTR		.DW	0
ENVIR		.DB	0			; NONE=MONITOR, M=MEMO, D=DISK
LINNUM		.DB	0
COLNUM		.DB	0
AAAA		.DW	0
BBBB		.DW	0
CCCC		.DW	0
CHKSUM	 	.DB	0					; Checksum for xmodem
BYTECNT		.DB	0					; Byte counter for xmodem and hex2com
RETRY		.DB 0					; Retry counter for xmodem
BLOCK		.DB	0					; Block counter for xmodem

DSK			.DB	0					; Disk number [00,0F]
TRK			.DW	0					; Track number [0,1FF]
SEC			.DB	0					; Sector number [0,1F]
LBA0		.DB	0
LBA1		.DB	0
LBA2		.DB	0

			.END
