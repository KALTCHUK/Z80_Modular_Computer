/* Serial communication test.

With crystal = 11.059MHz
-------------
Baud    TH1
-------------
 1200   0xD0
 2400   0xE8
 4800   0xF4
 9600   0xFA
19200   0xFD
28800   0xFE
57600   0xFF
-------------
*/

#include "REG51.h" 
#include <stdio.h> 
#include <stdlib.h>

void Inits(void);
unsigned char serialRX(void);
void serialTX(unsigned char x);

int milli;

void timer0_isr() interrupt 1
{
    TH0 = 0xfc;        //ReLoad the timer value
    TL0 = 0x66;

    milli++;
}

void main(void) {
    int tempo = 0;

    Inits();

    while(1) {
        serialTX(0x30 + tempo++);
        if(tempo > 9)   tempo = 0;
    
        milli = 0;
        while(milli < 1000);
    }
}

void Inits() {     // Initialize UART and TIMER0
    TMOD = 0x21;        // TIMER0 = mode_1 and TIMER1 = mode_2
    PCON |= 0x80;       // SMOD=1 => double baud rate;
    TH1 = 0xFD;         // 19200bps (see table in the header)
    SCON = 0x50;        // Serial port = mode 1 (8 bits, clocked by TIMER1)
    TR1 = 1;            // Turn on TIMER1

    TH0 = 0xfc;        //ReLoad the timer value
    TL0 = 0x66;
    TR0 = 1;           //turn ON Timer zero
    ET0 = 1;           //Enable TImer0 Interrupt
    EA = 1;            //Enable Global Interrupt bit
}

unsigned char serialRX(void) {
    while(RI == 0);
    RI = 0;
    return SBUF;
}

void serialTX(unsigned char x) {
    SBUF = x;
    while(TI == 0);
    TI = 0;
}

