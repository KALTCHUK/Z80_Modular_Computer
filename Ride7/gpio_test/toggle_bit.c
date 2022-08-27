// Toggle P1_0 pin every cycle and RD with half the frequency

#include "REG51.h" 
#include <stdio.h> 
#include <stdlib.h>

#define Sbit(x, y, z)   sbit x = y^z

/*  P1  */
Sbit (P1_0   , P1, 0);

void main(void) {
    int i=0;

    while(1) {
        P1_0 = !P1_0;
        i++;
        if (i==2) {
            RD = !RD;
            i = 0;
        }
    }
}
