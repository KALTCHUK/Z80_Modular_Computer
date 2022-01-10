import sys
import string

def ShowUse():
    print("LBR v1.0 Library file extractor.")
    print("Commands:")
    print("   O <library>  open library (.LBR implicit)")
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
        fp.seek(0)
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
                full_name = name.rstrip(" ") + "." + ext.rstrip(" ") 
                print(x, full_name)

    if command[0] == "x" or command[0] == "X":
        fp.seek(0)
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
                full_name = name.rstrip(" ") + "." + ext.rstrip(" ") 
                print("Extracting " + full_name)
                fp_target = open(full_name, "wb")
                old_fp_position = fp.tell()
                fp.seek(128 * start, 0)
                for i in range(0,size):
                    record = fp.read(128)
                    fp_target.write(record)
                fp_target.close()
                fp.seek(old_fp_position,0)

    if command[0] == "q" or command[0] == "Q":
        break
        