'TESTCS.BAS
'Test if chip select is working

$crystal = 24000000

Config Scl = P3.5
Config Sda = P3.4
I2cstop

Dim C As Byte

Unwait Alias P3.0
Cs Alias P3.1
Rd Alias P3.2
Wr Alias P3.3
A00 Alias P3.7

Set Unwait
C = 0

While 1 = 1
   If Cs = 1 Then                                             'if chip selected, put c on databus
      P1 = C                                                  'and release wait signal
      C = C + 1
      Reset Unwait
      Set Unwait
   End If
Wend