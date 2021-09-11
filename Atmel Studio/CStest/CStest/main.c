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

void xmit(char send_this)
{
	while ( !( UCSR0A & (1<<UDRE0)) )
	{}
	UDR0 = send_this;
}

void xmitHex(char bite)
{
	char	finale=0;
	char	bite2;
	
	bite2 = (bite>>4);
	if (bite2 > 9)
		finale = bite2 + 0x37;
	else
		finale = bite2 + 0x30;
	xmit(finale);
	
	bite2 = (bite&0xf);
	if (bite2 > 9)
		finale = bite2 + 0x37;
	else
		finale = bite2 + 0x30;
	xmit(finale);
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
	
	xmit('T');
	xmit('T');
	xmit('Y');
	xmit(CR);
	xmit(LF);

}

ISR(INT0_vect)			// Houston, we got a chip_select... CPU wants something
{
	char	operation;		//snapshots from I/O pins
	char	dataByte;
		
	operation = PINC & 0x7;
	dataByte  = (PINB&0x7)|(PIND&0xf8);

	xmitHex(operation);
	xmit('-');
	xmitHex(dataByte);
	xmit('.');
	xmit(' ');
	
	_delay_ms(5000);
	
	RSM_LO;
	RSM_HI;
}

int main(void)
{
	USART_Init(MYUBRR);
	
//	DDRC |= (1<<RSM);
	DDRC = 8;
	RSM_HI;
	EIMSK = (1<<INT0);		// enable INT0 (CS)
	
	sei();
    while (1) 
    {
		
    }
}

