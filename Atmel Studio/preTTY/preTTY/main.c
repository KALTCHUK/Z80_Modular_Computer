/*
 * preTTY.c
 *
 * Created: 29/08/2021 17:29:23
 * Author : kaltchuk
 */ 


#define F_CPU	20000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define BAUD		38400
#define MYUBRR		((F_CPU/16/BAUD)-1)

#define CS			(PIND&(1<<INT0))
#define RSM			3
#define RSM_LO		(PORTC &= ~(1<<RSM))
#define RSM_HI		(PORTC |= (1<<RSM))

#define asInput		1
#define asOutput	2

#define WR_DATA		2
#define WR_COMMAND	3
#define RD_DATA		4
#define RD_STATUS	5

#define CR			0x0d
#define LF			0x0a

#define MAXBUFF		256

char	uBuffRX[MAXBUFF]; 					// Buffer for chars that arrived through serial port.
int		uBuffRX_inPtr=0, uBuffRX_outPtr=0;

char	uBuffTX[MAXBUFF]; 					// Buffer for chars to be sent through serial port.
int		uBuffTX_inPtr=0, uBuffTX_outPtr=0;

void setDataBus(int modus)
{
	if (modus == asInput)	// Write zeros to PORTs
	{
		PORTB &= ~0x07;
		PORTD &= ~0xf8;
	}
	else					// Write ones to PORTs
	{
		PORTB |= 0x07;
		PORTD |= 0xf8;
	}
}

void USART_Init( unsigned int ubrr)
{
	/* Set baud rate */
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;

	/* Enable receiver, transmitter and also RX_complete_interrupt */
	UCSR0B = (1<<RXCIE0)|(1<<RXEN0)|(1<<TXEN0);

	/* Set frame format: 8N1 */
	UCSR0C = (3<<UCSZ00);
}

ISR(USART_RX_vect)
{
	uBuffRX[uBuffRX_inPtr++] = UDR0;
	if (uBuffRX_inPtr == MAXBUFF)
	uBuffRX_inPtr = 0;
}

ISR(INT0_vect)								// We got a chip_select (CPU wants something)
{
	char	operation, dataByte;
	
	operation = PINC & 0x7;					// Snapshots from I/O pins
	dataByte = (PIND & 0xF)|(PINB & 0x07);
	
	switch (operation)
	{
		case RD_DATA:								// Read data request
		setDataBus(asOutput);
		if (uBuffRX_inPtr != uBuffRX_outPtr)
		{
			PORTB = (PINB & ~0x07)|(uBuffRX[uBuffRX_outPtr] & 0x07);
			PORTD = (PIND & ~0xf8)|(uBuffRX[uBuffRX_outPtr] & 0xf8);
			
			uBuffRX_outPtr += 1;
			if (uBuffRX_outPtr == MAXBUFF)
			uBuffRX_outPtr = 0;
		}
		RSM_LO;							// Release wait line
		RSM_HI;
		
		while (CS == 0)					// Wait till CS is high
		{
		}

		setDataBus(asInput);
		break;

		case RD_STATUS:						// Read status request
		setDataBus(asOutput);
		if (uBuffRX_inPtr != uBuffRX_outPtr)	// Put 0xff on data bus
		{
			PORTB |= 0x07;
			PORTD |= 0xf8;
		}
		else							// Put 00 on data bus
		{
			PORTB &= ~0x07;
			PORTD &= ~0xf8;
		}
		RSM_LO;							// Release wait line
		RSM_HI;
		
		while (CS == 0)					// Wait till CS is high
		{
		}

		setDataBus(asInput);
		break;
		
		case WR_DATA:		// write data request
		uBuffTX[uBuffTX_inPtr++] = dataByte;
		if (uBuffTX_inPtr == MAXBUFF)
		uBuffTX_inPtr = 0;
		RSM_LO;							// Release wait line
		RSM_HI;
		break;

		case WR_COMMAND:		// write command request
		RSM_LO;							// Release wait line
		RSM_HI;
		break;
	}
}

int main(void)
{
	char	iniMsg[] = ">preTTY card\r\n>38400bps 8N1\r\n\r\n\0";
	int		i=0;
	
	USART_Init(MYUBRR);		// Initialize USART
	while ( iniMsg[i] != 0)
	{
		while ( !( UCSR0A & (1<<UDRE0)) )
		{}
		UDR0 = iniMsg[i++];
	}
	DDRC |= (1<<RSM);		// Configure RSM pin as output
	RSM_HI;					// Turn off RSM (active low)
	EIMSK = (1<<INT0);		// Enable INT0 (chip select)
	
	sei();
	while (1) 				// If we're not busy attending a service request
	{						// from CPU, let's empty the TX buffer.
		if (uBuffTX_inPtr != uBuffTX_outPtr)
		{
			while ( !( UCSR0A & (1<<UDRE0)) )
			{}
			//UDR0 = uBuffTX[uBuffTX_outPtr++];
			UDR0 = 'A';
			if (uBuffTX_outPtr == MAXBUFF)
				uBuffTX_outPtr = 0;
		}
	}
}
