/*
 * ModbusMaster.c v2.0
 *
 * Created: 28/10/2022 17:29:23
 * Author : Kaltchuk
 *
 */ 

//#define F_CPU	11059200UL
#define F_CPU	20000000UL					// Final version of RS485 Card must us 11059100

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

// Define Drive enable pin
#define DE			4						// DE pin
#define DE_LO		(PORTC &= ~(1<<DE))		// Receive enable.
#define DE_HI		(PORTC |= (1<<DE))		// Drive enable.

// Define chip select and release pins
#define CS			(PIND & (1<<INT0))		// CS pin
#define RSM			3						// RSM pin
#define RSM_LO		(PORTC &= ~(1<<RSM))
#define RSM_HI		(PORTC |= (1<<RSM))

#define asInput		1
#define asOutput	2

// Define Operations		/WR /RD AO1
#define WR_DATA		2	//	0	1	0
#define WR_COMMAND	3	//	0	1	1
#define RD_DATA		4	//	1	0	0
#define RD_STATUS	5	//	1	0	1		// Used only to read status after readRegister and writeRegister operations.

// Define Commands
#define setBaudrate			1		// receive 1 byte with new baud rate (ENUM). Followed by WR_DATA <baud>
#define getBaudrate			2		// send byte with current baud rate (ENUM). Followed by RD_DATA <baud> (0..9 ==> 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200 bps)
#define clearRXbuffer		3		// clear RX buffer. No arguments following.
#define clearTXbuffer		4		// clear TX buffer. No arguments following.
#define flushTXbuffer		5		// flush TX buffer. No arguments following.
#define enableCRCappend		6		// calculate and append CRC to TX buffer before flushing TX buffer. Default. No arguments following.
#define disableCRCappend	7		// don't do the CRC stuff. No arguments following.
#define sizeRXbuffer		8		// send number of bytes available in RX buffer. Followed by RD_DATA <size>.
#define readRXbuffer		9		// send one byte from RX buffer. Followed by RD_DATA <byte>.
#define writeTXbuffer		10		// receive byte and put it in TX buffer. Followed by WR_DATA <byte>
#define readRegister		11		// read a register. Followed by WR_DATA <register_HI> WR_DATA <register_LO> RD_DATA <val_HI> RD_DATA <val_LO>.
#define writeRegister		12		// write to a register. Followed by WR_DATA <register_HI> WR_DATA <register_LO> WR_DATA <val_HI> WR_DATA <val_LO>.

// Define types of I/Os
#define discInput			0		// R
#define coil				1		// R/W
#define inputReg			3		// R
#define holdingReg			4		// R/W

// Define Status
#define illigalFunction		1
#define illigalAddress		2
#define illigalValue		3
#define timeout				7



#define MAXBUFF		256

char			RXbuf[MAXBUFF]; 					// Buffer for chars that arrived through serial port.
int				RXbufInPtr=0, RXbufOutPtr=0;
char			TXbuf[MAXBUFF]; 					// Buffer for chars to be sent through serial port.
int				TXbufInPtr=0, TXbufOutPtr=0;

char			command=0;
bool			appendCRC=1, opMode=1;

char			tempBuf[8];
int				byteCount;
char			status=0;							// status returned from readRegister or writeRegister operations.

unsigned int long	baud[] = {1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200};
unsigned long int	newBaud = 5;					// i.e. initial baud rate = 19200bps

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
	while (TXbufInPtr != TXbufOutPtr) {
		xmit(TXbuf[TXbufOutPtr++]);
		if (TXbufOutPtr == MAXBUFF)
			TXbufOutPtr = 0;
	}
	DE_LO;
}

void reply(char toPost) {
	setDataBus(asOutput);
	PORTB = (PINB&~0x7)|(toPost&0x7);
	PORTD = (PIND&~0xf8)|(toPost&0xf8);
}

char devType(void) {
	int		dev;
	
	dev = (((int)tempBuf[2])<<8) | tempBuf[3];
	
	if (dev < 1000)
		return discInput;
	if (dev < 20000)
		return coil;
	if (dev < 30000)
		return illigalAddress;
	if (dev < 40000)
		return inputReg;
	if (dev < 50000)
		return holdingReg;
	return illigalAddress;
}
void regOperation(void) {
	if (command == readRegister) {
		switch (devType()) {
			case discInput:
				tempBuf[1] = 2;
				break;
			case coil:
				tempBuf[1] = 1;
				break;
			case inputReg:
				tempBuf[1] = 4;
				break;
			case holdingReg:
				tempBuf[1] = 3;
				break;
			case illigalAddress:
				status = illigalAddress;
				return;
		}
	} else {
		switch (devType()) {
			case coil:
				tempBuf[1] = 5;
				break;
			case holdingReg:
				tempBuf[1] = 6;
				break;
			case discInput:
			case inputReg:
				status = illigalFunction;
				return;
			case illigalAddress:
				status = illigalAddress;
				return;
		}
	}
	CRC();
	RXbufInPtr = 0;
	RXbufOutPtr = 0;
	sendTXbuf();
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
			switch (dataByte) {
				case clearRXbuffer:
					RXbufInPtr = 0;
					RXbufOutPtr = 0;
					command = 0;
					break;
				case clearTXbuffer:
					TXbufInPtr = 0;
					TXbufOutPtr = 0;
					command = 0;
					break;
				case flushTXbuffer:
					if (appendCRC)
						CRC();
					sendTXbuf();
					TXbufInPtr = 0;
					TXbufOutPtr = 0;
					command = 0;
					break;
				case enableCRCappend:
					appendCRC = 1;
					break;
				case disableCRCappend:
					appendCRC = 0;
					command = 0;
					break;
				case writeRegister:
				case readRegister:
					TXbufInPtr = 0;
					TXbufOutPtr = 0;
				case getBaudrate:
				case setBaudrate:
				case sizeRXbuffer:
				case readRXbuffer:
				case writeTXbuffer:
				command = dataByte;							// What's the command?
				break;
			}
			break;

		case RD_STATUS:
			reply(status);
			break;
			
		case WR_DATA:
			switch (command) {
				case setBaudrate:
					newBaud = dataByte;
					USART_Init(newBaud);
					command = 0;
					break;
				case writeTXbuffer:
					TXbuf[TXbufInPtr++] = dataByte;
					if (TXbufInPtr == MAXBUFF)
						TXbufInPtr = 0;
					break;
				case readRegister:
					if (TXbufInPtr < 4) {
						if (TXbufInPtr == 1)
							TXbufInPtr++;
						TXbuf[TXbufInPtr++] = dataByte;
					}
					if (TXbufInPtr == 4)
						regOperation();
					break;
				case writeRegister:
					if (TXbufInPtr < 6) {
						if (TXbufInPtr == 1)
						TXbufInPtr++;
						TXbuf[TXbufInPtr++] = dataByte;
					}
					if (TXbufInPtr == 6)
						regOperation();
					break;
			}
			break;

		case RD_DATA:
			switch (command) {
				case readRXbuffer:
					if (RXbufInPtr != RXbufOutPtr) {
						reply(RXbuf[RXbufOutPtr++]);
						if (RXbufOutPtr == MAXBUFF)
							RXbufOutPtr = 0;
					} else
						reply(0);
					break;
				case getBaudrate:
					reply(newBaud);
					command = 0;
					break;
				case sizeRXbuffer:
					if (RXbufOutPtr <= RXbufInPtr)
						reply(RXbufInPtr - RXbufOutPtr);
					else
						reply(MAXBUFF - RXbufOutPtr + RXbufInPtr);
					command = 0;
					break;
				case readRegister:

					break;
				default:
					reply(0xff);
			}
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

