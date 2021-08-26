/*
 * 
 *
 * Created: 24/07/2021 11:51:55
 * Author : kaltchuk
 */ 

#define MAX_BUF		80

char	TX_buff[MAX_BUF];
int		rdPtr=0;
int		wrPtr=0;

void xmitString(char *buffer)
{
	while (rdPtr != wrPtr)
	{
		while ( !( UCSR0A & (1<<UDRE0)) )
		{}
		UDR0 = TX_buff[rdPtr++];
		if (rdPtr == MAX_BUF)
			rdPtr = 0;
	}
}

void hex2ascii(char hexval)
{
	char nibble;
	
	nibble = hexval >> 4;	// convert upper nibble
	if (nibble > 9)
		nibble += 0x56;
	else
		nibble += 0x30;
	
	TX_buff[wrPtr++] = nibble;
	if (wrPtr == MAX_BUF)
		wrPtr = 0;
	
	nibble &= 0x0f;	// convert lower nibble
	if (nibble > 9)
		nibble += 0x56;
	else
		nibble += 0x30;
	
	TX_buff[wrPtr++] = nibble;
	if (wrPtr == MAX_BUF)
		wrPtr = 0;
	
}