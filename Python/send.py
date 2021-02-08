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
listFCB = list("            ") 
CheckSum = 0
dot = -1
all_drives = "ABCDEFGHIJKLMNOP"

while True:
    drive = input("Target drive in CP/M (A through P)?").upper()
    if drive[0] in all_drives:
        break
listFCB[0] = drive[0]

# Which file?
while True:
    file_name = input("File name? ").upper()
    if len(file_name) >= 1:
        break

i = 1
while i < 9:
    if (len(file_name) >= i) and (file_name[i-1] !='.'):
        listFCB[i] = file_name[i-1]
        i+=1
    else:
        if file_name[i-1] =='.':
            dot = i
        for i in range(i, 9):
            listFCB[i] = " "
            i+=1

while i < 12:
    if (dot != -1) and (len(file_name) >= (dot + i - 8)):
        listFCB[i] = file_name[dot + i - 9]
    else:
        listFCB[i] = " "
    i+=1

print("".join(listFCB) + "<")
e = input("continue?")




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
