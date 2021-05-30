
/*
	This program was written to simplify mass file
	transfers on a single-drive disk system (like mine.)
	The following things must be on the disk when you run
	copyall:
		1) the "copyall" program,
		2) the files you wish to transfer (copy),
		3) a text file containing
		   the names of all the files to be copied.

	*************************************************
	* NOTE: None of the files you try to transfer	*
	*	should be any longer than BUFSIZ bytes	*
	*	in length (copyall will check for this.)*
	*************************************************


	Example of use:
	If you want to copy the files "FOO.C", "BAR.C", "ZOT.C"
	and "FRAZ.ASM", then first edit a file (say, "CLIST")
	to appear as follows:

	-----------------------------
	foo.c <cr>
	bar.c <cr>
	zot.c <cr>
	fraz.asm <cr>
	-----------------------------

	The format is: one filename per line, no spaces or tabs anywhere.
	(the dashed lines should NOT be in the file...<cr> means CR-LF.)

	Then, to copy the files, just say:

	A>copyall <cr>

	answer "clist" when it asks you for the name of the
	control file, and let "copyall" do the rest!
*/

#define CPMSIZE 56	/* the amount of RAM in your
				 CP/M  system, in K	*/
#define BUFSIZ (CPMSIZE-17)*1024 /* size of data buffer	*/
#define MAXFILES 30

char fnames[MAXFILES][13];	 /*	file names	*/
int nrecs[MAXFILES];	/* # of records in each file	*/
int fnc;	/* # of files in currently in buffer	*/

char buf[BUFSIZ], *bufp;

int ffd;	/* file descriptor for source files	*/
char ibuf[134];		/* I/O buffer for filename file */

char done, partly;	/*	flags			*/

char control[20];	/* name of control file		*/
int ncopies;		/* number of copies to make	*/

main()
{
	int fd1;	/* file descriptor of file list file */
	done = 0;	/* Not done yet */
	partly = 0;	/* not partly done reading in a file */
	printf("BDS Single Disk Mass File Copy Program\n\n");
	printf("How many copies? ");
	ncopies = atoi(gets(control));

	printf("Insert source disk (it must contain the\n");
	printf("files to be copied AND the control file\n");
	printf("containing the names of the files to be\n");
	printf("copied. Hit return when source disk is in: ");
	getchr();
	printf("What is the control file named? ");
	gets(control);
	fd1 = fopen(control,ibuf);
	if (fd1 == -1) {
		printf("Can't read %s\n",control);
		exit();
	}

	while (fillbuf()) {
		dumpbuf();
	}
	printf("All done!\n");
	close(fd1);
}


/*
	Routine to fill up the memory buffer as much as
	possible. If it fills up in the middle of reading
	in a file, set the "partly" flag and get the rest
	of the file next time. Returns 0 when nothing left
	to read in, else returns 1.
*/

fillbuf()
{
	int i,ii,nr;
	if (done) return 0;
	if (partly) {
		printf("Loading rest of %s\n",fnames[fnc]);
		movmem(bufp - (nr = nrecs[fnc] * 128), buf,nr);
		strcpy(fnames[0], fnames[fnc]);
		bufp = buf + nr;
		i = 0;
		do {
			if (bufp + 1023 >= buf + BUFSIZ) {
				printf("\7\nFile too big. Aborting.\n");
				exit();
			 }
			i += (ii = read(ffd, bufp, 8));
			bufp += ii * 128;
		} while (ii == 8);
		nrecs[0] = nrecs[fnc] + i;
		fnc = 1;
		partly = 0;
		close(ffd);
	 }
	else {
		bufp = buf;
		fnc = 0;
	 }

	do {
		partly = 1;

		if ( !fscanf(ibuf, "%s\n", &fnames[fnc]) ||
					fnames[fnc][0] == '\0')
			return done = 1;

		ffd = open(fnames[fnc], 0);
		if (ffd == -1) {
			printf("\7\nCan't open %s...",fnames[fnc]);
			printf("Skipping that one.\n\n");
			partly = 0;
			continue;
		 }
		else printf("Loading %s\n",fnames[fnc]);

		nrecs[fnc] = 0;
		while (bufp + 1023 < buf + BUFSIZ) {
		   nr = read(ffd, bufp, 8);
		   if (nr == -1) {
			printf("\7\nRead error. aborting.\n");
			exit();
		   }
		   bufp += nr * 128;
		   nrecs[fnc] += nr;
		   if (nr != 8) {
			fnc++;
			close(ffd);
			partly = 0;
			break;
		    }
		 }
	  if (!fnc) {
		printf("\7\nFile too long. Aborting.\n");
		exit();
	   }
	} while (!partly);
	return 1;
}


/*
	This routine dumps fnc files to the destination
	disk:
*/

dumpbuf()
{
	int fd, i;
	int pass;
	char *bufp;

	for (pass=0; pass<ncopies; pass++) {
	  printf("\nInsert destination disk #%1d: ",pass+1);
	  getchr();
	  bdos(13);	/* log in disk so we don't get R/O error */
	  bufp = buf;
	  for (i=0; i<fnc; i++) {
		if ((fd = creat(fnames[i])) == -1) {
			printf("\7\nCan't create %s\n",fnames[i]);
			break;
		 }
		else printf("Writing %s\n",fnames[i]);
		if ((write(fd, bufp, nrecs[i])) != nrecs[i]) {
			printf("\7\nWrite error on %s\n",fnames[i]);
			break;
		 }
		close(fd);
		bufp += nrecs[i] * 128;
	   }
	 }
	printf("\nPut back source disk: ");
	getchr();
}


/*
	Routine to wait for a key to be typed and then
	echo a CRLF:
*/

getchr()
{
	if (kbhit()) getchar(); /* clear status if kb pre-hit */
	getchar();
	putchar('\n');
}

