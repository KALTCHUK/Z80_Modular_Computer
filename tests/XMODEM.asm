;===========================================================
; XMODEM.Z80 - Xmodem File Transfer Protocol
; version 1.1 - Send file option included.
;===========================================================
;===========================================================
; USEFUL ADDRESSES.
;===========================================================
BDOS            EQU     05
FCB             EQU     05CH
FCB2            EQU     06CH
TPA             EQU     0100H           ; Transient Programs Area
BIOS            EQU     0E620h          ; Base of BIOS.

;===========================================================
; BIOS functions.
;===========================================================
LEAP            EQU     3               ; 3 bytes for each entry

BOOT            EQU     BIOS            ;  0 Initialize.
WBOOT           EQU     BIOS+(LEAP*1)   ;  1 Warm boot.
CONST           EQU     BIOS+(LEAP*2)   ;  2 Console status.
CONIN           EQU     BIOS+(LEAP*3)   ;  3 Console input.
CONOUT          EQU     BIOS+(LEAP*4)   ;  4 Console OUTput.
PRINTSEQ        EQU     BIOS+(LEAP*17)  ; not a BIOS function

;===========================================================
; BDOS functions.
;===========================================================
FOPEN           EQU     15
FCLOSE          EQU     16
FDELETE         EQU     19
FREAD           EQU     20
FWRITE          EQU     21
FCREATE         EQU     22
SETDMA          EQU     26

MAXTRY          EQU     10
FCBCR           EQU     FCB+32

;===========================================================
; ASCII characters.
;===========================================================
SOH             EQU     01H
ETX             EQU     03H
EOT             EQU     04H
ACK             EQU     06H
LF              EQU     0AH
CR              EQU     0DH
NAK             EQU     15H
CAN             EQU     18H

;===========================================================
; MAIN PROGRAM STARTS HERE
;===========================================================
                ORG     TPA

XMODEM:         LD      (OLDSTACK),SP
                LD      SP,XMSTACK

                LD      A,(FCB+1)       ; CHECK IF ARGUMENTS ARE OK
                CP      ' '
                JP      Z,NOFILE
                LD      A,(FCB2+1)
                CP      '-'
                JP      NZ,ARGERR
                LD      A,(FCB2+2)
                CP      'R'
                JP      Z,RECOP
                CP      'S'
                JP      Z,SENDOP
ARGERR:         CALL    PRINTSEQ
                DB      CR,LF,"INVALID OR MISSING ARGUMENT",CR,LF,CR,LF,0
HOW2USE:        CALL    PRINTSEQ
                DB      "XMODEM 1.1 - by Kaltchuk, 2021.",CR,LF
                DB      "Use: XMODEM [drive:]file_name -<option>",CR,LF
                DB      "options:    R to receive file",CR,LF
                DB      "            S to send file",CR,LF,CR,LF,0
EXIT:           LD      SP,(OLDSTACK)
                RET

NOFILE:         CALL    PRINTSEQ
                DB      "MISSING FILE NAME",CR,LF,CR,LF,0
                JP      HOW2USE

;===========================================================
; RECEIVE OPERATION STARTS HERE
;===========================================================
RECOP:          CALL    DELETEFILE
                CALL    CREATEFILE
                INC     A
                JP      NZ,FCREATOK
                CALL    PRINTSEQ
                DB      "FILE CREATE ERROR",CR,LF,CR,LF,0
                JR      EXIT

FCREATOK:       LD      A,0
                LD      (RETRY),A       ; Init retry counter
                INC     A
                LD      (BLOCK),A       ; Init block counter
ALIVE:          CALL SENDNAK
GET1ST:         LD      B,5
                CALL TOCONIN            ; 5s timeout
                JR      C,REPEAT        ; Timed out?
                CP      EOT
                JR      Z,GOTEOT        ; EOT? WRAP IT UP
                CP      CAN
                JR      Z,EXIT          ; CAN? EXIT
                CP      SOH
                JR      Z,GOTSOH        ; SOH? GET NEXT BLOCK
                JR      GET1ST

REPEAT:         LD      A,(RETRY)
                INC     A
                LD      (RETRY),A
                CP      MAXTRY
                JR      NZ,ALIVE        ; Try again?
                CALL SENDCAN
                JR      EXIT

GOTEOT:         CALL SENDNAK
                LD      B,1
                CALL TOCONIN
                CALL SENDACK
                CALL    PRINTSEQ
                DB      "FILE RECEIVED",CR,LF,0
                CALL    CLOSEFILE       ; CLOSE THE FILE
                INC     A
                JR      Z,CLOSERR
                JP      EXIT

CLOSERR:        CALL    PRINTSEQ
                DB      "FILE CLOSE ERROR",CR,LF,0
                JP      EXIT

GOTSOH:         LD      B,131
                LD      HL,BUFFER
GETBYTE:        PUSH    BC
                LD      B,1
                CALL TOCONIN            ; Get incoming block number
                JP      C,EXIT          ; Timed out?
                LD      (HL),A          ; STORE BYTE IN BUFFER
                INC     HL
                POP     BC
                DJNZ    GETBYTE
                LD      HL,BUFFER
                LD      A,(HL)          ; PICK RECEIVED BLOCK NUMBER
                LD      B,A
                LD      A,(BLOCK)
                CP      B
                JR      Z,BLKNUMOK
BLKERR:         CALL    SENDNAK
                JP      GET1ST

BLKNUMOK:       LD      B,A
                INC     HL
                LD      A,(HL)          ; PICK RECEIVED /BLOCK NUMBER
                ADD     A,B
                CP      0FFH
                JR      NZ,BLKERR
                XOR     A               ; DO THE CHECKSUM
                LD      HL,BUFFER+2
                LD      B,128
SUMBYTE:        ADD     A,(HL)
                INC     HL
                DJNZ    SUMBYTE
                CP      (HL)
                JR      NZ,BLKERR
                CALL    WRITEFILE
                CP      0
                JR      NZ,FWRERR
                LD      A,0
                LD      (RETRY),A       ; Reset retry counter
                LD      A,(BLOCK)
                INC     A
                LD      (BLOCK),A       ; Increment block counter
                CALL SENDACK
                JP      GET1ST

FWRERR:         CALL    SENDCAN
                CALL    PRINTSEQ
                DB      "FILE WRITE ERROR",CR,LF,0
                JP      EXIT

;===========================================================
; SEND OPERATION STARTS HERE
;===========================================================
SENDOP:         XOR     A
                LD      (BLOCK),A       ; INIT BLOCK COUNTER
                LD      A,SOH
                LD      (BUFFER),A
                CALL    OPENFILE
                CP      0FFH
                JR      Z,FOPENERR
                CP      1
                JR      Z,FOPENEOF
                JR      FOPENOK
FOPENERR:       CALL    PRINTSEQ
                DB      "FILE OPEN ERROR",CR,LF,0
                JP      EXIT
FOPENEOF:       CALL    PRINTSEQ
                DB      "FILE IS EMPTY",CR,LF,0
                JP      EXIT

FOPENOK:        LD      B,60            ; WAIT 1MIN FOR NAK
                CALL    TOCONIN
                JP      C,EXIT          ; TIMEOUT, SO EXIT
                CP      NAK
                JR      Z,CLEAR         ; CLEAR TO CONTINUE
                CP      CAN
                JP      Z,EXIT          ; CANCELED BY RTU
                JR      FOPENOK

CLEAR:          CALL    READFILE
                CP      1
                JR      Z,GOTEOF
                CP      0
                JR      Z,GOTNEWBLK
                CALL    SENDCAN         ; ERROR READING FILE
                JP      EXIT

GOTEOF:         CALL    CLOSEFILE
                CALL    SENDEOT
                LD      B,1
                CALL    TOCONIN
                CALL    SENDEOT
                LD      B,1
                CALL    TOCONIN
                JP      EXIT

GOTNEWBLK:      LD      A,(BLOCK)
                INC     A
                LD      (BUFFER+1),A    ; WRITE BLOCK
                CPL
                LD      (BUFFER+2),A    ; WRITE /BLOCK
                XOR     A               ; CALCULATE CHECKSUM
                LD      B,128
                LD      HL,BUFFER+3
NEXTCS:         ADD     A,(HL)
                INC     HL
                DJNZ    NEXTCS
                LD      (HL),A          ; WRITE CHECKSUM
SENDBLOCK:      LD      B,132
                LD      HL,BUFFER
SENDBYTE:       LD      A,(HL)          ; SEND THE BUFFER
                LD      C,A
                CALL    CONOUT
                INC     HL
                DJNZ    SENDBYTE
GETREPLY:       LD      B,5             ; GET RTU'S REPLY
                CALL    TOCONIN
                JP      C,EXIT          ; NO ANSWER
                CP      NAK
                JR      Z,SENDBLOCK     ; RESEND BLOCK
                CP      ACK
                JR      Z,CLEAR
                JR      GETREPLY

;===========================================================
; Timed Out Console Input - X seconds, with X passed on regB
; Incoming byte, if any, returns in A
; Carry flag set if timed out.
;===========================================================
TOCONIN:        PUSH    BC
                PUSH    HL

                LD      B,5
LOOP0:          LD      HL,685
LOOP1:          LD      C,35
LOOP2:          CALL CONST
                INC     A
                JR      Z,BWAITING
                LD      A,C
                DEC     C
                JR      NZ,LOOP2
                DEC     HL
                LD      A,H
                OR      L
                JR      NZ,LOOP1
                DJNZ    LOOP0
                SCF
                JR      TOUT
BWAITING:       CALL CONIN
                SCF                     ; Reset carry flag
                CCF
TOUT:           POP     HL
                POP     BC
                RET

;===========================================================
; DELETE FILE. RETURNS 0FFH IF ERROR
;===========================================================
DELETEFILE:     LD      DE,FCB
                LD      C,FDELETE
                CALL    BDOS
                RET

;===========================================================
; CREATE FILE. RETURNS 0FFH IF ERROR
;===========================================================
CREATEFILE:     LD      DE,FCB
                LD      A,0             ; START AT BLOCK 0
                LD      (FCBCR),A
                LD      C,FCREATE
                CALL    BDOS
                RET

;===========================================================
; OPEN FILE. RETURNS 0FFH IF ERROR
;===========================================================
OPENFILE:       LD      DE,FCB
                LD      A,0             ; START AT BLOCK 0
                LD      (FCBCR),A
                LD      C,FOPEN
                CALL    BDOS
                RET

;===========================================================
; CLOSE FILE. RETURNS 0FFH IF ERROR
;===========================================================
CLOSEFILE:      LD      DE,FCB
                LD      C,FCLOSE
                CALL    BDOS
                RET

;===========================================================
; READ FILE. RETURNS 0 IF OK, 1 IF END OF FILE
;===========================================================
READFILE:       LD      DE,BUFFER+3
                LD      C,SETDMA
                CALL    BDOS
                LD      DE,FCB
                LD      C,FREAD
                CALL    BDOS
                RET

;===========================================================
; WRITE FILE. RETURNS 0 IF OK
;===========================================================
WRITEFILE:      LD      DE,BUFFER+2
                LD      C,SETDMA
                CALL    BDOS
                LD      DE,FCB
                LD      C,FWRITE
                CALL    BDOS
                RET

;===========================================================
; SEND ACK
;===========================================================
SENDACK:        LD C,ACK
                CALL CONOUT
                RET

;===========================================================
; SEND NAK
;===========================================================
SENDNAK:        LD C,NAK
                CALL CONOUT
                RET

;===========================================================
; SEND SOH
;===========================================================
SENDSOH:        LD C,SOH
                CALL CONOUT
                RET

;===========================================================
; SEND EOT
;===========================================================
SENDEOT:        LD C,EOT
                CALL CONOUT
                RET

;===========================================================
; SEND CAN
;===========================================================
SENDCAN:        LD C,CAN
                CALL CONOUT
                RET

;===========================================================
;===========================================================
RETRY           DB      0               ; Retry counter
BLOCK           DB      0               ; Block counter
BUFFER:         DS      132             ; BUFFER TO STORE BLOCK
                                        ; <BLK> </BLK> 128 X <BYTE> <CHKSUM>
OLDSTACK:       DS      2
STACK:          DS      256
XMSTACK         EQU $

                END

