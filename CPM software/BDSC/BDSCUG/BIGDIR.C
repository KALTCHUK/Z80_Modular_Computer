/*
	BIG DIRECTORY PROGRAM
	Written by Richard Damon
	Version 1.0 May 1980

Usage:

A>BIGDIR d

	Where d is a drive specifier (A,B,C,D, default is current drive)
Prints out a directory listing similar to stat but formatted to fit on a
24 x 80 display.
*/

main(argc,argv)
int argc;
char *argv[];
{
	struct fcb{
		char drive;
		char name[11];
		char extent;
		char dummy[2];
		char rc;
		char diskmap[16];
	} directory[64];
	char nr;
	int i,j,k,totalblocks,ex,fun,comp(),sdrive;
	char *pntr;
	sdrive=bdos(25,0);
	if(argc>1){
		++argv;
		bdos(14,toupper(**argv)-'A');
	}
	k=1;
	bios(10,2);
	for(i=0;i<16;i++){
		bios(11,k);
		bios(12,&directory[i*4]);
		bios(13);
		k+=6;
		if(k>26)k-=26;
		if(k==1)k=2;
	}
	qsort(directory,64,32,comp);
	for(i=0;i<3;i++)
		printf("Filename.ext   NR  K    ");
	totalblock=0;
	for(j=0;!directory[j].drive;j++){
		if(j%3 == 0) putchar('\n');
		ex=directory[j].extent;
		nr=directory[j].rc;
		directory[j].dummy[0]=0;
		for(k=10;k>7;k--)
			directory[j].name[k+1]=directory[j].name[k];
		directory[j].name[8]='.';
		totalblock+=(nr+7)/8;
		printf("%s",directory[j].name);
		if(ex==0) printf("  ");
			else printf("/%x",ex);
		printf(" %2x %2d  %c ",nr,(nr+7)/8,j%3==2 ? ' ': '|');
	}
	printf("\nUsage= %d Blocks In %d Extents.  Left %d Blocks and %d Extents",totalblocks,j,241-totalblocks,64-j);
	bdos(14,sdrive);
}
comp(x,y)
char *x,*y;
{
	char i;
	for(i=1 ; (i || *x) && *x!=0xE5 && *x==*y ;x++,y++,i=0);
	if(*x>*y) return 1;
	if(*x<*y) return -1;
	return 0;
}
