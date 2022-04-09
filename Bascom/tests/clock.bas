'CLOCK.0000002041 æ}{;      C////C////C/C/C/C//   BAS
'Read time and set time according to CPU request
'
'version 1.1 - no more command address on I2C card.
'version 1.2 - several bugs fixed.
'
'Commands:  00 Set time, receive second, minute, hour from CPU.
'           01 Get time, sends second, minute, hour to CPU.
'           02 Set date, receive day, date, month, year from CPU
'           03 Get date, send day, date, month, year to CPU
'           04 Set control word
'           05 Get control word
'

$crystal = 24000000

Config Scl = P3.5
Config Sda = P3.4

Dim Bus As Byte
Dim A0 As Byte
Dim A1 As Byte
Dim A2 As Byte
Dim A3 As Byte
Dim I As Byte

Unwait Alias P3.0
Cs Alias P3.1
Rd Alias P3.2
Wr Alias P3.3

Const Rtcwr = &HD0
Const Rtcrd = &HD1
Const Cword = &H07

Const Ack = 8
Const Nack = 9

Const Cmd_set_time = 0
Const Cmd_get_time = 1
Const Cmd_set_date = 2
Const Cmd_get_date = 3

I2cstop
Gosub Release_wait
'Wait 1

'*** Main program starts here
While 1 = 1
   Gosub Wait_cs_wr

   Select Case Bus
   Case Cmd_set_time:
      Gosub Wait_cs_wr                                        'receive hour
      A0 = Bus
      Gosub Wait_cs_wr                                        'receive minute
      A1 = Bus
      Gosub Wait_cs_wr                                        'receive second
      A2 = Bus
      I2cstart
      I2cwbyte Rtcwr
      I2cwbyte 0
      I2cstart                                                'restart signal.
      I2cwbyte Rtcwr
      I2cwbyte A2                                             'write seconds
      I2cwbyte A1                                             'write minutes
      I2cwbyte A0                                             'write hours
      I2cstop
      Bus = &HFF
   Case Cmd_get_time:
      I2cstart
      I2cwbyte Rtcwr
      I2cwbyte 0
      I2cstart                                                'restart signal.
      I2cwbyte Rtcrd
      I2crbyte A0 , Ack                                       'read seconds
      I2crbyte A1 , Ack                                       'read minutes
      I2crbyte A2 , Nack                                      'read hours
      I2cstop
      Bus = A2
      Gosub Wait_cs_rd                                        'send hour
      Bus = A1
      Gosub Wait_cs_rd                                        'send minute
      Bus = A0
      Gosub Wait_cs_rd                                        'send second
      Bus = &HFF
   Case Cmd_set_date:

   Case Cmd_get_date:

   End Select

Wend

'*** Subroutines here

'*** Release CPU wait signal
Release_wait:
   Reset Unwait
   Set Unwait
Return

'*** Wait for CS + wr
Wait_cs_wr:
   While 1 = 1
      If Cs = 1 And Wr = 0 Then
         Bus = P1
         Exit While
      End If
   Wend
   Gosub Release_wait
Return


'*** Wait for CS + rd
Wait_cs_rd:
   While 1 = 1
      If Cs = 1 And Rd = 0 Then
         P1 = Bus
         Exit While
      End If
   Wend
   Gosub Release_wait
Return