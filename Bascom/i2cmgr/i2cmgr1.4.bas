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

$crystal = 24000000

'Configure I2C pins
Config Scl = P3.5
Config Sda = P3.4

Dim Bus As Byte

Unwait Alias P3.0
Wr Alias P3.1
Cs Alias P3.2
A00 Alias P3.7

Const Cmd_write = 1
Const Cmd_read = 2
Const Cmd_read_rand = 3
Const Ack = 8
Const Nack = 9

'*** Main program starts here
I2cstop

While 1 = 1

Wend

'*** Subroutines here
'*** Release CPU wait signal
Release_wait:
   Reset Unwait
   Set Unwait
Return

