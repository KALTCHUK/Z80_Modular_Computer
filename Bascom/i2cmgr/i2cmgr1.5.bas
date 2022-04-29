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
Dim Command As Byte                                           'Current command being executed
Dim Astep As Byte                                             'Step be executed
Dim Buf(19) As Byte                                           'Read/write buffer
Dim Port As Byte                                              'Port=P1 or P1=Port, for read and write, respectively
Dim Addr_size As Byte                                         'Size of address (1 or 2)
Dim Num_bytes As Byte                                         'Number of bytes to be written or read
Dim I As Byte                                                 'Used for Buf index
Dim J As Byte                                                 'General use variable

'*** Main program starts here
I2cstop

Enable Interrupts
Enable Int0
Set Tcon.0
On Int0 Chip_selected

Gosub Release_wait

While 1 = 1
   Idle
Wend

'*** Subroutines here

'*** Chip selected via INT0
Chip_selected:
   If A00 = 1 Then                                            'It's a command select operation
      Command = P1
      Astep = 0
      I = 1
   Else
      Select Case Astep
         Case 0:                                              'Get slave
            Buf(i) = P1 * 2
            If Command = Cmd_read Then
               Astep = 3
            End If
            Incr I
         Case 1:                                              'Get address size (1 or 2)
            Addr_size = P1
         Case 2:                                              'Get address high (or low if addr_size = 1)
            Buf(i) = P1
            Incr I
            If Addr_size = 1 Then
               Incr Astep
            End If
         Case 3:                                              'Get address low if addr_size = 2
            Buf(i) = P1
            Incr I
         Case 4:                                              'Get number of bytes to read or write
            Num_bytes = P1
            J = 1
            If Command <> Cmd_write Then                      'Read bytes from slave
               If Command = Cmd_read_rand Then
                  I2cstart
                  I2cwbyte Buf(1)
                  I2cwbyte Buf(2)
                  If Addr_size = 2 Then
                     I2cwbyte Buf(3)
                  End If
               End If
               Incr Buf(1)
               I2cstart
               I2cwbyte Buf(1)
               For I = 1 To Num_bytes
                  If I = Num_bytes Then
                     I2crbyte Buf(i) , Nack
                  Else
                     I2crbyte Buf(i) , Ack
                  End If
               Next
               I2cstop
               Incr Astep
               I = 1
            End If
         Case 5:                                              'Get byte to be written
            Buf(i) = P1
            Incr J
            Incr I
            If J > Num_bytes Then
               J = Num_bytes + 3
               If Addr_size = 1 Then
                  Decr J
               End If
               I2cstart
               For I = 1 To J
                  I2cwbyte Buf(i)
               Next
               I2cstop
               I = 1
            End If
            Decr Astep
         Case 6:                                              'Send bytes to Z80
            If I <= Num_bytes Then
               P1 = Buf(i)
               Incr I
               Decr Astep
            End If
      End Select
      Incr Astep
   End If
   Gosub Release_wait
Return


'*** Release CPU wait signal
Release_wait:
   Reset Unwait
   Set Unwait
Return

