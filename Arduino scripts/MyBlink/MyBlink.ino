/*
 * myBlink.c
 *
 * Created: 24/07/2021 11:51:55
 * Author : kaltchuk
 */ 
#define F_CPU  20000000UL

#define LED         PORTB5
#define LED_ON      PORTB |= (1<<LED)
#define LED_OFF     PORTB &= ~(1<<LED)

#include <avr/io.h>
#include <util/delay.h>


int main(void)
{
  DDRC  |= (1 << LED);
  LED_OFF;          //Turn off LED
  
    while (1) 
    {
    LED_ON;     //Toggle LED
    _delay_ms(500);
    LED_OFF;
    _delay_ms(100);
    }
}
