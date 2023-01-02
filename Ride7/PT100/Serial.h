/*
 Serial.h - Header file for serial communication.

 Functions:
	void serialInit(unsigned int baud) - Initialize UART 8N1 @ baud (crystal=16MHz).
	void serialTX(char x) - Send one byte.
	unsigned char serialRX(void) - Receive one byte.

Port3 has two especial pins:
	P3.0: RX
	P3.1: TX

*/

// Global Variables
unsigned int baud;

// Function Prototyping
void serialInit(unsigned int baud);
void serialTX(char x);
unsigned char serialRX(void);

// Functions
void serialInit(unsigned int baud) {     // Initialize UART
    TMOD |= 0x20;       // TIMER1 = mode_2
    PCON |= 0x80;       // SMOD=1 => double baud rate;
    SCON = 0x50;        // Serial port = mode 1 (8 bits, clocked by TIMER1)
	switch(baud) {
		case 1200:
		case 2400:
		case 4800:
			TH1 = 0xEF;
			break;
		case 9600:
		case 19200:
		case 28800:
		case 57600:
			TH1 = 0xEF;
			break;
	}
    TR1 = 1;            // Turn on TIMER1
}

void serialTX(char x) {
    SBUF = x;
    while(TI == 0);
    TI = 0;
}

unsigned char serialRX(void) {
    while(RI == 0);
    RI = 0;
    return SBUF;
}

