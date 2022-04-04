'RDTIME.BAS
'Disable clock halt and read the first 3 bytes (sec, min, hour) every 2 seconds.

$crystal = 24000000

Config Scl = P3.5
Config Sda = P3.4

Dim A As Byte

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

I2cstop
Set Unwait
'**********
'********** Main program starts here
'**********
'disable clock halt
I2cstart
I2cwbyte Rtcwr
I2cwbyte 0
I2cwbyte 0
I2cstop

Wait 1

'**********
'********** Loop ad eternum
'**********
While 1 = 1
'Read time
I2cstart
I2cwbyte Rtcwr
I2cwbyte 0
I2cstart                                                      'restart signal.
I2cwbyte Rtcrd
I2crbyte A , Ack                                              'get seconds
I2crbyte A , Ack                                              'get minutes
I2crbyte A , Nack                                             'get hours
I2cstop

Wait 2

Wend