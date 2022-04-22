'I2CMGR.BAS
'I2C Manager - Receive commands from CPU and translate to I2C commands to slaves.
'
'version 1.1 - no more command address on I2C card.
'version 1.2 - several bugs fixed.
'version 1.3 - change communication protocol.
'version 1.4 - change communication protocol.
'
'Protocol:
'
'WRITE
'  <wr><slave><size_addr>[<addr_hi>]<addr_lo><num_bytes><b1>...<bn> ==>
'
'READ
'  <rd><slave><num_bytes> ==>
'                         <==   <b1>...<bn>
'
'READ RANDOM
'  <rr><slave><size_addr>[<addr_hi>]<addr_lo><num_bytes> ==>
'                                                        <==   <b1>...<bn>
'
'<wr> = 1
'<rd> = 2
'<rr> = 3
'
'<slave> = slave's address
'<size_addr> = 1 or 2, number of bytes for address. If 2, <addrr_hi> must be submmited,
'              otherwiths, only <addr_lo>.
'<num_bytes> = number of bytes to be written or read (min 1 and max 16).
'

$crystal = 24000000

'Configure I2C pins
Config Scl = P3.5
Config Sda = P3.4

'Some nicknames
Unwait Alias P3.0
Wr Alias P3.1
Cs Alias P3.2
A00 Alias P3.7

'Some constants
Const Cmd_write = 1
Const Cmd_read = 2
Const Cmd_read_rand = 3
Const Ack = 8
Const Nack = 9

'Variables dimensioning
Dim Buf(19) As Byte
Dim Port As Byte
Dim Addr_size As Byte
Dim Num_bytes As Byte
Dim I As Byte                                                 'Used for Buf index
Dim J As Byte                                                 'General use variable

'*** Main program starts here
I2cstop

While 1 = 1
   If Cs = 0 Then
      Select Case P1
         Case 1:
            Gosub Write_op
         Case 2:
            Gosub Read_op
         Case 3:
            Gosub Read_rand_op
      End Select
   End If
Wend

'*** Subroutines here
'*** Release CPU wait signal
Release_wait:
   Reset Unwait
   Set Unwait
Return

'Wait for CS and get byte on P1
Wait_for_p1:
   While Cs = 1
   Wend
   Port = P1
   Gosub Release_wait
Return

'Wait for CS and put byte on P1
Send_via_p1:
   While Cs = 1
   Wend
   If Wr = 0 Then P1 = Port
   Gosub Release_wait
Return

'*** Write operation
Write_op:
   I = 1
   Gosub Release_wait
   Gosub Wait_for_p1                                          'Get slave address
   Buf(i) = Port * 2
   Incr I
   Gosub Wait_for_p1                                          'Get address size (1 or 2)
   Addr_size = Port
   Gosub Wait_for_p1                                          'Get address byte (or high address byte if address size = 2)
   Buf(i) = Port
   Incr I
      If Addr_size = 2 Then
         Gosub Wait_for_p1                                    'Get address byte low if address size = 2
         Buf(i) = Port
         Incr I
      End If
   Gosub Wait_for_p1                                          'Get number of bytes to write
   Num_bytes = Port
   For J = 1 To Num_bytes                                     'Get bytes from CPU
      Gosub Wait_for_p1
      Buf(i) = Port
      Incr I
   Next
   Decr I
   I2cstart                                                   'Start I2C write
   For J = 1 To I
      I2cwbyte Buf(j)
   Next
   I2cstop
Return

'*** Read operation
Read_op:
   I = 1
   Gosub Release_wait
   Gosub Wait_for_p1                                          'Get slave address
   Buf(i) = Port * 2
   Incr Buf(i)
   Gosub Wait_for_p1                                          'Get number of bytes to write
   Num_bytes = Port
   I2cstart                                                   'Start I2C read
   I2cwbyte Buf(1)
   If Num_bytes > 1 Then
      Decr Num_bytes
      For I = 1 To Num_bytes
         I2crbyte Buf(i) , Ack
      Next
   End If
   I2crbyte Buf(i) , Nack
   I2cstop
   For J = 1 To I                                             'Send bytes to CPU
      Port = Buf(j)
      Gosub Send_via_p1
   Next
Return

'*** Read random operation
Read_rand_op:
   I = 1
   Gosub Release_wait
   Gosub Wait_for_p1                                          'Get slave address
   Buf(i) = Port * 2
   Incr I
   Gosub Wait_for_p1                                          'Get address size (1 or 2)
   Addr_size = Port
   Gosub Wait_for_p1                                          'Get address byte (or high address byte if address size = 2)
   Buf(i) = Port
   Incr I
      If Addr_size = 2 Then
         Gosub Wait_for_p1                                    'Get address byte low if address size = 2
         Buf(i) = Port
         Incr I
      End If
   Gosub Wait_for_p1                                          'Get number of bytes to read
   Num_bytes = Port
   Decr I
   I2cstart
   For J = 1 To I                                             'Set slave's address pointer
      I2cwbyte Buf(j)
   Next
   Incr Buf(1)
   I2cstart                                                   'Start I2C read
   I2cwbyte Buf(1)
   If Num_bytes > 1 Then
      Decr Num_bytes
      For I = 1 To Num_bytes
         I2crbyte Buf(i) , Ack
      Next
   End If
   I2crbyte Buf(i) , Nack
   I2cstop
   For J = 1 To I                                             'Send bytes to CPU
      Port = Buf(j)
      Gosub Send_via_p1
   Next
Return

