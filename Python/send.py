#************************************************************************************************
# This program sends 1 or more files to CP/M.
#************************************************************************************************
STX = 0x2
EOT	= 0x4
ACK	= 0x6
LF	= 0xA
CR	= 0xD
NAK	= 0x15
import serial

print('\r\n')    

# Which COM port?
com_port = input("COM port number? ")
#com_port = 16
Z80_port = serial.Serial(port = "COM" + str(com_port), baudrate = 9600)

listFCB = list("            ") 
CheckSum = 0
all_drives = "ABCDEFGHIJKLMNOP"

# Which drive?
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

# Transform drive + file_name into FCB
dot = file_name.find(".")
i = 1
if dot == -1:                               # name has no extension
    while i < 9:
        if (len(file_name) >= i):
            listFCB[i] = file_name[i-1]
        else:
            for i in range(i, 8):
                listFCB[i] = " "
        i+=1
    while i < 12:
        listFCB[i] = " "
        i+=1
else:                                       # name has extension
    while i < 9:
        if i <= dot:
            listFCB[i] = file_name[i-1]
        else:
            listFCB[i] = " "
        i+=1
    while i < 12:
        if len(file_name) >= (dot+i-7):
            listFCB[i] = file_name[dot+i-8]
        else:
            listFCB[i] = " "
        i+=1

# Start RECEIVE.COM on CP/M
Z80_port.write(b'RECEIVE')
Z80_port.write(b'\r\n')
print('Waiting for ACK...')
# Wait for <ACK>
while Z80_port.read(1) != ACK:
    a=1

# Send FCB

# Wait for <ACK>

# Open file and star sending it, in chunks of 256 charcters (1 CP/M disk block)
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
