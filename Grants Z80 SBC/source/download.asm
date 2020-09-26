;==================================================================================
; Contents of this file are copyright Grant Searle
; HEX routine from Joel Owens.
;
; You have permission to use this for NON COMMERCIAL USE ONLY
; If you wish to use it elsewhere, please include an acknowledgement to myself.
;
; http://searle.hostei.com/grant/index.html
;
; eMail: home.micros01@btinternet.com
;
; If the above don't work, please perform an Internet search to see if I have
; updated the web page hosting service.
;
;==================================================================================

TPA	.EQU	100H
REBOOT	.EQU	0H
BDOS	.EQU	5H
CONIO	.EQU	6
CONINP	.EQU	1
CONOUT	.EQU	2
PSTRING	.EQU	9
MAKEF	.EQU	22
CLOSEF	.EQU	16
WRITES	.EQU	21
DELF	.EQU	19
SETUSR	.EQU	32

CR	.EQU	0DH
LF	.EQU	0AH

FCB	.EQU	05CH
BUFF	.EQU	080H

	.ORG TPA


	LD	A,0
	LD	(buffPos),A
	LD	(checkSum),A
	LD	(byteCount),A
	LD	(printCount),A
	LD	HL,BUFF
	LD	(buffPtr),HL


WAITLT:	CALL	GETCHR
	CP	'U'
	JP	Z,SETUSER
	CP	':'
	JR	NZ,WAITLT


	LD	C,DELF
	LD	DE,FCB
	CALL	BDOS

	LD	C,MAKEF
	LD	DE,FCB
	CALL	BDOS

GETHEX:
	CALL 	GETCHR
	CP	'>'
	JR	Z,CLOSE
	LD   B,A
	PUSH BC
	CALL GETCHR
	POP BC
	LD   C,A

	CALL BCTOA

	LD	B,A
	LD	A,(checkSum)
	ADD	A,B
	LD	(checkSum),A
	LD	A,(byteCount)
	INC	A
	LD	(byteCount),A

	LD	A,B

	LD	HL,(buffPtr)

	LD	(HL),A
	INC	HL
	LD	(buffPtr),HL

	LD	A,(buffPos)
	INC	A
	LD	(buffPos),A
	CP	80H

	JR	NZ,NOWRITE

	LD	C,WRITES
	LD	DE,FCB
	CALL	BDOS
	LD	A,'.'
	CALL	PUTCHR

        ; New line every 8K (64 dots)
	LD	A,(printCount)
	INC	A
	CP	64
	JR	NZ,noCRLF
	LD	(printCount),A
	LD	A,CR
	CALL	PUTCHR
	LD	A,LF
	CALL	PUTCHR
	LD	A,0
noCRLF:	LD	(printCount),A

	LD	HL,BUFF
	LD	(buffPtr),HL

	LD	A,0
	LD	(buffPos),A
NOWRITE:
	JR	GETHEX
	

CLOSE:

	LD	A,(buffPos)
	CP	0
	JR	Z,NOWRITE2

	LD	C,WRITES
	LD	DE,FCB
	CALL	BDOS
	LD	A,'.'
	CALL	PUTCHR

NOWRITE2:
	LD	C,CLOSEF
	LD	DE,FCB
	CALL	BDOS

; Byte count (lower 8 bits)
	CALL 	GETCHR
	LD   B,A
	PUSH BC
	CALL GETCHR
	POP BC
	LD   C,A

	CALL BCTOA
	LD	B,A
	LD	A,(byteCount)
	SUB	B
	CP	0
	JR	Z,byteCountOK

	LD	A,CR
	CALL	PUTCHR
	LD	A,LF
	CALL	PUTCHR

	LD	DE,countErrMess
	LD	C,PSTRING
	CALL	BDOS

	; Sink remaining 2 bytes
	CALL GETCHR
	CALL GETCHR

	JR	FINISH

byteCountOK:

; Checksum
	CALL 	GETCHR
	LD   B,A
	PUSH BC
	CALL GETCHR
	POP BC
	LD   C,A

	CALL BCTOA
	LD	B,A
	LD	A,(checkSum)
	SUB	B
	CP	0
	JR	Z,checksumOK

	LD	A,CR
	CALL	PUTCHR
	LD	A,LF
	CALL	PUTCHR

	LD	DE,chkErrMess
	LD	C,PSTRING
	CALL	BDOS
	JR	FINISH

checksumOK:
	LD	A,CR
	CALL	PUTCHR
	LD	A,LF
	CALL	PUTCHR

	LD	DE,OKMess
	LD	C,PSTRING
	CALL	BDOS
		


FINISH:
	LD	C,SETUSR
	LD	E,0
	CALL	BDOS

	JP	REBOOT


SETUSER:
	CALL	GETCHR
	CALL	HEX2VAL
	LD	E,A
	LD	C,SETUSR
	CALL	BDOS
	JP	WAITLT

	
; Get a char into A
;GETCHR: LD C,CONINP
;	CALL BDOS
;	RET

; Wait for a char into A (no echo)
GETCHR: 
	LD	E,$FF
	LD 	C,CONIO
	CALL 	BDOS
	CP	0
	JR	Z,GETCHR
	RET

; Write A to output
PUTCHR: LD C,CONOUT
	LD E,A
	CALL BDOS
	RET


;------------------------------------------------------------------------------
; Convert ASCII characters in B C registers to a byte value in A
;------------------------------------------------------------------------------
BCTOA	LD   A,B	; Move the hi order byte to A
	SUB  $30	; Take it down from Ascii
	CP   $0A	; Are we in the 0-9 range here?
	JR   C,BCTOA1	; If so, get the next nybble
	SUB  $07	; But if A-F, take it down some more
BCTOA1	RLCA		; Rotate the nybble from low to high
	RLCA		; One bit at a time
	RLCA		; Until we
	RLCA		; Get there with it
	LD   B,A	; Save the converted high nybble
	LD   A,C	; Now get the low order byte
	SUB  $30	; Convert it down from Ascii
	CP   $0A	; 0-9 at this point?
	JR   C,BCTOA2	; Good enough then, but
	SUB  $07	; Take off 7 more if it's A-F
BCTOA2	ADD  A,B	; Add in the high order nybble
	RET

; Change Hex in A to actual value in A
HEX2VAL SUB	$30
	CP	$0A
	RET	C
	SUB	$07
	RET


buffPos	.DB	0H
buffPtr	.DW	0000H
printCount .DB	0H
checkSum .DB	0H
byteCount .DB	0H
OKMess	.BYTE	"OK$"
chkErrMess .BYTE	"======Checksum Error======$"
countErrMess .BYTE	"======File Length Error======$"
	.END
