/*
	DISK UTILITY PROGRAM

	Written by Richard Damon
	Version 1.0 May 1980

    This program allows the operator to examine and modify
a CPM diskette.

    The commands available in this package are :

Tn  set current track to n (0-76)
Sn  set current sector to n (1-26)
Dn  set current disk number to n (0-3)
Bn  set current track and sector to point to block n (0-F2)
N   set current track and sector to next sector/block
	next sector if last set command was for track or sector
	next block if last set command was for block
I   increment sector, if sector>26 set to 1 and increment track
R   read sector/block into buffer
W   write sector/block from buffer
P   print out contents of buffer, allong with track/sector/block information
Ea n n n n
    edit buffer starting from location a filling with values n n n.
Fn  Fill buffer with value n
X   exit program
M   print disk allocation map

Notes:
    1)  Multiple commands may be specified on a line except for X
which must be the only command on the line followed by return.
    2)  Commands may be in upper or lower case letters
    3)  Spaces are ignored except in the E command where they are used
	as separaters for the numbers

Typical commands:
d0t0s1rp	read in the track 0 sector 1 of disk 0 (Drive A) and print it
e1A 4F 20 11	set buffer location 1A to 4F, 1B to 20, and 1C to 11.
e0a 00w		set buffer location 0a to 0 and write buffer
			Note no space after last data byte
nrp		get next buffer and print it

Disk Allocation Map
    The M command is designed to allow the directory blocks (blocks 0 and 1)
to be printed out in a convient format. The directory is print out in the
following format:

 Section 1:
	The top half of the directory listing is a listing of the name
    inforamtion of the directory entries.  Each line corresponds to 1 sector
    of the directory.  A typical entry would be f=DISKTESTCOM/1 4c
    The first letter is a code letter used to referance into section 2.
    The equal sign indicats that the file exists, a star here indicates
      that this entry is a deleted file.
    Next comes the filename and extension.
    The following /n is printed if this is other then the first extent 
      (extent 0) of a file where n is the extent number of this entry.
    The following number is the hex record count for this extent.

 Section 2:
	The bottom half of the directory listing is a disk allocation map
    showing which blocks are in use and by which file. Free blocks are
    indicated by a dot while used blocks are marked by the file control
    letter asigned to a file in section 1.  This listing has been blocked off
    in groups of 8 and 16 to ease reading.

CPM FILE STRUCTURE

    To help the user of this program the following is a brief description
of the format used in CPM.  The first 2 tracks of a disk are reserved
for the bootstrap and the copy of the CPM operating system.  Tracks 2
through 76 store the data.  To speed up disk access CPM does not store
consecutive data in consecutive sectors.  Insteed it uses every 6th sector
for data. Thus to read logical consecutive sectors you must read the
sectors in the following order:
 1 7 13 19 25 5 11 17 23 3 9 15 21 2 8 14 20 26 6 12 18 24 4 10 16 22
This interleaving is taken care of when reading in multiple sectors
or when incrementing the disk address with the N command.  To simplify
the disk allocation scheme the sectors are the collected into groups of
8 sectors forming a 1k block.  These blocks are numbered from 0 starting
at the begining of the dirctory. (track 2 sector 1).  Block numbers range
from 0 to F2.
    The directory is organized to use 2 block of storage (16 sectors) to
store information on 64 file extensions.  A file extension is a part of a
file up to 16k bytes long.  The directory entry for a file extension is
as follows:

byte  0   : file code : 0 if file exists, E5 if file is deleted
byte  1- 8: file name : ascii representation of file name
byte  9-11: file type : ascii representation of file type
byte 12   : file ext  : binary number for extent number
byte 13,14: unused
byte 15   : rec count : count of number of sectors in extent
byte 16-31: map       : list of block numbers used by this extent

*/
main(){
	int track,sector,disk,nsect,t,s,i,j,k,block;
	char buffer[1024],buff[80],*bufp,c,d,mc,dir[2048],map[256];
	disk=0;
	track=0;
	sector=1;
	nsect=1;
	while(tolower(*(bufp=gets(buff))) != 'x' || *(bufp+1) != '\0'){
		while((c=*bufp++) != '\0')
		switch(toupper(c)){
			case 'T' : track=getnum(&bufp,0,76,10);
				nsect=1;
				break;
			case 'S' : sector=getnum(&bufp,1,26,10);
				nsect=1;
				break;
			case 'D' : disk=getnum(&bufp,0,1,10);
				break;
			case 'B' : block=getnum(&bufp,0,0xf2,16);
				nsect=8;
				track=2+block*8/26;
	 			s=block*8%26;
				sector=s*6%26+1;
				if(s>12)sector++;
				break;
			case 'N' : for(i=0;i<nsect;i++){
					sector+=6;
					if(sector>26)sector-=26;
					if(sector==2){
						sector=1;
						track++;
					}
					else if(sector==1) sector=2;
				}
				break;
			case 'I' : sector+=nsect;
				if(sector>26){
					sector-=26;
					track++;
				}
				break;
			case 'R' : bios(9,disk);
				t=track;
				s=sector;
				for(i=0;i<nsect;i++){
					bios(10,t);
					bios(11,s);
					bios(12,&buffer[i*128]);
					bios(13);
					s+=6;
					if(s>26) s-=26;
					if(s==2){
						s=1;
						t++;
					}
					else if(s==1) s=2;
				}
				break;
			case 'W' : bios(9,disk);
				t=track;
				s=sector;
				for(i=0;i<nsect;i++){
					bios(10,t);
					bios(11,s);
					bios(12,&buffer[i*128]);
					bios(14);
					s+=6;
					if(s>26) s-=26;
					if(s==2){
						s=1;
						t++;
					}
					else if(s==1) s=2;
				}
				break;
			case 'P' : switch (sector%6){
					case 0: block=17+sector/6; break;
					case 1: block= 0+sector/6; break;
					case 2: block=13+sector/6; break;
					case 3: block= 9+sector/6; break;
					case 4: block=22+sector/6; break;
					case 5: block= 5+sector/6; break;
				}
				block=block+26*(track-2);
				printf("track %d  sector %d ",track,sector);
				printf(" block %x.%d ",block/8,block%8);
				for(i=0;i<128*nsect;i+=16){
					printf("\n %4x  ",i);
					for(j=0;j<16;j++){
						printf("%2x ",buffer[i+j]);
						if(j%4 == 3) printf(" ");
					}
					for(j=0;j<16;j++){
						c=buffer[i+j]&0x7f;
						c=c<' '||c==0x7f ? '.' : c;
						putchar(c);
					}
				if(kbhit()) break;
				}
				putchar('\n');
				break;
			case 'E' : i=getnum(&bufp,0,nsect*128-1,16);
				while(*bufp==' '){
					buffer[i++]=getnum(&bufp,0,255,16);
					if(i>=nsect*128) break;
				}
				break;
			case 'F' : i=getnum(&bufp,0,255,16);
				for(j=0;j<nsect*128;j++) buffer[j]=i;
				break;
			case 'M' : bios(9,disk);
				bios(10,2);
				s=1;
				for(i=0;i<16;i++){
					bios(11,s);
					bios(12,&dir[i*128]);
					bios(13);
					s+=6;
					if(s>26)s-=26;
					if(s==1)s=2;
				}
				setmem(&map,256,0);
				for(i=0;i<64;i++){
					if(i%4==0) putchar('\n');
					j=32*i;
					c=(dir[j]==0) ? '=' : '*';
					d=dir[j+12];
					mc=mapchar(i);
					if(d==0xe5){
						printf("%c%19s",mc,"");
						continue;
					}
					dir[j+12]=0;
					printf("%c%c%s",mc,c,&dir[j+1]);
					if(d != 0) printf("/%x",d%0x10);
						else printf("  ");
					printf(" %2x  ",dir[j+15]);
					if(c=='*')mc+=128;
					for(k=16;k<32 && dir[j+k];k++){
						d=dir[j+k];
						if(mc<128) map[d]=mc;
					}
				}
				for(i=0;i<0xf3;i++){
					if(i%64==0) putchar('\n');
					else if(i%16==0) printf("  ");
					else if(i%8==0) printf(" ");
					putchar(map[i] ? map[i] : '.');
				}
				putchar('\n');
				break;
			case ' ' : break;
			default : printf("%c ??????\n",c);
				*bufp='\0';
				break;
		}
	if(kbhit()) getchar();
	}
}
getnum(pntr,low,high,base)
int low,high,base;
char **pntr;
{
	int number;
	char c,buffer[50],*bp;
	number=0;
	while( **pntr== ' ') (*pntr)++ ;
	while( (c=toupper(*(*pntr)++))>='0' && c<= '9' ||
		base==16 && (c-=7) > '9' && c <= ('F'-7) )
			number=base*number+c-'0';
	(*pntr)--;
	if (number<low || number>high){
		printf("bad number %d ",number);
		bp=gets(buffer);
		number=getnum(&bp,low,high,base);
	}
	return (number);
}
mapchar(i)
char i;
{	if(i<10) return(i+'0');
	if(i<36) return(i-10+'a');
	return(i-36+'A');
}
putchar(c)
char c;
{
	putch(c);
}
