;================================================================================================
; MONITOR 2.0  - USE WITH VT100 TERMINAL
; MONITOR 2.1B - Unified command set, no more environment change.
;
;================================================================================================
TPA			.EQU	0100H		; Transient Programs Area
MONITOR		.EQU	0D000H		; Monitor entry point
BIOS		.EQU	0E600H		; BIOS entry point
DMA			.EQU	0080H		; Buffer used by Monitor
DISKPAD		.EQU	0E000H		; Draft area used by disk R/W ops
								; (512 bytes between Monitor and BIOS)

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

;================================================================================================
; FLASH card stuff
;================================================================================================
FLASH_ADDR		.EQU	0B0H			; Base I/O address for compact flash card
CF_DATA			.EQU	(FLASH_ADDR+0)	; R/W
CF_FEATURES		.EQU	(FLASH_ADDR+1)	; W
CF_ERROR		.EQU	(FLASH_ADDR+1)	; R
CF_SECCOUNT		.EQU	(FLASH_ADDR+2)	; W

CF_SECTOR		.EQU	(FLASH_ADDR+3)	; W
CF_CYL_LOW		.EQU	(FLASH_ADDR+4)	; W
CF_CYL_HI		.EQU	(FLASH_ADDR+5)	; W
CF_HEAD			.EQU	(FLASH_ADDR+6)	; W

CF_LBA0			.EQU	(FLASH_ADDR+3)	; W
CF_LBA1			.EQU	(FLASH_ADDR+4)	; W
CF_LBA2			.EQU	(FLASH_ADDR+5)	; W
CF_LBA3			.EQU	(FLASH_ADDR+6)	; W

CF_STATUS		.EQU	(FLASH_ADDR+7)	; R
CF_COMMAND		.EQU	(FLASH_ADDR+7)	; W

;CF Features
CF_8BIT			.EQU	1
CF_NOCACHE		.EQU	082H

;CF Commands
CF_READ_SEC		.EQU	020H
CF_WRITE_SEC	.EQU	030H
CF_SET_FEAT		.EQU 	0EFH
;================================================================================================
; MAIN PROGRAM STARTS HERE
;================================================================================================
			.ORG MONITOR

CYCLE:		CALL PRINTENV
			CALL LINER					; Call the line manager
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
; Help for main program
;================================================================================================
HELP:		CALL CRLF
			CALL PRINTSEQ
			.DB	" Options:   READ aaaa             read from memory.",CR,LF
			.DB "            WRITE aaaa,c1 c2 cN   write to memory.",CR,LF
			.DB "            COPY aaaa-bbbb,cccc   copy memory block.",CR,LF
			.DB "            FILL aaaa-bbbb,cc     fill memory block.",CR,LF
			.DB	"            DREAD aaaa            read from disk.",CR,LF
			.DB "            DOWN d,ttt,ss         download one sector from disk.",CR,LF
			.DB "            UP d,ttt,ss           upload one sector to disk.",CR,LF
			.DB "            VERIFY d,ttt,ss       verify disk sector(s).",CR,LF
			.DB "            XMODEM aaaa           receive file using xmodem protocol.",CR,LF
			.DB "            HEX2COM aaaa          convert intel hex to executable.",CR,LF
			.DB "            RUN aaaa              run program.",CR,LF
			.DB "            BOOT",CR,LF,0
			JP	CYCLE
			
;================================================================================================
; Read memory operations
;================================================================================================
MREAD:		LD	DE,DMA+4
			CALL GETWORD		; Get aaaa
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
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
TRYAGAIN:	CALL CONIN			; Wait for user's decision
			CP	CR
			JR	Z,NEWHDR
			CP	ESC
			JP	Z,CYCLE
			JR	TRYAGAIN

PRINTHDR:	CALL PRINTSEQ
			.DB ">ADDR: 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  0123456789ABCDEF",CR,LF,
			.DB ">----- -----------------------------------------------  ----------------",0
			RET

PRINTFTR:	CALL CRLF
			CALL PRINTSEQ
			.DB ">#================= <ENTER> = next page, <ESC> = quit =================#",CR,LF,0
			RET

;================================================================================================
; Write memory operations
;================================================================================================
MWRITE:		LD	DE,DMA+5
			CALL GETWORD		; Get aaaa
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			LD	(AAAA),BC		; Save aaaa
			LD	DE,DMA+10
MWNEXT:		INC	DE
			LD	A,(DE)
			CP	0
			JP	Z,CYCLE			; End of char string?
			CALL GETBYTE		; Get cc
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			LD	HL,(AAAA)
			LD	(HL),B			; Put the byte in memory
			INC	HL
			LD	(AAAA),HL
			JR	MWNEXT

;================================================================================================
; Copy memory operations
;================================================================================================
MCOPY:		LD	DE,DMA+4
			CALL GETWORD		; Get aaaa
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			LD	(AAAA),BC		; Save aaaa
			LD	DE,DMA+10
			CALL GETWORD		; Get bbbb
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			LD	(BBBB),BC		; Save bbbb
			LD	DE,DMA+15
			CALL GETWORD		; Get cccc
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			LD	(CCCC),BC		; Save cccc
			LD	HL,(BBBB)
			LD	DE,(AAAA)
			XOR	A				; Reset carry flag
			SBC	HL,DE
			INC	HL
			EX	DE,HL			; HL=source
			PUSH DE
			POP BC				; BC=counter
			LD	DE,(CCCC)		; DE=target
			LDIR
			JP	CYCLE

;================================================================================================
; Fill memory operations
;================================================================================================
MFILL:		LD	DE,DMA+4
			CALL GETWORD		; Get aaaa
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			LD	(AAAA),BC		; Save aaaa
			LD	DE,DMA+10
			CALL GETWORD		; Get bbbb
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			LD	(BBBB),BC		; Save bbbb
			LD	DE,DMA+15
			CALL GETBYTE		; Get cc
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			LD	HL,(AAAA)
			LD	(HL),B			; Put cc in the 1st position of the area to be filled.
			LD	HL,(BBBB)
			LD	DE,(AAAA)
			XOR	A				; Reset carry flag
			SBC	HL,DE
			EX	DE,HL			; HL=source
			PUSH DE
			POP BC				; BC=counter
			PUSH HL
			POP	DE
			INC DE
			LDIR
			JP	CYCLE

;================================================================================================
; Xmodem Command
;================================================================================================
XMODEM:		LD	DE,DMA+6
			CALL GETWORD		
			CP	1					; Is the argument OK?
			JP	NZ,CYCLE
			LD	(AAAA),BC			; Save address
			LD	A,0
			LD	(RETRY),A			; Init retry counter
			INC	A
			LD	(BLOCK),A			; Init block counter

ALIVE:		CALL SENDNAK
GET1ST:		LD	B,5
			CALL TOCONIN			; 5s timeout
			JR	C,REPEAT			; Timed out?
			CP	EOT
			JR	Z,GOTEOT			; EOT?
			CP	CAN
			JP	Z,CYCLE				; CAN?
			CP	SOH
			JR	Z,GOTSOH			; SOH?
REPEAT:		LD	A,(RETRY)
			INC	A
			LD	(RETRY),A
			CP	MAXTRY
			JR	NZ,ALIVE			; Try again?
OUT3:		
			CALL SENDCAN
			JP	CYCLE
			
GOTEOT:		CALL SENDNAK
			LD	B,1
			CALL TOCONIN
			CALL SENDACK
			JP	CYCLE
			
GOTSOH:		LD	A,0
			LD	(CHKSUM),A			; Reset checksum
			LD	(BYTECNT),A			; Reset byte counter
			LD	B,1
			CALL TOCONIN			; Get incoming block number
			JR	C,OUT2				; Timed out?
			LD	C,A					; Save incoming block number
			LD	B,1
			CALL TOCONIN			; Get complement of incoming block number
			JR	C,OUT2				; Timed out?
			CPL
			CP	C
			JR	NZ,OUT2				; block = //block?
			LD	A,(BLOCK)
			CP	C					; Is block number what we expected?
			JR	Z,RECPACK
			DEC	A
			CP	C					; block number is the anterior? Probably sender missed our ACK.
			JR	NZ,OUT2
ANTBLK:		CALL PURGE				; Purge input buffer before sending ACK
			CALL SENDACK
			JP	GET1ST
OUT2:		CALL PURGE
			CALL SENDCAN
			JP	CYCLE
RECPACK:	LD	B,1					; Start receiving data packet (128 bytes)
			CALL TOCONIN
			JR	C,OUT2				; Timed out?
			LD	HL,(AAAA)
			LD	(HL),A				; Put byte in buffer
			INC	HL					; Inc buffer pointer
			LD	(AAAA),HL
			LD	C,A
			LD	A,(CHKSUM)
			ADD	A,C
			LD	(CHKSUM),A			; Update checksum
			LD	A,(BYTECNT)			; Inc byte counter
			INC	A
			LD	(BYTECNT),A
			CP	128					; Check if we received a full data packet
			JR	NZ,RECPACK
			LD	B,1
			CALL TOCONIN			; Get checksum
			JR	C,OUT2				; Timed out?
			LD	C,A
			LD	A,(CHKSUM)
			CP	C
			JP	NZ,REPEAT			; Checksum OK?
			LD	A,0
			LD	(RETRY),A			; Reset retry counter
			LD	A,(BLOCK)
			INC	A
			LD	(BLOCK),A			; Increment block counter

			CALL SENDACK
			JP	GET1ST
			
SENDACK:	LD C,ACK
			CALL CONOUT
			RET

SENDNAK:	LD C,NAK
			CALL CONOUT
			RET

SENDCAN:	LD C,CAN
			CALL CONOUT
			RET

;==================================================================================
; Timed Out Console Input - X seconds, with X passed on reg B
; Incoming byte, if any, returns in A
; Carry flag set if timed out.
;==================================================================================
TOCONIN:	PUSH	BC
			PUSH	HL
LOOP0:		LD	HL,685				;2.5					\
LOOP1:		LD	C,35				;1.75	\				|
LOOP2:		CALL CONST				;36.5	|t=41.5C+0.5	| 
			INC	A					;1		|				|
			JR	Z,BWAITING			;3/1.75	|				| t=HL(41.5C+6.5)+1.25
			LD	A,C					;1		|				|
			DEC	C					;1		|				|
			JR	NZ,LOOP2			;3/1.75	/				| with HL=685 and c=35,
			DEC	HL					;1						|  t=0.9994sec (WOW!!!)
			LD	A,H					;1						|
			OR	L					;1						|
			JR	NZ,LOOP1			;3/1.75					/
			DJNZ	LOOP0			;3.25/2
			SCF
			JR	TOUT
BWAITING:	CALL CONIN
			SCF						; Reset carry flag
			CCF
TOUT:		POP	HL
			POP	BC
			RET

;==================================================================================
; Purge console input.
;==================================================================================
PURGE:		LD	B,3
			CALL TOCONIN
			JR	NC,PURGE
			RET

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
			LD	A,0					; Reset checksum
			LD	(CHKSUM),A
			CALL HGB				; Get byte count
			LD	A,B
			CP	0
			JP	Z,CYCLE				; If byte count=0, we're done.
			LD	(BYTECNT),A			; Save byte count
			CALL UPCHKSUM			; Update checksum
			INC	IX
			CALL HGW				; Get target address
			PUSH BC
			POP IY					; IY holds the target address
			CALL UPCHKSUM			; Update checksum
			LD	B,C
			CALL UPCHKSUM			; Update checksum
			CALL PRTADDR			; Print target address
			CALL HGB				; Get record type (just for checksum update)
			CALL UPCHKSUM			; Update checksum
			INC	IX
			LD	A,(BYTECNT)
			LD	B,A
GETDATA:	PUSH BC
			CALL HGB				; Get data byte
			LD	(IY+0),B
			CALL UPCHKSUM			; Update checksum
			INC	IY
			INC IX
			POP BC
			DJNZ GETDATA
			CALL HGB				; Get checksum
			LD	A,(CHKSUM)
			NEG
			CP	B
			JR	NZ,CHKSUMER
			CALL PRINTSEQ
			.DB	": OK.",CR,LF,0
			JR	FINDSC
CHKSUMER:	CALL PRINTSEQ
			.DB	": Checksum Error.",CR,LF,0
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
; Read disk operation (READ D,TTT,SS)
;================================================================================================
DREAD:		LD	DE,DMA+6
			CALL GETDTS
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			CALL DTS2LBA
			
NEXTSEC:	CALL PRINTDTS
			CALL CRLF
			CALL PRINTHDR
			CALL PRINTDSEC
			CALL PRINTFTR		; Print footer message
TAGAIN:		CALL CONIN			; Wait for user's decision
			CP	CR
			JR	NZ,NOTCR
			CALL INCDTS
			CALL DTS2LBA
			JP	NEXTSEC
NOTCR:		CP	ESC
			JP	Z,CYCLE
			JR	TAGAIN


PRINTDTS:	CALL PRINTSEQ
			.DB	">Disk = ",0
			LD	A,(DSK)
			ADD	A,41H
			LD	C,A
			CALL CONOUT
			CALL PRINTSEQ
			.DB	" ,Track = ",0
			LD	A,(TRK+1)
			CALL PRINTBYTE
			LD	A,(TRK)
			CALL PRINTBYTE
			CALL PRINTSEQ
			.DB	" ,Sector = ",0
			LD	A,(SEC)
			CALL PRINTBYTE
			CALL PRINTSEQ
			.DB	" ,LBA = ",0
			LD	A,(LBA3)
			CALL PRINTBYTE
			LD	A,(LBA2)
			CALL PRINTBYTE
			LD	A,(LBA1)
			CALL PRINTBYTE
			LD	A,(LBA0)
			CALL PRINTBYTE
			RET

PRINTBYTE:	LD	B,A
			CALL B2HL
			LD	C,H
			CALL CONOUT
			LD	C,L
			CALL CONOUT
			RET

PRINTDSEC:	RET

INCDTS:		LD	A,(SEC)
			CP	1FH
			JR	Z,ZSEC
			INC	A
			LD	(SEC),A
			RET
ZSEC:		XOR	A
			LD	(SEC),A
			LD	HL,(TRK)
			LD	BC,1FFH
			SCF
			CCF
			SBC	HL,BC
			JR	Z,ZTRK
			LD	HL,(TRK)
			INC	HL
			LD	(TRK),HL
			RET
ZTRK:		LD	HL,0
			LD	(TRK),HL
			LD	A,(DSK)
			CP	0FH
			JR	Z,ZDSK
			INC	A
			LD	(DSK),A
			RET
ZDSK:		XOR	A
			LD	(DSK),A
			RET
			
;================================================================================================
; Download 1 sector from disk to memory (@ DMIRROR)
;================================================================================================
DDOWN:		LD	DE,DMA+5
			CALL GETDTS
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			CALL DTS2LBA
			CALL DISKREAD
			JP	CYCLE

;================================================================================================
; Routine to get DTS from command line. DE=line_buf_ptr(should point to where DTS starts).
; Returns A=0 if missing arg, A=1 if OK, A=2 if invalid arg. 
;================================================================================================
GETDTS:		CALL GETDISK
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			INC DE
			CALL GETTRACK
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			INC	DE
			INC DE
			CALL GETSECTOR
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			RET

GETDISK:	LD	A,(DE)
			CP	0
			JP	NZ,GD1
			CALL GBNA
			RET
GD1:		SUB	'A'
			LD	(DSK),A
			CP	10H
			JP	M,GD2
			CALL GBIA
			RET
GD2:		LD	A,1
			RET

GETTRACK:	LD	A,'0'
			LD	(DE),A
			CALL GETWORD
			CP	1
			RET	NZ
			LD	(TRK),BC
			LD	HL,1FFH
			SCF
			CCF
			SBC	HL,BC
			LD	A,1
			RET	P
			CALL GBIA
			RET

GETSECTOR:	CALL GETBYTE
			CP	1
			RET	NZ
			LD	A,B
			LD	(SEC),A
			CP	20H
			LD	A,1
			RET	M
			CALL GBIA
			RET
			
;================================================================================================
; Convert disk/track/sector to LBA0,1,2,3.
;================================================================================================
DTS2LBA:	LD	HL,(TRK)
			RLC	L
			RLC	L
			RLC	L
			RLC	L
			RLC	L
			LD	A,L
			AND	0E0H
			LD	L,A
			LD	A,(SEC)
			ADD	A,L
			LD	(LBA0),A
			LD	HL,(TRK)
			RRC	L
			RRC	L
			RRC	L
			LD	A,L
			AND	01FH
			LD	L,A
			RLC	H
			RLC	H
			RLC	H
			RLC	H
			RLC	H
			LD	A,H
			AND	020H
			LD	H,A
			LD	A,(DSK)
			RLC	A
			RLC	A
			RLC	A
			RLC	A
			RLC	A
			RLC	A
			AND	0C0H
			ADD	A,H
			ADD	A,L
			LD	(LBA1),A
			LD	A,(DSK)
			RRC	A
			RRC	A
			AND	03H
			LD	(LBA2),A
			LD	A,0E0H
			LD	(LBA3),A
			RET
			
;================================================================================================
; Wait for disk to be ready (busy=0,ready=1)
;================================================================================================
DWAIT:		PUSH AF
DWAIT1:		IN 	A,(CF_STATUS)
			AND	080H
			CP 	080H
			JR	Z,DWAIT1
			POP	AF
			RET

;================================================================================================
; Set LBA on CF
;================================================================================================
SETLBA:		LD	A,(LBA0)
			OUT (CF_LBA0),A
			LD	A,(LBA1)
			OUT (CF_LBA1),A
			LD	A,(LBA2)
			OUT (CF_LBA2),A
			LD	A,(LBA3)
			OUT (CF_LBA3),A
			LD 	A,1
			OUT (CF_SECCOUNT),A
			RET				

;================================================================================================
; Read physical sector from host
;================================================================================================
DISKREAD:	PUSH AF
			PUSH BC
			PUSH HL

			CALL DWAIT
			CALL SETLBA
			LD 	A,CF_READ_SEC
			OUT (CF_COMMAND),A
			CALL DWAIT
			LD 	C,4
			LD 	HL,DISKPAD
rd4secs:	LD 	B,128
rdByte:		IN 	A,(CF_DATA)
			LD 	(HL),A
			INC HL
			DEC B
			JR 	NZ, rdByte
			DEC C
			JR 	NZ,rd4secs

			POP HL
			POP BC
			POP AF
			RET

;================================================================================================
; Write physical sector to host
;================================================================================================
DISKWRITE:	PUSH AF
			PUSH BC
			PUSH HL

			CALL DWAIT
			CALL SETLBA
			LD 	A,CF_WRITE_SEC
			OUT (CF_COMMAND),A
			CALL DWAIT
			LD 	C,4
			LD 	HL,DISKPAD
wr4secs:	LD 	B,128
wrByte:		LD 	A,(HL)
			OUT (CF_DATA),A
			INC HL
			DEC B
			JR 	NZ,wrByte
			DEC C
			JR 	NZ,wr4secs

			POP HL
			POP BC
			POP AF
			RET

;================================================================================================
; Upload 1 sector from memory (@ DMIRROR) to disk
;================================================================================================
DUP:		LD	DE,DMA+3
			CALL GETDTS
			CP	1				; Is the argument OK?
			JP	NZ,CYCLE
			CALL DTS2LBA
			CALL DISKWRITE
			JP	CYCLE

;================================================================================================
; Verify disk. Options:
;
;	VERIFY d,ttt,ss	= only this sector
;	VERIFY d,ttt	= all sectors on this track
;	VERIFY d		= all sectors on this disk
;	VERIFY			= all media (128MB)	:O
;================================================================================================
DVERIFY:	JP	DREAD

;================================================================================================
; Run (Execute) Command
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
GBNA:		CALL PRINTSEQ
			.DB	">Missing argument.",CR,LF,0
			LD	A,0
			RET
GBSPC:		INC	DE
			JR	GETBYTE
GBIA:		CALL PRINTSEQ
			.DB	">Invalid argument.",CR,LF,0
			LD	A,2
			RET

PRINTENV:	LD	C,PROMPT
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
CMDTBL:		.DB	"?",RS
			.DB	"BOOT",RS
			.DB	"XMODEM",RS
			.DB	"HEX2COM",RS
			.DB	"RUN",RS
			.DB	"READ",RS
			.DB	"DREAD",RS
			.DB	"WRITE",RS
			.DB	"COPY",RS
			.DB	"FILL",RS
			.DB	"DOWN",RS
			.DB	"UP",RS
			.DB	"VERIFY",ETX

JMPTBL:		JP	HELP
			JP	WBOOT
			JP	XMODEM
			JP	HEX2COM
			JP	RUN
			JP	MREAD
			JP	DREAD
			JP	MWRITE
			JP	MCOPY
			JP	MFILL
			JP	DDOWN
			JP	DUP
			JP	DVERIFY
			
;================================================================================================
CMDNUM		.DB	0
LBUFPTR		.DW	0
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
LBA3		.DB	0
LBA2		.DB	0
LBA1		.DB	0
LBA0		.DB	0

			.END
