# This program opens an ASCII file and transmits it through a COM port to the Z80 MC.

import serial

# Which COM port?
print('\r\n')    

com_port = input("COM port? ")
Z80_port = serial.Serial(port = "COM" + str(com_port), baudrate = 9600)

file_name = input("File name? ")
f = open(file_name,"rb")

print('\r\n' + "Transmitting..." + '\r\n')    
    
Z80_port.write(f.read()+b'\r\n')

print("Transmission complete.")

f.close()
