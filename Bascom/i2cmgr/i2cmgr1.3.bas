'I2CMGR.BAS
'I2C Manager - Receive commands from CPU and translate to I2C commands to slaves.
'
'version 1.1 - no more command address on I2C card.
'version 1.2 - several bugs fixed.
'version 1.3 - change communication protocol.
'
'Protocol:	CPU request		On the Z80				Condition test
			------------	---------------------	-----------------------
'			stop_cmd		OUT	(I2C_CMD),0			WR=0 AND A00=0 AND P1=0
'			start_cmd		OUT	(I2C_CMD),1			WR=0 AND A00=0 AND P1=1
'			write <byte>	OUT	(I2C_DATA),<byte>	WR=0 AND A00=1
'			read+ack		IN	A,(I2C_ACK)			WR=1 AND A00=0
'			read+nak		IN	A,(I2C_NAK)			WR=1 AND A00=1
'
'			All test conditions when INT0 triggered.

$crystal = 24000000

Config Scl = P3.5
Config Sda = P3.4

Dim Bus As Byte

Unwait Alias P3.0
Wr Alias P3.1
A00 Alias P3.7

'RTC_addr = 0x86
'Const Rtcwr = &HD0
'Const Rtcrd = &HD1
'Const Cword = &H07

Const Ack = 8
Const Nack = 9

Const Cmd_stop = 0
Const Cmd_start = 1
Const Cmd_write = 2
Const Cmd_readack = 3
Const Cmd_readnak = 4

enable interrupts
enable int0
on int0 cpucalling

I2cstop
Gosub Release_wait
Wait 1

'*** Main program starts here
While 1 = 1
   Gosub Wait_cs_wr

   select case bus
   case Cmd_start:
      I2cstart
      Gosub Release_wait
   
   case Cmd_stop:
      I2cstop
      Gosub Release_wait
   
   case Cmd_write:
      Gosub Release_wait
      Gosub Wait_cs_wr
      I2cwbyte Bus
      Gosub Release_wait

   case Cmd_readack:
      I2crbyte Bus , Ack
      Gosub Release_wait
      Gosub Wait_cs_rd
      Gosub Release_wait

   case Cmd_readnak:
      I2crbyte Bus , Nack
      Gosub Release_wait
      Gosub Wait_cs_rd
      Gosub Release_wait
   End select

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
Return


'*** Wait for CS + rd
Wait_cs_rd:
   While 1 = 1
      If Cs = 1 And Rd = 0 Then
         P1 = Bus
         Exit While
      End If
   Wend
Return