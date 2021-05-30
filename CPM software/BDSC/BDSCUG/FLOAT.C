

/*
	Floating point package support routines

	Note the "fp" library function, available in DEFF2.CRL,
	is used extensively by all the floating point number
	crunching functions.

	(see FLOAT.DOC for details...)

	NEW FEATURE: a special "printf" function has been included
		     in this source file for use with floating point
		     operands, in addition to the normal types. The
		     printf presented here will take precedence over
		     the DEFF.CRL version when "float" is specified
		     on the CLINK command line at linkage time.
		     Note that the "fp" function, needed by most of
		     the functions in this file, resides in DEFF2.CRL
		     and will be automatically collected by CLINK.

	All functions here written by Bob Mathias, except printf and
	sprintf (written by Leor Zolman.)
*/

#define RAM		0x0000		/* start of RAM area for CP/M */
#define NORM_CODE	0
#define ADD_CODE	1
#define SUB_CODE	2
#define MULT_CODE	3
#define DIV_CODE	4
#define FTOA_CODE	5

fpcomp(op1,op2)
	char *op1,*op2;
{
	char work[5];
	fpsub(work,op1,op2);
	if (work[3] > 127) return (-1);
	if (work[0]+work[1]+work[2]+work[3]) return (1);
	return (0);
}

fpnorm(op1) char *op1;
{	fp(NORM_CODE,op1,op1);return(op1);}

fpadd(result,op1,op2)
	char *result,*op1,*op2;
{	fp(ADD_CODE,result,op1,op2);return(result);}

fpsub(result,op2,op1)
	char *result,*op1,*op2;
	{fp(SUB_CODE,result,op1,op2);return(result);}

fpmult(result,op1,op2)
	char *result,*op1,*op2;
{	fp(MULT_CODE,result,op1,op2);return(result);}

fpdiv(result,op1,op2)
	char *result,*op1,*op2;
{	fp(DIV_CODE,result,op1,op2);return(result);}

atof(fpno,s)
	char fpno[5],*s;
{
	char *fpnorm(),work[5],ZERO[5],FP_10[5];
	int sign_boolean,power;

	initb(FP_10,"0,0,0,80,4");
	setmem(fpno,5,0);
	sign_boolean=power=0;

	while (*s==' ' || *s=='\t') ++s;
	if (*s=='-'){sign_boolean=1;++s;}
	for (;isdigit(*s);++s){
		fpmult(fpno,fpno,FP_10);
		work[0]=*s-'0';
		work[1]=work[2]=work[3]=0;work[4]=31;
		fpadd(fpno,fpno,fpnorm(work));
	}
	if (*s=='.'){
		++s;
		for (;isdigit(*s);--power,++s){
			fpmult(fpno,fpno,FP_10);
			work[0]=*s-'0';
			work[1]=work[2]=work[3]=0;work[4]=31;
			fpadd(fpno,fpno,fpnorm(work));
		}
	}
	if (toupper(*s) == 'E') {++s; power += atoi(s); }
	if (power>0)
		for (;power!=0;--power) fpmult(fpno,fpno,FP_10);
	else
	if (power<0)
		for (;power!=0;++power) fpdiv(fpno,fpno,FP_10);
	if (sign_boolean){
		setmem(ZERO,5,0);
		fpsub(fpno,ZERO,fpno);
	}
	return(fpno);
}
ftoa(result,op1)
	char *result,*op1;
{	fp(FTOA_CODE,result,op1);return(result);}

itof(op1,n)
char *op1;
int n;
{
	char temp[20];
	return atof(op1, itoa(temp,n));
}

itoa(str,n)
char *str;
{
	char *sptr;
	sptr = str;
	if (n<0) { *sptr++ = '-'; n = -n; }
	_uspr(&sptr, n, 10);
	*sptr = '\0';
	return str;
}


/*
	The short "printf" function given here is exactly the
	same as the one in the library, but it needs to be placed
	here so that the special "sprintf" is used instead of the
	normal one in DEFF.CRL. The way the linker works is that
	a function is not linked in UNTIL IT IS REFERENCED...so
	if the definition of "printf" were not placed here in this
	file, "sprintf" would not be referenced at all
	until the "printf" from DEFF.CRL got yanked in, at which time
	"sprintf" would ALSO be taken from DEFF.CRL and cause the
	floating point "sprintf" options to not be recognized.

	In other words, if "printf" were not given explicitly here,
	the WRONG sprintf would end up being used.
*/

printf(format)
char *format;
{
	char line[200];
	_mvl();
	sprintf(line,format);
	puts(line);
}


/*
	This is the special formatting function, which supports the
	"e" and "f" conversions as well as the normal "d", "s", etc.
	When using "e" or "f" format, the corresponding argument in
	the argument list should be a pointer to one of the five-byte
	strings used as floating point numbers by the floating point
	functions. Note that you don't need to ever use the "ftoa"
	function when using this special printf/sprintf combination;
	to achieve the same result as ftoa, a simple "%e" format
	conversion will do the trick. "%f" is used to eliminate the
	scientivic notation and set the precision. The only [known]
	difference between the "e" and "f" conversions as used here
	and the ones described in the Kernighan & Ritchie book is that
	ROUNDING does not take place in this version...e.g., printing
	a floating point number which happens to equal exactly 3.999
	using a "%5.2f" format conversion will produce " 3.99" instead
	of " 4.00".
*/


sprintf(line,format)
char *line, *format;
{
	char _uspr(), c, base, *sptr;
	char wbuf[80], *wptr, pf, ljflag;
	int width, precision, exp, *args;

	args = (RAM + 0x3fb);
	while (c = *format++)
	  if (c == '%') {
	    wptr = wbuf;
	    precision = 6;
	    ljflag = pf = 0;

	    if (*format == '-') {
		    format++;
		    ljflag++;
	     }

	    if ( !(width = _gv2(&format))) width++;

	    if ((c = *format++) == '.') {
		    precision = _gv2(&format);
		    pf++;
		    c = *format++;
	     }

	    switch(toupper(c)) {
		case 'E':  if (precision>7) precision = 7;
			   ftoa(wbuf,*args++);
			   strcpy(wbuf+precision+3, wbuf+10);
			   width -= strlen(wbuf);
			   goto pad2;

		case 'F':  ftoa(&wbuf[60],*args++);
			   sptr = &wbuf[60];
			   while ( *sptr++ != 'E')
				;
			   exp = atoi(sptr);
			   sptr = &wbuf[60];
			   if (*sptr == ' ') sptr++;
			   if (*sptr == '-') {
				*wptr++ = '-';
				sptr++;
				width--;
			    }
			   sptr += 2;

			   if (exp < 1) {
				*wptr++ = '0';
				width--;
			    }

			   pf = 7;
			   while (exp > 0 && pf) {
				*wptr++ = *sptr++;
				pf--;
				exp--;
				width--;
			    }

			   while (exp > 0) {
				*wptr++ = '0';
				exp--;
				width--;
			    }

			   *wptr++ = '.';
			   width--;

			   while (exp < 0 && precision) {
				*wptr++ = '0';
				exp++;
				precision--;
				width--;
			    }

			   while (precision && pf) {
				*wptr++ = *sptr++;
				pf--;
				precision--;
				width--;
			    }

			   while (precision>0) {
				*wptr++ = '0';
				precision--;
				width--;
			    }

			   goto pad;


		case 'D':  if (*args < 0) {
				*wptr++ = '-';
				*args = -*args;
				width--;
			    }
		case 'U':  base = 10; goto val;

		case 'X':  base = 16; goto val;

		case 'O':  base = 8;

		     val:  width -= _uspr(&wptr,*args++,base);
			   goto pad;

		case 'C':  *wptr++ = *args++;
			   width--;
			   goto pad;

		case 'S':  if (!pf) precision = 200;
			   sptr = *args++;
			   while (*sptr && precision) {
				*wptr++ = *sptr++;
				precision--;
				width--;
			    }

		     pad:  *wptr = '\0';
		     pad2: wptr = wbuf;
			   if (!ljflag)
				while (width-- > 0)
					*line++ = ' ';

			   while (*line = *wptr++)
				line++;

			   if (ljflag)
				while (width-- > 0)
					*line++ = ' ';
			   break;

		 default:  *line++ = c;

	     }
	  }
	  else *line++ = c;

	*line = '\0';
}
