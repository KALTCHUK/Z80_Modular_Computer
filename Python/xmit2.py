# This program opens a file and transmits it through a COM port to the Z80 MC.
# It may be a binary or ASCII file.

import serial

print('\r\n')    

# Which COM port?
#com_port = input("COM port number? ")
com_port = 16
Z80_port = serial.Serial(port = "COM" + str(com_port), baudrate = 9600)

# Which file?
#file_name = input("File name? ")
file_name = "Mbasic.com"
with open(file_name,"rb") as f:

    # Which type of file?
    file_type = input("Which type of file, Binary or ASCII (B/A)? ")
    print('\r\n' + "Transmitting..." + '\r\n')
    byte_counter = 0    

    if file_type == 'a' or file_type == 'A':
        while True:
            br = f.read(1)
            if br == b'':
                byte_counter /= 2
                break
            byte_counter += 1
            Z80_port.write(br)
    else:
        while byte_counter < 5:
            br = f.read(1)

#            if br == b'':
#                break

            byte_counter += 1
            nbr = int(br)
            nbr += 1
            print(br + nbr)
            
    # End the transmission with CR+LF
    Z80_port.write(b'\r\n')

    # Calculate number of pages to be used with SAVE command        
    pages = byte_counter / 0x100
    if byte_counter % 0x100 > 0:
        pages += 1

    print("Transmission complete." + '\r\n')
    print("Use: SAVE " + str(int(pages)))
    print('\r\n')    
