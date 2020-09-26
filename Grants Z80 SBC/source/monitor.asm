;==================================================================================
; Contents of this file are copyright Grant Searle
; HEX routines from Joel Owens.
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

;------------------------------------------------------------------------------
;
; Z80 Monitor Rom
;
;------------------------------------------------------------------------------
; General Equates
;------------------------------------------------------------------------------

CR		.EQU	0DH
LF		.EQU	0AH
ESC		.EQU	1BH
CTRLC		.EQU	03H
CLS		.EQU	0CH

; CF registers
CF_DATA		.EQU	$10
CF_FEATURES	.EQU	$11
CF_ERROR	.EQU	$11
CF_SECCOUNT	.EQU	$12
CF_SECTOR	.EQU	$13
CF_CYL_LOW	.EQU	$14
CF_CYL_HI	.EQU	$15
CF_HEAD		.EQU	$16
CF_STATUS	.EQU	$17
CF_COMMAND	.EQU	$17
CF_LBA0		.EQU	$13
CF_LBA1		.EQU	$14
CF_LBA2		.EQU	$15
CF_LBA3		.EQU	$16

;CF Features
CF_8BIT		.EQU	1
CF_NOCACHE	.EQU	082H
;CF Commands
CF_READ_SEC	.EQU	020H
CF_WRITE_SEC	.EQU	030H
CF_SET_FEAT	.EQU 	0EFH


loadAddr	.EQU	0D000h	; CP/M load address
numSecs		.EQU	24	; Number of 512 sectors to be loaded


;BASIC cold and warm entry points
BASCLD		.EQU	$2000
BASWRM		.EQU	$2003

SER_BUFSIZE	.EQU	40H
SER_FULLSIZE	.EQU	30H
SER_EMPTYSIZE	.EQU	5

RTS_HIGH	.EQU	0E8H
RTS_LOW		.EQU	0EAH

SIOA_D		.EQU	$00
SIOA_C		.EQU	$02
SIOB_D		.EQU	$01
SIOB_C		.EQU	$03

		.ORG	$4000
serABuf		.ds	SER_BUFSIZE
serAInPtr	.ds	2
serARdPtr	.ds	2
serABufUsed	.ds	1
serBBuf		.ds	SER_BUFSIZE
serBInPtr	.ds	2
serBRdPtr	.ds	2
serBBufUsed	.ds	1

primaryIO	.ds	1
secNo		.ds	1
dmaAddr		.ds	2

stackSpace	.ds	32
STACK   	.EQU    $	; Stack top


;------------------------------------------------------------------------------
;                         START OF MONITOR ROM
;------------------------------------------------------------------------------

MON		.ORG	$0000		; MONITOR ROM RESET VECTOR
;------------------------------------------------------------------------------
; Reset
;------------------------------------------------------------------------------
RST00		DI			;Disable INTerrupts
		JP	INIT		;Initialize Hardware and go
		NOP
		NOP
		NOP
		NOP
;------------------------------------------------------------------------------
; TX a character over RS232 wait for TXDONE first.
;------------------------------------------------------------------------------
RST08		JP	conout
		NOP
		NOP
		NOP
		NOP
		NOP
;------------------------------------------------------------------------------
; RX a character from buffer wait until char ready.
;------------------------------------------------------------------------------
RST10		JP	conin
		NOP
		NOP
		NOP
		NOP
		NOP
;------------------------------------------------------------------------------
; Check input buffer status
;------------------------------------------------------------------------------
RST18		JP	CKINCHAR

;------------------------------------------------------------------------------
; SIO Vector = 0x60
;------------------------------------------------------------------------------

		.ORG	$0060
		.DW	serialInt


;------------------------------------------------------------------------------
; Serial interrupt handlers
; Same interrupt called if either of the inputs receives a character
; so need to check the status of each SIO input.
;------------------------------------------------------------------------------
serialInt:	PUSH	AF
		PUSH	HL

		; Check if there is a char in channel A
		; If not, there is a char in channel B
		SUB	A
		OUT 	(SIOA_C),A
		IN   	A,(SIOA_C)	; Status byte D2=TX Buff Empty, D0=RX char ready	
		RRCA			; Rotates RX status into Carry Flag,	
		JR	NC, serialIntB

serialIntA:
		LD	HL,(serAInPtr)
		INC	HL
		LD	A,L
		CP	(serABuf+SER_BUFSIZE) & $FF
		JR	NZ, notAWrap
		LD	HL,serABuf
notAWrap:
		LD	(serAInPtr),HL
		IN	A,(SIOA_D)
		LD	(HL),A

		LD	A,(serABufUsed)
		INC	A
		LD	(serABufUsed),A
		CP	SER_FULLSIZE
		JR	C,rtsA0
	        LD   	A,$05
		OUT  	(SIOA_C),A
	        LD   	A,RTS_HIGH
		OUT  	(SIOA_C),A
rtsA0:
		POP	HL
		POP	AF
		EI
		RETI

serialIntB:
		LD	HL,(serBInPtr)
		INC	HL
		LD	A,L
		CP	(serBBuf+SER_BUFSIZE) & $FF
		JR	NZ, notBWrap
		LD	HL,serBBuf
notBWrap:
		LD	(serBInPtr),HL
		IN	A,(SIOB_D)
		LD	(HL),A

		LD	A,(serBBufUsed)
		INC	A
		LD	(serBBufUsed),A
		CP	SER_FULLSIZE
		JR	C,rtsB0
	        LD   	A,$05
		OUT  	(SIOB_C),A
	        LD   	A,RTS_HIGH
		OUT  	(SIOB_C),A
rtsB0:
		POP	HL
		POP	AF
		EI
		RETI

;------------------------------------------------------------------------------
; Console input routine
; Use the "primaryIO" flag to determine which input port to monitor.
;------------------------------------------------------------------------------
conin:
		PUSH	HL
		LD	A,(primaryIO)
		CP	0
		JR	NZ,coninB
coninA:

waitForCharA:
		LD	A,(serABufUsed)
		CP	$00
		JR	Z, waitForCharA
		LD	HL,(serARdPtr)
		INC	HL
		LD	A,L
		CP	(serABuf+SER_BUFSIZE) & $FF
		JR	NZ, notRdWrapA
		LD	HL,serABuf
notRdWrapA:
		DI
		LD	(serARdPtr),HL

		LD	A,(serABufUsed)
		DEC	A
		LD	(serABufUsed),A

		CP	SER_EMPTYSIZE
		JR	NC,rtsA1
	        LD   	A,$05
		OUT  	(SIOA_C),A
	        LD   	A,RTS_LOW
		OUT  	(SIOA_C),A
rtsA1:
		LD	A,(HL)
		EI

		POP	HL

		RET	; Char ready in A


coninB:

waitForCharB:
		LD	A,(serBBufUsed)
		CP	$00
		JR	Z, waitForCharB
		LD	HL,(serBRdPtr)
		INC	HL
		LD	A,L
		CP	(serBBuf+SER_BUFSIZE) & $FF
		JR	NZ, notRdWrapB
		LD	HL,serBBuf
notRdWrapB:
		DI
		LD	(serBRdPtr),HL

		LD	A,(serBBufUsed)
		DEC	A
		LD	(serBBufUsed),A

		CP	SER_EMPTYSIZE
		JR	NC,rtsB1
	        LD   	A,$05
		OUT  	(SIOB_C),A
	        LD   	A,RTS_LOW
		OUT  	(SIOB_C),A
rtsB1:
		LD	A,(HL)
		EI

		POP	HL

		RET	; Char ready in A

;------------------------------------------------------------------------------
; Console output routine
; Use the "primaryIO" flag to determine which output port to send a character.
;------------------------------------------------------------------------------
conout:		PUSH	AF		; Store character
		LD	A,(primaryIO)
		CP	0
		JR	NZ,conoutB1
		JR	conoutA1
conoutA:
		PUSH	AF

conoutA1:	CALL	CKSIOA		; See if SIO channel A is finished transmitting
		JR	Z,conoutA1	; Loop until SIO flag signals ready
		POP	AF		; RETrieve character
		OUT	(SIOA_D),A	; OUTput the character
		RET

conoutB:
		PUSH	AF

conoutB1:	CALL	CKSIOB		; See if SIO channel B is finished transmitting
		JR	Z,conoutB1	; Loop until SIO flag signals ready
		POP	AF		; RETrieve character
		OUT	(SIOB_D),A	; OUTput the character
		RET

;------------------------------------------------------------------------------
; I/O status check routine
; Use the "primaryIO" flag to determine which port to check.
;------------------------------------------------------------------------------
CKSIOA
		SUB	A
		OUT 	(SIOA_C),A
		IN   	A,(SIOA_C)	; Status byte D2=TX Buff Empty, D0=RX char ready	
		RRCA			; Rotates RX status into Carry Flag,	
		BIT  	1,A		; Set Zero flag if still transmitting character	
        	RET

CKSIOB
		SUB	A
		OUT 	(SIOB_C),A
		IN   	A,(SIOB_C)	; Status byte D2=TX Buff Empty, D0=RX char ready	
		RRCA			; Rotates RX status into Carry Flag,	
		BIT  	1,A		; Set Zero flag if still transmitting character	
        	RET

;------------------------------------------------------------------------------
; Check if there is a character in the input buffer
; Use the "primaryIO" flag to determine which port to check.
;------------------------------------------------------------------------------
CKINCHAR
		LD	A,(primaryIO)
		CP	0
		JR	NZ,ckincharB

ckincharA:

		LD	A,(serABufUsed)
		CP	$0
		RET

ckincharB:

		LD	A,(serBBufUsed)
		CP	$0
		RET

;------------------------------------------------------------------------------
; Filtered Character I/O
;------------------------------------------------------------------------------

RDCHR		RST	10H
		CP	LF
		JR	Z,RDCHR		; Ignore LF
		CP	ESC
		JR	NZ,RDCHR1
		LD	A,CTRLC		; Change ESC to CTRL-C
RDCHR1		RET

WRCHR		CP	CR
		JR	Z,WRCRLF	; When CR, write CRLF
		CP	CLS
		JR	Z,WR		; Allow write of "CLS"
		CP	' '		; Don't write out any other control codes
		JR	C,NOWR		; ie. < space
WR		RST	08H
NOWR		RET

WRCRLF		LD	A,CR
		RST	08H
		LD	A,LF
		RST	08H
		LD	A,CR
		RET


;------------------------------------------------------------------------------
; Initialise hardware and start main loop
;------------------------------------------------------------------------------
INIT		LD   SP,STACK		; Set the Stack Pointer

		LD	HL,serABuf
		LD	(serAInPtr),HL
		LD	(serARdPtr),HL

		LD	HL,serBBuf
		LD	(serBInPtr),HL
		LD	(serBRdPtr),HL

		xor	a			;0 to accumulator
		LD	(serABufUsed),A
		LD	(serBBufUsed),A

;	Initialise SIO

		LD	A,$00
		OUT	(SIOA_C),A
		LD	A,$18
		OUT	(SIOA_C),A

		LD	A,$04
		OUT	(SIOA_C),A
		LD	A,$C4
		OUT	(SIOA_C),A

		LD	A,$01
		OUT	(SIOA_C),A
		LD	A,$18
		OUT	(SIOA_C),A

		LD	A,$03
		OUT	(SIOA_C),A
		LD	A,$E1
		OUT	(SIOA_C),A

		LD	A,$05
		OUT	(SIOA_C),A
		LD	A,RTS_LOW
		OUT	(SIOA_C),A

		LD	A,$00
		OUT	(SIOB_C),A
		LD	A,$18
		OUT	(SIOB_C),A

		LD	A,$04
		OUT	(SIOB_C),A
		LD	A,$C4
		OUT	(SIOB_C),A

		LD	A,$01
		OUT	(SIOB_C),A
		LD	A,$18
		OUT	(SIOB_C),A

		LD	A,$02
		OUT	(SIOB_C),A
		LD	A,$60		; INTERRUPT VECTOR ADDRESS
		OUT	(SIOB_C),A
	
		LD	A,$03
		OUT	(SIOB_C),A
		LD	A,$E1
		OUT	(SIOB_C),A

		LD	A,$05
		OUT	(SIOB_C),A
		LD	A,RTS_LOW
		OUT	(SIOB_C),A

		; Interrupt vector in page 0
		LD	A,$00
		LD	I,A

		IM	2
		EI

		; Display the "Press space to start" message on both consoles
		LD	A,$00
		LD	(primaryIO),A
    		LD   	HL,INITTXT
		CALL 	PRINT
		LD	A,$01
		LD	(primaryIO),A
    		LD   	HL,INITTXT
		CALL 	PRINT

		; Wait until space is in one of the buffers to determine the active console

waitForSpace:

		CALL ckincharA
		jr	Z,notInA
		LD	A,$00
		LD	(primaryIO),A
		CALL	conin
		CP	' '
		JP	NZ, waitForSpace
		JR	spacePressed

notInA:
		CALL ckincharB
		JR	Z,waitForSpace
		LD	A,$01
		LD	(primaryIO),A
		CALL	conin
		CP	' '
		JP	NZ, waitForSpace
		JR	spacePressed

spacePressed:

		; Clear message on both consoles
		LD	A,$0C
		CALL	conoutA
		CALL	conoutB

		; primaryIO is now set to the channel where SPACE was pressed
	

		CALL TXCRLF	; TXCRLF
		LD   HL,SIGNON	; Print SIGNON message
		CALL PRINT

;------------------------------------------------------------------------------
; Monitor command loop
;------------------------------------------------------------------------------
MAIN  		LD   HL,MAIN	; Save entry point for Monitor	
		PUSH HL		; This is the return address
MAIN0		CALL TXCRLF	; Entry point for Monitor, Normal	
		LD   A,'>'	; Get a ">"	
		RST 08H		; print it

MAIN1		CALL RDCHR	; Get a character from the input port
		CP   ' '	; <spc> or less? 	
		JR   C,MAIN1	; Go back
	
		CP   ':'	; ":"?
		JP   Z,LOAD	; First character of a HEX load

		CALL WRCHR	; Print char on console

		CP   '?'
		JP   Z,HELP

		AND  $5F	; Make character uppercase

		CP   'R'
		JP   Z,RST00

		CP   'B'
		JP   Z,BASIC

		CP   'G'
		JP   Z,GOTO

		CP   'X'
		JP   Z,CPMLOAD

		LD   A,'?'	; Get a "?"	
		RST 08H		; Print it
		JR   MAIN0
	
;------------------------------------------------------------------------------
; Print string of characters to Serial A until byte=$00, WITH CR, LF
;------------------------------------------------------------------------------
PRINT		LD   A,(HL)	; Get character
		OR   A		; Is it $00 ?
		RET  Z		; Then RETurn on terminator
		RST  08H	; Print it
		INC  HL		; Next Character
		JR   PRINT	; Continue until $00


TXCRLF		LD   A,$0D	; 
		RST  08H	; Print character 
		LD   A,$0A	; 
		RST  08H	; Print character
		RET

;------------------------------------------------------------------------------
; Get a character from the console, must be $20-$7F to be valid (no control characters)
; <Ctrl-c> and <SPACE> breaks with the Zero Flag set
;------------------------------------------------------------------------------	
GETCHR		CALL RDCHR	; RX a Character
		CP   $03	; <ctrl-c> User break?
		RET  Z			
		CP   $20	; <space> or better?
		JR   C,GETCHR	; Do it again until we get something usable
		RET
;------------------------------------------------------------------------------
; Gets two ASCII characters from the console (assuming them to be HEX 0-9 A-F)
; Moves them into B and C, converts them into a byte value in A and updates a
; Checksum value in E
;------------------------------------------------------------------------------
GET2		CALL GETCHR	; Get us a valid character to work with
		LD   B,A	; Load it in B
		CALL GETCHR	; Get us another character
		LD   C,A	; load it in C
		CALL BCTOA	; Convert ASCII to byte
		LD   C,A	; Build the checksum
		LD   A,E
		SUB  C		; The checksum should always equal zero when checked
		LD   E,A	; Save the checksum back where it came from
		LD   A,C	; Retrieve the byte and go back
		RET
;------------------------------------------------------------------------------
; Gets four Hex characters from the console, converts them to values in HL
;------------------------------------------------------------------------------
GETHL		LD   HL,$0000	; Gets xxxx but sets Carry Flag on any Terminator
		CALL ECHO	; RX a Character
		CP   $0D	; <CR>?
		JR   NZ,GETX2	; other key		
SETCY		SCF		; Set Carry Flag
		RET             ; and Return to main program		
;------------------------------------------------------------------------------
; This routine converts last four hex characters (0-9 A-F) user types into a value in HL
; Rotates the old out and replaces with the new until the user hits a terminating character
;------------------------------------------------------------------------------
GETX		LD   HL,$0000	; CLEAR HL
GETX1		CALL ECHO	; RX a character from the console
		CP   $0D	; <CR>
		RET  Z		; quit
		CP   $2C	; <,> can be used to safely quit for multiple entries
		RET  Z		; (Like filling both DE and HL from the user)
GETX2		CP   $03	; Likewise, a <ctrl-C> will terminate clean, too, but
		JR   Z,SETCY	; It also sets the Carry Flag for testing later.
		ADD  HL,HL	; Otherwise, rotate the previous low nibble to high
		ADD  HL,HL	; rather slowly
		ADD  HL,HL	; until we get to the top
		ADD  HL,HL	; and then we can continue on.
		SUB  $30	; Convert ASCII to byte	value
		CP   $0A	; Are we in the 0-9 range?
		JR   C,GETX3	; Then we just need to sub $30, but if it is A-F
		SUB  $07	; We need to take off 7 more to get the value down to
GETX3		AND  $0F	; to the right hex value
		ADD  A,L	; Add the high nibble to the low
		LD   L,A	; Move the byte back to A
		JR   GETX1	; and go back for next character until he terminates
;------------------------------------------------------------------------------
; Convert ASCII characters in B C registers to a byte value in A
;------------------------------------------------------------------------------
BCTOA		LD   A,B	; Move the hi order byte to A
		SUB  $30	; Take it down from Ascii
		CP   $0A	; Are we in the 0-9 range here?
		JR   C,BCTOA1	; If so, get the next nybble
		SUB  $07	; But if A-F, take it down some more
BCTOA1		RLCA		; Rotate the nybble from low to high
		RLCA		; One bit at a time
		RLCA		; Until we
		RLCA		; Get there with it
		LD   B,A	; Save the converted high nybble
		LD   A,C	; Now get the low order byte
		SUB  $30	; Convert it down from Ascii
		CP   $0A	; 0-9 at this point?
		JR   C,BCTOA2	; Good enough then, but
		SUB  $07	; Take off 7 more if it's A-F
BCTOA2		ADD  A,B	; Add in the high order nybble
		RET

;------------------------------------------------------------------------------
; Get a character and echo it back to the user
;------------------------------------------------------------------------------
ECHO		CALL	RDCHR
		CALL	WRCHR
		RET

;------------------------------------------------------------------------------
; GOTO command
;------------------------------------------------------------------------------
GOTO		CALL GETHL		; ENTRY POINT FOR <G>oto addr. Get XXXX from user.
		RET  C			; Return if invalid       	
		PUSH HL
		RET			; Jump to HL address value

;------------------------------------------------------------------------------
; LOAD Intel Hex format file from the console.
; [Intel Hex Format is:
; 1) Colon (Frame 0)
; 2) Record Length Field (Frames 1 and 2)
; 3) Load Address Field (Frames 3,4,5,6)
; 4) Record Type Field (Frames 7 and 8)
; 5) Data Field (Frames 9 to 9+2*(Record Length)-1
; 6) Checksum Field - Sum of all byte values from Record Length to and 
;   including Checksum Field = 0 ]
;------------------------------------------------------------------------------	
LOAD		LD   E,0	; First two Characters is the Record Length Field
		CALL GET2	; Get us two characters into BC, convert it to a byte <A>
		LD   D,A	; Load Record Length count into D
		CALL GET2	; Get next two characters, Memory Load Address <H>
		LD   H,A	; put value in H register.
		CALL GET2	; Get next two characters, Memory Load Address <L>
		LD   L,A	; put value in L register.
		CALL GET2	; Get next two characters, Record Field Type
		CP   $01	; Record Field Type 00 is Data, 01 is End of File
		JR   NZ,LOAD2	; Must be the end of that file
		CALL GET2	; Get next two characters, assemble into byte
		LD   A,E	; Recall the Checksum byte
		AND  A		; Is it Zero?
		JR   Z,LOAD00	; Print footer reached message
		JR   LOADERR	; Checksums don't add up, Error out
		
LOAD2		LD   A,D	; Retrieve line character counter	
		AND  A		; Are we done with this line?
		JR   Z,LOAD3	; Get two more ascii characters, build a byte and checksum
		CALL GET2	; Get next two chars, convert to byte in A, checksum it
		LD   (HL),A	; Move converted byte in A to memory location
		INC  HL		; Increment pointer to next memory location	
		LD   A,'.'	; Print out a "." for every byte loaded
		RST  08H	;
		DEC  D		; Decrement line character counter
		JR   LOAD2	; and keep loading into memory until line is complete
		
LOAD3		CALL GET2	; Get two chars, build byte and checksum
		LD   A,E	; Check the checksum value
		AND  A		; Is it zero?
		RET  Z

LOADERR		LD   HL,CKSUMERR  ; Get "Checksum Error" message
		CALL PRINT	; Print Message from (HL) and terminate the load
		RET

LOAD00  	LD   HL,LDETXT	; Print load complete message
		CALL PRINT
		RET

;------------------------------------------------------------------------------
; Start BASIC command
;------------------------------------------------------------------------------
BASIC
    		LD HL,BASTXT
		CALL PRINT
		CALL GETCHR
		RET Z	; Cancel if CTRL-C
		AND  $5F ; uppercase
		CP 'C'
		JP  Z,BASCLD
		CP 'W'
		JP  Z,BASWRM
		RET

;------------------------------------------------------------------------------
; Display Help command
;------------------------------------------------------------------------------
HELP   	 	LD   HL,HLPTXT	; Print Help message
		CALL PRINT
		RET
	
;------------------------------------------------------------------------------
; CP/M load command
;------------------------------------------------------------------------------
CPMLOAD

    		LD HL,CPMTXT
		CALL PRINT
		CALL GETCHR
		RET Z	; Cancel if CTRL-C
		AND  $5F ; uppercase
		CP 'Y'
		JP  Z,CPMLOAD2
		RET
CPMTXT
		.BYTE	$0D,$0A
		.TEXT	"Boot CP/M?"
		.BYTE	$00

CPMTXT2
		.BYTE	$0D,$0A
		.TEXT	"Loading CP/M..."
		.BYTE	$0D,$0A,$00

CPMLOAD2
    		LD HL,CPMTXT2
		CALL PRINT


		CALL	cfWait
		LD 	A,CF_8BIT	; Set IDE to be 8bit
		OUT	(CF_FEATURES),A
		LD	A,CF_SET_FEAT
		OUT	(CF_COMMAND),A


		CALL	cfWait
		LD 	A,CF_NOCACHE	; No write cache
		OUT	(CF_FEATURES),A
		LD	A,CF_SET_FEAT
		OUT	(CF_COMMAND),A

		LD	B,numSecs

		LD	A,0
		LD	(secNo),A
		LD	HL,loadAddr
		LD	(dmaAddr),HL
processSectors:

		CALL	cfWait

		LD	A,(secNo)
		OUT 	(CF_LBA0),A
		LD	A,0
		OUT 	(CF_LBA1),A
		OUT 	(CF_LBA2),A
		LD	a,0E0H
		OUT 	(CF_LBA3),A
		LD 	A,1
		OUT 	(CF_SECCOUNT),A

		call	read

		LD	DE,0200H
		LD	HL,(dmaAddr)
		ADD	HL,DE
		LD	(dmaAddr),HL
		LD	A,(secNo)
		INC	A
		LD	(secNo),A

		djnz	processSectors

; Start CP/M using entry at top of BIOS
; The current active console stream ID is pushed onto the stack
; to allow the CBIOS to pick it up
; 0 = SIO A, 1 = SIO B
		
		ld	A,(primaryIO)
		PUSH	AF
		ld	HL,($FFFE)
		jp	(HL)


;------------------------------------------------------------------------------

; Read physical sector from host

read:
		PUSH 	AF
		PUSH 	BC
		PUSH 	HL

		CALL 	cfWait

		LD 	A,CF_READ_SEC
		OUT 	(CF_COMMAND),A

		CALL 	cfWait

		LD 	c,4
		LD 	HL,(dmaAddr)
rd4secs:
		LD 	b,128
rdByte:
		nop
		nop
		in 	A,(CF_DATA)
		LD 	(HL),A
		iNC 	HL
		dec 	b
		JR 	NZ, rdByte
		dec 	c
		JR 	NZ,rd4secs

		POP 	HL
		POP 	BC
		POP 	AF

		RET


; Wait for disk to be ready (busy=0,ready=1)
cfWait:
		PUSH 	AF
cfWait1:
		in 	A,(CF_STATUS)
		AND 	080H
		cp 	080H
		JR	Z,cfWait1
		POP 	AF
		RET

;------------------------------------------------------------------------------

SIGNON	.BYTE	"Z80 SBC Boot ROM 1.1"
		.BYTE	" by G. Searle"
		.BYTE	$0D,$0A
		.BYTE	"Type ? for options"
		.BYTE	$0D,$0A,$00

BASTXT
		.BYTE	$0D,$0A
		.TEXT	"Cold or Warm ?"
		.BYTE	$0D,$0A,$00

CKSUMERR	.BYTE	"Checksum error"
		.BYTE	$0D,$0A,$00

INITTXT  
		.BYTE	$0C
		.TEXT	"Press [SPACE] to activate console"
		.BYTE	$0D,$0A, $00

LDETXT  
		.TEXT	"Load complete."
		.BYTE	$0D,$0A, $00


HLPTXT
		.BYTE	$0D,$0A
		.TEXT	"R           - Reset"
		.BYTE	$0D,$0A
		.TEXT	"BC or BW    - ROM BASIC Cold or Warm"
		.BYTE	$0D,$0A
		.TEXT	"X           - Boot CP/M (load $D000-$FFFF from disk)"
		.BYTE	$0D,$0A
		.TEXT	":nnnnnn...  - Load Intel-Hex file record"
		.BYTE	$0D,$0A
        	.BYTE   $00

;------------------------------------------------------------------------------

FINIS		.END	

