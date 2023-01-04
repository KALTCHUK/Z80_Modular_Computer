/*
 PT100.c
  */

#include <REG51.h>
#include "Serial.h"

// Definitions
#define CR      0x0D
#define LF      0x0A
#define _CS     INT0
#define _RD     INT1
#define _WR     T0
#define _INT    T1

unsigned int milli;

// Function Prototyping
void greeting(void);
void printASCII(unsigned char v);
void milliStart(void);
void milliStop(void);
void newLine(void);
unsigned char readADC(void);

void main() {
    _CS = 1;
    _RD = 1;
    _WR = 1;
    _INT = 1;
    P1 = 0xff;

    baud = 19200;
	serialInit(baud);
	
    greeting();

	while (1) {
        printASCII(readADC());
        milliStart();
        while(milli < 1);
        milliStop();
    }
}

void timer0_isr() interrupt 1 {
    TH0 = 0xfc;        //Reload the TIMER0.
    TL0 = 0x66;

    milli++;
}

void greeting(void) {
    char msg[]="*** PT100 reading ***";
    int i;

    newLine();
    for(i=0; msg[i] != 0; i++)
        serialTX(msg[i]);
    newLine();
}

void printASCII(unsigned char v) {
    unsigned char buf[2], vDiv, vRem;

    vDiv = v / 0xa;
    vRem = v % 0xa;

    if(vDiv < 0xa)
        buf[0] = vDiv + '0';
    else
        buf[0] = vDiv + 'A' - 0xa;

    if(vRem < 0xa)
        buf[0] = vRem + '0';
    else
        buf[0] = vRem + 'A' - 0xa;

    newLine();
    serialTX(buf[0]);
    serialTX(buf[1]);
}

void milliStart(void) {
	ET0 = 0;				//Disable TIMER0 interrupt while configuring it.
    TMOD |= 0x01;      //TIMER0 = mode_1.
    TH0 = 0xfc;        //Load the timer value for 1ms tick (crystal = 11.059MHz).
    TL0 = 0x66;
    TR0 = 1;           //Turn ON TIMER0.
    ET0 = 1;           //Enable TIMER0 Interrupt.
    EA = 1;            //Enable Global Interrupt.
	
	milli = 0;
}

void milliStop(void) {
    ET0 = 0;           //Disable TIMER0 Interrupt.
}

void newLine(void) {
    serialTX(CR);
    serialTX(LF);
}

unsigned char readADC(void) {
    unsigned char i, val=0;
    unsigned int sum=0;

    for(i=0; i<16; i++) {   //Read 16 samples.
        _CS = 0;
        _WR = 0;
        val++;              //Just a delay.
        _WR = 1;
        _CS = 1;
    
        while(_INT == 1);   //Wait for interrupt signal (end of ADC conversion cycle).
    
        _CS = 0;
        _RD = 0;
        _CS = 0;
        while(_INT == 0);   //Wait for valid data.
        sum += P1;
        _RD = 1;
        _CS = 1;
    }

    val = sum/16;           //Average sample.
    return val;
}