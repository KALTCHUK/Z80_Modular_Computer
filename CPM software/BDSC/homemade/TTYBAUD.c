/*
 TTYBAUD v1.0 by Katchuk, dec/2021

 Change TTY port baud rate
*/

#include <stdio.h>

#define	ESC		0x1b
#define MAXPORT		0xff
#define MAXOPTION	0xa

int	str2int(linha, max)
char	*linha;
int	max; {

	int	p, i;

	i = 0;
	p = 0;
	while(linha[i] != 0) {
		if((linha[i] < '0') | (linha[i] > 'f'))
			return(max + 1);
		if((linha[i] > '9') & (linha[i] < 'A'))
			return(max + 1);
		if((linha[i] > 'F') & (linha[i] < 'a'))
			return(max + 1);

		if((linha[i] >= '0') & (linha[i] <= '9'))
			p = (16 * p) + linha[i] - '0';

		if((linha[i] >= 'A') & (linha[i] <= 'F'))
			p = (16 * p) + linha[i] - 'A' + 0xa;

		if((linha[i] >= 'a') & (linha[i] <= 'f'))
			p = (16 * p) + linha[i] - 'a' + 0xa;

		i++;
	}
	return(p);
}

main() {
	char	portline[8];
	char	optionline[8];
	int	port;
	char	cport;
	int	option;
	char	coption;
	char	speed[8];
	int	i;

	printf("TTYBAUD v1.0 by Kaltchuk, 12/2021\n\r\n\r");
	port = 0;
	do {
		printf("Port address (one hex byte)? ");
		gets(portline);
		port = str2int(portline, MAXPORT);
		if(port > MAXPORT)
			printf("\n\rInvalid port number.\n\r");
	} while(port > MAXPORT);

	printf("\n\rBaud rate options (in bps):\n\r");
	printf("   0 =   1200\n\r");
	printf("   1 =   2400\n\r");
	printf("   2 =   4800\n\r");
	printf("   3 =   9600\n\r");
	printf("   4 =  14400\n\r");
	printf("   5 =  19200\n\r");
	printf("   6 =  28800\n\r");
	printf("   7 =  38400\n\r");
	printf("   8 =  57600\n\r");
	printf("   9 = 125000\n\r");
	printf("   A = 250000\n\r\n\r");

	do {
		printf("Which option? ");
		gets(optionline);
		option = str2int(optionline, MAXOPTION);
		if(option > MAXOPTION)
			printf("\n\rInvalid option.\n\r");

	} while(option > 0xa);

	switch(option) {
		case 0:
			strcpy(speed, "1200");
			break;
		case 1:
			strcpy(speed, "2400");
			break;
		case 2:
			strcpy(speed, "4800");
			break;
		case 3:
			strcpy(speed, "9600");
			break;
		case 4:
			strcpy(speed, "14400");
			break;
		case 5:
			strcpy(speed, "19200");
			break;
		case 6:
			strcpy(speed, "28800");
			break;
		case 7:
			strcpy(speed, "38400");
			break;
		case 8:
			strcpy(speed, "57600");
			break;
		case 9:
			strcpy(speed, "125000");
			break;
		case 10:
			strcpy(speed, "250000");
			break;
	}
	i = 0;
	while(portline[i] != 0)
		portline[i] = toupper(portline[i++]);
	printf("\n\rSet port '%s' to %s bps (y or n)? ", portline, speed);

	cport = port +2;
	coption = option;

	gets(optionline);
	if((optionline[0] == 'y') | (optionline[0] == 'Y'))
		outp(cport, coption);
}

