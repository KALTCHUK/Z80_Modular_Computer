/*  
 STARS.C is the C-version of STARS.BAS.
 
 Made for VT-100 console only.

20 E$=CHR$(27)
30 CLRSCR$=E$+"[2J"
40 REVCHR$=E$+"[7m"
50 ATTOFF$=E$+"[0m"
60 CURHOM$=E$+"[H"
70 PRINT CLRSCR$;REVCHR$;CURHOM$;


*/

#include <stdio.h>

#define CONST	2	// BIOS function CONST
#define CONIN	3	// BIOS function CONIN
#define CONOUT	4	// BIOS function CONOUT

#define HITE	20	// Frame hight.
#define WID		60	// Frame width.

#define	ESC		27

clearscreen()
{
	char	cls[] = "[2J"
	
	bios(CONOUT, ESC);				// Clear screen ESC sequence 
	while (cls[i] != '\n') {
		bios(CONOUT, cls[i++]);
	}
	
}

drawframe
{
	
}

plot(x,y,c)
int		x, y;
char	c;
{
	
}

main (argc, argv)
int argc;
char *argv[];
{
	int		x, y, c;
	char	astro[] = ".,+*o ;
	
	srand(0);						// Get random seed
	clearscreen();
	drawframe();
	
	do {								// Start populating the sky
		x = (rand() % (WID-1)) + 1;		// Get random x
		y = (rand() % (HITE-1)) +1;		// Get random y
		c = rand() % 20;				// Get random c
		if (c>5)	c = 5;
		
		plot(x, y, astro[c]);
	} while (bios(CONST) == 0);

}
