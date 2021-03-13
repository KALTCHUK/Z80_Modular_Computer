;==================================================================================
; XMODEM.ASM version 1 - Kaltchuk, feb/2021
;
; This program implements xmodem protocol on CP/M.
; (3 bytes header, 128byte data packets, 1byte CheckSum).
;
; +-------- header --------+------- data packet -------+
; |                        |                           |
;  <SOH> <BlkNum> </BlkNum> <byte1> <byte2>...<byte128> <ChkSum>
;==================================================================================

SOH			.EQU	01H				; ASCII characters
EOT			.EQU	04H
ACK			.EQU	06H
LF			.EQU	0AH
CR			.EQU	0DH
NAK			.EQU	015H
CAN			.EQU	018H
SUB			.EQU	01AH

MAXTRY		.EQU	5

USART_DAT	.EQU	80H
USART_STA	.EQU	81H
;==================================================================================
			.ORG 0

GETBYTE:	CALL SENDNAK
			LD	B,4
			CALL TOCONIN			;10s timeout
			JR	C,REPEAT			; Timed out?
			HALT
REPEAT:		LD	A,(RETRY)
			INC	A
			LD	(RETRY),A
			CP	MAXTRY
			JR	NZ,GETBYTE			; Try again?
			HALT

;==================================================================================
; Send ACK
;==================================================================================
SENDACK:	LD C,'A'
			CALL CONOUT
			RET

;==================================================================================
; Send NAK
;==================================================================================
SENDNAK:	LD C,'N'
			CALL CONOUT
			RET

;==================================================================================
; Send CAN
;==================================================================================
SENDCAN:	LD C,'C'
			CALL CONOUT
			RET

;==================================================================================
; Timed Out Console Input - X seconds, with X passed on reg B
; Incoming byte, if any, returns in A
; Carry flag set if timed out.
;==================================================================================
TOCONIN:	PUSH	BC
			PUSH	HL
LOOP0:		LD	HL,2				;2.5					\
LOOP1:		LD	C,3				;1.75	\				|
LOOP2:		NOP						;1		|				|
			CALL CONST				;36.5	|t=41.5C+0.5	|
			INC	A					;1		|				|
			JR	Z,BWAITING			;3/1.75	|				| t=HL(41.5C+6.5)+1.25
			DEC	C					;1		|				|
			JR	NZ,LOOP2			;3/1.75	/				| with HL=685 and c=35,
			DEC	HL					;1						|  t=0.9994sec (WOW!!!)
			LD	A,H					;1						|
			OR	L					;1						|
			CALL SENDACK
			JR	NZ,LOOP1			;3/1.75					/
			DJNZ	LOOP0			;3.25/2
			SCF
			JR	TOUT
BWAITING:	CALL CONIN
			XOR	A					; Reset carry flag
TOUT:		POP	HL
			POP	BC
			RET

;================================================================================================
; Console Status (Return A=0FFh if character waiting. Otherwise, A=0)
;================================================================================================
CONST:		PUSH	BC
			PUSH	HL
			IN	A,(USART_STA)
			CP	0					; Reset carry flag
			JR	Z,CONVOID
			LD	A,0FFH
CONVOID:
			POP	HL
			POP	BC
			RET

;================================================================================================
; Console Input (Wait for input and return character in A)
;================================================================================================
CONIN:		PUSH	BC
			PUSH	HL
AGAIN:		CALL	CONST
			CP	0
			JR	Z,AGAIN			; Keep trying till we receive something
			IN	A,(USART_DAT)
EOCONIN:	POP	HL
			POP	BC
			RET					; Char read returns in A

;================================================================================================
; Console Output (Send character in reg C)
;================================================================================================
CONOUT:		LD	A,C
			OUT	(USART_DAT),A		; send character
			RET

;==================================================================================
RETRY		.DB 0					; Retry counter

			.DS	020h				; Start of stack area.
STACK		.EQU	$


			.END
