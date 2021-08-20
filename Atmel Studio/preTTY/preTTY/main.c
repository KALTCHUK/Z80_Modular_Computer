/*
 * preTTY.c
 *
 * Created: 19/08/2021 19:33:30
 * Author : kaltchuk
 */ 

#define F_CPU			20000000UL

#define LED				PORTB1
#define LED_ON			PORTB |= (1<<LED)
#define LED_OFF			PORTB &= ~(1<<LED)

#define INPUT			1
#define OUTPUT			0

#include <stdlib.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define UBRR_2400		520
#define UBRR_4800		259
#define UBRR_9600		129
#define UBRR_14400		86
#define UBRR_19200		64
#define UBRR_28800		42
#define UBRR_38400		32
#define UBRR_57600		21
#define UBRR_76800		15
#define UBRR_115200		10
#define UBRR_1250000	0

#define MAX_BUFF_SIZE	256
char	RX_buff[MAX_BUFF_SIZE];
int		RX_wr_ptr=0, RX_rd_ptr=0;
char	TX_buff[MAX_BUFF_SIZE];
int		TX_wr_ptr=0, TX_rd_ptr=0;

// ************************** //
// ******** FUNCTIONS ******* //
// ************************** //
void init_DDR(void)		// Configure I/O pins
{
	// keep in mind that 0=In, 1=Out
	DDRB &= 0xf8;		// mask = X  X  X  X  X  In In In --> &11111000
	DDRC &= 0xf8;		// mask = X  X  X  X  X  In In In --> &11111000
	DDRD &= 0x03;		// mask = In In In In In In X  X  --> &00000011
}

void init_USART(unsigned int ubrr)
{
	/* Set baud rate */
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;

	/* Enable receiver and transmitter */
	UCSR0B = (1<<RXEN0)|(1<<TXEN0);

	/* Set frame format: 8N1 */
	UCSR0C = (3<<UCSZ00);
}

int	TX_buff_use(void)	// Returns the number of charS that have to be transmitted
{
	return abs(TX_wr_ptr - TX_rd_ptr);
}

void send_char(void)	// Transmit the next char in the TX_buff
{
	/* Wait for empty transmit buffer */
	while ( !( UCSR0A & (1<<UDRE0)) )
	;
	/* Put data into buffer, sends the data */
	UDR0 = TX_buff[TX_rd_ptr++];
	if (TX_rd_ptr == MAX_BUFF_SIZE)
	TX_rd_ptr = 0;
}

void config_data_pins(int direction)
{
	if (direction == INPUT)
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

// ************************** //
// *** INTERRUPT SERVICES *** //
// ************************** //
ISR(USART_RX_vect)		// Catch an incoming char on the serial port and put it on the RX_buff
{
	RX_buff[RX_wr_ptr++] = UDR0;
	if (RX_wr_ptr == MAX_BUFF_SIZE)
	RX_wr_ptr = 0;
	reti();
}

ISR(INT0_vect)			// Houston, we got a chip_select... CPU wants something
{
	// ...
	reti();
}


// ************************** //
// ****** MAIN PROGRAM ****** //
// ************************** //

int main(void)
{
	init_DDR();
	init_USART(UBRR_9600);
	sei();
	
	while (1)
	{
		if(TX_buff_use() > 0)
		{
			send_char();
		}
	}
}

