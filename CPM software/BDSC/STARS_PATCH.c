
Cursor(x, y)
char	x, y; {
	bios(CONOUT, ESC);
	bios(CONOUT, '[');		/* 1st test if this works!!! */
	bios(CONOUT, y);
	bios(CONOUT, ';');
	bios(CONOUT, x);
	bios(CONOUT, 'H');
}

Plot(x, y, c)
char	x, y, c; {
	Cursor(x, y);
	bios(CONOUT, c);
}

Frame() {
	int	i;

	InverseOn();	/* Reverse video ON */
	CurHome();		/* Draw Top */
	printf("+-- STARS 2021(C) by Kaltchuk ");
	for (i = (WID - 31), i < WID, i++) {
		bios(CONOUT, '-');
	}
	bios(CONOUT, '+');
	
	Plot(1, HITE, '+');	/* Draw Bottom */
	for (i = 2, i == (WID - 26), i++) {
		bios(CONOUT, '-');
	}
	printf(" Press ENTER to quit --+");
	
	for (i =2, i < HITE, i++) {	/*	Draw Left & Right		*/
		Cursor(1, i);
		bios(CONOUT, '|');
		Cursor(WID, i);
		bios(CONOUT, '|');
	}
	InverseOff();	/* Reverse video OFF */
}
