// Serial communication test.


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
    TH1 = 0xfd;         // 0xf4 => 2400bps, 0xfa => 4800bps, 0xfd => 9600bps, @ 11.0592MHz
    PCON |= 0x80;       // SMOD=1 => double baud rate;
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