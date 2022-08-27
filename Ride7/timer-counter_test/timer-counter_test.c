//  Toggle all the bits of port P1 continuously with some delay in between. Use Timer 0, mode 2 (8-bit auto-reload), to generate the delay.

#include "REG51.h" 
#include <stdio.h> 
#include <stdlib.h>

#define Sbit(x, y, z)   sbit x = y^z

void T0delay(void);

void main(void) {
    while(1) {
        P1 = 0x55;
        T0delay();
        P1 = 0xAA;
        T0delay();
    }
}

void T0delay() {
    TMOD = 0x02;
    TH0 = 58;
    TR0 = 1;
    while(TF0 == 0);
    TR0 = 0;
    TF0 = 0;
}