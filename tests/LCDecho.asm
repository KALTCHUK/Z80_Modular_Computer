;================================================================================================
; Read console (no echo) and send to LCD. Ctrl-C terminates the program and returns to CCP.
; When <CR><LF> occurs on the 2nd line, the display scrolls down 1 line. 
; Converts non printable characters (from 0x0 to 0x1F) to tag.
;
; 00 --> [NUL]
; 01 --> [SOH]
; 02 --> [STX]
;    ...
; 1F --> [US]
; 
; CPU @ 4.0MHz (this is important for the delay routines)
;
; RS  = A0 from CPU
; R/W = A1 from CPU
; E   = 74LS85 output pin 'A=B'
;================================================================================================

DAT_WR		.EQU	0E1H			;
DAT_RD		.EQU	0E3H			;
CMD_WR		.EQU	0E0H			;
CMD_RD		.EQU	0E2H			;

BOOT		.EQU	0				; Boot address (return control to CCP)
TPA			.EQU	0100H			; Transient Program Area initial address
BDOS		.EQU	5H
; BDOS functions
C_RAWIO		.EQU	6
C_READ		.EQU	1
C_WRITE		.EQU	2
C_WRITESTR	.EQU	9

SPACE		.EQU	020H

;================================================================================================
; Main program
;================================================================================================
			.ORG	TPA

			CALL LCDINIT
			CALL LCDCLEAR
		


;================================================================================================
; Initialize LCD
;================================================================================================
LCDINIT:	LD	B,15			; wait 15ms
			CALL	DELAYMS
			LD	A,030H		; write command 030h
			OUT	(CMD_WR),A
			LD	B,5			; wait 5ms
			CALL	DELAYMS
			LD	A,030H		; write command 030h
			OUT	(CMD_WR),A
			LD	C,20			; wait (5x20) 100us
			CALL	DELAY5US
			LD	A,030H		; write command 030h
			OUT	(CMD_WR),A
			LD	C,20			; wait (5x20) 100us
			CALL	DELAY5US
			LD	A,038H		; write command 038h = function set (8-bits, 2-lines, 5x7dots)
			OUT	(CMD_WR),A
			CALL	BWAIT
			LD	A,08H			; write command 08h = display (off)
			OUT	(CMD_WR),A
			CALL	BWAIT
			LD	A,01H			; write command 01h = clear display
			OUT	(CMD_WR),A
			CALL	BWAIT
			LD	A,06H			; write command 06h = entry mode (increment)
			OUT	(CMD_WR),A
			CALL	BWAIT
			LD	A,0CH			; write command 0Ch = display (on)
			OUT	(CMD_WR),A
			RET	

;================================================================================================
; Clear LCD and goto line 1, column 1.
;================================================================================================
LCDCLEAR:	CALL	BWAIT
			LD	A,01H			; write command 01h = clear display
			OUT	(CMD_WR),A
			RET

;================================================================================================
; Send to LCD char in regC. Print at current position (what ever it is)
;================================================================================================
LCDPUT:		CALL	BWAIT
			LD	A,C			; write command 01h = clear display
			OUT	(DAT_WR),A
			RET

;================================================================================================
; Position LCD cursor at line regH, column regL.
;================================================================================================
LCDPOS:		DEC	H
			SLA	H
			SLA	H
			SLA	H
			SLA	H
			SLA	H
			SLA	H
			LD	A,H
			DEC	L
			OR	L
			OR	080H
			LD	H,A
			CALL	BWAIT
			LD	A,H
			OUT	(CMD_WR),A
			RET

;================================================================================================
; (pseudo) Line Feed - De facto, it performs <LF><CR>.
; 
;================================================================================================
LCDLF:		PUSH 	BC
			CALL	BWAIT
			IN A,(CMD_RD)
			RLCA
			RLCA
			JR	NC,LINEONE

			LD	B,0				; initialize position counter
NEWSRC:		CALL	BWAIT
			LD	A,B
			OR	0C0H
			OUT	(CMD_WR),A		; set addr counter to source position
			CALL	BWAIT
			IN	A,(DAT_RD)		; get data from source position
			LD	C,A
			CALL	BWAIT
			LD	A,B
			OR	080H
			OUT	(CMD_WR),A		; set addr counter to target position
			CALL	BWAIT
			LD	A,C
			OUT	(DAT_WR),A		; put data in target position
			CALL	BWAIT
			LD	A,B
			OR	0C0H
			OUT	(CMD_WR),A		; set addr counter back to source position
			CALL	BWAIT
			LD	A,SPACE
			OUT	(DAT_WR),A		; put blank space in source position
			INC	B
			LD	A,B
			SUB	010H
			JR	NZ,NEWSRC

LINEONE:	LD	HL,0201H
			CALL	LCDPOS

			POP 	BC
			RET

;================================================================================================
; Delay X miliseconds, with X passed on reg B
;================================================================================================
DELAYMS:	PUSH	BC
DECB:		LD	C,0C8H
DECC:		NOP
			DEC	C
			JR	NZ,DECC
			DEC	B
			JR	NZ,DECB
			POP	BC
			RET

;================================================================================================
; Delay 5*X microseconds, with X passed on reg C
;================================================================================================
DELAY5US:	PUSH	BC
DEC:		NOP
			DEC	C
			JR	NZ,DEC
			POP	BC
			RET

;================================================================================================
; Wait until Busy flag = 0
;================================================================================================
BWAIT:		IN A,(CMD_RD)
			RLCA
			JR	C,BWAIT
			RET

;================================================================================================
; Conversion table for non printable characters
;================================================================================================
CODETAB:	.DB		"NUL"			; Null
			.DB		"SOH"			; Start of Header
			.DB		"STX"			; Start of Text
			.DB		"ETX"			; End of Text
			.DB		"EOT"			; End of Transmission
			.DB		"ENQ"			; Enquiry
			.DB		"ACK"			; Acknowledge
			.DB		"BEL"			; Bell
			.DB		"BS	"			; Backspace
			.DB		"HT	"			; Horizontal Tab
			.DB		"LF	"			; Line Feed
			.DB		"VT	"			; Vertical Tab
			.DB		"FF	"			; Form Feed
			.DB		"CR	"			; Carriage Return
			.DB		"SO	"			; Shift Out
			.DB		"SI	"			; Shift In
			.DB		"DLE"			; Data Link Escape
			.DB		"DC1"			; Device Control 1
			.DB		"DC2"			; Device Control 2
			.DB		"DC3"			; Device Control 3
			.DB		"DC4"			; Device Control 4
			.DB		"NAK"			; Negative Acknowledge
			.DB		"SYN"			; Synchronize
			.DB		"ETB"			; End of Transmission Block
			.DB		"CAN"			; Cancel
			.DB		"EM	"			; End of Medium
			.DB		"SUB"			; Substitute
			.DB		"ESC"			; Escape
			.DB		"FS	"			; File Separator
			.DB		"GS	"			; Group Separator
			.DB		"RS	"			; Record Separator
			.DB		"US	"			; Unit Separator

			.END
