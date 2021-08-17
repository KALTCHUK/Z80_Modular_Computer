/*
 * IOtests.c
 *
 * Created: 16/08/2021 07:44:26
 * Author : kaltchuk
 *
 * Flash the LED several times when button is pressed.
 *
 * PB0 = SWITCH (WITH PULLUP RESISTOR)
 * PB1 = LED (ACTIVE HI)
 *
 */ 

#define F_CPU		20000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define LED_ON			PORTB |= (1<<PORTB1)
#define LED_OFF			PORTB &= ~(1<<PORTB1)
#define LED_TOGGLE		PINB |= (1<<PINB1)
#define SWITCH_PRESSED	!(PINB & (1<<PINB0))

ISR(PCINT0_vect)
{
	if (SWITCH_PRESSED)
	{
		for(int i=0; i<20; i++) 
		{
			LED_TOGGLE;			//Toggle LED
			_delay_ms(50);
		}
	}
}

int main(void)
{
	DDRB |= (1<<DDB1);		// set PB0 as output (LED)
	DDRB &= ~(1<<DDB0);		// set PB1 as input (switch)
	
	PCMSK0 |= (1<<PCINT0);
	PCICR |= (1<<PCIE0);
	
	sei();
	
    while (1) 
    {

    }
}

