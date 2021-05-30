/*
	Utility functions for word processor
*/

#include <macdefs.wp>
#include <globals.wp>

#define fputc putc	/* I keep getting it wrong */

/*
	copy title from buf to ttl
*/

gettl(buf,ttl)
	char *buf;
	char *ttl;
	{

	while ( ! isspace(*buf) )
	  buf++;
	while ( isspace(*buf) )
	  buf++;
	if ( *buf == '\'' || *buf == '"' )
	  buf++;
	strcpy(ttl,buf);
	}


/*
	space n lines or to bottom of page
*/

space(n)
	int n;
	{

	brk();
	if ( lineno > bottom )
	  return;
	if( lineno == 0 )
	  phead();
	skip(min(n,bottom+1-lineno));
	lineno += n;
	if ( lineno > bottom )
	  pfoot();
	}


/*
	put out a line with proper spacing and indenting
*/

put(buf)
	char buf[];
	{
	int i;

	if ( lineno == 0 || lineno > bottom )
	  phead();
	for ( i=0; i < tival; i++ )
	  fputc(' ',outfile);
	tival = inval;
	fputs(buf,outfile);
	skip(min(lsval-1,bottom-lineno));
	lineno += lsval;
	if ( lineno > bottom )
	  pfoot();
	}


/*
	delete leading blanks and set tival
*/

leadbl(buf)
	char buf[];
	{
	int i;

	brk();
	for ( i = 0; buf[i] == ' '; i++ )
	  ;
	if ( buf[i] != '\n' )
	  tival = i;
	strcpy(buf,&buf[i]);
	}




/*
	put out page header
*/

phead()
	{

	curpag = newpag++;
	if ( m1val > 0 ) {
	  skip(m1val-1);
	  puttl(header,curpag);
	  }
	skip(m2val);
	lineno = m1val + m2val + 1;
	}



/*
	put out page footer
*/

pfoot()
	{

	skip(m3val);
	if ( m4val > 0 )
	  puttl(footer,curpag);
	skip(m4val-1);
	lineno = 0;
	}



/*
	put out title line with optional page number
*/

puttl(buf,pageno)
	char *buf;
	int pageno;
	{
	char c;

	while ( c = *buf++ )
	  if ( c == '#' )
	    fprintf(outfile,"%4d",pageno);
	  else
	    fputc(c,outfile);
	}

/*
	get a non-blank word from in[i] to out[]
	and advance i
	return length of out[]
*/

getwrd(in,i,out)
	char in[];
	int *i;
	char out[];
	{
	int ii;
	int j;
	char c;

	ii = *i;
	while ( (c=in[ii]) == ' ' || c == '\t' )
	  ++ii;
	j = 0;
	while ( (c=in[ii]) != ' ' && c != '\t' && c != '\n' && c != '\0' )
	  out[j++] = in[ii++];
	out[j] = '\0';
	*i = ii;
	return j;
	}


/*
	output n blank lines
*/

skip(n)
	int n;
	{
	int i;

	for ( i = 0; i < n; i++ ) {
	  putc('\r',outfile);
	  putc('\n',outfile);
	  }
	}



/*
	minimum of two arguments
*/

min(a,b)
	int a;
	int b;
	{
	return a < b ? a : b;
	}



/*
	maximum of two arguments
*/

max(a,b)
	int a;
	int b;
	{
	return a > b ? a : b;
	}


/*
	compare strings for equality
	make upper and lower case equivalent
*/

samestr(str1,str2)
	char *str1,*str2;
	{
	while ( *str1 )
	  if ( toupper(*str1++) != toupper(*str2++) )
	    return 0;
	if ( *str2 != '\0' )
	  return 0;
	return 1;
	}


/*	-------------------------------------------------------

	Name:		index(s,t)
	Result:		position of s in t
	Errors:		notfound
	Globals:	---
	Macros:		---
	Procedures:

	Action:		Return the position (index) in the
			string s where string t begins,
			or -1 if s doesn't contain t.
			Uses 0 as starting position in s

	------------------------------------------------------- */

index(s, t)
	char s[], t[];
	{
	int i, j, k;

	for (i = 0; s[i] != '\0'; i++) {
	  for (j=i, k=0; t[k]!='\0' && s[j]==t[k]; j++, k++)
	    ;
	  if (t[k] == '\0')
	    return(i);
	  }
	return -1;
	}
