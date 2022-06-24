/*
 PROTON v1.0 by Katchuk, dec/2021

 Do the Matrix effect on screen
*/

#include <stdio.h>

#define	ESC		0x1b

char	c[120];

void	insline() {
	printf("%c[1;1H", ESC);
	printf("%c[1;1H%c[L", ESC, ESC);
}


void	clear() {
	printf("%c[2J", ESC);
}

void	greeting() {

	printf("%c[15;1H", ESC);

	clear();
	printf("                                   WELCOME TO THE\r\n\r\n\r\n");
	printf("                                 @@      @@    @@   @@@@@@@@ @@@@@@  @@@@ @@@   @@@\r\n");
	printf("                                 @@@    @@@   @@@@     @@    @@   @@  @@   @@   @@\r\n");
	printf("                                 @@@@  @@@@  @@  @@    @@    @@   @@  @@    @@ @@\r\n");
	printf("                                 @@ @@@@ @@ @@    @@   @@    @@@@@@   @@     @@@\r\n");
	printf("                                 @@  @@  @@ @@@@@@@@   @@    @@ @@    @@    @@ @@\r\n");
	printf("                                 @@      @@ @@    @@   @@    @@  @@   @@   @@   @@\r\n");
	printf("                                 @@      @@ @@    @@   @@    @@   @@ @@@@ @@@   @@@");

	sleep(80);

	printf("%c[18;20H", ESC);
	printf("                   @@@@@@  @@@@@@   @@@    @@@@@@@@  @@@    @@   @@\r\n");
	sleep(10);
	printf("%c[21;20H", ESC);
	printf("                @@@@@@  @@@@@@  @@   @@    @@    @@   @@ @@ @@@@\r\n");
	sleep(10);
	printf("%c[23;20H", ESC);
	printf("              @@      @@  @@  @@   @@    @@    @@   @@ @@   @@  \r\n");
	sleep(10);
	printf("%c[20;20H", ESC);
	printf("                 @@   @@ @@   @@ @@   @@    @@    @@   @@ @@@@ @@\r\n");
	sleep(10);
	printf("%c[22;20H", ESC);
	printf("               @@      @@ @@   @@   @@    @@    @@   @@ @@  @@@\r\n");
	sleep(10);
	printf("%c[19;20H", ESC);
	printf("                  @@   @@ @@   @@ @@   @@    @@    @@   @@ @@@  @@\r\n");
	sleep(10);
	printf("%c[24;20H", ESC);
	printf("             @@      @@   @@    @@@     @@       @@@  @@   @@     \r\n\r\n");
	printf("                                                                    by Kaltchuk 2021");

	printf("%c[40;20H", ESC);
}

main() {
char	caracter;
int	i;

	greeting();
	srand(0);
	printf("%c[1;1H", ESC);

	for(i=0; i<120; c[i++] = 0)

	while(1) {
		for(i=0; i<120; i++) {
			if(c[i]==0) {
				c[i] = rand() % 0xff;
				if(c[i]>15) c[i] = 0;
			}
			if(c[i] == 0) printf(" ");
			else {
				c[i] -= 1;
				do {
					caracter = rand() % 0x7f;
				} while(caracter < 0x20);
				printf("%c", caracter);
			}			
		}
		insline();
	}
}

