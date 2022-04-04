'TESTSQW.BAS
'Instruct RTC to generate 32kHz square wave.

$crystal = 24000000

Config Scl = P3.5
Config Sda = P3.4
CONFIG I2CDELAY = 0

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

'set 32kHz square wave
I2cstart
I2cwbyte Rtcwr
I2cwbyte Cword
I2cwbyte &H13
I2cstop

Wait 3

Wend