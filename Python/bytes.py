#************************************************************************************************
# This program sends a file to CP/M. Run "send.py -h" to see options.
# REVEIVE.COM must be present in the active drive of CP/M.
#************************************************************************************************
import sys
import serial
import time

STX	= 0x02
ETX	= 0x03
EOT	= 0x04
ACK	= 0x06
LF	= 0x0A
CR	= 0x0D
NAK	= 0x15
EM  = 0x19

Z80_port = serial.Serial(port = "COM20", baudrate = 9600, timeout = 1)

Z80_port.write(STX.to_bytes(1, 'big'))
Z80_port.write(ETX.to_bytes(1, 'big'))
Z80_port.write(EOT.to_bytes(1, 'big'))
Z80_port.write(ACK.to_bytes(1, 'big'))
Z80_port.write(LF.to_bytes(1, 'big'))
Z80_port.write(CR.to_bytes(1, 'big'))
Z80_port.write(NAK.to_bytes(1, 'big'))
Z80_port.write(EM.to_bytes(1, 'big'))

Z80_port.write(STX)
Z80_port.write(ETX)
Z80_port.write(EOT)
Z80_port.write(ACK)
Z80_port.write(LF)
Z80_port.write(CR)
Z80_port.write(NAK)
Z80_port.write(EM)


print('\r\n')
Z80_port.close()
    
exit()
