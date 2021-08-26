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

#define BAUD 38400
#define MYUBRR ((F_CPU/16/BAUD)-1)

#define LED			PORTD1
#define LED_OFF		PORTD |= (1<<LED)
#define LED_ON		PORTD &= ~(1<<LED)
#define LED_TOGGLE	PORTD ^= (1<<LED)

#define CS			(PIND&(1<<INT0))

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
	while ( !( UCSR0A & (1<<UDRE0)) )
	;
	/* Put data into buffer, sends the data */
	UDR0 = 0x2a;
}

int main(void)
{
	USART_Init(MYUBRR);

	EIMSK = (1<<INT0);		// enable INT0 (CS)
	//DDRD  |= (1 << LED);
	//LED_OFF;
	
	sei();
    while (1) 
    {
    }
}

