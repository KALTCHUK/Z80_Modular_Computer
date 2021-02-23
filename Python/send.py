#************************************************************************************************
# This program sends a file to CP/M. Run "send.py -h" to see options.
# REVEIVE.COM must be present in the active drive of CP/M.
#************************************************************************************************
import sys
import serial

EOT	= 0x04
ACK	= 0x06
LF	= 0x0A
CR	= 0x0D
NAK	= 0x15
EM  = 0x19

valid_drives = "ABCDEFGHIJKLMNOP"
listFCB = list("            ") 

opts = [opt for opt in sys.argv[1:] if opt.startswith("-")]


if "-h" in opts:
    print('Use: send.py -p<port> [-d<drive>] -f<file>' + '\n\r')
    print('Where <port>  is the number of the serial COM port')
    print('      <drive> is the target CP/M drive (A, B, C ... P)')
    print('      <file>  is the name of the file to be transmmited')
    print('              (must be in the same directory with send.py)' + '\n\r')
    exit()

goPort = False
goFile = False
goDrive = True
noDrive = True
for i in range(0, len(opts)):
    if opts[i].startswith("-p"):
        port = opts[i][2:]
        try:
            Z80_port = serial.Serial(port = "COM" + port, baudrate = 9600, timeout = 1)
            print('Serial port : COM' + port)
            goPort = True
        except:
            print('Serial port : unable to open COM' + port)
    if opts[i].startswith("-d"):
        drive = opts[i][2].upper()
        if drive in valid_drives:
            noDrive = False
            print('Target drive: ' + drive)
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

if (goPort != True) or (goDrive != True) or (goFile != True):
    if goPort == True:
        Z80_port.close()
    if goFile == True:
        f.close()
    exit()

# We're ready to start communication with CP/M
# Start RECEIVE.COM on CP/M
print('Starting RECEIVE.COM on CP/M.')
if noDrive == True:
    Z80_port.write(b'RECEIVE ' + ufile.encode() + b'\r')
else:
    Z80_port.write(b'RECEIVE ' + (drive + ':' + ufile).encode() + b'\r')

# Wait for <ACK> or <NAK>
print('Waiting for ACK... ', end='')
while True:
    rec_byte = Z80_port.read(1)
    if int.from_bytes(rec_byte, 'big') == ACK:
        print('Clear to go.')
        break
    if int.from_bytes(rec_byte, 'big') == NAK:
        print('Unable to create file on CP/M. Transmission aborted.')
        Z80_port.close()
        f.close()
        exit

print('Starting transmission.')
checksum = 0
while True:
    br = f.read(1)
    if br == b'':                       # If its EOF, exit the loop
        break
    nbr = int.from_bytes(br, 'big')
    checksum += nbr                     # Update checksum
    if checksum > 0xff:                 # Check for overflow
        checksum -= 0x100 
    msn = nbr // 16                     # Calculate most significant nibble
    if msn < 0xa:
        msn += 0x30
    else:
        msn += 0x37
    lsn = nbr % 16                      # Calculate least significant nibble
    if lsn < 0xa:
        lsn += 0x30
    else:
        lsn += 0x37
    Z80_port.write(msn.to_bytes(1, 'big'))
    Z80_port.write(lsn.to_bytes(1, 'big'))
    while True:
        rec_byte = Z80_port.read(1)
        if int.from_bytes(rec_byte, 'big') == ACK:
            break
        if int.from_bytes(rec_byte, 'big') == NAK:
            print('Error writing file on CP/M. Transmission aborted.')
            Z80_port.close()
            f.close()
            exit
        if int.from_bytes(rec_byte, 'big') == EM:
            print('.', end='')

f.close()                               # We don't need the file anymore
Z80_port.write(EOT)                     # Send EOT

msn = checksum // 16                    # Calculate most significant nibble
if msn < 0xa:
    msn += 0x30
else:
    msn += 0x37
lsn = checksum % 16                     # Calculate least significant nibble
if lsn < 0xa:
    lsn += 0x30
else:
    lsn += 0x37
print('\r\n' + 'Sending CheckSum.')
Z80_port.write(msn.to_bytes(1, 'big'))
Z80_port.write(lsn.to_bytes(1, 'big'))

# Wait for <ACK>
print('Waiting for ACK... ', end='')
while True:
    rec_byte = Z80_port.read(1)
    if int.from_bytes(rec_byte, 'big') == ACK:
        print('File successfully transmitted.')
        break
    if int.from_bytes(rec_byte, 'big') == NAK:
        print('CheckSum error!')
        break
    
print('\r\n')
Z80_port.flushInput()    
Z80_port.close()
    
exit()
