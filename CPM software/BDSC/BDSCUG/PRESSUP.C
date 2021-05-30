

/* Press-up game...
       pressup <options>
  where <options> may include
       -f      Machine goes first
       -d n    Search depth is n moves (default 3)
		(greater search depths take longer...but
		 play better!!)
       -b	Print machine's evaluation of its moves.

	THIS PROGRAM WILL ONLY WORK ON TERMINALS HAVING
	LOWER CASE CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!!!!

	This excellant program was written by:
		Prof. Steve Ward
		Director, Real-Time Systems Group
		MIT Lab for Computer Science
		Cambridge, Massachussetts, 02139

		(slightly modified by Leor Zolman)

	The game of Press-Ups is played as follows:
	The board is a n by n array of pegs, each of
	which is standing up at the start of the game. Pegs
	come in 3 colors: Red (yours), Blue (the machine's),
	and white (periods, actually; they're neutral.)

	The first player to move must"push down" a neutral
	peg. Thereafter, players take turns pushing down pegs,
	where each peg pushed must be adjacent to the last one
	pushed.

	Pegs are named by giving a letter and a number, for the
	row and column of the desired peg.

	As soon as a player gets all of his pegs down, he wins.
	When there are no more legal moves to play,
	the player with the most of his own colored pegs down
	is the winner.

	Watch out...at search depths of 6 or more, this program
	plays a mean game!!!
*/

#define SIDE		7	/* Dimension of board	*/

#define HISFIRST (SIDE*2+1)	/* His best first move	*/
#define MYFIRST (SIDE+SIDE/2-1) /* My best first move	*/
#define BELL 0x07
#define BACKSP 0x08

char toupper();

int	Depth;		/* Search depth (default = 3)	*/
int	Helpflag;
char	FFlag,	    /* -f option: machine goes first */
	BFlag;	    /* Debugging flag		    */
char	Startflag;	/* True on first move only */

char *image;
int Adj[16];

int	BestMove;		/* Returned by search	*/

#define BBOARD struct bord

struct bord
  {	char board[SIDE*SIDE];
	int  star;
	char red;
	char blue;
  };

BBOARD initb;

BBOARD master, savebd;

char string[20];

CheckWin(bp)
 BBOARD *bp;
 {	int i;
	i = search(bp,1,1,-32000,-32000);
	if (BestMove >= 0) return 0;

	if (i>0) printf("I win!\n");
	if (i<0) printf("You win!\n");
	if (i==0) printf("Tie game!\n");
	return 1;
	}

asknew()
{
	printf("\nAnother game? ");	
	if (toupper(getchar()) != 'Y') exit();
	printf("\n");
}

main(argc,argv)
 char **argv;
  {	int i,j; char *arg;
	FFlag  = BFlag = 0;
	image = ".rbXRB";
	initw(Adj,"-1,-1,-1,0,-1,1,0,-1,0,1,1,-1,1,0,1,1");

	Depth = 3;
	for (i=1; i<argc; i++)
	 {if (*(arg = argv[i])=='-') switch (toupper(*++arg)) {
		case 'D':	Depth = atoi(argv[++i]); continue;
		case 'F':	FFlag++; continue;
		case 'B':	BFlag++; continue;
		default:	printf("Illegal argument: '%1s'\n",argv[i]);
				exit(); }
	   else {printf("Illegal argument: '%1s'\n",arg); exit(); }}

ngame:
	Startflag = 1;
	Helpflag = 0;
	for (i=0; i<(SIDE*SIDE); i++) initb.board[i] = 0;
	 for (j=1; j<(SIDE-1); j++)
		{ initb.board[j] = 1;
		  initb.board[(SIDE*SIDE-1)-j] = 1;
		  initb.board[SIDE*j] = 2;
		  initb.board[SIDE*j + SIDE-1] = 2; };
	initb.star = -1; initb.red = 0; initb.blue = 0;

	bcopy(&initb,&master);
	pboard(&master); bcopy(&master,&savebd);

	for(;;)
	  {	if (FFlag) { FFlag = 0; goto Mine; }
		if (CheckWin(&master)) {
			asknew();
			goto ngame;
		 }
		i = getmove();
		if (i == 'Q') {	
			asknew();
			goto ngame;
		 }
		dmove(i);
		if (CheckWin(&master)) {
			asknew();
			goto ngame;
		 }
	Mine:	printf("I'm thinking...\n");
		i = search(&master,Depth,1,-32000,-32000);
		if (BFlag) printf("Eval = %d\n",i); 
		dmove(BestMove);
		if (i > 500) printf("I've got you!\n"); 
		if (i < -500) printf("You've got me!\n"); 

	  }
  }


pboard(bp)
BBOARD *bp;
  {	int i, j, n;
	char letter;
	letter = 'A';
	printf("\n\n     ");
	for (i=0; i<SIDE; i++) printf("%-3d",i+1); printf("\n");
	printf("   "); for (i=0; i<(2+3*SIDE); i++) printf("-"); printf("\n");
	for (i = 0; i < SIDE; i++)
	  {	printf(" %c |",letter);
		for (j = 0; j < SIDE; j++)
		 { if ((n = i*SIDE + j) == bp -> star) printf(" * ");
		   else printf(" %c ",image[bp->board[n]]); }
		printf("| %c",letter++);

		if (i==0) printf("\tSearch Depth: %1d moves",
					Depth);
		if (i==2) printf("\tScore:\tBlue(me)  Red(you)");
		if (i==3) printf("\t\t  %1d        %1d",
				master.blue, master.red);
		if (i==5) {
			if (Helpflag)
				printf("\tYou've had help!");
			if (Startflag)
				printf(FFlag?"\tI go first"
					    :"\tYou go first");
			Startflag = 0;
		 }
		printf("\n");
	  }
	printf("   "); for (i=0; i<(2+3*SIDE); i++) printf("-"); printf("\n");
	printf("     ");
	for (i=0; i<SIDE; i++) printf("%-3d",i+1); printf("\n");
	printf("\n");
  }

bcopy(p1,p2)
BBOARD *p1, *p2;
  {	int i;
	i = (SIDE*SIDE)-1;
	do p2->board[i] = p1->board[i];
		while(i--);
	p2->star = p1->star;
	p2->red = p1->red;
	p2->blue = p1->blue;
  }


/* display move #n */

dmove(n)
  {
	move(&master,n);
	pboard(&master);
	bcopy(&master,&savebd);
  }

move(bp,n)
BBOARD *bp;
  {	int type;
	type = bp->board[n] += 3;
	if (type == 4) bp->red++;
	else if (type == 5) bp->blue++;
	bp->star = n;
  }

search (bp,ddepth,who,alpha,beta)
BBOARD *bp;
  {	BBOARD new;
	int i,j,k;
	int myalpha,hisalpha,result,status;
	int best;
	int num;
	int bestmove, ii, jj, n;
	int SavStar;
	int SavBlue;
	int SavRed;
	int Save;
	char moves[9];
	status = -1;
	best = -32000;
	num = 0;
	SavStar = bp -> star;
	SavBlue = bp -> blue;
	SavRed	= bp -> red;
	BestMove = -1;		/* No best move yet...	*/

	if (SavStar == -1)	/* special case opening moves	*/
	 { BestMove = HISFIRST;
	   if (who > 0) BestMove = MYFIRST;
	   return 0; };

	if (!ddepth--)
		return(who * (bp->blue - bp->red));
	if (bp->blue == (SIDE*2-4) || bp->red == (SIDE*2-4))
		return(who*(bp->blue - bp->red)*1000);

		  /* alpha-beta pruning   */
	  if (who>0)   { myalpha = bp->blue; hisalpha = bp->red; }
	   else 	{ myalpha = bp->red; hisalpha = bp->blue; }
	   myalpha += ddepth;  /* Most optimistic estimate. */
	   if (myalpha > (SIDE*2-4)) myalpha = (SIDE*2-4);
	   if (myalpha == (SIDE*2-4)) myalpha = 1000*(myalpha-hisalpha);
	   else myalpha -= hisalpha;
	   if (myalpha <= alpha) return best;

	k = bp->star;
	i = k%SIDE;
	j = k/SIDE;
	for (n=0; n<8; n++)
	 {
		if ((ii = i+Adj[n+n]) < 0 || ii >= SIDE) continue;
		if ((jj = j+Adj[n+n+1]) < 0 || jj >= SIDE) continue;
		if (bp->board[moves[num] = jj*SIDE + ii] < 3) num++; }
	if (num == 0) return(who*(bp->blue - bp->red)*1000);
	bestmove = moves[0];
	for (i=0; i<num; i++)
	 { Save = bp->board[moves[i]];	move(bp,moves[i]);
	   k = -search(bp,ddepth,-who,beta,alpha);
	   bp->board[moves[i]] = Save;
	   bp->blue = SavBlue; bp->red = SavRed; bp->star = SavStar;
	   if (k > alpha) alpha = k;
	   if (k > best) { best = k; bestmove = moves[i]; }
	   if (k>100) break; }
	BestMove = bestmove;
	return best; }



Help()
 {	printf("I'm thinking for you...\n");
	Helpflag = 1;
	search(&master,Depth,-1,-32000,-32000);
	return BestMove; }

getmove()
  {	int row, col, n;
	int dc, dr;
	int star2;
	star2 = master.star;
loop:	printf("\nYour move (z for help; p for board): ");
getrow: for (;;) {
		 if ((row = toupper(getchar()) ) == 'Z') {
			printf("\n");
			return Help();
			}

		  if (row == 'Q') return row;
		  if (row == 'P') {
			pboard(&master);
			goto loop;
		   }
		  if (row == 0177 || row == '\n') goto err;
		  if (row<'A' || row> ('A'+SIDE-1))
			putchar(BACKSP);
			else break;
		}
	row -= 'A';

	for (;;) {
		 col = toupper(getchar());
		  if (col == 0177) {
			putchar(BACKSP);
			goto getrow;
		   }
		if (col == '\n' || col == '\b') goto err;
		if (col < '1' || col > ('0'+SIDE))
			putchar(BACKSP);
			else break;
		}

	col -= '1';
	n = row*SIDE + col;
	dr = abs(row - star2/SIDE);
	dc = abs(col - star2%SIDE);

	if ((star2 < 0 && master.board[n] == 0) ||
	    (dr < 2 && dc < 2 && master.board[n] < 3))
		return(n);

   err:	putchar(BELL);
	printf("  Illegal!  ");
	goto loop;
  }


