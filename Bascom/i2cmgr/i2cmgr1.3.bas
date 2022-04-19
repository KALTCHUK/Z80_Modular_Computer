'I2CMGR.BAS
'I2C Manager - Receive commands from CPU and translate to I2C commands to slaves.
'
'version 1.1 - no more command address on I2C card.
'version 1.2 - several bugs fixed.
'version 1.3 - change communication protocol.
'
'Protocol:  CPU request    On the Z80              Condition test
'
'           stop_cmd       OUT (I2C_CMD),0         WR=0 AND A00=0 AND P1=0
'           start_cmd      OUT (I2C_CMD),1         WR=0 AND A00=0 AND P1=1
'           write <byte>   OUT (I2C_DATA),<byte>   WR=0 AND A00=1
'           read+ack       IN A,(I2C_ACK)          WR=1 AND A00=0
'           read+nak       IN A,(I2C_NAK)          WR=1 AND A00=1
'
'           All test conditions when INT0 triggered.

$crystal = 24000000

'Configure I2C pins
Config Scl = P3.5
Config Sda = P3.4

Dim Bus As Byte

Unwait Alias P3.0
Wr Alias P3.1
Cs Alias P3.2
A00 Alias P3.7

Const Cmd_stop = 0
Const Cmd_start = 1
Const Ack = 8
Const Nack = 9

'*** Main program starts here
I2cstop
Gosub Release_wait
Wait 1

Enable Interrupts
Enable Int0
On Int0 Cpu_call

While 1 = 1
'Do nothing, just wait for a CPU call.
Wend

'*** Subroutines here
'*** Release CPU wait signal
Release_wait:
   Reset Unwait
   Set Unwait
Return

'*** INT0 --> CPU calling
Cpu_call:
If Wr = 1 Then
 If A00 = 1 Then
  I2crbyte Bus , Nak                                          'read+nak
  P1 = Bus
 Else
  I2crbyte Bus , Ack                                          'read+ack
  P1 = Bus
 End If
Else
 If A00 = 1 Then
  Bus = P1                                                    'write
  I2cwbyte Bus
 Else
  Select Case Bus
     Case Cmd_stop:                                           'stop
     I2cstop
  Case Cmd_start:                                             'start
     I2cstart
  End Select
 End If
End If
Gosub Release_wait
Return