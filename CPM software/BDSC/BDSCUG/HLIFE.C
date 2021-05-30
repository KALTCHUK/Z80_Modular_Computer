
/*
	"LIFE"

	The game invented by John Conway

	*************************************************	
	*	This version specially configured for	*
	*	the H19 terminal (and its 25th line)	*
	*************************************************
	
	This version written by Leor Zolman to exemplify
	PROPER use of"goto" statements in C programs!

	Compile with the "-o" option to CC1 for best per-
	formance.

	Note that the Universe is a toroid; i.e,
	the left extreme is adjacent to the right extreme,
	the top is adjacent to the bottom, and each corner
	is adjacent to each other corner.
	In other words, there ARE NO EXTREMES !!
	Or, in a more physical illustration: If I could
	take a peek straight ahead through the magical
	eyepiece of an infinitely powerful telescope,
	I'd be able to see the back of my brain-damaged 
	head....that is, of course, assuming no galaxies
	or cats get in the way.

*/

#define SILENT 0	/* comment out this line to
				enable data display		*/

#define CLEARS "\033E\033y1\033x1\033x5"

#define TWIDTH 80	/* # of columns on your terminal	*/
#define XSIZE 100	/* length of cell array	(max # of lines)*/
#define YSIZE 90	/* width of cell array			*/
			/* To see how the toroid works,
			   try reducing XSIZE and YSIZE to
			   around 10 or 20.			*/

#define BOREDOM_THRESHOLD 5  /* This is how many generations
				are allowed to pass without a
				population change before Divine 
				intervention is called for.	*/

char *gets();		/* routine to accept a line of input	*/
char cell[XSIZE][YSIZE];     /* the universe matrix		*/
int minx, maxx, miny, maxy, pop, gen;	/* misc. variables	*/
char doneflag;	  	/* This goes true when we want to stop	*/
int boring;		/* keeps count of how many generations
			   go by without a population change	*/
/*
	The main driving routine, to accept random initial
	and population configurations, and display their
	evolution according to a proximity-based formula.
*/

main()
{
	char c;
	printf("%s\n\t**** BDS  Life ****\n\n",CLEARS);
	printf(    "\tSpecial H19 Version\n\n");
	for (;;) {
	  clear();
	  setup();
	  if (!pop) break;
	  adjust();
	  display();
	  while (pop) {
		adjust();
		dogen();
		if (kbhit()) {
			getchar();
			puts("\033y1\033x1\033j\033Y89");
			printf("The Wrath Of God Strikes! KA-BEEP!\7");
			puts("\033K\033k\033y5\n");
			sleep(10);
			break;
		 }
		display();
		if (boring == BOREDOM_THRESHOLD) {
		  boring++;
		  printf("\033j\033y5\033y1\033x1\033Y8 No change in ");
		  printf("population for %d ",BOREDOM_THRESHOLD);
		  printf("generations. Abort? (y/n) ");
		  c = toupper(getchar());
		  puts("\033k");
		  if (c == 'Y') break;
		 }
		if (doneflag) break;
	   }
	 }
	puts("\033z");
 }

/* Initialize the cell matrix to all dead */

clear()
{
	setmem(cell,(XSIZE*YSIZE),0);
}

/* Get initial set-up from user */

setup()
{
	char c;
	int y;
	char string[YSIZE], *ptr;
	y = pop = gen = minx = maxx = miny= maxy = 0;
	boring = 0;
	printf("\033y5");
	printf("\n\nEnter initial configuration (single period to end):\n");

	while (*gets(string) != '.') {
		ptr = string;
		while (*ptr) {
			if ( *ptr++ != ' ') {
				cell[maxx][y] = 10;
				++pop;
			 }
			++y;
			if (y==YSIZE) {
			 printf("Truncated to %d chars\n",
				 YSIZE); break;
			 }
		 }
		--y;
		++maxx;
		if (y>maxy) maxy = y;
		if (maxx==XSIZE) break;
		y = 0;
	 }
	--maxx;
	printf(CLEARS);
}

/* Display the current generation */

display()
{
	int i,j,k,l,j9;
	char c;
	char line;
	char *cline;

	puts("\033x5");		/* shut off blinking cursor	*/

	if (!pop) {
		printf("\033y1\033x1\033j\033Y89Life ends at %d\033k\033y5\7",
		       gen);
		sleep(20);
		return;
	 }

	if(minx && prow(minx-1)) minx--;
	if(miny && pcol(miny-1)) miny--;
	if ((maxx < (XSIZE-1)) && prow(maxx+1)) maxx++;
	if((maxy<(YSIZE-1)) && pcol(maxy+1))maxy++;
	
	while (!prow(minx)) minx++;
	while (!prow(maxx)) maxx--;
	while (!pcol(miny)) miny++;
	while (!pcol(maxy)) maxy--;

	if (!doneflag) {
#ifndef SILENT
	  printf("\033y1\033x1\033j\033Y87generation = %3d   population = %3d",
		gen,pop);
	  puts("\033k\033E");
#endif
	;}
	else puts("\033y5\033E");

	++gen;

	line = 255;

	if (maxx - minx < 23) {
		line += (23 - (maxx - minx))/2;
		printf("\033Y%co\033b",line+' ');
	 }

	j9 = maxy - miny + 1;
	for (i = minx; i<=maxx; i++) {
	   cline = cell[i] + miny;

	   if (line == 23) putchar('\n');
		else line++;

	   l = (j9<TWIDTH) ? (TWIDTH-j9)/2 : (j9 = (TWIDTH-2),0);
	   printf("\033Y%c%c\033l",line+' ',l+' ');

	   for(j=0; j<j9; j++)
		putchar( *cline++ ? '*' : ' ');
	}
	printf("\033J");
}

/* Test if given column is populated */

pcol(n)
{
	int i,hi;
	hi = (maxx == (XSIZE-1)) ? maxx : maxx+1;
	for (i = minx ? minx-1 : minx; i<=hi; ++i)
		if (cell[i][n]) return 1;
	return 0;
}

/* Test if given row is populated */

prow(n)
{
	int i,hi;
	hi = (maxy == (YSIZE-1)) ? maxy : maxy+1;
	for (i = miny ? miny-1 : miny; i<=hi; ++i)
		if (cell[n][i]) return 1;
	return 0;
}


/*
   Compute next generation. Algorithm used is a two-pass
   cuteness suggested to me by Ward Christensen (he uses
   it on a machine-language version on a 1024 character
   display, and it cranks out 20 generations a second at
   2 MHz.)
   The algorithm uses the low order 3 bits of each 1-byte
   cell as a neighbor count. The first pass finds all live
   cells and increments the count of each of the 8 neighbors
   of such live cells. For the first pass, dead cells are
   totally ignored. The second pass then comes along and
   checks the counts off all cells within the active square
   to determine who lives and who dies. Note that this is a
   significant improvement over the "obvious" method of
   examining all 8 neighbors of each and every cell, dead
   or alive, in the array.
*/

dogen()
{
	int i,j,i2,j2;
	int bigflag;
	int k,l;
	int oldpop;
	char c;
	int pass;
	doneflag = 1;
	oldpop = pop;
	bigflag =  (minx<2 || maxx>(XSIZE-3) ||
		miny<2 || maxy>(YSIZE-3)) ;
	i2 = (maxx==(XSIZE-1)) ? maxx : maxx+1;
	j2 = (maxy==(YSIZE-1)) ? maxy : maxy+1;
	for (pass = 0; pass < 2; pass++)
	for (i=minx ? minx-1 : minx; i<=i2; ++i)
	  for (j=miny ? miny-1 : miny; j<=j2; ++j) {
	   c = cell[i][j];
	   if (!pass) {
	     if (c >= 10)
		if (bigflag)
		  for (k = -1; k <= 1; k++)
		   for (l = -1; l <= 1; l++)
		    cell[mod(i+k,XSIZE)][mod(j+l,YSIZE)]++;
		else
		  for (k = -1; k<=1; k++)
		   for (l = -1; l <= 1; l++)
		    cell[i+k][j+l]++;
	    }
	   else
	     if (c > 10)
		if (c < 13 || c > 14) {
			cell[i][j] = 0;
			pop--;
			doneflag = 0;
		 }
		else cell[i][j] = 10;
	     else
		if (c == 3) {
			cell[i][j] = 10;
			pop++;
			doneflag = 0;
		 }
		else cell[i][j] = 0;
	 }
	if (pop == oldpop) boring++;
	  else boring = 0;
	if (doneflag) {
	 printf("\033y1\033x1\033j\033Y89Static configuration reached\033k\7");
	 sleep(20);
	}
}


int mod(a,b)
{
	if (a<0) return b+a;
	if (a<b) return a;
	return a-b;
}


/* If we're about to run off the matrix, adjust accordingly (if possible) */

adjust()
{
	adjx();		/* for overflow in x direction	*/
	adjy();		/* and also in y direction	*/
}

/* Adjust vertical position */

adjx()
{
	int delta, i,j;
	int savdelta;
	if (maxx - minx + 1 > XSIZE-2) return;
	if (minx==0) {
		delta = (XSIZE-maxx)/2+maxx;
		savdelta = delta;
		for (i=maxx; i >= 0; --i) {
			for (j=miny; j<=maxy; ++j) {
				cell[delta][j] = cell[i][j];
				cell[i][j] = 0;
			 }
		--delta;
		}
		minx = delta+1;
		maxx = savdelta;
	}

	if (maxx == (XSIZE-1)) {
		delta = minx/2;
		savdelta = delta;
		for (i=minx; i<XSIZE; ++i) {
			for (j=miny; j<=maxy; ++j) {
				cell[delta][j] = cell[i][j];
				cell[i][j] = 0;
			}
		++delta;
		}
		maxx = delta-1;
		minx = savdelta;
	}
}


/* Adjust horizontal position */

adjy()
{
	int delta, i, j;
	int savdelta;
	if (maxy - miny + 1 > YSIZE -2) return;
	if (miny == 0) {
		delta = (YSIZE-maxy)/2+maxy;
		savdelta = delta;
		for (i=maxy; i>=0; --i) {
			for (j=minx; j<=maxx; ++j) {
				cell[j][delta] = cell[j][i];
				cell[j][i] = 0;
			}
		--delta;
		}
		miny = delta+1;
		maxy = savdelta;
	}

	if (maxy == (YSIZE-1)) {
		delta = miny/2;
		savdelta = delta;
		for (i=miny; i<YSIZE; ++i) {
			for (j=minx; j<=maxx; ++j) {
				cell[j][delta] = cell[j][i];
				cell[j][i] = 0;
			}
		++delta;
		}
		maxy = delta -1;
		miny = savdelta;
	}
}

/*
	This is done so that the Wrath Of God doesn't mess up the
	display:
*/

putchar(c)
char c;
{
	putch(c);
}

