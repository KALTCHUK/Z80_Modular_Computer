/*
 * myBlink.c
 *
 * Created: 24/07/2021 11:51:55
 * Author : kaltchuk
 */ 
#define F_CPU	16000000UL

#define LED				PORTD1
#define LED_ON			PORTD |= (1<<LED)
#define LED_OFF			PORTD &= ~(1<<LED)
#define LED_TOGGLE		PORTD ^= (1<<LED)


#include <avr/io.h>
#include <util/delay.h>


int main(void)
{
    int		i;
	
	DDRD  |= (1 << LED);
	LED_OFF;					//Turn off LED
	
    while (1) 
    {
		LED_TOGGLE;			//Toggle LED
		_delay_ms(300);
    }
}

