/*
	Freak out program for H19 terminals
	-----------------------------------
	Written By Leor Zolman	    5/26/80
*/

#define X_OFF 0x13
#define X_ON  0x11

char stopf;

main()
{
	int mf;
	char i,ch,c;
	char line;

	while (1)
	{
	 stopf = 0;
	 if (bdos(2)) bdos(3);	/* clear input status */

	 do {
	   srand1("\033E\033y5Density factor (1-15, or 0 to quit)? ");
	   if (!scanf("%d",&mf)) mf = 7;
	 } while (mf > 15);

	 if (!mf) {
		puts("\033z");
		return;
	  }
	 mf = (1 << (16-mf)) - 1;

	 puts("Character to use? ");
	 if (!scanf("%c",&ch) || ch == '\n') ch = ' ';
	 puts("\033E\033p\033x5");	/* enter reverse video */

	   while(1)
	   {
		for (i=' '; i<111; i++)
			if (rand() & mf) continue;
			else {
			  putchar('\033'); putchar('Y');
			  putchar(' '); putchar(i); putchar(ch);
			}
		if (stopf) break;
		puts("\033L");
	   }

	}
}

putchar(c)
char c;
{
	bios(4,c);
	if (bios(2)) {
		if ((c = bios(3)) == X_OFF)
			while (bios(3) != X_ON);
		else stopf = 1;
	}
}

