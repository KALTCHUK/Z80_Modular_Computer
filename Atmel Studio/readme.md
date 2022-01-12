## What you'll find in this directory ##
Several "projects" built with Atmel Studio. Most of them are only some tests I made in order to get familiar with Atmel Studio and ATmega328.

The important thing here is the directory called "preTTY". (It's called preTTY because I started working on it before the TTY Card was complete). There you'll find the firmware used on the microcontrollers from the TTY Card (two ATmega328, one for each serial port). 

Before beginning the Proton project I already had a good experience using Arduino. But, for the TTY Card, I couldn't simply plug an Arduind board and that's it. So I used only the Arduino's microcontroller "bareback", with no bootloader, running at 20MHz.