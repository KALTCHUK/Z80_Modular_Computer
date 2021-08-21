/*
 * USARTechoISR.c same as USARTecho but using interrupt.
 *
 * Created: 19/08/2021 16:43:09
 * Author : Kaltchuk
 */ 

#define F_CPU		20000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define BAUD 38400
#define MYUBRR ((F_CPU/16/BAUD)-1)
#define LED		PORTB1
#define LED_ON	PORTB |= (1<<LED)
#define LED_OFF	PORTB &= ~(1<<LED)

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


ISR(USART_RX_vect,ISR_BLOCK)
{
	while ( !( UCSR0A & (1<<UDRE0)) )
	;
	/* Put data into buffer, sends the data */
	UDR0 = UDR0;
	reti();
}

int main(void)
{
	USART_Init(MYUBRR);
	DDRB |= (1<<LED);		// set PB0 as output (LED)
	
	sei();

    /* Replace with your application code */
    while (1) 
    {
    }
}

