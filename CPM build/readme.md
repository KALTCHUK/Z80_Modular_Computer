## What you'll find in this directory ##
Here is all you need to put on the EEPROM to boot and run CP/M. We have:

- kbios2_0 - the customized BIOS for the Proton,
- kcpm221 - a slightly customized version of CP/M 2.2 and
- romboot - a small portion of software that transfers the BIOS and CP/M from EEPROM to RAM.

There are also some older versions of kbios and kcpm that I kept just for documentation reasons.

Special thanks to Grant Searle, from Wales, for is magnificent work on the BIOS, specially the disk functions, which I used as a starting point for my KBIOS.

For all of them, you'll find three kinds of files:

1) .ASM, the source file with syntax for TASM Z80 compiler.
2) .LST, the list result after compilation.
3) .OBJ, the HEX (Intel format) result after compilation.

So you have to put romboot.obj, kcpm221.obj and kbios2_0.obj on the EEPROM. How? Read the "Getting Started" section in the Proton Manual. Be aware that the destination addresses are not the same seen in the HEX files. Depending on which ROM block will be used to boot, a displacement must be added.
