
/*

	OTHELLO -- The Game of Dramatic Reversals

	This version started out at Bell Labs some
	indefinite time ago; it was heavily modified
	by Bert Halstead (RTS group, MIT LCS) and
	eventually it fell into my hands. The program is
	a good example of heirarchical function organization
	and arrays as formal parameters; unfortunately, it
	plays a lousy game (probably because it doesn't use
	alpha-beta like STONE and PRESSUP do.) If anyone
	manages to rewrite the s_move function and make it
	pick reasonable moves, send me a copy and I'll include
	your version in the package instead of this lemon.
	(I'd do it myself, except that I'm too busy fixing
	bugs in the compiler...the number found so far of
	which you'd need an UNSIGNED integer to express...)

	Object of the game is for two players to alternate
placing their marker someplace on an 8 by 8 grid, so that
at least one of the opponent's pieces becomes surrounded
by the moving player's peices -- causing the flanked pieces
to flip 'color' and belong to the moving player. After 60
moves have been played (or if no player has a legal move left),
the player with the most of his own pieces on the board wins.
	Normal mode for the program is for you to play the
computer, you go first. Your piece is the asterisk ('*'), and
the machine plays 'at' signs ('@'). You enter a move as a two
digit number, each digit being from 1 to 8, first digit
representing row and second representing column. For example,
your first move might be '46', meaning 4th row down, 6th
position across.
	As an alternative to entering a move, one of the
following commands may be typed:

	g	causes computer to play both sides until game
		is over

	a	causes computer to print out an analysis of
		each of your possible moves. A letter from A
		to Z will appear at each of your legal move
		positions, where A is the machine's opinion
		of an excellant move and Z is a real loser.

	hn	sets handicap. n is 1,2,3, or 4. If n is
		positive, gives n free pieces to the computer.
		If n is negative, gives YOU the free peices.

	f	forfeit the current move. This happens
		automatically if you have no legal moves.

	q	quit the current game.

	b	prints out board again.

	s	prints out the score, and tells who is winning.

*/



#define BLACK '*'
#define WHITE '@'
#define EMPTY '-'


int handicap;
char selfplay;
int h[4][2];

main(argc,argv)
int argc;
char **argv;
{
	char b[8][8];
	int i;
	h[0][0] = h[0][1] = h[2][0] = h[3][1] = 0;
	h[1][0] = h[1][1] = h[2][1] = h[3][0] = 7;
	srand(0);
	printf("\nWelcome to the BDS C OTHELLO program!\n");
	printf("\nGood luck!!!\n\n");
	do {
		clrbrd(b);
		prtbrd(b);
		i = game(b,4);
		if (i==4) break;
		if (i=='Q') continue;
		printf("\n");
		i = prtscr(b);
		if (i>0) printf(" You won by %d\n",i);
		else if (i<0) printf(" You lost by %d\n",-i);
		else printf(" A draw\n");
	} while (ask("Another game? ")=='Y');
}

game(b,n)
char b[8][8];
int n;
{
	char c;
	int ff;
	int i,j;
	handicap = 0;
	selfplay = ' ';
	ff=0;
	while(1) {
		if (cntbrd(b,EMPTY)==0) return 'D';
		if (chkmvs(b,BLACK)==0) {
			printf("Forfeit");
			ff |= 1;
			}
		else switch (c = getmov(&i,&j)) {
		case 'B': prtbrd(b); continue;
		case 'S': i= prtscr(b);
			if (i>0) printf(" You're winning\n");
			else if (i<0)printf(" You're losing!\n");
			else putchar('\n');
			continue;
		case 'Q': case 4: return c;

		case 'H': if (n>abs(handicap)+4)
				printf("Illegal!\n");
			else for (j=0; i!=0; j++) {
			 b[h[j][0]][h[j][1]]= i>0?BLACK:WHITE;
			 handicap += i>0 ? 1 : -1;
			 ++n;
			 i += i>0 ? -1 : 1;
			}
			prtbrd(b); continue;
		case 'A': analyze(b,BLACK,WHITE,EMPTY);
			continue;
		case 'G': my_mov(b,BLACK,WHITE,EMPTY,&i,&j);
		case 'M': if (chkmov(b,BLACK,i,j)>0) {
			printf("%1d-%1d",i+1,j+1);
			putmov(b,BLACK,i,j);
			}
			else {
			  printf("Illegal!\n");
			  continue;
			 }
			break;
		case 'F': if (n>abs(handicap)+4) {
			printf ("Illegal!\n");
			continue;
			 }
			else printf("Forfeit");
		}
		if (cntbrd(b,EMPTY) == 0) return 'D';
		if (chkmvs(b,WHITE)==0) {
			printf("...Forfeit\n");
			ff |=2;
			}
		else {
			my_mov(b,WHITE,BLACK,EMPTY,&i,&j);
			printf("...%1d-%1d\n",i+1,j+1);
			putmov(b,WHITE,i,j);
			++n;
			}
		if (ff==3 || n>64) return 'D';
		if (!(ff & 1)) prtbrd(b);
		ff = 0;
	}
}


prtscr(b)
char *b;
{
	int i,j;
	printf("%1d-%1d",i = cntbrd(b,BLACK), j=cntbrd(b,WHITE));
	return i-j;
}

char getmov(i,j)
int *i, *j;
{
	char a,c;
	int n;
	char *p;
	char skipbl();
	if (selfplay == 'G') {
		if (!kbhit()) return 'G';
		selfplay = ' ';
		getchar();
	}
	printf("Move: ");
	while(1) switch (c=skipbl()) {
		case '\n': printf("Move?  "); continue;
		case 'G': if ((c = skipbl()) != '\n')
				goto flush;
			selfplay='G';
			return 'G';
		case 'B': case 'S': case 'Q':
		case 'F': case 'A':
		  a=c;
		  if (( c = skipbl()) != '\n') goto flush;
		  return a;
		case 'H': if ((a=c=skipbl()) == EMPTY)
				c=getchar();
			if (c<'1' || c>'4' || skipbl() !='\n')
				goto flush;
			*i = a==EMPTY? -(c-'0') : (c-'0');
			return 'H';
		case 4: return c;
		default: if (c<'1' || c>'8') goto flush;
			*i = c-'1';
			c = skipbl();
			if (c<'1' || c>'8') goto flush;
			*j = c- '1';
			if ((c=skipbl()) == '\n') return 'M';
		flush:	while (c != '\n' && c != 4)
				c=getchar();
			if (c==4) return c;
			printf ("Huh?? ");
		}
}

char ask(s)
char *s;
{
	char a,c;
	printf ("%s ",s);
	a=skipbl();
	while (c != '\n' && c != 4) c= getchar();
	return a;
}

char skipbl()
{
	char c;
	while ((c = toupper(getchar())) == ' ' || c=='\t');
	return c;
}



chkmvs(b,p)
char b[8][8];
char p;
{
	int i,j,k;
	k=0;
	for (i=0; i<8; i++) for (j=0; j<8; j++)
		k += chkmov(b,p,i,j);
	return k;
}


chkmov(b,p,x,y)
char b[8][8],p;
int x,y;
{
	if (b[x][y] != EMPTY) return 0;
	return	chkmv1(b,p,x,y,0,1) + chkmv1(b,p,x,y,1,0) +
		chkmv1(b,p,x,y,0,-1)+ chkmv1(b,p,x,y,-1,0)+
		chkmv1(b,p,x,y,1,1) + chkmv1(b,p,x,y,1,-1)+
		chkmv1(b,p,x,y,-1,1)+ chkmv1(b,p,x,y,-1,-1);
}


chkmv1(b,p,x,y,m,n)
char b[8][8],p;
int x,y,m,n;
{
	int k;
	k=0;
	while ((x += m) >= 0 && x < 8 && (y += n) >= 0 && y<8)
	{
		if (b[x][y]==EMPTY) return 0;
		if (b[x][y]== p ) return k;
		if (x==0 || x==7 || y==0 || y==7)
			k += 10;
		 else k++;
	}
	return 0;
}


notake(b,p,o,e,x,y)
char b[8][8];
char p,o,e;
int x,y;
{
	return notak1(b,p,o,e,x,y,0,1)&&
		notak1(b,p,o,e,x,y,1,1)&&
		notak1(b,p,o,e,x,y,1,0)&&
		notak1(b,p,o,e,x,y,1,-1);
}


notak1(b,p,o,e,x,y,m,n)
char b[8][8],p,o,e;
int x,y,m,n;
{
	int c1,c2;
	c1 = notak2(b,p,o,e,x,y,m,n);
	c2 = notak2(b,p,o,e,x,y,-m,-n);
	return !(c1==o && c2==e || c1==e && c2==o);
}


notak2(b,p,o,e,x,y,m,n)
char b[8][8],p,o,e;
int x,y,m,n;
{
	x += m; y +=n;
	if (x>=0 && x<=7 && y>=0 && y<=7)
		while(b[x][y] == 0) {
		 x += m; y+=n;
		 if (x<0 || x>7 || y<0 || y>7 || b[x][y]==e)
			return o;
		 }
	while (x>=0 && x<=7 && y>=0 && y<=7 && b[x][y]==p)
			{ x +=m; y+=n; }
	if (x<0 || x>7 || y<0 || y>7) return p;
	return b[x][y];
}


putmov(b,p,x,y)
char b[8][8];
char p;
int x,y;
{
	int i,j;
	b[x][y] = p;
	for (i= -1; i<=1; i++) for (j= -1; j<=1; j++) {
		if ((i != 0 || j!=0)&&chkmv1(b,p,x,y,i,j)>0)
			putmv1(b,p,x,y,i,j);
	 }
}


putmv1(b,p,x,y,m,n)
char b[8][8];
char p;
int x,y,m,n;
{
	while ((x += m) >= 0 && x<8 && (y += n)>=0 && y<8) {
		if (b[x][y] == EMPTY || b[x][y] == p) return;
		b[x][y] = p;
	 }
}


struct mt {
		int x;
		int y;
		int c;
		int s;
	 };

my_mov(b,p,o,e,m,n)
char b[8][8],p;
int *m, *n;
{
	struct mt  t[64];
	int i,k;
	int cmpmov();
	k = fillmt(b,p,o,e,t);
	if (!k) return 0;
	qsort (&t, k, 8, &cmpmov);
	for (i=1; i<k; i++)
		if (t[i].s != t[0].s || t[i].c != t[0].c)
						break;
	k = rand() % i;
	*m = t[k].x;
	*n = t[k].y;
	return 1;
}

analyze(b,p,o,e)
char b[8][8], p,o,e;
{
	struct mt  t[64];
	char a[8][8];
	int i,k,c;
	k = fillmt(b,p,o,e,t);
	cpybrd(a,b);
	for (i=0; i<k; i++)
	  a[t[i].x][t[i].y] = ((c = 'F' - t[i].s) <= 'Z')?c:'Z';
	prtbrd(a);
}


fillmt(b,p,o,e,t)
char b[8][8],p,o,e;
struct mt  t[64];
{
	int i,j,k;
	k = 0;
	for (i=0; i<8; i++) for(j=0; j<8; j++)
	   if (t[k].c = chkmov(b,p,i,j)) {
			t[k].x =i;
			t[k].y =j;
			t[k].s = s_move(b,p,o,e,i,j);
			++k;
		}
	return k;
}



s_move(b,p,o,e,i,j)
char b[8][8], p, o, e;
int i,j;
{
	char a[8][8];
	int ok,s,k,l,side,oside;
	int c,dkl;
	cpybrd(a,b);
	putmov(a,p,i,j);
	side = 0;
	if (i==0 || i==7) side++;
	if (j==0 || j==7) side++;
	s = 0;
	ok = 0;
	if (side==2 || notake(b,p,o,e,i,j)) ok++;
	oside = 0;
	for (k=0; k<8; k++) for(l=0; l<8; l++)
	 {
		c=chkmov(a,o,k,l);
		if (c==0) continue;
		dkl = 1;
		if (k==0 || k==7) { dkl+=2; oside|=4;}
		if (l==0 || l==7) {dkl+=2; oside|=4; }
		if (dkl==5) {dkl = 10; oside |= 16; }
			else if (!notake(a,o,p,e,k,l))
					continue;
		oside |= 1;
		s -= dkl;
		if (c>=10) { s -= 4; oside |= 8; }
		}
	if (s< -oside) s= -oside;
	if (side>0) return s+side-7+10*ok;
	if (i==1 || i==6) {s--; side++;}
	if (j==1 || j==6) {s--; side++;}
	if (side>0) return s;
	if (i==2 || i==5) s++;
	if (j==2 || j==5) s++;
	return s;
}

cmpmov(a,b)
struct mt  *a, *b;
{
	if ((*a).s > (*b).s) return -1;
	if ((*a).s < (*b).s) return 1;
	if ((*a).c > (*b).c) return -1;
	if ((*a).c < (*b).c) return 1;
	return 0;
}



clrbrd(b)
char b[8][8];
{
	int i,j;
	for (i=0; i<8; i++)
		for (j=0; j<8; j++)
			b[i][j]= EMPTY;
	b[3][3] = b[4][4] = BLACK;
	b[3][4] = b[4][3] = WHITE;
}


prtbrd(b)
char b[8][8];
{
	int i,j;
	printf("   1 2 3 4 5 6 7 8\n");
	for (i=0; i<8; i++) {
		printf("%2d",i+1);
		for (j=0; j<8; j++) {
			putchar(' ');
			putchar(b[i][j]);
		 }
		putchar('\n');
	 }
	putchar('\n');
}


cpybrd(a,b)
char *a, *b;
{
	int i;
	i=64;
	while (i--)
		*a++ = *b++;
}

cntbrd(b,p)
char *b, p;
{
	int i,j;
	i= 64; j=0;
	while (i--)
		if (*b++ == p) ++j;
	return (j);
}
