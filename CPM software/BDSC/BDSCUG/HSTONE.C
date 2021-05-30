/*
		    ===
	"STONE" --- H19  Version (for H19/Z19/H89/Z89 ONLY)
		    ===

	(otherwise known as "Awari")

	This version written by:

	Terry Hayes & Clark Baker
	Real-Time Systems Group
	MIT Lab for Computer Science

	Hacked up a little by Leor Zolman and Steve Ward
	(Steve did all the neat H19 display hackery!)

	The algorithm used for STONE is a common one
	to Artificial Intelligence people: the "Alpha-
	Beta" pruning heuristic. By searching up and down 
	a tree of possible moves and keeping record of
	the minimum and maximum scores from the
	terminal static evaluations, it becomes possible
	to pinpoint move variations which can in no way
	affect the outcome of the search. Thus, those
	variations can be simply discarded, saving 
	expensive static evaluation time.

	THIS is the kind of program that lets C show its
	stuff; Powerful expression operators and recursion
	combine to let a powerful algorithm be implemented
	painlessly.

	And it's fun to play!


	Rules of the game:

	Each player has six pits in front of him and a
	"home" pit on one side (the computer's home pit
	is on the left; your home pit is on the right.)

	At the start of the game, all pits except the home
	pits are filled with n stones, where n can be anything
	from 1 to 6.

	To make a move, a player picks one of the six pits
	on his side of the board that has stones in it, and
	redistributes the stones one-by-one going counter-
	clockwise around the board, starting with the pit
	following the one picked. The opponent's HOME pit is
	never deposited into.

	If the LAST stone happens to fall in that player's
	home pit, he moves again.

	If the LAST stone falls into an empty pit on the
	moving player's side of  board, then any stones in the
	pit OPPOSITE to that go into the moving
	player's home pit.

	When either player clears the six pits on his
	side of the board, the game is over. The other player
	takes all stones in his six pits and places them in
	his home pit. Then, the player with the most stones
	in his home pit is the winner.

	The six pits on the human side are numbered one
	to six from left to right; the six pits on the	
	computer's side are numbered one to six right-to-
	left.

	The standard game seems to be with three stones;
	Less stones make it somewhat easier (for both you
	AND the computer), while more stones complicate
	the game. As far as difficulty goes, well...it
	USED to be on a scale of 1 to 50, but I couldn't
	win it at level 1. So I changed it to 1-300, and
	couldn't win at level 1. So I changed it to 1-1000,
	and if I STILL can't win it at level 1, I think
	I'm gonna commit suicide.

	Good Luck!!!
*/

unsigned total;
char string[80];

unsigned COUNT, Seed;
int NUM;

int holex[14];
int holey[14];
int stonex[48];
int stoney[48];

exinit()
 {	initw(holex, "7,10,10,10,10,10,10,8,4,4,4,4,4,4");
	initw(holey, "7,16,24,32,40,48,56,66,56,48,40,32,24,16");
	initw(stonex, "0,0,0,-1,1,1,1,-1,-1,1,1,0,0,-1,-1,-2,-2,-2,-2,\
	 -2,-3,-3,-3,-3,-3,-1,0,-2,1,-3,2,2,2,2,3,3,-4,-4,-4,-4,3,2,3,\
	 2,3,3,-4,-4");
	initw(stoney, "0,1,-1,0,0,-1,1,-1,1,-2,2,-2,2,-2,2,0,-1,1,-2,2,\
	 0,-1,1,-2,2,-3,-3,-3,-3,-3,0,-1,-2,1,0,-1,-1,0,-2,1,1,2,-2,-3,\
	 2,-3,2,-3");
 }

putchar(ch)
 {	
	bios(4,ch);
 }

dance(y, x)
 {	int i,j,k;
	k = 30;
	puts("\033q\033F");
	while (!bios(2))
	 { display(y,x);
	   for (i=0; i<k; i++) putchar((i+j) & 3? ' ':'^'); j++; }
	display(y, x);
	for (i=0; i<k; i++) putchar(' ');
 }


main(argc,argv)
{
        int  hum,com,y,inp;
        char board[14];
	for (y=0; y<1000; y++) Seed += stonex[y];
	srand(Seed);
	exinit();

new:	printf("\033E\033q\033G");
	printf("New Game:\r\nDifficulty (1-1000, or q to quit): ");
	inp = atoi(gets(string));
	if (inp < 1) { printf("\033z"); return; }
	if (inp>1000) goto new;
	printf("Number of stones (1-6): ");
	NUM = atoi(gets(string));
	COUNT = inp * 65;
	NewBD();
	initb(board);
	display(21,50); printf("\033p Difficulty: %d \033q", inp);
	display(19,0);
	printf("Do you want to go first (y or n)? ");
	inp = toupper(getchar());
        printf("\033l\n\n");
        if (inp ==  'N') goto first;
        y = 0;
        while(notdone(board)) {
again:		display(20,10);
                printf("\033G\033p Your move:   \b\b");
                for (;;) {
			dance(20, 40); puts("\033p"); display(20,22);
                        inp = getchar() - '0';
			if (toupper(inp+'0')=='Q')goto new;
                        if (inp < 1 || inp > 6 || !board[inp])
			 { putchar(7); goto again; }
                        y++;
                        break;
                }
		puts("\033q");
                if (!dmove(board,inp)) continue;
first:		display(20,10); rptc(' ', 30);
                y = 0;
                while (notdone(board)) {
			display(21, 10);
	                printf("\033p I'm thinking \033q");
                        inp = comp(board);
			display(21,10); rptc(' ', 30);
			display(22,10);
                        printf("\033p Computer moves: ");
                        printf("%d \033q",inp-7);
                        y++;
                        if (dmove(board,inp)) break;
			display(22,10); rptc(' ', 30);
                }
                y = 0;
        }
        com = board[0]; 
        hum = board[7];
        for (inp = 1; inp < 7; inp++) { 
                hum += board[inp]; 
                com += board[inp+7]; 
        }
	display(23,10);
        printf("\033p Score:   me %d  you %d . . . ",com,hum);
	if (com>hum) switch (rand() % 4) {
		case 0: printf("Gotcha!!");
			break;
		case 1:	printf("Chalk one up for the good guys!");
			break;
		case 2: printf("Automation does it again!");
			break;
		case 3: printf("I LOVE to WIN!");
		}
	else if (hum==com) printf("How frustrating!!");
	else printf("Big Deal! Try a REAL difficulty!");
	printf(" \033q\033G");
	display(19,0);
        printf("\033p New Game (y or n): \033q\033K");
	dance(19,40);
	if (toupper(getchar()) == 'Y') goto new;
	display(23,0);
	printf("\033z");
        exit();
}

mod(i,j)  int i,j; 
{
	++i;
        if (i == 7) return( j ? 7 : 8);
        if (i > 13) return ( j ? 1 : 0);
        return(i);
}

initb(board)  char *board; 
{
         int i,j;
        for (i= 0; i <14; ++i)
	 { board[i]=0;
	   if (i != 0 && i != 7) for (j = 0; j < NUM; j++) incpit(board,i); }
        return;
}

comp(board)  char *board; 
{
         int score;
        int bestscore,best;
        char temp[14];
         int i;
        unsigned nodes;
        total = 0;

        if ((i = countnodes(board,8)) == 1)
                for (best = 8; best < 14; ++best)
                        if (board[best]) return(best);
        nodes = COUNT/i;
        bestscore = -10000;
        for (i = 13; i > 7; --i) if (board[i]) {
                score = mmove(board,temp,i);
		score = comp1( temp, score, nodes, bestscore, 10000);
                if (score > bestscore) {
                        bestscore = score;
                        best = i;
                }
        }
	display(19,10);
        if (bestscore > 1000)
		puts("\033p I'VE GOT YOU! \033q\n");
        if (bestscore < -1000)
                printf("\033p YOU'VE GOT ME! \033q\n");
        return(best);
}

comp1(board,who,count,alpha,beta)
 char *board; int who; int alpha,beta;
unsigned count; 
{
         int i;
        int turn,new;
        char temp[14];
        unsigned nodes;
        if (count < 1) {
                new = board[0]-board[7];
                for (i = 1; i < 7; ++i) { turn = min(7-i,board[i]);
                                          new -= 2*turn - board[i]; }
                for (i = 8; i < 14; ++i) { turn = min(14-i,board[i]);
                                           new += 2*turn - board[i]; }
                if (board[0] > 6*NUM) new += 1000;
                if (board[7] > 6*NUM) new -= 1000;
                return(new);
        }
        if (!notdone(board)) {
                new = board[0]+board[8]+board[9]+board[10]
                    +board[11]+board[12]+board[13]-board[1]-board[2]
                    -board[3]-board[4]-board[5]-board[6]-board[7];
                if ( new < 0) return (new - 1000);
                if ( new > 0) return (new + 1000);
                return(0);
        }
        nodes = count/countnodes(board,8-who*7);
        for (i = 7*(1-who)+6; i > 7*(1-who); --i)
                if (board[i]) {
                        turn = mmove(board,temp,i);
                        new = comp1(temp,(turn? 1-who: who),nodes,alpha,beta);
                        if (who) {
                           beta = min(new,beta);
                           if (beta <= alpha) return(beta); }
                        else { 
                            alpha = max(new,alpha);
                            if (alpha >= beta) return(alpha); }
                }
        return(who ? beta : alpha);
}

min(i,j)  int i,j; 
{
        return(i < j ? i : j);
}

max(i,j)  int i,j; 
{
        return(i > j ? i : j);
}

notdone(board)  char *board; 
{
	return (board[1] || board[2] || board[3] || board[4]
		|| board[5] || board[6]) &&
	       (board[8] || board[9] || board[10] || board[11]
		|| board[12] || board[13]);
}

countnodes(board,start) int start; char *board; 
{
        int i;
        int num;
        num = 0;
	for (i = start; i< start + 6; ++i)
		num += (board[i] ? 1 : 0);
        return(num);
}

incpit(board,pit) char *board; int pit; 
{
	display(1+holex[pit]+stonex[board[pit]],
		3+holey[pit] +stoney[board[pit]]);
	printf("\033F^\033G");
	board[pit]++;
}

display(x,y) int x,y; 
{
	printf("\033Y%c%c",x+32,y+32);
}

decpit(board,pit) char *board; int pit; 
{
	board[pit]--;
	display(1+holex[pit]+stonex[board[pit]],
		3+holey[pit] +stoney[board[pit]]);
	putchar(' ');
}


rpt(cc, n)
 {	while (n--) printf(cc); }

rptc(cc, n)
 {	while (n--) putchar(cc); }

nb1(n)
 {	rpt("ii    q        p  q       p q       p q       p q       p q       p q       p  q        p  ii\n\r", n); }

NewBD()
 {	printf("\033H\033J\033p\033F");
	rptc('i', 77);
	printf("\n\rii"); rptc(' ',73);
	printf("ii\n\rii");
	printf("       ME        6       5       4       3");
	printf("       2       1               ii\n\rii    qr      _p ");
	rpt(" qr     _p", 6); printf("            ii\n\r");
	printf("ii    q        p  q       p q       p q       p q       p q       p q       p  qr      _p  ii\n\r");
	nb1(2);
	printf("ii    q        p  _q     pr _q     pr _q     pr _q     pr _q     pr _q     pr  q        p  ii\n\r");
	printf("ii    q        p                                                   q        p  ii\n\r");

	printf("ii    q        p  qr     _p qr     _p qr     _p qr     _p qr     _p qr     _p  q        p  ii\n\r");
	nb1(2);
	printf("ii    _q      pr  q       p q       p q       p q       p q       p q       p  q        p  ii\n\r");
	printf("ii              _q     pr _q     pr _q     pr _q     pr _q     pr _q     pr  _q      pr  ii\n\r");
	printf("ii                 1       2       3       4       5       6        YOU    ii\n\r");
	printf("ii                                                                         ii\n\r");
	rptc('i', 77);
	printf("\033G\033q");
 }

sleep(n)
 {	int i;
	while (n--) for (i=12000; i--;); }

dmove(new,move) char *new,move; 
{	int i;
	int j; 
	int who;
	if ((move < 1) || (move > 13) || (move == 7) || !new[move])
		printf("Bad arg to mmove: %d",move);
	who = (move < 7 ? 1 : 0);
	i = new[move];
	for (j = 0; j < i; j++) decpit(new,move);
	sleep(1);
	while (i--) {
		move = mod(move,who);
		incpit(new,move);
		putchar(7);
		sleep(1);
	}
	if (new[move] == 1 && who == (move < 7 ? 1 : 0) && move && move != 7)
		while(new[14-move]) { 
			decpit(new,14-move);
			incpit(new,who*7);
		}
	if (move == 0 || move == 7) return(0); 
	else return(1);
}


mmove(old,new,move) char *old;  char *new; int move; 
{
         int i; 
        int who;
        total++;

        for (i = 0; i < 14; ++i) new[i] = old[i];
        if ((move < 1) || (move > 13) || (move == 7) || !new[move])
                printf("Bad arg to mmove: %d",move);
        who = (move < 7 ? 1 : 0);
        i = old[move];
        new[move] = 0;
        while (i--) {
                move = mod(move,who);
		++new[move];
        }
        if (new[move] == 1 && who == (move < 7 ? 1 : 0) && move && move != 7)
        { 
                new[who*7] += new[14-move];
                new[14-move] = 0;
        }
        if (move == 0 || move == 7) return(0); 
        else return(1);
}
