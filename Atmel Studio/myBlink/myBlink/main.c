/*
 * myBlink.c
 *
 * Created: 24/07/2021 11:51:55
 * Author : kaltchuk
 */ 
#define F_CPU	16000000UL
#define LED		PB1

#include <avr/io.h>
#include <util/delay.h>


int main(void)
{
    DDRB  |= (1 << LED);
	PORTB &= ~(1 << LED);			//Turn off LED
	
    while (1) 
    {
		_delay_ms(100);
		PORTB ^= (1 << LED);			//Toggle LED
    }
}

