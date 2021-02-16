#************************************************************************************************
# This program sends a file to CP/M. Run "send.py -h" to see options.
# REVEIVE.COM must be present in the active drive of CP/M.
#************************************************************************************************
EOT	= 0x23      #0x04
ACK	= 0x24      #0x06
LF	= 0x0A
CR	= 0x0D
NAK	= 0x25      #0x15
EM  = 0x26      #0x19

import sys
import serial

opts = [opt for opt in sys.argv[1:] if opt.startswith("-")]

valid_drives = "ABCDEFGHIJKLMNOP"
listFCB = list("            ") 


if "-h" in opts:
    print('Use: send.py -p<port> -d<drive> -f<file>' + '\n\r')
    print('Where <port>  is the number of the serial COM port')
    print('      <drive> is the target CP/M drive (A, B, C ... P)')
    print('      <file>  is the name of the file to be transmmited')
    print('              (must be in the same directory with send.py)' + '\n\r')
    exit()

for i in range(0, len(opts)):
    #print(opts[i])
    if opts[i].startswith("-p"):
        port = opts[i][2:]
        try:
            Z80_port = serial.Serial(port = "COM" + port, baudrate = 9600, timeout = 1)
            #Z80_port.flushInput()
            print('Serial port : COM' + port)
            goPort = True
        except:
            print('Serial port : unable to open COM' + port)
            goPort = False
    if opts[i].startswith("-d"):
        drive = opts[i][2].upper()
        if drive in valid_drives:
            print('Target drive: ' + drive)
            goDrive = True
        else:
            print('Target drive: ' + drive + ' invalid drive')
            goDrive = False
    if opts[i].startswith("-f"):
        file = opts[i][2:]
        try:
            f = open(file,"rb")
            print('Source file : ' + file)
            goFile = True
        except:
            print('Source file : unable to open ' + file)
            goFile = False

if (goPort != True) or (goDrive != True) or (goFile != True):
    if goPort == True:
        Z80_port.close()
    if goFile == True:
        f.close()
    exit()

# Transform drive and file into FCB format
dot = file.find(".")
i = 1
listFCB[0] = drive
if dot == -1:                               # name has no extension
    while i < 9:
        if (len(file) >= i):
            listFCB[i] = file[i-1]
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
            listFCB[i] = file[i-1]
        else:
            listFCB[i] = " "
        i+=1
    while i < 12:
        if len(file) >= (dot+i-7):
            listFCB[i] = file[dot+i-8]
        else:
            listFCB[i] = " "
        i+=1

FCB = ''.join(listFCB).upper()

# We're ready to start communication with CP/M
# Start RECEIVE.COM on CP/M
print('Starting RECEIVE.COM on CP/M.')
Z80_port.write(b'RECEIVE' + b'\r')
Z80_port.flush()

# Wait for <ACK>
print('Waiting for ACK... ', end='')
while True:
    rec_byte = Z80_port.read(1)
    if int.from_bytes(rec_byte, 'big') == ACK:
        print('Clear to go.')
        break

# Send FCB
print('Sending FCB.')
Z80_port.write(FCB.encode())
Z80_port.flush()

# Wait for <ACK>
print('Waiting for ACK... ', end='')
xuxu=0
while xuxu==0:
    rec_byte = Z80_port.read(1)
    if int.from_bytes(rec_byte, 'big') == ACK:   
        print('Clear to go.')
        print('Get me out of here!!!')
        xuxu=1
print('Ouch')
CheckSum = 0
while True:
    br = f.read(1)
    print('F',end='')
    print(br)
    if br == b'':
        break
    nbr = int.from_bytes(br, 'big')
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
    Z80_port.flush()
    while True:
        rec_byte = Z80_port.read(1)
        print('R',end='')
        print(rec_byte)
        if int.from_bytes(rec_byte, "big") == ACK:   
            break
        elif int.from_bytes(rec_byte, "big") == EM:   
            print('.', end='')

f.close()

# Send EOT
Z80_port.write(EOT)
Z80_port.flush()

# Send checksum
print('\r\n' + 'Sending Checksum...')
msn = CheckSum // 16
if msn < 0xa:
    msn += 0x30
else:
    msn += 0x37
lsn = CheckSum % 16
if lsn < 0xa:
    lsn += 0x30
else:
    lsn += 0x37
Z80_port.write(msn.to_bytes(1, 'big'))
Z80_port.write(lsn.to_bytes(1, 'big'))
Z80_port.flush()

# Wait for ACK or NAK
print('Waiting for ACK or NAK...')
while True:
    rec_byte = Z80_port.read(1)
    if int.from_bytes(rec_byte, "big") == ACK:
        print('Transmission successful.')
        break
    elif int.from_bytes(rec_byte, "big") == NAK:
        print('File operation error or Checksum error.')
        break

print('\r\n')    
Z80_port.close()
    
exit()

#    elif int.from_bytes(rec_byte, "big") == NAK:
#        print("Fail to create file." +'\r\n')
#        Z80_port.close()
#        f.close()
#        exit()
