## What you'll find in this directory ##
Here is all you need to put on the EEPROM to boot and run Monitor. We have:

- mbios2_0 - the customized BIOS for the Proton,
- monitor_2_3 - the latest version of Monitor and
- romboot - a small portion of software that transfers the BIOS and Monitor from EEPROM to RAM.

There are also some older versions of kbios and Monitor that I kept just for documentation reasons.

For all of them, you'll find three kinds of files:

1) .ASM, the source file with syntax for TASM Z80 compiler.
2) .LST, the list result after compilation.
3) .OBJ, the HEX (Intel format) result after compilation.

So you have to put romboot.obj, monitor_2_3.obj and mbios2_0.obj on the EEPROM. How? Read the "Getting Started" section in the Proton Manual. Be aware that the destination addresses are not the same seen in the HEX files. Depending on which ROM block will be used to boot, a displacement must be added.
