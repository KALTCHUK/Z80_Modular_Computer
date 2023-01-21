/*
 I2C_LCD.c
  */

#include <REG51.h>

// Definitions
#define pinRS   RXD
#define pinR_W  TXD
#define pinE    INT0
#define pinSDA  T1
#define pinSCL  RD
#define CR      0x0D
#define LF      0x0A

unsigned int milli;

// Function Prototyping
void milliStart(void);
void initLCD(void);
void putLCD(char);

void main() {
    char line1[] = "Display ready";
    char line2[] = "8-bit mode";
    int i;

    pinRS = 0;
    pinR_W = 0;
    pinE = 0;
    pinSDA = 1;
    pinSCL = 1;

    initLCD();

    while(1);

    i = 0;
    while(line1[i] != 0)
        putLCD(line1[i++]);
    
    P1 = 0xc0;  // Position cursor at the beginning of the 2nd line.
    pinRS = 0;
    pinR_W = 0;
    pinE = 1;
    pinE = 0;
    
    i = 0;
    while(line2[i] != 0)
        putLCD(line2[i++]);
}

void milliStart(void) {
	ET0 = 0;           //Disable TIMER0 interrupt while configuring it.
    TMOD |= 0x01;      //TIMER0 = mode_1.
    TH0 = 0xfc;        //Load the timer value for 1ms tick (crystal = 11.059MHz).
    TL0 = 0x66;
    TR0 = 1;           //Turn ON TIMER0.
    ET0 = 1;           //Enable TIMER0 Interrupt.
    EA = 1;            //Enable Global Interrupt.
	
	milli = 0;
}

void initLCD(void) {
    int i;

    milliStart();
    while(milli < 20);

    pinRS = 0; // Function set.
    pinR_W = 0;
    P1 = 0x38;
    pinE = 1;
    i++;
    pinE = 0;

    milli = 0;
    while(milli < 5);
    pinE = 1;   // Repeat function set.
    i++;
    pinE = 0;

    milli = 0;
    while(milli < 1);
    pinE = 1;   // Repeat function set.
    i++;
    pinE = 0;

    milli = 0;
    while(milli < 1);
    P1= 0x0e;   // Display on/off control.
    pinE = 1;
    i++;
    pinE = 0;

    milli = 0;
    while(milli < 1);
    P1= 0x06;   // Entry mode set.
    pinE = 1;
    i++;
    pinE = 0;
}

void putLCD(char c) {
    int i;

    pinRS = 0;
    pinR_W = 1;
    do {
        P1 = 0xff;
        pinE = 1;
        i++;
        pinE = 0;
    } while((P1 & 0x80) != 0);

    P1 = c;
    pinRS = 1;
    pinR_W = 0;
    pinE = 1;
    i++;
    pinE = 0;
}