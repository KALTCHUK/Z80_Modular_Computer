;********************************************
; SOME ADDRESSES
;********************************************
BOOT		EQU	0
CCP			EQU	0D000h		; Base of CCP (or Monitor).
BIOS		EQU	0E620h		; Base of BIOS.
FCB			EQU	05CH		; WHERE CCP WRITES THE COMMAND'S ARGUMENT
UINT		EQU	0E88FH		; ADDR OF ORIGINAL USART INTERRUPT ROUTINE
INTJMPADDR	EQU	039H		; ADDRESS CONTAINING UINT OR ALTUINT

;********************************************
; USART STUFF
;********************************************
USART_STA	EQU
USART_DAT	EQU

;********************************************
; CONSOLE INPUT BUFFER STUFF
;********************************************
BUFINI		EQU
BUFEND		EQU
WRPTR		EQU

;********************************************
; BIOS FUNCTIONS
;********************************************
LEAP		EQU	3

CONST:		EQU	BIOS+(LEAP*2)
CONIN:		EQU	BIOS+(LEAP*3)
CONOUT:		EQU	BIOS+(LEAP*4)
LIST:		EQU	BIOS+(LEAP*5)
LISTST:		EQU	BIOS+(LEAP*15)
PRINTSEQ:	EQU	BIOS+(LEAP*17)

;********************************************
; ASCII TABLE
;********************************************
CTRLA		EQU	1
CTRLC		EQU	3
CTRLD		EQU	4
CTRLE		EQU	5
CTRLF		EQU	6
CTRLG		EQU	7
LF			EQU	0AH
CR			EQU	0DH
CTRLQ		EQU	11H
CTRLR		EQU	12H
CTRLS		EQU	13H
CTRLW		EQU	17H
CTRLX		EQU	18H
CTRLZ		EQU	1AH
ESC			EQU	1BH

;*************************************************
; THIS IS THE ALTERNATIVE USART INTERRUPT ROUTINE.
; IT GOES IMMEDIATELY UNDER CCP.
;*************************************************
			.PHASE	BELOW_CCP <<< FAKE

ALTUINT:	PUSH	BC
			PUSH	HL

			IN	A,(USART_DAT)		; read incoming byte
			CP	ESC
			JR	Z,GOTESC
			CALL 	BUFFERIZE
EXIT:		POP	HL
			POP	BC
			IM	1
			EI
			RETI

GOTESC:		CALL	GETCHAR
			CP	ESC
			JR	Z,GOT2NDESC
			CP	'O'
			JR	Z,GOTO
			CP	BRACKET
			JR	NZ,EXIT
GOTBRACKET:	CALL	GETCHAR
			CP	'A'
			JR	Z,GOTBRKTA
			CP	'B'
			JR	Z,GOTBRKTB
			CP	'C'
			JR	Z,GOTBRKTC
			CP	'D'
			JR	Z,GOTBRKTD
			CP	'1'
			JR	Z,GOTBRKT1
			CP	'3'
			JR	Z,GOTBRKT3
			CP	'4'
			JR	Z,GOTBRKT4
			CP	'5'
			JR	Z,GOTBRKT5
			CP	'6'
			JR	NZ,EXIT
GOTBRKT6:	CALL	GETCHAR
			CP	'~'
			JR	NZ,EXIT
			CALL	PUTINBUF
			DB	CTRLC,0				; PAGE DOWN
			JP	EXIT
GOTBRKTA:	CALL	PUTINBUF
			DB	CTRLE,0				; ARROW UP
			JP	EXIT
GOTBRKTB:	CALL	PUTINBUF
			DB	CTRLX,0				; ARROW DOWN
			JP	EXIT
GOTBRKTC:	CALL	PUTINBUF
			DB	CTRLD,0				; ARROW RIGHT
			JP	EXIT
GOTBRKTD:	CALL	PUTINBUF
			DB	CTRLS,0				; ARROW LEFT
			JP	EXIT

GOTBRKT1:	CALL	GETCHAR
			CP	'~'
			JR	NZ,EXIT
			CALL	PUTINBUF
			DB	CTRLQ,'S',0			; HOME
			JP	EXIT
GOTBRKT3:	CALL	GETCHAR
			CP	'~'
			JR	NZ,EXIT
			CALL	PUTINBUF
			DB	CTRLG,0				; DELETE
			JP	EXIT
GOTBRKT4:	CALL	GETCHAR
			CP	'~'
			JR	NZ,EXIT
			CALL	PUTINBUF
			DB	CTRLQ,'D',0			; END
			JP	EXIT
GOTBRKT5:	CALL	GETCHAR
			CP	'~'
			JR	NZ,EXIT
			CALL	PUTINBUF
			DB	CTRLR,0				; PAGE UP
			JP	EXIT

GOT2NDESC:	CALL	PUTINBUF
			DB	ESC,0				; ESC
			JP	EXIT
			
GOTO:		CALL	GETCHAR
			CP	'A'
			JR	Z,GOTOA
			CP	'B'
			JR	Z,GOTOB
			CP	'C'
			JR	Z,GOTOC
			CP	'D'
			JR	NZ,EXIT
GOTOD:		CALL PUTINBUF
			DB	CTRLA,0				; CTRL LEFT ARROW
			JP	EXIT
GOTOA:		CALL	PUTINBUF
			DB	CTRLW,0				; CTRL RIGHT ARROW
			JP	EXIT
GOTOB:		CALL	PUTINBUF
			DB	CTRLZ,0				; CTRL RIGHT ARROW
			JP	EXIT
GOTOC:		CALL	PUTINBUF
			DB	CTRLF,0				; CTRL RIGHT ARROW
			JP	EXIT

;********************************************
; WAIT TILL USART HAS A CHARACTER IN BUFFER
; AND RETURN IT ON A
;********************************************
GETCHAR:	IN	A,(USART_STA)
			AND	00000010B
			JR	Z,GETCHAR
			IN	A,(USART_DAT)
			RET

;********************************************
; PUT A STRING OF CHARACTERS (ENDING WITH 00)
; IN THE BUFFER. (IDEA COPIED FROM PRINTSEQ).
;********************************************
PUTINBUF:	EX 	(SP),HL
NEXTCHAR:	LD 	A,(HL)
			CP	0
			JR	Z,EOPIB
			CALL 	BUFFERIZE
			INC 	HL
			JR	NEXTCHAR
EOPIB:		INC 	HL
			EX 	(SP),HL
			RET

;********************************************
; PUT CHARACTER IN A, IN BUFFER AND UPDATE
; WRITE POINTER.
;********************************************
BUFFERIZE:	PUSH	BC
			PUSH	HL

			LD	BC,(WRPTR)
			LD	(BC),A
			INC	BC
			LD	HL,BUFEND
			SCF
			CCF
			SBC	HL,BC
			JR	NZ,EOINT
			LD	BC,BUFINI
EOINT:		LD	(WRPTR),BC
			POP	HL
			POP	BC
			RET

			.DEPHASE
			
			
			END


