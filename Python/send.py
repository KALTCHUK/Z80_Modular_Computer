#************************************************************************************************
# This program sends 1 or more files to CP/M.
#************************************************************************************************

import serial

print('\r\n')    

# Which COM port?
#com_port = input("COM port number? ")
com_port = 16
Z80_port = serial.Serial(port = "COM" + str(com_port), baudrate = 9600)

# Which drive?
drive = input("Target drive (A through P)?")
CheckSum = 0

# Which file?
file_name = ""
while len(file_name) < 1:
    file_name = input("File name? ")

i = 1
while True:
    if len(file) >= i:
        




with open(file_name,"rb") as f:
    
    while True:
        br = f.read(1)
        if br == b'':
            break
        byte_counter += 1
        nbr = int.from_bytes(br, "big")
        CheckSum += nbr
        
        msn = nbr // 16
        if msn < 0xa:
            msn += 0x30
        else:
            msn += 0x37
                
        lsn = nbr % 16
        if lsn < 0xa:
            lsn += 0x30
        else:
            lsn += 0x37
                
        Z80_port.write(msn.to_bytes(1, 'big'))
        Z80_port.write(lsn.to_bytes(1, 'big'))
            
    # End the transmission with CR+LF
    Z80_port.write(b'\r\n')

    # Calculate number of pages to be used with SAVE command        
    pages = byte_counter / 0x100
    if byte_counter % 0x100 > 0:
        pages += 1

    print("Transmission complete." + '\r\n')
    print("Use: SAVE " + str(int(pages)))
    print('\r\n')    
