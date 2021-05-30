/*
	Line printer formatter 

	Written by Leor Zolman
		   May 28, 1980

	First prints all files named on the command line, and then
	asks for names of more files to print until a null line is typed.
	Control-Q aborts current printing and goes to next file.

	Paper should be positioned ready to print on the first page; each
	file is always printed in an even number of pages so that new files
	always start on the same phase of fan-fold paper.

	Tabs are expanded into spaces.
*/

#define FF 0x00		/* formfeed character, or zero if not supported */
#define PGLEN 66	/* lines per lineprinter page */

int colno, linesleft;

main(argc,argv)
char **argv;
{
	int i;
	int pgno, date[20], linebuf[135];
	char fnbuf[30], *fname;
	int fd, ibuf[134];
	char *gets();
	pgno = colno = 0;
	linesleft = PGLEN; 
	printf("What is today's date? ");
	gets(date);
	while (1)
	{
		if (argc-1)
		 {
			fname = *++argv;
			argc--;
		 }
		else
		 {
			printf("\nEnter file to print, or CR if done: ");
			if (!*(fname = gets(fnbuf))) break;
		 }

		if ((fd = fopen(fname,ibuf)) == -1)
		 {
			printf("Can't open %s\n",fname);
			continue;
		 }
		else printf("\nPrinting %-13s",fname);

		for (pgno = 1; ; pgno++)
		 {
			putchar('*');
			sprintf(linebuf,"\n%28s%-13s%5s%-3d%20s\n\n",
				"file: ",fname,"page ",pgno,date);
			linepr(linebuf);
		loop:	if (!fgets(linebuf,ibuf)) break;
			if (kbhit() && getchar() == 0x11) break;
			linepr(linebuf);
			if (linesleft > 2) goto loop;
			formfeed();
		 }
		formfeed();
		if (pgno % 2) formfeed();
		fabort(fd);
	}
}

linepr(string)
char *string;
{
	char c;
	while (c = *string++)
	  switch (c) {
	    case '\n':	
		putlpr('\r');
		putlpr('\n');
		colno = 0;
		linesleft--;
		break;

	    case '\t':
		do {
		  putlpr(' ');
		  colno++;
		} while (colno % 8);
		break;

	    default:					
		putlpr(c);
		colno++;
	}
}

putlpr(c)
char c;
{
	bios(5,c);
}

formfeed()
{
	if (FF) putlpr(FF);
	else while (linesleft--) putlpr('\n');
	linesleft = PGLEN;
}
