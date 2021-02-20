#************************************************************************************************
# This program sends a file to CP/M. Run "send.py -h" to see options.
# REVEIVE.COM must be present in the active drive of CP/M.
#************************************************************************************************
EOT	= 0x04
ACK	= 0x06
LF	= 0x0A
CR	= 0x0D
NAK	= 0x15
EM  = 0x19

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
        ufile = file.upper()
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

# We're ready to start communication with CP/M
# Start RECEIVE.COM on CP/M
print('Starting RECEIVE.COM on CP/M.')
Z80_port.write(b'RECEIVE ' + (drive + ':' + file).encode() + b'\r')

print('Starting transmission.')
while True:
    br = f.read(1)
    print(str(br)[2],end='')
    if br == b'':
        break
    nbr = int.from_bytes(br, 'big')
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
    Z80_port.flushInput()

f.close()
print('\r\n' + 'Sending EOT.')
# Send EOT
Z80_port.write(EOT)
    
print('\r\n')
Z80_port.flushInput()    
Z80_port.close()
    
exit()
