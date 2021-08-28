/*
 * CStest.c
 *
 * Created: 25/08/2021 18:09:44
 * Author : kaltchuk
 */ 

#define F_CPU	20000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define BAUD	38400
#define MYUBRR	((F_CPU/16/BAUD)-1)

#define CS		(PIND&(1<<INT0))
#define RSM		3
#define RSM_LO	PORTC &= ~(1<<RSM)
#define RSM_HI	PORTC |= (1<<RSM)

#define CR		0x0d
#define LF		0x0a

char	i=1;

void mySend(char send_this)
{
	while ( !( UCSR0A & (1<<UDRE0)) )
	{}
	UDR0 = send_this;
}

void USART_Init( unsigned int ubrr)
{
	/* Set baud rate */
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;

	/* Enable receiver, transmitter and RX_complete interrupt */
	UCSR0B = (1<<RXCIE0)|(1<<RXEN0)|(1<<TXEN0);

	/* Set frame format: 8N1 */
	UCSR0C = (3<<UCSZ00);
}

ISR(INT0_vect)			// Houston, we got a chip_select... CPU wants something
{
	char	operation;		//snapshots from I/O pins
	
	operation = PINC & 0x7;
	
	RSM_LO;
	RSM_HI;
	switch (operation)
	{
		case 4:		// read data
			mySend('r');
			mySend('d');
			mySend(CR);
			mySend(LF);
			break;
		case 5:		// read status
			mySend('r');
			mySend('s');
			mySend(CR);
			mySend(LF);
			break;
		case 2:		// write data
			mySend('w');
			mySend('d');
			mySend(CR);
			mySend(LF);
			break;
		case 3:		// write command
			mySend('w');
			mySend('c');
			mySend(CR);
			mySend(LF);
			break;
	}
}

int main(void)
{
	USART_Init(MYUBRR);
	DDRC |= (1<<RSM);
	RSM_HI;
	EIMSK = (1<<INT0);		// enable INT0 (CS)
	
	sei();
    while (1) 
    {
    }
}

