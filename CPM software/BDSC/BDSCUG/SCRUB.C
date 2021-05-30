/*
	Program to copy a file deleting:
		all non tab,lf,cr,ff control chars
*/

/*
	Macros for constant definitions
*/

#define ERROR -1	/* error flag returned by buffered i/o routines */
#define EOFF -1		/* end of file marker returned by getc() */
#define EOF 0x1A	/* CP/M's end file char for ascii files */
#define NOFILE -1	/* no such file indication given by fopen() */

/*
	Argument vector indices
*/

#define FROM_FILE 1
#define TO_FILE   2

/*
	main to open the files for scrub()
	and handle invocation errors.
*/

main(argc,argv)
  int argc;
  char *argv[];
  {
  int fdin,fdout;
  char inbuf[134],outbuf[134];

  if( argc != 3 ) {
    puts("Correct invocation form is:\n\n");
    puts(" SCRUB <from file> <to file>\n");
    }
  else if( (fdin = fopen(argv[FROM_FILE],inbuf)) == NOFILE )
    printf("No such file %s\n",argv[FROM_FILE]);
  else if( (fdout  = fcreat(argv[TO_FILE],outbuf)) == ERROR )
    printf("Can't open %s\n",argv[TO_FILE]);
  else
    scrub(inbuf,outbuf);
  exit();
  }

/*
	procedure scrub -- copy file to file deleting unwanted ctrl chars
*/

scrub(filein,fileout)
  char filein[];	/* the input file buffer */
  char fileout[];	/* the output file buffer */
  {
  int c;		/* 1 char buffer */
  unsigned killed;	/* numbers of bytes deleted */

  killed = 0;
  while( (c = getc(filein)) != EOFF  && c != EOF )
    if( c >= ' ' && c < '\177' ) /* is a visable character */
      putc(c,fileout);
    else
      switch(c) {
        case '\r':
        case '\n':
        case '\t':
        case '\f':	putc(c,fileout);	/* ok control chars */
			break;

        default:	killed++;
			break; /* ignore it */
        }
  putc(EOF,fileout); /* sent textual end of file */
  if( fflush(fileout) == ERROR)
    exit(puts("output file flush error\n"));
  printf("%u characters were deleted\n",killed);
  }	/* end scrub */

