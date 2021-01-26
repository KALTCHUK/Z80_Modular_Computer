# This program opens an ASCII file and transmits it through a COM port to the Z80 MC.

import serial

print('\r\n')    
file_name = input("Bin file name? ")
f = open(file_name,"r")
g = open("T.ASC", "w")    

g.write(f.read())

f.close()
