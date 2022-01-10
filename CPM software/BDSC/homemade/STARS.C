/*
 STARS.C does the same as STARS.BAS.
*/

#include <stdio.h>

#define ESC	27
#define WID	80
#define HITE	40

itoa(i)
int	i; {
	int	d;

	d = i / 10;
	if (d > 0) {
		putchar(d + 48);
	}
	i = i - (10 * d);
	putchar(i + 48);
}

Cursor(x, y)
int	x, y; {
	putchar(ESC);
	putchar('[');
	itoa(y);
	putchar(';');
	itoa(x);
	putchar('H');
}

Plot(x, y, c)
int	x, y;
char	c; {
	Cursor(x, y);
	putchar(c);
}

Frame() {
	int	i;

	Cls();
	RevOn();		/* Reverse video ON */

	CurHome();		/* Draw Top */
	printf("+-- STARS 2021(C) by Kaltchuk ");
	for (i = 1; i < (WID-30); i++) {
		putchar('-');
	}
	putchar('+');
	
	Plot(1, HITE, '+');	/* Draw Bottom */
	for (i = 2; i <= (WID - 25); i++) {
		putchar('-');
	}
	printf(" Press Ctrl-C to quit --+");

	for (i = 2; i < HITE; i++) {
		Cursor(1, i);
		putchar('|');
		Cursor(WID, i);
		putchar('|');
	}
	
	RevOff();		/* Reverse video OFF */
}

Cls() {
	putchar(ESC);
	puts("[2J");
}

CurHome() {
	putchar(ESC);
	puts("[H");
}

RevOn() {
	putchar(ESC);
	puts("[7m");
}

RevOff() {
	putchar(ESC);
	puts("[0m");
	putchar(ESC);
	puts("[?25l");
}
 
main() {
	int	x, y, lena, i, dt;
	char	c;
	char	astros[21];
	char	delay[10];

	strcpy(astros, ".,o*x               ");
	lena = strlen(astros);

	srand(0);

	printf("\nDelay (in ms)?");
	gets(delay);
	dt = atoi(delay) / 50;
	Frame();

	do {
		do {
			x = rand() % WID;
		} while (x <= 1);
		do {
			y = rand() % HITE;
		} while (y <= 1);

		i = rand() % 20;
		Plot(x, y, astros[i]);
		sleep(dt);
	} while (bios(2) == 0);
	Cls();
	CurHome();
	exit();
}

/*-----------*/

