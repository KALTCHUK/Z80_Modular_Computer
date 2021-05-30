
/*
	"Bugs"
	written by Steve Ward for the H19/H89 display terminal
	BD says..."This one is WIERD!!!"
*/

#define	BUGS	25
#define BOT	0
#define LEFT	0
#define RADIUS2	21

int	Top,		/* Pagesize-1				*/
	Right;		/* Linelength-2				*/

struct bug {
	int X,Y;
	int Dir;	/* 0-down, 1-left, 2-up, 3-right.	*/
	int State; } bugs[BUGS];
char	Wflg, Cflg;
int	CurX, CurY;
int	Bugs;
int	XMotion[20], YMotion[20];

rand()
{
	return nrand(2);
}

step(bb)
	struct bug *bb;
 {	switch ((*bb).State) {
	 case 0:	r(bb,1,0,' ');
			r(bb,1,-1,'\\'); (*bb).State++; break;
	 case 1:	r(bb,-1,0,' ');
			r(bb,-1,-1,'/');
			(*bb).State++;	break;
	 case 2:	r(bb,1,1,' ');
			r(bb,1,0,'\\');
			(*bb).State++;	break;
	 case 3:	r(bb,-1,1,' ');
			r(bb,-1,0,'/');
			(*bb).State++;	break;
	 case 4:	r(bb,0,-1,'0');
			r(bb,0,0,'O');
			r(bb,1,-1,'/');
			r(bb,-1,-1,'\\');
			r(bb,1,0,'/');
			r(bb,-1,0,'\\');
			(*bb).State++;	break;
	 case 5:	r(bb,1,2,' ');
			r(bb,1,1,'\\');
			(*bb).State++;	break;
	 case 6:	r(bb,-1,2,' ');
			r(bb,-1,1,'/');
			(*bb).State++;	break;
	 case 7:	r(bb,1,1,'/');
			r(bb,0,1,' ');
			r(bb,-1,1,'\\');
			switch (((*bb).Dir) & 03) {
			 case 0: (*bb).Y--; break;
			 case 2: (*bb).Y++; break;
			 case 1: (*bb).X++; break;
			 case 3: (*bb).X--; break; }
			(*bb).State = 0;	break;
/* Diagonal movement:						*/

	case 20:	r(bb,1,1,' ');
			r(bb,1,0,'-');
			(*bb).State++;	break;
	case 21:	r(bb,-1,-1,' ');
			r(bb,0,-1,'|');
			(*bb).State++;	break;
	case 22:	r(bb,0,1,' ');
			r(bb,1,1,'/');
			(*bb).State++;	break;
	case 23:	r(bb,-1,0,' ');
			r(bb,-1,-1,'/');
			(*bb).State++;	break;
	case 24:	r(bb,1,-1,'0');
			r(bb,0,0,'O');
			r(bb,1,1,' ');
			r(bb,0,1,'|');
			r(bb,-1,-1,' ');
			r(bb,-1,0,'-');
			r(bb,1,0,'|');
			r(bb,0,-1,'-');
			(*bb).State++;	break;
	case 25:	r(bb,-1,2,' ');
			r(bb,0,2,'/');
			(*bb).State++;	break;
	case 26:	r(bb,-2,1,' ');
			r(bb,-2,0,'/');
			(*bb).State++;	break;
	case 27:	r(bb,-1,1,' ');
			r(bb,0,2,' ');
			r(bb,-2,0,' ');
			r(bb,1,0,'|');
			r(bb,0,-1,'-');
			switch (((*bb).Dir)& 03) {
			 case 0: (*bb).X++; (*bb).Y--; break;
			 case 1: (*bb).X++; (*bb).Y++; break;
			 case 2: (*bb).X--; (*bb).Y++; break;
			 case 3: (*bb).X--; (*bb).Y--; break; }
			(*bb).State = 20;	break;

/* turn from diag to orthogonal (45 deg CCW)				*/

	case 40:	r(bb,-1,0,' ');
			r(bb,-2,0,'/');
			(*bb).State++; break;
	case 41:	r(bb,-1,0,'O');
			r(bb,-1,2,' ');
			r(bb,-1,1,'|');
			r(bb,-2,0,'\\');
			r(bb,-2,1,'\\');
			(*bb).State++; break;
	case 42:	r(bb,1,1,' ');
			r(bb,0,1,'\\');
			r(bb,-1,1,'\\');
			r(bb,-2,0,' ');
			r(bb,-2,-1,'/');
			r(bb,0,-1,'/');
			(*bb).Dir = (((*bb).Dir)+1) & 03;
			(*bb).State = 0; break;

/* Turn from ortho to diagonal:					*/

	case 50:	r(bb,-1,0,' ');
			r(bb,-1,-1,'/');
			(*bb).State++; break;
	case 51:	r(bb,-1,1,' ');
			r(bb,-1,0,'/');
			(*bb).State++; break;
	case 52:	r(bb,1,2,' ');
			r(bb,0,1,'|');
			r(bb,-1,1,'O');
			r(bb,1,0,' ');
			r(bb,-1,2,' ');
			r(bb,0,2,'/');
			r(bb,-1,0,' ');
			r(bb,-2,0,'/');
			r(bb,-2,1,'-');
			(*bb).State++; break;
	case 53:	r(bb,0,2,' ');
			r(bb,-1,2,'|');
			r(bb,-2,0,' ');
			r(bb,-1,0,'-');
			(*bb).Dir = (((*bb).Dir) | 04);
			(*bb).State = 20; break; }
 }


mkbug(bb,x,y,dir)
	struct bug (*bb);
 {	(*bb).X = x;
	(*bb).Y = y;
	(*bb).State = 0;
	(*bb).Dir = dir;

	if (dir<4) {
	 r(bb,0,0,'0');
	 r(bb,0,1,'O');
	 r(bb,1,0,'/');
	 r(bb,1,1,'/');
	 r(bb,1,2,'/');
	 r(bb,-1,2,'\\');
	 r(bb,-1,1,'\\');
	 r(bb,-1,0,'\\'); }
	else {
	 (*bb).State = 20;
	 r(bb,0,0,'0');
	 r(bb,1,1,'/');
	 r(bb,-1,-1,'/');
	 r(bb,0,1,'|');
	 r(bb,-1,0,'-');
	 r(bb,-1,1,'O');
	 r(bb,-1,2,'|');
	 r(bb,-2,1,'-'); }
 }


r(bb,dx,dy,ch)
	struct bug (*bb);
	char ch;
 {	int tx,ty,dir,xdist,ydist;
	char buf[4];
	dir = ((*bb).Dir) & 03;

	if ((dir == 1) || (dir == 3))
	 { switch (ch) {
		case '/':	ch = '\\'; break;
		case '\\':	ch = '/'; break;
		case '|':	ch = '-'; break;
		case '-':	ch = '|'; break;
		default:	break; }}

	switch (dir) {
	 case 0: tx = dx+(*bb).X; ty = dy+(*bb).Y; break;
	 case 2: tx = (*bb).X-dx; ty = (*bb).Y-dy; break;
	 case 1: tx = (*bb).X-dy; ty = (*bb).Y+dx; break;
	 case 3: tx = (*bb).X+dy; ty = (*bb).Y-dx; break; }
	placech(ch,tx,ty); }


placech(ch,tx,ty)
	char ch;
 {	int xdist,ydist;

	if ((tx<LEFT) || (tx>Right) || (ty<BOT) || (ty>Top)) return;

	xdist = CurX-tx; ydist = CurY-ty;
	if (xdist<0) xdist = -xdist;
	if (ydist<0) ydist = -ydist;
	if ((ydist+xdist)>2)
	 { putchar('\033');
	   putchar('Y');
	   putchar(040 + Top - ty);
	   putchar(040 + tx);
	   CurX=tx; CurY=ty; }

	while (CurX<tx)
	 { putchar('\033'); putchar('C'); CurX++; }
	while (tx<CurX)
	 { putchar('\033'); putchar('D'); CurX--; }
	while (CurY<ty)
	 { putchar('\033'); putchar('A'); CurY++; }
	while (ty<CurY)
	 { putchar('\033'); putchar('B'); CurY--; }
	putchar(ch);
	CurX++; }


randbug(bb)
	struct bug *bb;
 {	int x,y,dir;
	 { dir = rand()%8;
	   x = rand()%80;
	   y = rand()%24;
	   if (Cflg)
		{ x = (Right-LEFT)/2; y = (Top-BOT)/2; }
	   else switch(dir & 03) {
		case 0:	y=24+4; break;
		case 2: y = -4; break;
		case 1: x = -4; break;
		case 3: x=80+4; break; }
	   mkbug(bb,x,y,dir); }}


alive(bb)
	struct bug *bb;
 {	int x,y;
	x = (*bb).X; y = (*bb).Y;
	switch(((*bb).Dir) & 03) {
	 case 0: return(y>=BOT-4);
	 case 1: return(x<=Right+6);
	 case 2: return(y<=Top+4);
	 case 3: return(x>=LEFT-4); }}

turn(bb)
	struct bug *bb;
 {	switch ((*bb).State) {
	 case 0:	(*bb).State = 50; return;
	 case 20:	(*bb).State = 40; return;
	 default:	return; }}


main(argc,argv)
	char **argv;
 {	int i,j,xdist,ydist,xmot,ymot;
	char *arg;

	initw(XMotion, "0,1,0,-1,1,1,-1,-1");
	initw(YMotion, "-1,0,1,0,-1,1,1,-1");
	CurX = 1000; CurY = 1000;
	Wflg = 0; Cflg = 0;
	Bugs = 5;
	Top = 23; Right = 78;

	nrand(0,"Are you ready to be driven buggy? ");
	getchar();

	for (i=1; i<argc; i++)
	 { arg = argv[i];
	   if (arg[0] == '-')
		for (j=1; arg[j]; j++) switch(arg[j]) {
		  case 'W':	Wflg++; break;
		  case 'C':	Cflg++; break;
		  default:	printf("bugs: Illegal option\n",21); exit();}
	   else Bugs = atoi(arg); }
	if (Bugs>BUGS) Bugs=BUGS;

	if (Wflg)
	 { for (i=LEFT; i<Right; i++) placech('-',i,Top);
	   for (i=Top; i>BOT; i--) placech('|',Right,i);
	   for (i=LEFT; i<Right; i++) placech('-',i,BOT);
	   for (i=Top; i>BOT; i--) placech('|',LEFT,i);
	 }

	for (i=0; i<Bugs; i++)
	 randbug(&bugs[i]);

	while(1)
	 { i = rand()%Bugs;
	   if (alive(&bugs[i]))
		{ step(&bugs[i]);
		  j = (bugs[i]).State;
		  xmot = XMotion[(bugs[i]).Dir];
		  ymot = YMotion[(bugs[i]).Dir];
		  if ((j == 0) || (j == 20))
			{ if (Wflg) {
			  xdist = (bugs[i]).X;
			  ydist = xdist-Right;
			  if ((xmot>0) && (ydist<0) && (ydist*ydist < RADIUS2))
				turn(&bugs[i]);
			  ydist = xdist-LEFT;
			  if ((xmot<0)&&(ydist>0) && (ydist*ydist < RADIUS2))
				turn(&bugs[i]);
			  xdist = (bugs[i]).Y;
			  ydist = xdist-Top;
			  if ((ymot>0)&&(ydist<0) && (ydist*ydist < RADIUS2))
				turn(&bugs[i]);
			  ydist = xdist-BOT;
			  if ((ymot<0)&&(ydist>0) && (ydist*ydist < RADIUS2))
				turn(&bugs[i]); }}

		  if ((j == 0) || (j == 20))
		   {	for (j=0;j<Bugs;j++)
			 { if (j==i) continue;
			   xdist = (bugs[j]).X - (bugs[i]).X;
			   ydist = (bugs[j]).Y - (bugs[i]).Y;
			   if ((xdist*xdist+ydist*ydist) < 21)
				{ if (((xdist*xmot)<=0) && ((ydist*ymot)<=0))
					continue;
				  turn(&bugs[i]);
				  break; }}
		   if (!(rand()%15))
			  turn(&bugs[i]);}}
	   else randbug(&bugs[i]); }}
