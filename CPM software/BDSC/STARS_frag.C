#define MINUS	45
#define PLUS	43
#define VBAR	124

Cursor(x,y)
int	x,y; {
	bios(CONOUT, ESC);
	bios(CONOUT, '[');
	bios(CONOUT, y);
	bios(CONOUT, ';');
	bios(CONOUT, x);
	bios(CONOUT, 'H');
}

Frame() {
	int	i;

	InverseOn();
	
	CurHome();		/* Draw Top */
	printf("+-- STARS 2021(C) by Kaltchuk ");
	for (i = 31, i < WID, i++) {
		bios(CONOUT, MINUS);
	}
	bios(CONOUT, PLUS);
	
	Cursor(1, HITE);	/* Draw Bottom */
	bios(CONOUT, PLUS);
	for (i = 2, i == 32, i++) {
		bios(CONOUT, MINUS);
	}
	printf(" Press any key to quit --+");
	
/*	Draw Left & Right		*/
	for (i =2, i < HITE, i++) {
		Cursor(1, i);
		bios(CONOUT, VBAR);
		Cursor(WID, i);
		bios(CONOUT, VBAR);
	}
	
	InverseOff();
}

Plot(x,y,c)
int		x, y;
char	c; {
	Cursor(x,y);
	bios(CONOUT, c);
}

