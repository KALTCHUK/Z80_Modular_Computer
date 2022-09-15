/* Serial communication test.

With crystal = 11.059MHz
Baud    TH1
 1200   0xD0
 2400   0xE8
 4800   0xF4
 9600   0xFA
19200   0xFD
38400   0xFE
57600   0xFF
*/

#include "REG51.h" 
#include <stdio.h> 
#include <stdlib.h>

void serialInit(void);
void serialTX(unsigned char x);
void delay(int t);

void main(void) {
    serialInit();

    while(1) {
        serialTX('A');
        serialTX('B');
        serialTX('C');
    }
}

void serialInit() {
    TMOD = 0x20;        // TIMER1 = mode 2
    PCON |= 0x80;       // SMOD=1 => double baud rate;
    TH1 = 0xfd;         // see table in the header
    SCON = 0x50;        // Serial port = mode 1 (8 bits, clocked by TIMER1)
    TR1 = 1;            // Turn on TIMER1
}

void serialTX(unsigned char x) {
    SBUF = x;
    while(TI == 0);
    TI = 0;
}
/*
void delay (int t) {
    int x;

    for(x = 0; x < t; x++);
}
*/