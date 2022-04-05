'I2CMGR1.BAS
'I2C Manager - Receive commands from CPU and translate to I2C commands to slaves.
'version 1.1 - no more command addres on I2C card
'Commands:  00 I2C start
'           01 I2C stop
'           02 I2C write
'           03 I2C read+ACK
'           04 I2C read+NAK

$crystal = 24000000

Config Scl = P3.5
Config Sda = P3.4

Dim Bus As Byte

Unwait Alias P3.0
Cs Alias P3.1
Rd Alias P3.2
Wr Alias P3.3
A00 Alias P3.7

'RTC_addr = 0x86
Const Rtcwr = &HD0
Const Rtcrd = &HD1
Const Cword = &H07

Const Ack = 8
Const Nack = 9

Const I2c_stop_cmd = 0
Const I2c_start_cmd = 1
Const I2c_write_cmd = 2
Const I2c_readack_cmd = 3
Const I2c_readnak_cmd = 4

I2cstop
Gosub Release_wait

'*** Main program starts here
Wait 1

While 1 = 1
   Gosub Wait_cs_wr

   If Bus = I2c_start_cmd Then
      I2cstart
   End If

   If Bus = I2c_stop_cmd Then
      I2cstop
   End If

   If Bus = I2c_write_cmd Then
      Gosub Release_wait
      Gosub Wait_cs_wr
      I2cwbyte Bus
      Gosub Release_wait
   End If

   If Bus = I2c_readack_cmd Then
      I2crbyte Bus , Ack
      Gosub Release_wait
      Gosub Wait_cs_rd
      Gosub Release_wait
   End If

   If Bus = I2c_readnak_cmd Then
      I2crbyte Bus , Nack
      Gosub Release_wait
      Gosub Wait_cs_rd
      Gosub Release_wait
   End If

Wend



'*** Subroutines here

'*** Release CPU wait signal
Release_wait:
   Reset Unwait
   Set Unwait
Return

' *** Wait for CS + wr
Wait_cs_wr:
   While 1 = 1
      If Cs = 1 And Wr = 0 Then
         Bus = P1
         Exit While
      End If
   Wend
Return


' *** Wait for CS + rd
Wait_cs_rd:
   While 1 = 1
      If Cs = 1 And Rd = 0 Then
         P1 = Bus
         Exit While
      End If
   Wend
Return
