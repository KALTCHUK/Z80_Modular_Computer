
/*
	BD Software presents:

	Tic Tac Toe  (by exhaustive search)

	written by Leor Zolman
		   September 1979

	This program was written for use as the crux
	of an article in BYTE (as yet to be published)
	on BDS C, structured programming and gaming.

	It is also intended to get you addicted to C so
	you'll go out and buy the 

		BD Software C Compiler

		only $110 on CP/M disk from:

		tiny c associates
		post office box 269
		holmdel, new jersey 07733

	The package includes the compiler, linking loader,
	library manager, standard library of functions, many
	interesting sample programs (such as "TELNET.C" for
	using your computer as a terminal and allowing I/O
	directly from modem to disk and vice-versa.) Also
	included is a copy of the best reference book available
	on the C language, written by the original implementors
	at Bell Labs (the package may be purchased without
	the book for $100.)

*/


#define X 1				/* The pieces on the board */
#define O 5
#define EMPTY 0

char board[9];				/* the playing board */
char BEST;				/* move returned by "ttteval" */
int wins[8][3];				/* table of  winning positions */


main()
{
	int i;
	int mefirst;			/* 1: computer goes first; 0: human */
	int turn;			/* counts number of moves played */
	int mypiece, hispiece;		/* who has x or o */
	int mywins, hiswins, catwins;	/* game count */
	int t;
	srand(0);			/* initialize random generator */
	initw(wins,"0,1,2,3,4,5,6,7,8,0,3,6,1,4,7,2,5,8,0,4,8,2,4,6");
	mywins = hiswins = catwins = 0;
	mefirst = 1;			/* let human go first */
	printf("\n\nWelcome to BDS Tic Tac Toe!!\n");
	printf("(In this version, X always goes first.\n");
	printf("The board is arranged as follows:");
	do {
	  mefirst = !mefirst;		/* reverse who goes first */
	  turn = 0;
	  display(1);
	  printf(mefirst ? "I go first...\n":
			   "You go first...\n");
	  clear();			/* clear the game board */
     	  mypiece = mefirst ? X : O; 	/* set who has got what */
	  hispiece  = mefirst ? O : X;
	  if (!mefirst) goto hismove;

 mymove: if (turn == 0)    		/* Opening move may be random */
		BEST = rand() % 9;
	  else if (turn == 1) {  	/* Response to opener: */
		if (board[4])
			BEST = rand() % 2 * 6 +
			rand() % 2 * 2;
		else BEST = 4;
	   }
	  else {			/* OK, we're into the game... */
		t = ttteval(mypiece,hispiece);
		if (t == 1) printf("I've got ya!\n");
	    }
	   board[BEST] = mypiece;  	/* make the move */
	   ++turn;
	   display(0);
	   if (win(mypiece)) {
		++mywins;
		printf("\nI win!!!\n");
		continue;
	    }
	   if (cats()) {
		++catwins;
		printf("\nMeee-ow!\n");
		continue;
	    }

  hismove: printf("Your move (1-9) ? ");
	   i = getchar() - 0x30;
	   if (i < 1 || i > 9 || board[i-1]) {
		printf("\nIllegal!\n");
		goto hismove;
	    }
	   board[i-1] = hispiece;
	   ++turn;
	   display(0);
	   if (win(hispiece)) {
		++hiswins;
		printf("\nYou beat me!!\n");
		continue;
	    }
	   if (cats()) {
		++catwins;
		printf("\nOne for Morris.\n");
		continue;
	    }
	   goto mymove;

	} while (ask("\nAnother game (y/n) ? "));

	printf("\n\nOK...Final score:\n");
	printf("You won %d game",hiswins);
	if (hiswins != 1) putchar('s');
	printf(";\nI won %d game",mywins);
	if (mywins != 1) putchar('s');
	printf(";\nThe Cat got %d game",catwins);
	if (catwins != 1) putchar('s');
	printf(".\nSee ya later!!\n");
}


/*
	The function "ttteval" returns an evaluation of
	player x's position on the tic-tac-toe board. If he's
	in a winning position, 1 is returned. If the best he
	can hope for is a cat's game, 0 is returned. And, if
	he's sure to lose if player y plays correctly, -1 is
	returned. In any case, the best move available to 
	player x is left in external variable BEST upon return
	from ttteval.

	Note that a value of -1 is often returned while
	recursive searching branches down into all possible
	wins and losses, but with the program in the shape
	it appears here, the outermost-level call to ttteval
	(from the main program) will never produce a return
	value of -1, since the computer has decided not to be
	able to lose (the obviously logical choice of any
	self-respecting problem-solver.)
	In any case, the main program still bothers to 
	consider the possibility of losing, so that if you
	want to try inserting your own "ttteval" routine
	in place of the one given, it dosn't have to be
	perfect in order to work with the main program.
	Tic-tac-toe is, of course, just about the only game
	in which it is feasable to do an exhaustive search;
	most game evaluation algorithms only go so deep and
	then make a "static" evaluation, or estimate of the
	player's status at the terminal position. That is how
	all decent chess playing programs today work.
*/

ttteval(me,him)
{
	char i,safemove;
	int v,loseflag;
		/* first check for the 3 simple terminal
		   conditions:				*/
	if (win(me)) return 1;
	if (win(him)) return -1;
	if (cats()) return 0;
		/* OK...now try all possible moves and see
		   our honorable opponent can do with each: */
	loseflag = 1;
	for (i=0; i<9; ++i) {
		if (board[i]) continue; /* ignore non-moves! */
		board[i] = me;		/* try the move...*/
		v = ttteval(him,me);
		board[i] = 0;		/* restore the empty space */
		if (v == -1) { 		/* if we force a loss, yey! */
			BEST = i;
			return 1;
		 }
		if (v) continue;   	/* uh oh! we shouldn't get beaten! */
		loseflag = 0;		/* cat's game guaranteed at least */
		safemove = i;
	 }
	BEST = safemove;
	return -loseflag;		/* if loseflag is true, this returns
					   -1 to indicate a loss; else zero
					   is returned (cat's game.)    */
}

/*
	This function returns true (non-zero) if player p
	has three in a row on the board:
*/

win(p)
{
	char i;
	for (i=0; i<8; ++i)
		if (board[wins[i][0]] == p &&
		    board[wins[i][1]] == p &&
		    board[wins[i][2]] == p) return 1;
	return 0;
}


/*
	This function returns true if all nine squares are
	taken (usually called after checking for a win, so
	that all spaces filled indicates a cat's game)
*/

cats()
{
	char i;
	for (i=0; i<9; ++i)
		if (!board[i]) return 0;
	return 1;
}

/*
	Function to clear the game board
*/

clear()
{
	char i;
	for (i=0; i<9; ++i)
		board[i] = EMPTY;
}

/*
	This one returns true if the player responds
	positively to the prompt string, else returns false
	(a good general-purpose yes/no asking function!)
*/

ask(s)
char *s;
{
	char *gets(), c;
	printf(s);
	c = toupper(getchar());
	return (c == 'Y');
}

/*
	Display the playing board with pieces if flag is 0,
	or else with each square numbered from 1-9.
*/

display(flag)
{
	int i,j;
	printf("\n\n");
	for (i=0; i<9; i+=3) {
		for (j=i; j< i+3; ++j) {
			putchar(' ');
			if (!flag)
			  switch(board[j]) {
			    case EMPTY: putchar(' ');
					break;
			    case X:	putchar('x');
					break;
			    case O:	putchar('o');
			   }
			else printf("%1d",j+1);
			putchar(' ');
			if (j != i+2) putchar('|');
		 }
		putchar('\n');
		if (i != 6) printf("---+---+---\n");
	 }
	putchar('\n');
}
][y] = p;
	for (i= -1; i<=1; i++) for (j= -1; j<=1; j++) {
		if ((i != 0 || j!=0)&&chkmv1(b,p,x,y,i,j)>0)
			putmv1(b,p,x,y,ireturn row;
		  if (row == 'P') {
			pboard(&master);
			goto loop;
		   }
		  if (row == 0177 || row == '\n') goto err;
	