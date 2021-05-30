/*
	H19 RALLY Game,		5/80	Steve Ward

	Works ONLY on Heathkit/Zenith H19/Z19 terminal
	 			(or H89 computer)

	Command format:

	A>rally [-rn] [-b] [mapname] <cr>

	where:	"n"  is an optional seed for the random number generator
		     (results in exactly the same minor track deviations each
		     time it is given with a particular track);
		     If "n" is omitted, then track deviations are totally
		     random for each session (but same for each run in any
		     single session.)

		"-b" is a debugging option doing Steve-knows-what.

		"mapname" specifies the map file to use for the track
		    (defaults to "rally.map").
*/


			/* Hardware Dependent defines:		*/
#define	CRTDAT	0350  	/* H19 data port			*/
#define	CRTSTA	0355  	/* H19 status port			*/
#define INPMASK 0x01	/* input data ready mask		*/
#define OUTMASK 0x20	/* ready to transmit to H19 mask	*/
			/* END Hardware Dependent defines	*/

			/* Note that the program is set up
			   assuming the status bits are active
			   HIGH...if yours are active low,
			   you'll have to go change the 
			   "putchar" function below.		*/

#define	CARY	16		/* Y position of car.		*/
#define	IBAD	0
#define	LSPEED	7		/* Line 25 label posns		*/
#define	LMILES	20
#define	MAXSPD	9
#define	SPDSCL	128
#define	TENTHS	10		/* Number of lines per mile.	*/
#define	TICMIN	1920		/* Number of tics per minute.	*/

char	Free[10000], *Freep;

char	CRTFrz, CRTChr;
int	Miles;
char	Pavement, Freeze, BFlag;
char	CurX, CurY, SignY;
int	CarX, CarDX;
char	RevFlg, AltFlg;
int	Speed, Tenths;
char	Image[CARY*80+80];
char	*ImPtr, *ImEnd;
int	Seed;
int	Ranno;
char	InBuf[134], SavChr;
int	SpTime[MAXSPD+1];

struct Road {
	struct Node *Next;
	char	active;
	char	Token;
	int	Windy;
	int	Curvy;
	int	Age;
	int	ToGo;
	char	Holes;
	char	X;
	char	dx;
	char	width; } Road1, Road2;

struct Sign {
	struct Node *Next;
	char key;
	char text[0]; };

struct Fork {
	struct Node *Next;
	char key;
	char *Branch; };

struct Dist {
	struct Node *Next;
	char key;
	char wid, curve, wind;
	int miles; };

union Node {
	struct Dist;
	struct Fork;
	struct Sign; } *Tag[128];

/*
	This function assumes that both input and output
	status bits on the H19 port are active (true) high.
	If your serial port goes the other way, you'll have to
	change two of the lines as follows:

	 { if (INPMASK & (stat = inp(CRTSTA)))
			goes to				(change #1)
	 { if (!(INPMASK & (stat = inp(CRTSTA))))

	AND 

	    if (stat & OUTMASK) { ... }}}
			becomes				(change #2)
	    if (!(stat & OUTMASK)) { ... }}}
*/

putchar(c)
 {	char stat, ch;
	for(;;)
	 { if (INPMASK & (stat = inp(CRTSTA)))
	    switch(ch = (0177 & inp(CRTDAT))) {
		case 'S'-64:	CRTFrz=1; break;
		case 'Q'-64:	CRTFrz=0; break;
		case 'C'-64:	puts("\033z"); exit();
		default:	CRTChr=ch; }
	   if (CRTFrz) continue;
	   if (stat & OUTMASK) { if (c) outp(CRTDAT, c); return; }}}


char *new(size)
 {	char *rr;
	rr = Freep; Freep += size; return rr; }

struct Dist *NRoad(widx, curv, windx, dist)
 {	struct Dist *rr;
	rr = new(sizeof *rr);
	rr->key = 'D';		rr->Next = 0;
	rr->miles = dist;	rr->wid = widx;
	rr->curve = curv;	rr->wind = windx;
	return rr; }

struct Sign *NSign(txt)
 char *txt;
 {	int leng; char *cc, *dd;
	struct Sign *ss;
	leng = sizeof *ss; leng++;
	for (cc=txt; *cc++; leng++);
	ss = new(leng);		ss->key = 'S';		ss->Next = 0;
	dd = &(ss->text); for (cc=txt; *dd++ = *cc++;);
	return ss; }

struct Fork *NFork(kk)
 {	struct Fork *ff;
	ff = new(sizeof *ff); ff->key = kk;
	ff->Next = 0;	ff->Branch = 0;
	return ff; }

PrNode(nn)
 struct Node *nn;
 {	printf("Node %x: %c -> %x \r\n", nn, nn->key, nn->Next); }

char rdc()
 {	char ch;
	if (ch = SavChr) { SavChr=0; return ch; };
	return (getc(InBuf)); }

char pkc()
 {	return (SavChr = rdc()); }

int rdn()
 {	int ans, ch;
	ans = 0;
	while (isdigit(pkc()))	ans = ans*10 + (rdc() - '0');
	return ans; }

struct Dist *LRoad()
 {	int w, c, iwid, dd;
	char ch;
	dd = rdn();
	w = -1; c = -1; iwid = 20;
	while (pkc() != '\n') switch(rdc())
	 {	case '~':	c++; continue;
		case 'W':	iwid = rdn(); continue;
		case '!':	w++; continue;
		default:	continue; }
	return NRoad(iwid, c, w, dd);
 }

struct Dist *Load(name)
 char *name;
 {	char ch, buf[100], *cc;
	struct Sign First, Ignore;
	struct Node *it, *last;
	puts("\033z");
	SavChr = 0;
	it = &First; First.key = '?';
	if (fopen(name, InBuf) == -1)
	 { printf("Can't read %s\r\n", name); exit(); }

	while ((ch = rdc()) != 014) putchar(ch);
	while ((ch = rdc()) != ('Z'-64))
	 { last = it;
	   switch(ch)
	    {	case '=':	Tag[rdc(InBuf)] = Freep; break;
		case '|':	while (rdc() != '\n'); break;
		case '"':	cc = buf;
				while (((ch = rdc()) != '"') &&
					(ch != '\n')) *cc++ = ch;
				*cc = 0;
				it->Next = NSign(buf); it = it->Next;
				break;
		case '#':	it->Next = LRoad(); it = it->Next;
				break;

		case ':':	it->Next = rdc();
		case '.':	it = &Ignore; break;

		case '>':	it->Next = NFork('R'); it = it->Next;
				it->Branch = rdc();
				break;
		case '<':	it->Next = NFork('L'); it = it->Next;
				it->Branch = rdc();
				break;

		case ' ':	case '\n':	case '\r':	case '\t':
		case '\f':	break;

		default:	puts("Illegal syntax: "); putchar(ch);
				while ((ch = rdc(InBuf)) != '\n') putchar(ch);
				puts("\n\r"); break; }}
	NSign("Unbound label");
	srand1("\033x1\033x5\033Y8   (type a character to start)");
	if (!Seed) Seed = rand();	/* Do this only if "-r" option given
					   without any argument.	*/
	bdos(3);
	return First.Next; }

Exec(rr)
 struct Road *rr;
 {	int x, dir, tt, right, left;
	union Node *nn;
	nn = rr->Next;	rr->Next = nn->Next;
	x = rr->X; dir = -1;

	switch (nn->key) {
	 case 'S':	right = x+(rr->width); left = 78-right;
			x = x>left? 0:right+2;
			printf("\033Y%c%c\033G %s \033F",
				SignY++, x+32, &(nn->text));
			return;
	 case 'D':	rr->Age = 0;
			if (nn->wind != 255) rr->Windy = ~(-1 << nn->wind);
			if (nn->curve != 255) rr->Curvy = nn->curve;
			rr->ToGo = nn->miles;
			if (nn->wid != 255) rr->width = nn->wid; return;
	 case 'L':	dir = 1;
	 case 'R':	if (!Freeze) fork(nn->Branch, dir); return;
			 }
 }

MoveTo(x, y) { puts("\033Y"); putchar(y+32); putchar(x+32); }
SpeedL() { MoveTo(LSPEED, 24); putchar(Speed + '0'); }
label(val, posn)
 {	printf("\033Y8%c%d ", posn+32, val); }


getchar()
 {	char ch;
	while (!(ch = CRTChr)) putchar(0);
	CRTChr = 0; return ch; }

car(x)
 {	puts("\033Y"); putchar(CARY+31); putchar(x+32);
	puts(" "); }

roll()
 {	puts("\033H\033L");
	CurX=0; CurY=0;
	if ((ImPtr += 80) == ImEnd) ImPtr = Image;
	Pavement = ImPtr[CarX];
	setmem(ImPtr, 80, IBAD); }

road(x, width, rdno)
 {	char i, *cc;
	puts("\033Y ");
	putchar(32+x);
	if (!RevFlg) { puts("\033p"); RevFlg=1; }
	if (!AltFlg) { puts("\033F"); AltFlg=1; }
	cc = &(ImPtr[x]);
	for (i=width; i--;) { putchar('i'); *cc++ |= rdno; }}

/* Update a Road; returns 1 if finish line.	*/

UpRd(rr)
 struct Road *rr;
 {	int ddx, left, right, curve, act, rough; unsigned i;
	if (!(act = rr->active)) return 0;
	(rr->ToGo)--;
	while ((rr->ToGo) <= 0)
	 { if (i = (rr->Next))
	    {	if (i == '.') return 1;
		if (i == '*') { rr->active = 0; return 0; }
		if (i < 128)
		 { rr->Next = Tag[i];
		   if (BFlag) { puts("\033H\033G");
				putchar(i);
				puts("\033F"); }}
		Exec(rr); }
	   else { rr->active = 0; return 0; }}
	if (Freeze) rough=0;
	else rough=1;
	if (++(rr->Age) > 24)
		if (!(Pavement & (rr->Token)))
			{ rr->active = 0; Freeze = 0; return 0; }
	ddx = rr->dx;
	left = rr->X; right = left+(rr->width);
	if (left < 1) ddx = rough;
	else if (right > 79) ddx = -rough;
	else if ((!Freeze) && (!((rr->Windy) & Ranno)))
	 { curve = rr->Curvy;
	   if (Ranno & 64) ddx += 1;
	   if (Ranno & 1024) ddx -= 1;
	   if ((ddx > curve) || (ddx < (-curve))) ddx = rr->dx; }
	rr->dx = ddx;
	rr->X += ddx;
	road(rr->X, rr->width, rr->Token);
	return 0; }

/* returns 2 iff end, 0 iff crash, 1 else.	*/

int Update()
 {	int Eor;
	SignY=32;
	roll();
	Eor = UpRd(&Road1) | UpRd(&Road2);
	if (Eor) return 2;
	Delay(SpTime[Speed]);
	if ((CarX += CarDX) < 0) { CarX=0; CarDX=0; }
	else if (CarX > 79) { CarX=79; CarDX=0; }
	car(CarX);
	if (Pavement == IBAD) return 0;
	return 1; }

Delay(n)
 {	char ch;
	n |= 1;
	while (n--)
	 {	putchar(0);
		if (CRTChr)
		 { ch = getchar();
		   switch(ch) {
			case '4':	CarDX--; break;
			case '6':	CarDX++; break;
			case '5':
			case '2':	if (Speed>1) Speed--; Speed--;
			case '8':	if (++Speed > MAXSPD) Speed=MAXSPD;
					SpeedL();
					 }}}}

fork(where, dir)
 struct Node *where;
 {	struct Road *r1, *r2, newx;
	r1 = &Road1; r2 = &Road2;
	if (!(r1->active)) { r1 = &Road2; r2 = &Road1; }
	r1->dx = dir; r2->dx = -dir;
	r2->X = r1->X;
	r2->active = 1; r2->Age = 0;
	r2->Windy = r1->Windy;
	r2->Curvy = r1->Curvy;
	r2->width = r1->width;
	r2->Next = where; r2->ToGo = -1;
	Freeze = 1; }

main(argc, argv)
 char **argv;
 {	int i, j, Mins, Hours, Tics;
	char *arg, *MapNam;
	struct Node *First;
	Seed = 12345;
	j = SPDSCL*MAXSPD;
	for (i=1; i<= MAXSPD; i++) SpTime[i] = j/i - SPDSCL;
	SpTime[MAXSPD] = 0;
	BFlag = 0; MapNam = "RALLY.MAP";
	for (i=1; i<argc; i++)
	 { if (*(arg = argv[i]) == '-') switch(*++arg) {
		case 'R':	Seed = atoi(++arg);
				continue;
		case 'B':	BFlag++; continue; }
	   else MapNam = arg; }
	CRTFrz = CRTChr = 0;
	Freep = Free;
	for (i=0; i<128; i++) Tag[i] = 0;
	First = Load(MapNam);
top:	srand(Seed); Ranno = rand();
	Freeze=0;
	puts("\033H\033J\033G\033x5\033x1\033Y8 \033K\033p");
	puts(" Speed 00     Miles 0      ");
	puts("\033Y8X Rally 1.2   Steve Ward ");
	setmem(Image,CARY*80,255);
	ImPtr = Image; ImEnd = &(Image[CARY*80]);
	Road1.Token=1; Road2.Token=2;
	Road1.active = 1; Road1.Age = 0; Road1.ToGo = 0;
	Road1.X = 20; Road1.dx = 0;
	Road2.active = 0;
	CarDX = 0;
	RevFlg = 0; AltFlg = 0;
	Road1.ToGo = 0; Road1.Next= First;
	CarX = Road1.X + (Road1.width >> 1);
	Speed=3;
	Update();
	for (i=0; i<CARY; i++) { Update(); SpeedL(); }
	Miles=0; Tenths=0;
	label(Miles, LMILES); Mins=0; Hours=0; Tics=0;
loop:	Ranno = rand();
	Tics += SpTime[Speed]+SPDSCL;
	while (Tics >= TICMIN) { Tics -= TICMIN; Mins++; };
	while (Mins >= 60) { Mins -= 60; Hours++; };
	if (!(i = Update()))
	 { puts("\033H CRASHED AFTER ");
done:	   printf("\033G %d Hours, %d Minutes\007!!! !!! !!!  ", Hours, Mins);
	   delay(10000);
	   goto top; }
	else if (i == 2)
	 { puts("\033H YOU MADE IT IN ");
	   goto done; }
	if (++Tenths >= 10)
	 { label(++Miles, LMILES); Tenths=0; }
	goto loop;
 }
