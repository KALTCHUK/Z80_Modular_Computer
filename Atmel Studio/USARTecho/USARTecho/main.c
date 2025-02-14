/*
 * USARTecho.c
 *
 * Created: 17/08/2021 16:43:09
 * Author : Kaltchuk
 */ 

#define F_CPU		20000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define BAUD 1250000
#define MYUBRR ((F_CPU/16/BAUD)-1)
#define LED		PORTB1
#define LED_ON	PORTB |= (1<<LED)

void USART_Init( unsigned int ubrr)
{
	/* Set baud rate */
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;

	/* Enable receiver and transmitter */
	UCSR0B = (1<<RXEN0)|(1<<TXEN0);

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

int main(void)
{
	USART_Init(MYUBRR);
	DDRB |= (1<<LED);		// set PB0 as output (LED)
	LED_ON;

    /* Replace with your application code */
    while (1) 
    {
		USART_Transmit(USART_Receive());
    }
}

