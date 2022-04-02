'TESTI2C.BAS
'Receive commands from CPU and convert to I2C

$crystal = 24000000

Config Scl = P3.5
Config Sda = P3.4
I2cstop

Unwait Alias P3.0
Cs Alias P3.1
Rd Alias P3.2
Wr Alias P3.3
A00 Alias P3.7

Const Rtcwr = &HD0
Const Rtcrd = &HD1
Const Control = &H07

Set Unwait

While 1 = 1

'set 32kHx square wave
I2cstart
I2cwbyte Rtcwr
I2cwbyte Control
I2cwbyte &H13
I2cstop

wait 1

Wend
