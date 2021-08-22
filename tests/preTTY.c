/******************************************************************************
 * preTTY.c
 *
 * Created: 19/08/2021 11:51:55
 * Author : kaltchuk
 * 
 ******************************************************************************
 * ATmega328 pin use for preTTY:
 *             7     6     5     4     3     2     1     0
 * PORT B	XTAL2 XTAL1  SCK  MISO  MOSI   D02   D01   D00
 * PORT C    ----- RESET   nc   nc    nc    WR    RD    A01
 * PORT D     D07   D06   D05   D04   D03   CS    TX    RX
 *
 * RESET, WR, RD and CS are all active low signals.
 ******************************************************************************
 * The logic:
 *
 * In the main loop, just keep checking if there is something in the
 * TX buffer. If so, xmit it and update the TX_rd_ptr.
 *
 * If a new char arrived at the serial port, a UART_RX_complete
 * interrupt will be generated and ISR(USART_RX_vect) will
 * put the char in the RX buffer and update the RX_wr_ptr.
 * 
 * If chip select is true, which means that the CPU wants something,
 * an expternal interrupt will be generated and ISR(INT0_vect) will
 * check what the CPU wants. The 3 options are:
 *
 * 1) read status, i.e. check if there are new chars available in the
 *    RX_buff.
 * 2) read data, i.e. pick a char from RX buffer and update RX_rd_ptr.
 * 3) write data, i.e. put a char on TX buffer and update TX_wr_ptr.
 *
 *****************************************************************************/
 
#define F_CPU			20000000UL
#define BAUD 			125000
#define MYUBRR 			((F_CPU/16/BAUD)-1)

#define MAX_BUFF_SIZE	256

#define asInput			1
#define asOutput		0

#define WR_data			3
#define RD_status		4
#define RD_data			5

#define D0pin			0
#define D1pin			1
#define D2pin			2
#define D3pin			3
#define D4pin			4
#define D5pin			5
#define D6pin			6
#define D7pin			7
#define A01pin			0
#define RDpin			1
#define WRpin			2
#define CSpin			2

#include <stdlib.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

char	RX_buff[MAX_BUFF_SIZE];		// stuff that came through the serial port
int		RX_wr_ptr=0, RX_rd_ptr=0;

char	TX_buff[MAX_BUFF_SIZE];		// stuff that has to be sent through the serial port
int		TX_wr_ptr=0, TX_rd_ptr=0;

// ************************************************************************* //
//                                FUNCTIONS                                  //
// ************************************************************************* //
void init_DDR(void)		// Configure I/O pins direction
{
						// keep in mind that 0=In, 1=Out
	DDRB &= 0xf8;		// mask = X  X  X  X  X  In In In --> &11111000
	DDRC &= 0xf8;		// mask = X  X  X  X  X  In In In --> &11111000
	DDRD &= 0x03;		// mask = In In In In In In X  X  --> &00000011
}

// ************************************************************************* //
void init_USART(unsigned int ubrr)		// Configure USART parameters
{
	/* Set baud rate */
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;

	/* Enable receiver, transmitter and RX_complete interrupt */
	UCSR0B = (1<<RXCIE0)|(1<<RXEN0)|(1<<TXEN0);

	/* Set frame format: 8N1 */
	UCSR0C = (3<<UCSZ00);
}

// ************************************************************************* //
void init_EI0(void)		// Enable INT0 (this is our chip select)
{
	EIMSK = (1<<INT0);
}

// ************************************************************************* //
void config_data_pins(int direction)
{
		if (direction == asInput)
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

// ************************************************************************* //
//                           INTERRUPT SERVICES                              //
// ************************************************************************* //
ISR(USART_RX_vect)		// Catch an incoming char on the serial port and put it on the RX_buff
{
	RX_buff[RX_wr_ptr++] = UDR0;
	if (RX_wr_ptr == MAX_BUFF_SIZE)
		RX_wr_ptr = 0;
	reti();
}

// ************************************************************************* //
ISR(INT0_vect)			// Houston, we got a chip_select... CPU wants something
{
	char data;
	
	switch (PINC & 0x7)		// get only 3 LSB (wr, rd, a01)
	​{
		case RD_status:
			config_data_pins(asOutput);
			if ((RX_rd_ptr - RX_wr_ptr) != 0)
			{
				PORTB |= 0x7;		// reply 0xff to CPU
				PORTD |= 0xf8;
			}
			else
			{
				PORTB &= 0xf8;		// reply 0 to CPU
				PORTD &= 0x7;
			}
			while (!(PINC & (1<<RDpin)))	// wait till CPU releases RD signal
				;
			config_data_pins(asInput);
			break;

		case RD_data:
			config_data_pins(asOutput);
			data = RX_buff[RX_rd_ptr++]
			if (RX_rd_ptr == MAX_BUFF_SIZE)
				RX_rd_ptr = 0;
			PORTB = (PORTB & 0xf8)|(data & 0x7);
			PORTD = (PORTD & 0x7)|(data & 0xf8);
			while (!(PINC & (1<<RDpin)))	// wait till CPU releases RD signal
				;
			config_data_pins(asInput);
			break;

		case WR_data:
			data = (PINB & 0x7)|(PIND & 0xf8);
			TX_buff[TX_wr_ptr++] = data;
			if (TX_wr_ptr == MAX_BUFF_SIZE)
				TX_wr_ptr = 0;
			break;

	}
	while (!(PIND & (1<<CSpin)))		// wait till CPU releases IORQ signal
		;
	reti();
}

// ************************************************************************* //
//                               MAIN PROGRAM                                //
// ************************************************************************* //
int main(void)
{
	init_DDR();
	init_USART(MYUBRR);
	init_EI0();
	sei();
	
    while (1) 
    {
		if((TX_wr_ptr - TX_rd_ptr) != 0) // check if TX buffer is empty
		{
			/* Wait for empty transmit register */
			while ( !( UCSR0A & (1<<UDRE0)) )
				;
			UDR0 = TX_buff[TX_rd_ptr++];
			if (TX_rd_ptr == MAX_BUFF_SIZE)
				TX_rd_ptr = 0;
		}
    }
}

