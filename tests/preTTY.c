/*
 * preTTY.c
 *
 * Created: 19/08/2021 11:51:55
 * Author : kaltchuk
 * 
 **********************************
 *ATmega328 pin use for preTTY
 *            7     6     5     4     3     2     1     0
 *PORT B	XTAL2 XTAL1  SCK  MISO  MOSI   D02   D01   D00
 *PORT C    ----- RESET   nc   nc    nc    WR    RD    A01
 *PORT D     D07   D06   D05   D04   D03   CS    TX    RX
 *
 *RESET, WR, RD and CS are all active low signals.
 */

#define F_CPU			20000000UL

#define LED				PORTB1
#define LED_ON			PORTB |= (1<<LED)
#define LED_OFF			PORTB &= ~(1<<LED)

#define PIN_IN			1
#define PIN_OUT			0

#include <avr/io.h>
#include <util/delay.h>

char	RX_buff[256];
int		RX_wr_ptr=0, RX_rd_ptr=0;
char	TX_buff[256];
int		TX_wr_ptr=0, TX_rd_ptr=0;

// *** FUNCTIONS *** //
void init_DDR(void)		// Configure I/O pins
{
						// keep in mind that 0=In, 1=Out
	DDRB &= 0xf8;		// mask = X  X  X  X  X  In In In --> &11111000
	DDRC &= 0xf8;		// mask = X  X  X  X  X  In In In --> &11111000
	DDRD &= 0x03;		// mask = In In In In In In X  X  --> &00000011
}
int	TX_buff_use(void)	// Returns the number of char that have to be transmitted
{
	
}

void send_char(void)	// Transmit the next char in the TX_buff
{
	
}

void config_data_pins(int direction)
{
		if(direction == PIN_IN)
		{
			DDRB &= 0xf8;		// mask = X  X  X  X  X  In In In --> &11111000
			DDRD &= 0x03;		// mask = In In In In In X  X  X  --> &00000111
		}
		else
		{
			DDRB |= 0x03;		// mask =  X   X   X   X   X  Out Out Out --> |00000111
			DDRD |= 0xf8;		// mask = Out Out Out Out Out  X   X  X   --> |11111000
		}
}

// *** INTERRUPT SERVICES *** //
ISR(USART_RX_vect)		// Catch an incoming char on the serial port and put it on the RX_buff
{
	
}

ISR(INT0_vect)			// Houston, we got a chip_select... CPU wants something
{
	
}


int main(void)
{
	init_DDR();
	
    while (1) 
    {
		if(TX_buff_use()>0)
		{
			send_char();
		}
    }
}

