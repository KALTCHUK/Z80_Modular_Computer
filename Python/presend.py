#************************************************************************************************
# This program sends 1 or more files to CP/M.
#************************************************************************************************

import serial

print('\r\n')    

# Which drive?
listFCB = list("            ") 
CheckSum = 0
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

print(dot)
print("012345678901")
print("".join(listFCB) + "<")

