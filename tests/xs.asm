;*****************************************************************************
; XS - Xmodem Send for Z80 CP/M 2.2 using CON:
; Copyright 2017 Mats Engstrom, SmallRoomLabs
;
; Licensed under the MIT license
;*****************************************************************************
;
;	Common entry points and locations
;
BOOT:	EQU	0000h	; Warm boot/Reset vector
BDOS:	EQU 	0005h	; BDOS function vector
DFCB:	EQU	5CH	; Default File Control Block
DFCBcr:	EQU 	DFCB+32 ; Current record
dbuf:	EQU	0080h

;
; BDOS function codes
;
;WBOOT:	 EQU	0	; System Reset
;GETCON: EQU	1	; Console Input A<char
;OUTCON: EQU	2	; Console Output E=char
;GETRDR: EQU	3	; Reader Input A<char
;PUNCH:	 EQU	4	; Punch Output E=char
;LIST:	 EQU	5	; List Output E=char
;DIRCIO: EQU	6	; Direct Console I/O E=char/FE/FF A<char
;GETIOB: EQU	7	; Get I/O Byte A<value
;SETIOB: EQU	8	; Set I/O Byte E=value
;PRTSTR: EQU	9	; Print $ String DE=addr
;RDBUFF: EQU	10	; Read Console Buffer DE=addr
;GETCSTS:EQU	11	; Get Console Status A<status (00empty FFdata)
;GETVER: EQU	12	; Return Version Number HL<version
;RSTDSK: EQU	13	; Reset Disk System
;SETDSK: EQU	14	; Select Disk E=diskno
OPENFIL: EQU	15	; Open File DE=FCBaddr A<handle (FFerr)
CLOSEFIL:EQU	16	; Close File DE=FCBaddr A<handle (FFerr)
;GETFST: EQU	17	; Search for First DE=FCBaddr A<handle (FFerr)
;GETNXT: EQU	18	; Search for Next A<handle (FFerr)
;DELFILE:EQU	19	; Delete File DE=FCBaddr A<handle (FFerr)
READSEQ: EQU	20	; Read Sequential DE=FCBaddr A<status (00ok)
;WRTSEQ: EQU	21	; Write Sequential DE=FCBaddr A<status (00ok)
;FCREATE:EQU	22	; Make File  DE=FCBaddr A<handle (FFerr)
;RENFILE:EQU	23	; Rename File DE=FCBaddr A<handle (FFerr)
;GETLOG: EQU	24	; Return Log-in Vector HL<bitmap
;GETCRNT:EQU	25	; Return Current Disk A<diskno
PUTDMA:	 EQU	26	; Set DMA Address DE=addr
;GETALOC:EQU	27	; Get Addr (ALLOC) HL<addr
;WRTPRTD:EQU	28	; Write Protect Current Disk
;GETROV: EQU	29	; Get Read-Only Vector HL<bitmap
;SETATTR:EQU	30	; Set File Attributes DE=FCBaddr A<handle
;GETPARM:EQU	31	; Get Addr (DISKPARMS) A<DPBaddr
;GETUSER:EQU	32	; Set/Get User Code E=code (FFget) A<value
;RDRANDOM:EQU	33	; Read Random DE=FCBaddr A<status
;WTRANDOM:EQU	34	; Write Random DE=FCBaddr A<status
;FILESIZE:EQU	35	; Compute File Size DE=FCBaddr
;SETRAN: EQU	36	; Set Random Record DE=FCBaddr
;LOGOFF: EQU	37	; Reset Drive DE=drivevector
;WTSPECL:EQU	40	; Write Random with Zero Fill DE=FCBaddr A<status

;
; ASCII codes
;
LF:	EQU	'J'-40h	; ^J LF
CR: 	EQU 	'M'-40h	; ^M CR/ENTER
SOH:	EQU	'A'-40h	; ^A CTRL-A
EOT:	EQU	'D'-40h	; ^D = End of Transmission
ACK:	EQU	'F'-40h	; ^F = Positive Acknowledgement
NAK:	EQU	'U'-40h	; ^U = Negative Acknowledgement
CAN:	EQU	'X'-40h	; ^X = Cancel

;
; Start of code
;
	ORG 0100h

	ld	A,(2)	; High part of BIOS Warm Boot address
	ld	(CONST+2),A	; Update jump target addressed
	ld	(CONIN+2),A	; ...
	ld	(CONOUT+2),A	; ...

	ld	(oldSP),SP
	ld	SP,stackend

	ld	HL,msgHeader	; Print a greeting
	call	PrintString0

	ld	A,(DFCB+1)	; Check if we got a filename
	cp	' '
	jp	Z,NoFileName

	ld  	DE,DFCB		; Then create new file
	ld 	A,0		; Start at block 0
	ld	(DFCBcr),A
	ld 	C,OPENFIL
	call	BDOS		; Returns A in 255 if error opening
	inc 	A
	jp	Z,FailOpenFile

	ld 	A,SOH		; Start packet with SOH
	ld 	(packet),A
	ld 	A,1		; The first packet is number 1
	ld 	(pktNo),A
	ld 	A,255-1		; Also store the 1-complement of it
	ld 	(pktNo1c),A

	call	ReadSector
	or	A
	jp	NZ,Done

WaitForReply:
 	ld 	A,60		; 60 Seconds of timeout before giving up
 	call	GetCharTmo
 	jp 	C,Failure

 	cp 	CAN		; Downloader wants to abort transfer?
 	jp 	Z,Cancelled	; Yes, then we're also done
 	cp	NAK		; Downloader want retransmit?
 	jp	Z,GotNAK	; Yes
	cp	ACK		; Downloader approved and wants next pkt?
	jp	Z,GotACK
	jp	WaitForReply	; Got something else. Go back and get another

GotNAK:
TransmitPacket:
	ld	A,132		; (Re-)Transmit the current packet
	ld	B,A
	ld	HL,packet
xmitloop:
	ld	C,(HL)
	push	HL
	push	BC
	call	CONOUT
	pop	BC
	pop	HL
	inc	HL
	djnz	xmitloop
	jp	WaitForReply

GotACK:
	ld	HL,pktNo	; Update the packet counters
	inc 	(HL)
	ld	HL,pktNo1c
	dec	(HL)

	call	ReadSector	; Fetch the next sector
	or	A
	jp	NZ,Done
	jp	TransmitPacket

;
; Read the next sector from disk into the packet buffer.
; Also calculate the checksum for the sector
; Returns 0 in A if OK, 1 in A if EOF
;
ReadSector:
 	ld	DE,data		; Set DMA address to the packet data buff
	ld 	C,PUTDMA
	call	BDOS
	ld  	DE,DFCB		; File Description Block
	ld 	C,READSEQ
	call	BDOS		; Returns A=0 if ok, A=1 if EOF

	push	AF		; Need to save A for later

	ld	HL,data		; Calculate checksum of the 128 data bytes
	ld	B,128
	ld	A,0
csloop:	add	A,(HL)		; Just add up the bytes
	inc	HL
	djnz	csloop
	ld	(chksum),A	; And store it in chksum

	pop	AF		; Restore A holding the result code

	ret

CloseFile:
	ld  	DE,DFCB		; Close the file
	ld 	C,CLOSEFIL
	jp	BDOS

Done:
DoneLoop:
	ld	C,EOT		; Tell receiver we're done
	call	CONOUT
 	ld 	A,10
 	call	GetCharTmo
 	jp 	C,DoneTmo
	ld	C,EOT		; Tell receiver we're done again
	call	CONOUT

DoneTmo:
 	ld 	A,1
 	call	GetCharTmo	; Delay 1 second

	ld 	HL,msgSucces1	; Print success message and filename
	call	PrintString0
	call	PrintFilename
	ld 	HL,msgSucces2
	jp	Die

FailOpenFile:
	ld	HL,msgFailOpn
	call	PrintString0
	call	PrintFilename
	ld	HL,msgCRLF
	jp	Exit

NoFileName:
	ld 	HL,msgNoFile
	call 	PrintString0	; Prints message and exits from program
	jp	Exit

Failure:
	ld 	HL,msgFailure
	jp	Die

Cancelled:
	ld 	HL,msgCancel
	jp	Die

Die:
	call 	PrintString0	; Prints message and exits from program
	call	CloseFile
Exit:
	ld	SP,(oldSP)
	ret

;
; Waits for up to A seconds for a character to become available and
; returns it in A without echo and Carry clear. If timeout then Carry
; it set.
;
GetCharTmo:
	ld 	B,A
GCtmoa:
	push	BC
	ld	B,255
GCtmob:
	push	BC
	ld	B,255
GCtmoc:
	push	BC
	call	CONST
	cp	00h		; A char available?
	jp 	NZ,GotChar	; Yes, get out of loop
	ld	HL,(0)		; Waste some cycles
	ld	HL,(0)		; ...
	ld	HL,(0)		; ...
	ld	HL,(0)		; ...
	ld	HL,(0)		; ...
	ld	HL,(0)		; ...
	pop	BC
	djnz	GCtmoc
	pop	BC
	djnz	GCtmob
	pop	BC
	djnz	GCtmoa
	scf 			; Set carry signals timeout
	ret

GotChar:
	pop	BC
	pop	BC
	pop	BC
	call	CONIN
	or 	A 		; Clear Carry signals success
	ret

;
; Print message pointed top HL until 0
;
PrintString0:
	ld	A,(HL)
	or	A		; Check if got zero?
	ret	Z		; If zero return to caller
	ld 	C,A
	call	CONOUT		; else print the character
	inc	HL
	jp	PrintString0

;
; Prints the 'B' bytes long string pointed to by HL, but no spaces
;
PrintNoSpaceB:
	push	BC
	ld	A,(HL)		; Get character pointed to by HL
	ld	C,A
	cp	' '		; Don't print spaces
	call	NZ,CONOUT
	pop	BC
	inc	HL		; Advance to next character
	djnz	PrintNoSpaceB	; Loop until B=0
	ret
;
;
;
PrintFilename:
	ld	A,(DFCB)	; Print the drive
	or	A		; If Default drive,then...
	jp	Z,PFnoDrive	; ...don't print the drive name
	add	A,'@'		; The drives are numbered 1-16...
	ld	C,A		; ...so we need to offset to get A..P
	call	CONOUT

	ld	C,':'		; Print colon after the drive name
	call	CONOUT

PFnoDrive:
	ld	HL,DFCB+1	; Start of filename in File Control Block
	ld	B,8		; First part is 8 characters
	call	PrintNoSpaceB

	ld	C,'.'		; Print the dot between filname & extension
	call	CONOUT

	ld 	B,3		; Then print the extension
	call	PrintNoSpaceB
	ret

;
; BIOS jump table vectors to be patched
;
CONST:	jp 	0ff06h	; A=0 if no character is ready, 0FFh if one is
CONIN:	jp	0ff09h	; Wait until character ready available and return in A
CONOUT:	jp	0ff0ch	; Write the character in C to the screen

;
; Message strings
;
msgHeader: DB 	'CP/M XS - Xmodem Send v0.1 / SmallRoomLabs 2017',CR,LF,0
msgFailure:DB	CR,LF,'Transmssion failed',CR,LF,0
msgCancel: DB	CR,LF,'Transmission cancelled',CR,LF,0
msgSucces1:DB	CR,LF,'File ',0
msgSucces2:DB	' sent successfully',CR,LF,0
msgFailOpn:DB	'Failed opening file ',0
msgNoFile: DB	'Filename expeced',CR,LF,0
msgCRLF:   DB	CR,LF,0

;
; Variables
;
oldSP:	 DS	2	; The orginal SP to be restored before exiting

packet:	 DS 	1	; SOH
pktNo:	 DS 	1 	; Current packet Number
pktNo1c: DS 	1 	; Current packet Number 1-complemented
data:	 DS	128	; data*128,
chksum:	 DS	1 	; chksum

stack:	 DS 	256
stackend: EQU $

	END