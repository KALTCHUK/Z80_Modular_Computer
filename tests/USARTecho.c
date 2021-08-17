/*
 * Send back every char received
 */

#define F_CPU		20000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define BAUD 2400
#define MYUBRR ((F_CPU/16/BAUD)-1)

void USART_Init( unsigned int ubrr)
{
	/* Set baud rate */
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;

	/* Enable receiver and transmitter */
	/* Enable RX_complete_interrupt    */
	UCSR0B = (1<<RXCIE0)|(1<<RXEN0)|(1<<TXEN0);

	/* Set frame format: 8N1 */
	UCSR0C = (3<<UCSZ00);
}

void USART_Transmit( unsigned char data )
{
	/* Wait for empty transmit buffer */
	while ( !( UCSR0A & (1<<UDRE0)) )
	;
	/* Put data into buffer, sends the data */
	UDR0 = data;
}

unsigned char USART_Receive( void )
{
	/* Wait for data to be received */
	while ( !(UCSR0A & (1<<RXC0)) )
	;
	/* Get and return received data from buffer */
	return UDR0;
}

ISR(USART_RX_vect)
{
	USART_Transmit(USART_Receive());
}

void main( void )
{

	USART_Init(MYUBRR)

	while(1)
	{
		
	}
}

