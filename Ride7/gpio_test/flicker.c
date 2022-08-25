// Set and reset continuously P1 and P3.7
#include "REG51.h" 
#include <stdio.h> 
#include <stdlib.h>

void main(void) {
    int i;

    while(1) {
        for (i=0; i<0x100; i++) {
            P1 = i;
        }
    }
}

