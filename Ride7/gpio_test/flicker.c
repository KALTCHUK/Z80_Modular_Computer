// Generate a saw-tooth wave on P1 (0 to 0xFF) and toggle P3.7 (RD), so P3.7 has the same output as P1.0.

#include "REG51.h" 
#include <stdio.h> 
#include <stdlib.h>

void main(void) {
    int i;

    while(1) {
        for (i=0; i<0x100; i++) {
            P1 = i;
            RD = !RD;
        }
    }
}

