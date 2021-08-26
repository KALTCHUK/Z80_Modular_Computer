/*
 * 
 *
 * Created: 26/08/2021 11:51:55
 * Author : kaltchuk
 */ 

#define MAX_BUF		80

char	TX_buff[MAX_BUF];
int		rdPtr=0;
int		wrPtr=0;

void hex2ascii(char hexval)
{
	char nibble;
	
	nibble = hexval >> 4;	// convert upper nibble
	if (nibble > 9)
		nibble += 0x56;
	else
		nibble += 0x30;
	
	storeChar(nibble);
	
	nibble = hexval & 0x0f;	// convert lower nibble
	if (nibble > 9)
		nibble += 0x56;
	else
		nibble += 0x30;
	
	storeChar(nibble);
}

void storeChar(char storeThis)
{
	TX_buff[wrPtr++] = nibble;
	if (wrPtr == MAX_BUF)
		wrPtr = 0;
}

void sendChar(void)
{
	while ( !( UCSR0A & (1<<UDRE0)) )
	{}
	UDR0 = TX_buff[rdPtr++];
	if (rdPtr == MAX_BUF)
		rdPtr = 0;

}

ISR(INT0_vect)
{
	char	ssPINB, ssPINC, ssPIND;		//snapshots from I/O pins
	
	ssPINB = PINB;
	ssPINC = PINC;
	ssPIND = PIND;
	
	hex2ascii(ssPINB);
	storeChar(0x20);
	hex2ascii(ssPINC);
	storeChar(0x20);
	hex2ascii(ssPIND);
	storeChar(0x0d);
	storeChar(0x0a);
}

void main(void)
{
	...
	
	while ()
	{
		if (wrPtr != rdPtr)
			sendChar();
	}
}