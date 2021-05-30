
/*
	This command prints out a given file with line
	numbers. Usage:

		A>pnum filename <cr>

	written by Leor Zolman
		   Jan, 1980
	modified March 1980 to make all printing take place in one
	(short)	statement. Try THAT with BASIC!
*/

main(argc,argv)
char **argv;
{
	int fd, lnum;
	char ibuf[134], linebuf[132];

	if (argc != 2) {
		printf("Usage: pnum filename\n");
		exit();
	}
	if ((fd = fopen(argv[1], ibuf)) == -1) {
		printf("cannot open: %s\n",argv[1]);
		exit();
	}
	lnum = 1;
	while (fgets(linebuf, ibuf))
		 printf("%3d: %s",lnum++,linebuf);
}

