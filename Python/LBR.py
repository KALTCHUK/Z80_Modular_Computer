import sys
import string

def ShowUse():
    print("LBR v1.0 Library file extractor.")
    print("Commands:")
    print("   O <library>  open library .LBR")
    print("   L            list files")
    print("  eXtract       extract all files")
    print("   Q            quit program.\n")

ShowUse()

while True:
    command = input("#")
    
    if command[0] == "o" or command[0] == "O":
        file_name = command[2:] + ".lbr"
        fp = open(file_name, "rb")
        print(file_name + " opened")
    if command[0] == "l" or command[0] == "L":
        for x in range(10):
            record = fp.read(32)
            print(record[1:8], ".", record[9:11])
            start = record[12] + (16*record[13])
            size  = record[14] + (16*record[15])
            print(start)
            print(size)
    if command[0] == "x" or command[0] == "X":
        print("extract")
    if command[0] == "q" or command[0] == "Q":
        break
        