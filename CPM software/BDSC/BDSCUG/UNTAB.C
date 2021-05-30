/*
	prog to take a text file full of tabs
	and turn them into the right number of spaces:
*/

#define CR 0x0d
#define LF 0x0a
#define BS 0x08
#define EOF 255
#define CPMEOF 0x1a
#define ERRORCODE -1
#define TAB 0x09

char ibuf[134], obuf[134];

main(argc,argv)
char **argv;
{
	int fd1, fd2, col;
	char c;
	int i;
	fd1 = fopen(argv[1],ibuf);
	fd2 = fcreat(argv[2],obuf);
	if (fd1 == ERRORCODE || fd2 == ERRORCODE) {
		printf("Open error.\n");
		exit();
	}
	col = 0;
	while ((c=getc(ibuf)) != EOF) {
		switch(c) {
		 	case CR: col = 0;
			case LF: putc2(c,obuf);
				 continue;

			case TAB: do {  
				   putc2(' ',obuf);
				   col++;
				  } while (col%8);
				  continue;
			default:   col++;
		 }
		putc2(c,obuf);
	 }
	fflush(obuf);
	close(fd1);
	close(fd2);
}

putc2(c,obuf)
char c;
{
	putchar(c);
	putc(c,obuf);
}

