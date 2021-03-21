;==================================================================================
; LINER.ASM - CONSOLE MANAGER TEST FOR MONITOR 2.0 - USE WITH VT100 TEMINAL
; (Should behave like CCP on CP/M)
;
; Backspace = delete last character
;   ^U = ^X = delete all the line
;
; After user types <ENTER>, the line is saved in line_buffer and control returns
; to Monitor program.
;==================================================================================
TPA			.EQU	0100H		; Transient Programs Area
MONITOR		.EQU	0D000H		; Monitor entry point
BIOS		.EQU	0E600H		; BIOS entry point
DMA			.EQU	0080H		; Buffer user by liner

;================================================================================================
; BIOS functions.
;================================================================================================
BOOT:		.EQU	BIOS				;  0 Initialize.
WBOOT:		.EQU	BIOS+(3*1)			;  1 Warm boot.
CONST:		.EQU	BIOS+(3*2)			;  2 Console status.
CONIN:		.EQU	BIOS+(3*3)			;  3 Console input.
CONOUT:		.EQU	BIOS+(3*4)			;  4 Console OUTput.
LIST:		.EQU	BIOS+(3*5)			;  5 List OUTput.
PUNCH:		.EQU	BIOS+(3*6)			;  6 Punch OUTput.
READER:		.EQU	BIOS+(3*7)			;  7 Reader input.
HOME:		.EQU	BIOS+(3*8)			;  8 Home disk.
SELDSK:		.EQU	BIOS+(3*9)			;  9 Select disk.
SETTRK:		.EQU	BIOS+(3*10)			; 10 Select track.
SETSEC:		.EQU	BIOS+(3*11)			; 11 Select sector.
SETDMA:		.EQU	BIOS+(3*12)			; 12 Set DMA ADDress.
READ:		.EQU	BIOS+(3*13)			; 13 Read 128 bytes.
WRITE:		.EQU	BIOS+(3*14)			; 14 Write 128 bytes.
LISTST:		.EQU	BIOS+(3*15)			; 15 List status.
SECTRAN:	.EQU	BIOS+(3*16)			; 16 Sector translate.
PRINTSEQ:	.EQU	BIOS+(3*17)			; not a BIOS function

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

;================================================================================================
; MAIN PROGRAM STARTS HERE
;================================================================================================
			.ORG TPA

			LD	HL,DMA
			LD	(LBUFPTR),HL
			LD	C,CR
			CALL CONOUT
			LD	C,LF
			CALL CONOUT
			LD	C,'>'
			CALL CONOUT
WAITCHAR:	CALL CONIN					; Wait for user's charater.
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
			LD	A,0						; has funished typing the command line.
			LD	(HL),A
			LD	C,CR
			CALL CONOUT
			LD	C,LF
			CALL CONOUT					; Output <CR><LF>.
			CALL UPPER					; Convert line to uppercase before parsing.
			LD	HL,CMDTBL
			LD	DE,DMA
			CALL PARSER					; Find command comparing buffer with Command Table.
			INC	A
			JP	Z,UNKNOWN				; No match found in command table.
			JP	(HL)					; Jump to Command Routine
			

GOTCAN:		LD	D,0						; We got a line delete.
			JR	AFTGOTBS

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
; Parse command. HL=cmd_table_pointer, DE=line_buffer_pointer.
; Returns jump address on HL. regA=cmd_num or FFh if no match.
;================================================================================================
PARSER:		PUSH BC
			LD	A,0
			LD	(CMDNUM),A		; Init command number.
			PUSH DE
			POP	IX				; Backup line buffer pointer.
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
			POP	DE
			LD	H,0
			LD	A,(CMDNUM)
			LD	L,A
			PUSH HL
			POP	BC
			ADD	HL,BC			; command_number * 2
			ADD	HL,BC			; command_number * 3
			ADD HL,DE
			POP	BC
			RET
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
			PUSH IX
			POP	DE
			JR	NEXT2PARS
NOMATCH:	LD	HL,0
			LD	A,0FFH
			POP	BC
			RET

;================================================================================================
; Memory Operations
;================================================================================================
MEMO:		CALL PRINTSEQ
			.DB	"M>Ready for Memory Operations",0
			JP	WBOOT

;================================================================================================
; Xmodem Command
;================================================================================================
XMODEM:		CALL PRINTSEQ
			.DB	">XMODEM aaaa",0
			JP	WBOOT

;================================================================================================
; Hexadecimal to Executable conversion
;================================================================================================
HEX2COM:	CALL PRINTSEQ
			.DB	">HEX2COM aaaa",0
			JP	WBOOT

;================================================================================================
; LCD Operations
;================================================================================================
LCD:		CALL PRINTSEQ
			.DB	"L>Ready for LCD Operations",0
			JP	WBOOT

;================================================================================================
; Disk Operations
;================================================================================================
DISK:		CALL PRINTSEQ
			.DB	"D>Ready for Disk Operations",0
			JP	WBOOT

;================================================================================================
; Execute Command
;================================================================================================
RUN:		CALL GETBYTE		
			HALT

;================================================================================================
; Unknown Command message. HL has the address of the line buffer.
;================================================================================================
UNKNOWN:	LD	C,(HL)
			CALL CONOUT
			INC	HL
			LD	A,C
			CP	0
			JR	NZ,UNKNOWN
			LD	C,'?'
			CALL CONOUT
			JP	WBOOT

;================================================================================================
; Get word from command line. DE=line_buffer_pointer(should point to where byte starts).
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
; Get byte from command line. DE=line_buffer_pointer(should point to where byte starts).
; If successfull, return byte in regC. A=0 if missing arg, A=1 if OK, A=2 if invalid arg. 
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
GBNA:		LD	A,0
			RET
GBSPC:		INC	DE
			JR	GETBYTE
GBIA:		LD	A,2
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
CMDTBL:		.DB	"MEMO",RS
			.DB	"XMODEM",RS
			.DB	"HEX2COM",RS
			.DB	"LCD",RS
			.DB	"DISK",RS
			.DB	"RUN",ETX

JMPTBL:		JP	MEMO
			JP	XMODEM
			JP	HEX2COM
			JP	LCD
			JP	DISK
			JP	RUN
			
CMDNUM		.DB	0
LBUFPTR		.DW	0


			.END
