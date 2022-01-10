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
        record = fp.read(32)
        start = record[12] + (16*record[13])
        entries  = 4*(record[14] + (16*record[15]))-1
        print(entries, " records in directory.\n")
        for x in range(0,entries):
            record = fp.read(32)
            if record[0] == 0:
                start = record[12] + (16*record[13])
                size = record[14] + (16*record[15])
                name = ""
                ext  = ""
                for i in range(1,9):
                    name = name + chr(record[i])
                for i in range(9,12):
                    ext = ext + chr(record[i])
                print(x, name + "." + ext + " -->", size, " records start at ", start)

    if command[0] == "x" or command[0] == "X":
        print("extract")

    if command[0] == "q" or command[0] == "Q":
        break
        