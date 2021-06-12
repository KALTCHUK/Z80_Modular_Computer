;===========================================================
; USEFUL ADDRESSES.
;===========================================================
IOBYTE		EQU	3
BDOS:		EQU	05
FCB			EQU	05CH
FCB2		EQU	06CH
TPA			EQU	0100H				; Transient Programs Area
CCP         EQU	0D000h          ; Base of CCP (or Monitor).
BIOS        EQU	0E620h          ; Base of BIOS.

;===========================================================
; BIOS functions.
;===========================================================
LEAP		EQU	3					; 3 bytes for each entry (JP aaaa)

BOOT:		EQU	BIOS				;  0 Initialize.
WBOOT:		EQU	BIOS+(LEAP*1)		;  1 Warm boot.
CONST:		EQU	BIOS+(LEAP*2)		;  2 Console status.
CONIN:		EQU	BIOS+(LEAP*3)		;  3 Console input.
CONOUT:		EQU	BIOS+(LEAP*4)		;  4 Console OUTput.
LIST:		EQU	BIOS+(LEAP*5)		;  5 List OUTput.
PUNCH:		EQU	BIOS+(LEAP*6)		;  6 Punch OUTput.
READER:		EQU	BIOS+(LEAP*7)		;  7 Reader input.
HOME:		EQU	BIOS+(LEAP*8)		;  8 Home disk.
SELDSK:		EQU	BIOS+(LEAP*9)		;  9 Select disk.
SETTRK:		EQU	BIOS+(LEAP*10)		; 10 Select track.
SETSEC:		EQU	BIOS+(LEAP*11)		; 11 Select sector.
SETDMA:		EQU	BIOS+(LEAP*12)		; 12 Set DMA ADDress.
READ:		EQU	BIOS+(LEAP*13)		; 13 Read 128 bytes.
WRITE:		EQU	BIOS+(LEAP*14)		; 14 Write 128 bytes.
LISTST:		EQU	BIOS+(LEAP*15)		; 15 List status.
SECTRAN:	EQU	BIOS+(LEAP*16)		; 16 Sector translate.
PRINTSEQ:	EQU	BIOS+(LEAP*17)		; not a BIOS function

;===========================================================
; BDOS functions.
;===========================================================
SYSRESET	EQU	0
CONSOLEIN	EQU	1
CONSOLEOUT	EQU	2
READERIN	EQU	3
PUNCHOUT	EQU	4
LISTOUT		EQU	5
DIRECTIO	EQU	6
GETIOBYTE	EQU	7
SETIOBYTE	EQU	8
PRTSTRING	EQU	9
READCONBUF	EQU	10
GETCONSTAT	EQU	11
GETVERNUM	EQU	12
RSTDSKSYS	EQU	13
SELDISK		EQU	14
OPENFILE	EQU	15
CLOSEFILE	EQU	16
GETFIRST	EQU	17
GETNEXT		EQU	18
DELFILE		EQU	19
READSEQ		EQU	20
WRITESEQ	EQU	21
CREFILE		EQU	22
RENFILE		EQU	23
GETLOGVEC	EQU	24
GETCURDSK	EQU	25
SETDMA		EQU	26
GETALOC		EQU	27
WRPDSK		EQU	28
GETROVEC	EQU	29
SETATTR		EQU	30
GETPARMS	EQU	31
GETUSER		EQU	32
RDRANDOM	EQU	33
WRRANDOM	EQU	34
FILESIZE	EQU	35
SETRAND		EQU	36
RSTDRIVE	EQU	37
WRRNDZERO	EQU	40

;===========================================================
; ASCII characters.
;===========================================================
NUL			EQU	00H
SOH			EQU	01H
STX			EQU	02H
ETX			EQU	03H
EOT			EQU	04H
ENQ			EQU	05H
ACK			EQU	06H
BEL			EQU	07H
BS			EQU	08H
HT			EQU	09H
LF			EQU	0AH
VT			EQU	0BH
FF			EQU	0CH
CR			EQU	0DH
SO			EQU	0EH
SI			EQU	0FH
DLE			EQU	10H
DC1			EQU	11H
DC2			EQU	12H
DC3			EQU	13H
DC4			EQU	14H
NAK			EQU	15H
SYN			EQU	16H
ETB			EQU	17H
CAN			EQU	18H
EM			EQU	19H
SUB			EQU	1AH
ESC			EQU	1BH
FS			EQU	1CH
GS			EQU	1DH
RS			EQU	1EH
US			EQU	1FH

