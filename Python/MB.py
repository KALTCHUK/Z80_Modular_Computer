import sys
import string
import serial

off_string = [0x07, 0x0f, 0x00, 0x00, 0x00, 0x08, 0x01, 0x00, 0x7e, 0xbf]
on_string  = [0x07, 0x0f, 0x00, 0x00, 0x00, 0x08, 0x01, 0xff, 0x3e, 0xff]

def ShowUse():
    print("MB v1.0 - test Modbus over RS485")
    print("Commands:")
    print("   0 (zero)      turn off all outputs;")
    print("   1 (one)       turn on all output;")
    print("   ?             show this menu;")
    print("   Q             quit program.\n")

ShowUse()
serialPort = serial.Serial(port = "COM11", baudrate=9600, bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)

while True:
    command = input("#")
    
    if command[0] == "0":
        print("turn off\n")
        serialPort.write(off_string)
            
    if command[0] == "1":
        print("turn on\n")
        serialPort.write(on_string)

    if command[0] == "?":
        ShowUse()

    if command[0] == "q" or command[0] == "Q":
        serialPort.close()
        break
        