'RDTIME.BAS
'Disable clock halt and read the first 3 bytes (sec, min, hour) every 2 seconds.

$crystal = 12000000

Config Scl = P3.5
Config Sda = P3.4

dim a as byte

Unwait Alias P3.0
Cs Alias P3.1
Rd Alias P3.2
Wr Alias P3.3
A00 Alias P3.7

'RTC_addr = 0x86
Const Rtcwr = &HD0
Const Rtcrd = &HD1
Const Cword = &H07

I2cstop
Set Unwait

'disable clock halt
I2cstart
I2cwbyte Rtcwr
I2cwbyte 0
I2cwbyte 0
I2cstop

Wait 1

While 1 = 1

'Read time
I2cstart
I2cwbyte Rtcwr
I2cwbyte 0
I2cstart
I2cwbyte Rtcrd
I2crbyte a, ack
I2crbyte a, ack
I2crbyte a, nack
I2cstop

Wait 2

Wend