/*
	Word processor
	Translated from the 'format' program in 'Software Tools'
*/

#include <macdefs.wp>
#include <globals.wp>

#define fputc putc	/* I keep getting it wrong */



/*
	Initialize global variables
*/


initialize()
	{
	lineno = curpag = 0;
	newpag = 1;
	plval = PAGELEN;
	m1val = m2val = m3val = m4val = 2;
	bottom = plval - m3val - m4val;
	strcpy(header,"\n");
	strcpy(footer,"\n");
	*outbuf = '\0';		/* initially empty output buffer */

	fill = YES;
	lsval = 1;
	rmval = PAGEWIDTH;
	inval = tival = ceval = ulval = 0;

	outp = outw = outwds = 0;

	dir = 0;
	}


/*
	Word processing main program
*/

main(argc,argv)
	int argc;
	char *argv[];
	{
	char *fgets();
	char ifile[134];
	char ofile[134];
	int ofd;
	char inbuf[INSIZE];	/* input line buffer */

	if( argc != 3 )
	  exit(puts("\nusage: WP <infile> <outfile>"));
	if( fopen(argv[1],ifile) == NOFILE )
	  exit(printf("\nNo such file : %s",argv[1]));
	if( samestr(argv[2],"CON:") )
	  outfile = 1;
	else if( samestr(argv[2],"LST:") )
	  outfile = 2;
	else if( samestr(argv[2],"PUN:") )
	  outfile = 3;
	else {	/* output sent to disk */
	  if( (ofd = fcreat(argv[2],ofile)) == NOFILE )
	    exit(printf("\nCan't open : %s",argv[2]));
	  else
	    outfile = ofile;
	  }
	initialize();
	while( fgets(inbuf,ifile) ) {
	  xpndtab(inbuf);
	  if( inbuf[0] == COMMAND )
	    command(inbuf);
	  else
	    text(inbuf);
	  }
	brk();			/* flush any remaining text */
	if( lineno > 0 )
	  space(HUGE);
	if( outfile == 2 ) /* lineprinter */
	  fputc('\f',outfile);
	else if( outfile > 3 ) { /* diskfile */
	  fputc(0x1a,outfile);
	  fflush(outfile);
	  if( close(ofd) == NOFILE )
	  printf("\nCan't close : %s",argv[2]);
	  }
	}




/*
	Command handler

	Defined commands:

	BP	.bp	{+,-} {<n>}	* begin page and set page number
	BR	.br			* break
	CE	.ce	{<n>}		* center n lines (default 1)
	FI	.fi			* fill
	FO	.fo	{<text>}	  footer title
	HE	.he	{<text>}	  header title
	IN	.in	{+,-}<n>	  indent n co
	LS	.ls	{+,-}<n>	  line spacing
	NF	.nf			* no fill
	PL	.pl	{+,-}<n>	  page length of n lines
	RM	.rm	{+,-}<n>	  right margin n columns
	SP	.sp	{<n>}		* space n lines (default 1 )
	TI	.ti	{+.-}<n>	* temporary indent n columns
	UL	.ul	{<n>}		  underline n lines (default 1)

	note: * => causes a break

*/

command(buf)
	char *buf;
	{
	int comtyp(),getval(),max();
	char argtyp;
	int ct;
	int spval;
	int val;

	val = getval(buf,&argtyp);
	switch( ct = comtyp(buf) ) {
	  case BP:	if( lineno > 0 )
			  space(HUGE);
			set(&curpag,val,argtyp,curpag+1,-HUGE,HUGE);
			newpag = curpag;
			break;

	  case BR:	brk();
			break;

	  case CE:	brk();
			set(&ceval,val,argtyp,1,0,HUGE);
			break;

	  case FI:	brk();
			fill = YES;
			break;

	  case FO:	gettl(buf,footer);
			break;

	  case HE:	gettl(buf,header);
			break;

	  case IN:	set(&inval,val,argtyp,0,0,rmval-1);
			tival = inval;
			break;

	  case LS:	set(&lsval,val,argtyp,1,1,HUGE);
			break;

	  case NF:	brk();
			fill = NO;
			break;

	  case PL:	set(&plval,val,argtyp,PAGELEN,
				(m1val+m2val+m3val+m4val+1),HUGE);
			bottom = plval - m3val - m4val;
			break;

	  case RM:	set(&rmval,val,argtyp,PAGEWIDTH,tival+1,HUGE);
			break;

	  case SP:	set(&spval,val,argtyp,1,0,HUGE);
			space(spval);
			break;

	  case TI:	brk();
			set(&tival,val,argtyp,0,0,rmval);
			break;

	  case UL:	set(&ulval,val,argtyp,0,1,HUGE);
			break;

	  default:	break;	/* ignore unknown commands */
	  }
	}

/*
	process Text
*/

text(inbuf)
	char inbuf[];
	{
	int i;

	if( inbuf[0] == ' ' || inbuf[0] == '\n' )
	  leadbl(inbuf);
	if( ulval > 0 )	{		/* underlining */
	  underl(inbuf,wrdbuf,INSIZE);
	  ulval--;
	  }
	if( ceval > 0 )	{		/* centering in effect */
	  center(inbuf);
	  put(inbuf);
	  ceval--;
	  }
	else if( inbuf[0] == '\n' )	/* all blank line */
	  put(inbuf);
	else if( fill == NO )		/* un-filled text */
	  put(inbuf);
	else				/* filled text */
	  for( i=0; getwrd(inbuf,&i,wrdbuf) > 0; )
	    putwrd(wrdbuf);
	}



/*
	Command type
*/


comtyp(buf)
	char *buf;
	{
	int index();
	char cmd[2];
	int i;

	for(i=0; i < 2;	i++ )
	  cmd[i] = tolower(buf[i+1]);
	cmd[2] = '\0';
	if( samestr(cmd,"bp") )
	  return BP;
	else if( samestr(cmd,"br") )
	  return BR;
	else if( samestr(cmd,"ce") )
	  return CE;
	else if( samestr(cmd,"fi") )
	  return FI;
	else if( samestr(cmd,"fo") )
	  return FO;
	else if( samestr(cmd,"he") )
	  return HE;
	else if( samestr(cmd,"in") )
	  return IN;
	else if( samestr(cmd,"ls") )
	  return LS;
	else if( samestr(cmd,"nf") )
	  return NF;
	else if( samestr(cmd,"pl") )
	  return PL;
	else if( samestr(cmd,"rm") )
	  return RM;
	else if( samestr(cmd,"sp") )
	  return SP;
	else if( samestr(cmd,"ti") )
	  return TI;
	else if( samestr(cmd,"ul") )
	  return UL;
	else
	  return UNKNOWN;
	}



/*
	Get a parameter value from a command line
	and whether it is an absolute or relative value
*/

getval(buf,argtyp)
	char *buf;
	char *argtyp;	/* pointer to single char */
	{
	int abs(),atoi();

	while( ! isspace(*buf) )	/* skip command */
	  buf++;
	while( isspace(*buf) )		/* skip whitespace separator */
	  buf++;
	*argtyp = *buf;			/* argument type: +, - or digit	*/
	if( isdigit(*argtyp) )
	  *argtyp = '0';
	if( *argtyp == '+' )
	  ++buf;
	return abs(atoi(buf));
	}



/*
	Set parameter and saturate on out of valid range
*/

set(param,val,argtyp,defval,minval,maxval)
	int *param;	/* address of parameter to be set */
	int val;	/* value from command line */
	char argtyp;	/* +, -, or 0 */
	int defval;	/* default value */
	int minval;	/* minimum allowable value */
	int maxval;	/* maximum allowable value */
	{

	switch( argtyp ) {
	  case '+':	*param += val;
			break;

	  case '-':	*param -= val;
			break;

	  case '0':	*param = val;
			break;

	  default:	*param = defval;
	  }
	if( *param > maxval )
	  *param = maxval;
	if( *param < minval )
	  *param = minval;
	}






/*
	Underline
		Replace non-whitespace chars with '_','\b',char
*/

underl(buf,tbuf,size)
	char buf[];
	char tbuf[];
	int size;
	{
	int i,j;
	char c;

	j = 0;
	for( i = 0; buf[i] != '\n' && j < size-1; i++ ) {
	  tbuf[j++] = buf[i];
	  if( buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\b' ) {
	    c = tbuf[--j];
	    tbuf[j++] = '_';
	    tbuf[j++] = '\b';
	    tbuf[j++] = c;
	    }
	  }
	tbuf[j++] = '\n';
	tbuf[j] = '\0';
	strcpy(buf,tbuf);
	}



/*
	Center -- fakeout by setting temporary indent
*/

center(buf)
	char *buf;
	{
	int width();
	int temp;

	temp = (rmval + tival - width(buf))/2;
	tival = max(temp,0);
	}


/*
	Spread words to justify right margin
*/

spread(buf,outp,nextra,outwds)
	char buf[];
	int outp;
	int nextra;
	int outwds;
	{
	int i,j,nb,nholes;
	int kk;

	if( nextra <= 0 || outwds <= 1 )
	  return;
	dir = ++dir & 1;	/* toggle bias direction */
	nholes = outwds - 1;
	i = outp - 1;	/* point at final non-blank */
	j = min(i + nextra,(MAXOUT-2));
	while( i < j ) {
	  buf[j] = buf[i];
	  if( buf[i] == ' ' ) {
	    if( dir )
	      nb = nextra / nholes;		/* truncated */
	    else
	      nb = (nextra - 1) / nholes + 1;	/* rounded */
	    nextra -= nb;
	    nholes--;
	    for( ; nb > 0; nb-- )
	      buf[--j] = ' ';
	    }
	  --i;
	  --j;
	  }
	}




/*
	put a word in outbuf including margin justification
*/

putwrd(wrdbuf)
	char *wrdbuf;
	{
	int width();
	int last;
	int llval;
	int nextra;
	int w;
	int i;	/* debug only */

	w = width(wrdbuf);	/* printable width of wrdbuf[] */
	last = strlen(wrdbuf) + outp; 
	llval = rmval - tival;	/* printable line length */
	if( outp > 0 && ( (outw+w) > llval || last >= (MAXOUT-2) ) ) {
	  last -= outp;				/* too big */
	  nextra = llval - (outw - 1);	/* # blanks needed to pad */
	  if( nextra > 0 && outwds > 1 ) {
	    outp--;			/* back up to final blank */
	    spread(outbuf,outp,nextra,outwds);
	    outp += nextra;
	    }
	  brk();	/* flush previous line */
	  }
	strcpy(outbuf+outp,wrdbuf);	/* add new word to outbuf[] */
	outp = last;
	outbuf[outp++] = ' ';		/* add a blank behind it */
	outw += (w + 1);		/* update output width */
	outwds++;			/* increment the word count */
	}




/*
	brk -- end current filled line
*/

brk()
	{

	if( outp > 0 ) {
	  outbuf[outp] = '\n';
	  outbuf[++outp] = '\0';
	  put(outbuf);
	  }
	outp = outw = outwds = 0;
	}



/*
	width of a printed line
*/

width(buf)
	char *buf;
	{
	int wid;
	char c;

	wid = 0;
	while ( c = *buf++ )
	  if( c == '\b' )
	    wid--;
	  else if( c != '\n' )
	    wid++;
	return wid;
	}



/*
	expand tabs in the input buffer since
	the word processor doesn't really know how
	to handle them
*/

xpndtab(inbuf)
	char *inbuf;
	{
	char tbuf[300];
	char *i,*t;
	int col;
	char c;

	col = 0;
	i = inbuf;
	t = tbuf;
	while( c=*i++ ) {
	  if( c == '\t' )
	    do {
	      *t++ = ' ';
	      } while( ++col & 7 );
	  else
	    *t++ = c;
	  }
	*t = '\0';
	strcpy(inbuf,tbuf);
	}


