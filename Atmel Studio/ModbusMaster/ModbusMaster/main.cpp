/*
 * ModbusMaster.c v1.0
 *
 * Created: 20/10/2022 17:29:23
 * Author : Kaltchuk
 *
 */ 

#define F_CPU	11059200UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

// Define Drive enable pin
#define DE			4						// DE pin
#define DE_LO		(PORTC &= ~(1<<DE))		// Receive enable.
#define DE_HI		(PORTC |= (1<<DE))		// Drive enable.

// Define chip select and release pins
#define CS			(PIND&(1<<INT0))		// CS pin
#define RSM			3						// RSM pin
#define RSM_LO		(PORTC &= ~(1<<RSM))
#define RSM_HI		(PORTC |= (1<<RSM))

#define asInput		1
#define asOutput	2

// Define Operations
#define WR_DATA		2
#define WR_COMMAND	3
#define RD_DATA		4

// Define Commands
#define setBaudrate			1		// receive 1 byte with new baud rate (index).
#define getBaudrate			2		// send byte with current baud rate (index).
#define clearRXbuffer		3		// clear RX buffer. No arguments following.
#define clearTXbuffer		4		// clear TX buffer. No arguments following.
#define flushTXbuffer		5		// flush TX buffer. No arguments following.
#define enableCRCappend		6		// calculate and append CRC to TX buffer before flushing TX buffer. Default. No arguments following.
#define disableCRCappend	7		// don't do the CRC stuff. No arguments following.
#define sizeRXbuffer		8		// send number of bytes available in RX buffer.
#define readRXbuffer		9		// send one byte from RX buffer.
#define writeTXbuffer		10		// receive byte and put it in TX buffer.

#define MAXBUFF		256

char			RXbuf[MAXBUFF]; 					// Buffer for chars that arrived through serial port.
int				RXbufInPtr=0, RXbufOutPtr=0;
char			TXbuf[MAXBUFF]; 					// Buffer for chars to be sent through serial port.
int				TXbufInPtr=0, TXbufOutPtr=0;

unsigned int long	baud[] = {1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200};
unsigned long int	newBaud = 5;					// i.e. initial baud rate = 19200bps

char			command=0;
bool			appendCRC=1;

void setDataBus(int modus) {
	if (modus == asInput) {				// Write zeros to PORTs.
		DDRB &= ~0x07;
		DDRD &= ~0xf8;
	}
	else {								// Write ones to PORTs.
		DDRB |= 0x07;
		DDRD |= 0xf8;
	}
}

void CRC(void) {
	bool lsb;
	char i=TXbufOutPtr, j;
	unsigned int crc = 0xFFFF;
	
	while (TXbufInPtr != i) {
		crc ^= (unsigned int)TXbuf[i++];
		for (j = 0; j < 8; j++) {
			lsb = crc & 1;
			crc >>= 1;
			if (lsb == 1)
			  crc ^= 0xA001;
		}
	}
	TXbuf[TXbufInPtr++] = crc & 0xff;
	TXbuf[TXbufInPtr++] = crc >> 8;	
}

void xmit(char toSend) {
	while (!( UCSR0A & (1<<UDRE0)));
	
	UDR0 = toSend;
	while (!( UCSR0A & (1<<TXC0)));
	UCSR0A |= (1<<TXC0);				// Reset TXC flag.
}

void sendTXbuf(void) {
	DE_HI;
	while (TXbufInPtr < TXbufOutPtr)
		xmit(TXbuf[TXbufOutPtr++]);
	DE_LO;
}

void reply(char toPost) {
	setDataBus(asOutput);
	PORTB = (PINB&~0x7)|(toPost&0x7);
	PORTD = (PIND&~0xf8)|(toPost&0xf8);
}

void USART_Init(unsigned int baudrateIndex) {
	unsigned int ubrr;
	
	ubrr = (F_CPU / 8 / baud[baudrateIndex]) - 1;
	
	/* Set baud rate */
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;

	/* Enable double speed */
	UCSR0A |= (1<<U2X0);

	/* Enable receiver, transmitter and also RX_complete_interrupt */
	UCSR0B = (1<<RXCIE0)|(1<<RXEN0)|(1<<TXEN0);

	/* Set frame format: 8N1 */
	UCSR0C = (3<<UCSZ00);
}

ISR(USART_RX_vect) {
	RXbuf[RXbufInPtr++] = UDR0;
	if (RXbufInPtr == MAXBUFF)
		RXbufInPtr = 0;
}

ISR(INT0_vect)	{								// We got a chip_select (CPU wants something).
	char		operation, dataByte;
	
	operation = PINC & 0x7;						// Snapshot from I/O pins.
	dataByte = (PIND & 0xf8)|(PINB & 0x07);		// Snapshot from data bus. 

	switch (operation) {
		case WR_COMMAND:
			command = dataByte;
			switch (command) {
				case clearRXbuffer:
					RXbufInPtr = 0;
					RXbufOutPtr = 0;
					break;
				case clearTXbuffer:
					TXbufInPtr = 0;
					TXbufOutPtr = 0;
					break;
				case flushTXbuffer:
					if (appendCRC)
						CRC();
					sendTXbuf();
					TXbufInPtr = 0;
					TXbufOutPtr = 0;
					break;
				case enableCRCappend:
					appendCRC = 1;
					break;
				case disableCRCappend:
					appendCRC = 0;
					break;
			}
			break;

		case WR_DATA:
			switch (command) {
				case setBaudrate:
					newBaud = dataByte;
					USART_Init(newBaud);
					break;
				case writeTXbuffer:
					TXbuf[TXbufInPtr++] = dataByte;
					break;
			}
			break;

		case RD_DATA:
			switch (command) {
				case getBaudrate:
					reply(newBaud);
					break;
				case sizeRXbuffer:
					reply(RXbufOutPtr - RXbufInPtr);
					break;
				case readRXbuffer:
					if (RXbufInPtr != RXbufOutPtr)
						reply(RXbuf[RXbufOutPtr++]);
					else
						reply(0);
					break;
			}
			break;
	}
	RSM_LO;							// Pulse RSM to release wait line.
	RSM_HI;
	
	setDataBus(asInput);
}

int main(void) {
	USART_Init(newBaud);		// Initialize USART

	DDRC |= (1<<RSM);			// Configure RSM pin as output
	RSM_HI;						// Turn off RSM (active low)
	EIMSK = (1<<INT0);			// Enable INT0 (chip select)
	
	DDRC |= (1<<DE);			// Configure DE pin as output
	DE_LO;						// Put SN76175 in "receive mode"
	
	setDataBus(asInput);

	sei();
	while (1);
}

