/*	The USERDISK program is for the purpose of allowing a
	user of an FSU micro-system to test a diskette for
	errors during read operations.

	The program is initially called by typing USERDISK <cr>.
	The program will request that the disk to be tested
	be inserted in the proper drive, and will then read
	that disk, starting with track 0, section 1, and continuing
	until all sectors have been read.

	If an error is found on track 0 or track 1, it
	is reported as ERROR ON SYSTEM TRACK (0 or 1).

	If an error is found on tracks 2-76, then:

		(a) if the bad sector (group) is not already assigned
		to a file, it is assigned to a file named BAD.BAD

		(b) if the bad sector (group) is already assigned to
		a file, and if that file is not named BAD.BAD, the
		user is queried as to whether to (1) release the file
		and assign the bad sector (group) to BAD.BAD, or
		(2) copy the file to a new file, release the old file,
		and assign the bad sector (group) to BAD.BAD, or (3)
		continue without taking any action.

	All errors are reported by track number, sector number and
	group number.

		JOHN W. NALL
		FLORIDA STATE UNIVERSITY
		COMPUTER CENTER
		TALLAHASSEE, FLORIDA 32306

		Telephone 904-644-2764
*/
#define NULL 0
#define	TRACKS	77	/* number of tracks on disk */
#define SECTORS 26	/* number of sectors per track */
#define SELTRK	10	/* BDOS FUNCTIONS */
#define	SETSEC	11
#define	READSEC 13
#define	TRUE	1
#define	FALSE	0 

struct file {		/* Define what directory entry looks like */
	char et;	/* entry-type */
	char fn[8];	/* file name */
	char ft[3];	/* file type */
	char ex;	/* extent (set to zero so can do compares on FN) */
	char fill[2];	/* (not used) */
	char rc;	/* size in sectors */
	char dm[16];	/* disk map */
	} direct[64];	/* file directory */
/*	Define the outline of file name table (fnt) */
struct fntabl {
	char fname[11];
	char zbyte;
	} fnt[64];	/* table of file names */

int nexsec[27];		/* next physical sector to read */
int logsec[26];		/* next logical sector to read */
int index, sec;
int fdx;	
int grpnum, c, fd1, fd2, nr, dirflag, diskno;
char *grptbl[243]; 	/* group assignment table */
char array[13];
int	FName[20], ibuf[134], obuf[134], buf[128];

main()
{
	int n, m;
	for(n=0;n<26;n++) logsec[n] = n+1;	/* preset logical sectors */
go:


	/* BODY OF PROGRAM - FUNCTION CALLS  */

	putmsg();	/* print initial messages on console */
	readir();	/* read in directory from tracks 0 and 1 */
	bldtbl();	/* build tables of file names and assigned groups */
	tesyst();	/* test system tracks only (tracks 0 and 1) */
	testds();	/* test remainder of disk */
	bdos(13);	/* RE-INITIALIZE SYSTEM FOR SAFETY	*/
	exit();
}

/*	The routine BLDTBL goes through the directory, which has been
	read in already by READIR, and builds a table of file names
	(fnt). Since there may be multiple directory entries for one
	file (because of sectors used by file) a directory entry may
	already be in the fnt.

	After the file name has been placed in the fnt, the disk
	assignments (i.e. group numbers) which are in the directory
	are used to indicate which groups are assigned to that
	particular file, by placing the address of the particular
	fnt entry for that file in the group table.  For example,
	suppose file XNALLX.TST is assigned group numbers 17 and 18
	in the directory. There will be an fnt entry for XNALLX.TST,
	say at address 4fe. Then the array grptbl will have two
	entries pointing to that fnt entry.  That is, grptbl[17] and
	grptbl[18] will both contain an address pointer to 4fe.
*/
 						
bldtbl()
{
	int n, i, j, c, m, hroy;
	for(n=0; n<243; n++)
		grptbl[n] = NULL;	/* initialize group table to zeroes */

	for (n=0; n<64; n++) {		/* initialize file name table  */ 
		fnt[n].zbyte = NULL;
		for (m=0; m<11; m++) 
			fnt[n].fname[m] = NULL;
	}


	for (n=0; n<64; n++)
	{
	  if (direct[n].et == '\345') continue; /* have E5? */
	  else  {		/* else have a file   */      
		j = 0;    

		for(i=0; i<64; i++)	/* see if file already in fnt */
		{
		  direct[n].ex = 0;	/* make sure string terminated */
		  c = strcmp(&(direct[n].fn[0]),&(fnt[i].fname[0]));

		  if (!c)  goto insert; 	/* already in fnt */
		  else if (fnt[i].fname[0] == '\0')
		  {
		   strcpy(&(fnt[i].fname[0]),&(direct[n].fn[0]));
		    goto insert;
		  }
		  else continue;
		}
insert:

	/* now insert address of file-name in group assigned to the file */
		while (direct[n].dm[j] != '\0')
		  {
	  	    grptbl[direct[n].dm[j]] = &fnt[i];
		  j++;
		  }
		}
	}

}

/*	Routine READIR will read the directory in from the disk */
readir()
{
	int k, n;

	initw(nexsec,"1,7,13,19,25,5,11,17,23,3,9,15,21,2,8,14,0,26,6,12,18,24,4,10,16,22,0");
	bios(10,2);	/* select track 2 */
	index = 0;
	k = 0;
	while (sec = nexsec[index++]) {
		bios(12,&(direct[k].et));  /* set DMA */
		bios(11,sec);		/* set sector */
		if (( n = bios(13)) != 0)
			printf("Error on sector: %3d\n",sec);
		k += 4;  

	}
	return;
}
/*	Routine PUTMSG issues the messages to the user to start
	off the program.  Any additional messages to user would
	be added to this routine. 
*/
 
putmsg()	/* initialization messages to user */
{
	char c1;
	char c;
	erase(); 	/* erase screen on console */
	printf("U S E R   D I S K   T E S T\n\n");
	printf("   DISKTEST VERSION 1.02  25 JULY 1980\n\n\n");
	Printf("Need instructions?? (Y/N)(default is Y) ");
	if (c=toupper(getchar()) != 'N')
	  {
	    erase();	
	    printf("\n\nUSERDISK will check a diskette for read errors.\n");
	    printf("If a bad sector is found during a read, one of\n");
	    printf("several alternate actions will be taken:\n\n");
	    printf("  (a) If the sector is on a system track, then\n");
	    printf("  a fatal error message is written.\n\n");
	    printf("  (b) If the sector is on a data track and is not\n");
	    printf("  already assigned, it will be permanently assigned\n");
	    printf("  to a file called BAD.BAD.\n\n");
	    printf("  (c) If the sector is already assigned to a file\n");
	    printf("  (other than BAD.BAD) you will be notified and\n");
	    printf("  asked to select an option (drop the file, copy\n");
	    printf("  to another file, or forge on.\n\n");
	    printf("\n\n***TYPE ANY KEY TO CONTINUE***\n");
	    c = getchar(); 
	}
   	erase();
	printf("SELECT DRIVE: ");
loop:	c = getchar();
	c = toupper(c);
	if (c == 'A' || c == 'B')
	  {
	    diskno = c - 'A';
	    printf("\n\n\nPLACE DISK IN DRIVE %c AND MAKE READY.\n",c);
	    printf("\nTYPE CARRIAGE-RETURN WHEN READY.\n\n");
	    c1 = getchar();
	    printf("Disk selected is: %c\n",c);
	    bdos(14,diskno);	/* select drive */
	    return;    
	  }
	else
	  {
	    printf("\n\nType either A or B\n\n");
	    goto loop;
	  } 
}

/*	This routine should erase either Beehive terminals or ADM-3's. */
erase()
{
	putchar('\033');	/* ESC */
	putchar('E');	/*  E  */
	putchar('\032');  /* CS (ADM3) */
	putchar('\010');  /* BS  */
	putchar(' ');   /* SP  */
	putchar('\010');  /* BS  */
	return;
}
/*	TESYST - test system tracks (0 and 1).
	Reads all sectors of these two tracks.
	If encounters error, prints ERROR ON SYSTEM TRACK!.
*/
tesyst()
{
	int n, m;
	nexsec[16] = 20;	/* This was set to 0 for directory read */
	bios(12,0x80);	/* Set DMA */
	index = 0;
	for (n=0; n<2; n++)
	{
		bios(10,n);	/* select track (0 or 1)	*/
		while(sec=nexsec[index++])
		{
		   bios(11,sec);	/* set sector */
		   if (( m = bios(13) ) != 0)
			printf("ERROR ON SYSTEM TRACK!\n");
		}
		index = 0;
	}
	return;
}

/*	Calculate GROUP when given track and sector.
	Body of the function clearly indicates the algorithm 
	which is used.
	NOTE: The sector is the LOGICAL sector, and not the
	physical sector. Also, this algorithm is only applicable
	to IBM-compatible disks.
*/ 
group(track,sector)
int track, sector;
{
	int  n, m, groupno;
	n = (track-2) * 26;
	m = n + sector-1;
	return(groupno=m/8);
}

testds()
{
	int m, secnum, grpnum;
	int track, sector;
	dirflag = FALSE;

	for(track=2;track<77; track++)
	{
	  index = 0;
	  bios(SELTRK,track);	/* select track		*/
	  while ((sector=nexsec[index++]) != 0)
	  {
		bios(SETSEC,sector);	/* select sector */
		if (bios(READSEC) != 0) /* read sector	 */
		  err(track,index); /* error processor */
	  }
	}
	if (dirflag == TRUE)		/* if directory changed */
 	  close(fdx);	/* Close BAD.BAD	*/
	return;
}
err(track,sector)
int track, sector;
{
	int c2, vv;
	grpnum = group(track,sector);	/* calculate group number */
	erase();
	vv = nexsec[sector-1]; /* get physical sector number */ 
	printf("DISK ERROR! Track %3d Sector %3d Group %3d\n",track,vv,grpnum);

	if(grptbl[grpnum] != 0) 	/*if group assigned to file */
	  printf("Assigned to file: %s\n",grptbl[grpnum]);
	else { putbad(); return; }
	if (strcmp(grptbl[grpnum],"BAD     BAD") == 0 )
	  return;

/* ELSE IS ASSIGNED TO FILE OTHER THAN BAD.BAD	*/

     for(;;) {		/* loop until choose an option	*/
	  printf("\n\nCHOOSE AN OPTION: (Type 1, 2 or 3)\n");
	  printf("  1=release %s and assign group to BAD.BAD\n",grptbl[grpnum]);	  
	  printf("  2=copy %s to new file and assigned group to BAD.BAD\n",grptbl[grpnum]); 
	  printf("  3=continue with no action\n\n");

	switch (c2 = getchar())
	{
	  CASE '1':
		printf("Sure? (y/n) ");
		if(( c=toupper(getchar())) != 'Y') continue;
		else {
			erasfn();	/* erase file */
			*grptbl[grpnum] = 0;
			grptbl[grpnum] = NULL;
			putbad();	/* assign group to BAD.BAD */
			return;
		}

	  CASE '2':
		printf("File to copy to? ");
		gets(FName);
		fd1 = fopen(FName,ibuf);
		if (fd1 != -1) {
		  printf("\nFile already exists!\n");
		  close(fd1);
		  continue;
		}
		fd1 = fcreat(FName,obuf);
		if (fd1 == -1) {
		  printf("\nCannot create file %s\n",FName);
		  continue;
		}
		makfn();
		printf("Opening %s\n",array);
		fd2 = fopen(array,ibuf);
		if (fd2 == -1) {
		  printf("\nCannot open %s\n",grptbl[grpnum]);
		  continue;
		}

		printf("\n\nPRESS RETURN IF GET AN ERROR WHILE COPYING.\n");

		for(;;) {
		  nr = read(fd2,buf,1);
		  if (nr > 0) { write(fd1,buf,1); continue; }
		  else if(nr == 0) { 
			fflush(fd1);
			close(fd1);
			erasfn();
			putbad();
			return;
		}	
		  else if(nr < 0) {
			printf("Checkpoint Joseph.\n");
			for (vv=0;vv<128;vv++)
				buf[vv] = '$';
			write(fd1,buf,1);
			continue;
		  }
		}
	       
	  CASE '3':
		return;

	  default:
		continue;

	}
     }
}
putbad()
{
	char *m;
	int n, index1, index2;
	dirflag = TRUE;
loopo:
	n = srchbad(&index1,&index2);	/* see if BAD.BAD exists */
	if (n<0) { creatbad(); goto loopo; }

/*	at this point, 'index1' is an index into FNT pointing to the
fnt entry for BAD.BAD, and 'index2' points, in DIRECT, to the
directory entry for BAD.BAD.
*/
	fdx = open("BAD.BAD",2);	/* open file */
	if (fdx < 0) {
		printf("Cannot open BAD.BAD!\n");
		exit();
	}
	grptbl[grpnum] = &(fnt[index1].fname[0]);
	for(n=0; n<16; n++) {
		if (( direct[index2].dm[n]) != 0) 
			continue;
		else {
			direct[index2].dm[n] = grpnum;

	/*	put in fcb also	*/
			m = fcbaddr(fdx);	/* get fcb address */
			*(m+15) = (n+1)*8; /* set record count */
			m += 16;	/* point to disk assignment area */
			m += n;		/* point to group in there */
			if (*m != 0) {
			     printf("Funny error! Already assigned!\n");
			     exit();
			}
			else
			     *m = grpnum;	
			return 1;
		}
	}
	printf("\n\n\nBAD.BAD has hit limit of 128 sectors assigned.\n");
	printf("\nRespectfully suggest you junk this disk!\n");
	exit();
}
creatbad(index1,index2)
int *index1, *index2;
{
	int m, n, k;

	m = creat("BAD.BAD");
	if (m<0) {
		printf("Error in creating BAD.BAD\n");
		exit();
	}

	close(m);

	readir();
	bldtbl();
	return;
}
srchbad(index1,index2)
int *index1, *index2;
{
     int n,m;   
     char hroy;	

	for (n=0; n<64; n++) {
		m = strcmp(fnt[n].fname,"BAD     BAD");
		if (m != 0)
			continue;
		else {
			*index1 = n;
			goto srch1;
		}
	}
	return -1;	/* if file not in fnt	*/

	/* if it is in fnt, then get directory pointer */

srch1:
	n = 0;
	for (n=0; n<64; n++) {
		m = strcmp(direct[n].fn,"BAD     BAD");
		if (m != 0)
			continue;
		else {
			*index2 = n;
			return 0;
		}
	}
	printf("Funny error. No directory entry found.\n");
	exit();
}
erasfn()
{
	makfn();	/* convert fnt entry to proper file name  */
	unlink(array); 
	return;
}
makfn()
{
	int n,j;
	char *m;		

	j = 0;
	m = grptbl[grpnum];

	for (n=0; n<8; n++) {
		if (*m != ' ') {
			array[j] = *m;
			j++;
		}
		m++;
	}
	array[j] = '.';
	j++;
	

	for (n=8; n<11; n++) {
		if (*m != ' ') {
			array[j] = *m;
			j++;
		}
		m++;
	}
	array[j] = '\0';
	return;
}