// Serial communication test.


#include "REG51.h" 
#include <stdio.h> 
#include <stdlib.h>

#define Sbit(x, y, z)   sbit x = y^z

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
    TMOD = 0x20;
    TH1 = 0xfd;         // 0xf4 => 2400bps, 0xfa => 4800bps, 0xfd => 9600bps, @ 11.0592MHz
    SCON = 0x50;
    TR1 = 1;
}

void serialTX(unsigned char x) {
    SBUF = x;
    while(TI == 0);
    TI = 0;
}

void delay (int t) {
    int x;

    for(x = 0; x < t; x++);
}