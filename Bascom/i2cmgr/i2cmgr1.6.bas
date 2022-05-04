'I2CMGR.BAS
'I2C Manager - Receive commands from CPU and translate to I2C commands to slaves.
'
'version 1.1 - no more command address on I2C card.
'version 1.2 - several bugs fixed.
'version 1.3 - change communication protocol.
'version 1.4 - change communication protocol.
'version 1.5 - use INT0 for chip select.
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
Const Cmd_sync = 0
Const Cmd_write = 1
Const Cmd_read = 2
Const Cmd_read_rand = 3
Const Ack = 8
Const Nack = 9

'Variables dimensioning
Dim Command As Byte
Dim Slave As Byte                                             'Current command being executed
Dim Buf(16) As Byte                                           'Read/write buffer
Dim Char As Byte                                              'Char=P1 or P1=Char, for read and write, respectively
Dim Addr_size As Byte                                         'Size of address (1 or 2)
Dim Addr_hi As Byte
Dim Addr_lo As Byte
Dim Num_bytes As Byte                                         'Number of bytes to be written or read
Dim I As Byte                                                 'Used for Buf index

'*** Main program starts here
I2cstop
Gosub Release_wait

Beginning:
 Command = Cmd_sync
 Gosub Get_char
 If Command = Cmd_sync Then Goto Beginning

 Gosub Get_char
 Slave = Char * 2

 If Command = Cmd_read Then Goto Get_num_bytes

 Gosub Get_char
 Addr_size = Char
 If Addr_size = 2 Then
  Gosub Get_char
  Addr_hi = Char
 End If

 Gosub Get_char
 Addr_lo = Char

Get_num_bytes:
 Gosub Get_char
 Num_bytes = Char

 If Command = Cmd_read_rand Then
  Goto Read_random
 Elseif Command = Cmd_read Then
  Goto Read_simple
 End If

 For I = 1 To Num_bytes
  Gosub Get_char
  Buf(i) = Char
 Next

Read_random:
 I2cstart
 I2cwbyte Slave
 If Addr_size = 2 Then I2cwbyte Addr_hi
 I2cwbyte Addr_lo

 If Command = Cmd_read_rand Then Goto Read_simple

 For I = 1 To Num_bytes
  I2cwbyte Buf(i)
 Next
 I2cstop

 Goto Beginning

Read_simple:
 Incr Slave
 Decr Num_bytes
 I2cstart
 I2cwbyte Slave
 For I = 1 To Num_bytes
  I2crbyte Buf(i) , Ack
 Next
 I2crbyte Buf(i) , Nack
 I2cstop

 Incr Num_bytes
 For I = 1 To Num_bytes
  Char = Buf(i)
  Gosub Put_char
 Next

 Goto Beginning


'*** Subroutines here

'*** Release CPU wait signal
Release_wait:
   Reset Unwait
   Set Unwait
Return

'*** Get char from P1
Get_char:
 While Cs = 1
 Wend

 If A00 = 1 Then Command = P1 Else Char = P1

 Gosub Release_wait
Return

'*** Put char on P1
Put_char:
 While Cs = 1
 Wend

 If Wr = 1 Then P1 = Char

 Gosub Release_wait
Return