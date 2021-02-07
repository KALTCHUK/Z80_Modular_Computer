
/*  
    //.C    David Kirkland, 20 October 1982

    This is a short submit program.  It is designed to be used 
    when the user wants to batch a few commands, but it's too 
    much trouble to edit a SUB file to do the work.  It can be 
    used in two forms:

	B>// command line 1; command line 2; ... command line n

    or

	B>//
	}command 1
	}command 2
	 .
	 .
	}command n
	}

    In the first form, the // command is entered with arguments.
    group of characters delimited by a semicolon (or the end of
    the line) is treated as a separate command.

    In the second form, // is entered without arguments.  
    // then prompts with a "}", and the user enters commands, one
    per line.  A null line terminates command entry.
    (To enter a null line, enter a singe ^ on the line.)

    In either form, control characters can be entered either
    directly or via a sequence beginning with a "^" and followed
    by a letter or one of [\]^_

*/


#include <stdio.h>

#define OPEN		15	/* BDOS function codes	*/
#define CLOSE		16
#define DELETE		19
#define CREATE		22
#define SET_DMA		26
#define RAND_WRITE	34
#define COMPUTE_SIZE	35

struct fcb {			/* define fcb format	*/
	char drivecode;
	char fname[8];
	char ftype[3];
	char extent;
	char pad[2];
	char rc;
	int  blk[8];
	char cr;
	int  rand_rec;
	char overflow;
	};

#define CPMEOF 0x1a
#define MAXBLK 256
#define SUBNAME "A:$$$.SUB"

struct  fcb ffcb;
				/* the way a record from the $$$.SUB  */
struct  subrec {		/* file looks: 			      */
	char reclen;		/*    number of characters in command */
	char aline[127];	/*    command line		      */
	} ;

struct	subrec out[128];

storeline(block,line) int block; char *line; {

	/* storeline takes the line pointed to by "line" and
	 * converts it to $$$.SUB representation and stores
	 * it in out[block]. 
	 * This routine handles control characters (the ^
	 * escape sequence).
	 *
	 */

	char *p;
	struct subrec *b;
	int i, len;

	b = out[block];

	/* copy line into out.aline, processing control chars */
	for (p = b->aline; *p = *line; p++, line++)
		if (*line=='^')
			if ('@' <= toupper(*++line) && 
			     toupper(*line) <= '_')
				*p = 0x1f&*line;
			else if (*p = *line)
				break;

	/* set up length byte */
	b->reclen = len = strlen(b->aline);
	if (len>127) {
		printf("Line %d is too long (%d > %d)\n",block,len,127);
		bdos(DELETE,ffcb);
		exit();
		}

	/* pad block with CPMEOFs (not needed?) */
	for (i=len+2;i<128;i++)
		*++p = CPMEOF;
}

main (argc, argv) int argc;  char *argv[]; {
	char  *p,		/* points to ; that ended
				   current command	*/
	      *b,		/* current character in
				   command		*/
	      done;		/* loop control 	*/
	char  line[256];
	int   block;		/* index into out array */

	block = 0;

	if (argc<2)		/* prompt user format	*/
		while (1) {
			putchar('}');
			if (!fgets(line,128, stdin))
				break;
			storeline(block++, line);
			}
	else {
		/* scan command line in low memory */
		b = p = 0x80;
		for (done=0; !done; p = b) {
			/* skip leading whitespace */
			while (isspace(*++b)) p = b;
			while (*b && *b!=';') b++;
			done = !*b;
			*b = 0;
			storeline(block++, p+1);
			}
		}

	setfcb(ffcb,SUBNAME);
	if (255==bdos(OPEN,ffcb) && 255==bdos(CREATE,ffcb)) {
		printf("Can't create %s\n",SUBNAME);
		exit();
		}

	/* find end of $$$.SUB so submits can nest */
	bdos(COMPUTE_SIZE,ffcb);

	/* write blocks in REVERSE order for CCP */
	for(--block; block >= 0; block--) {
		bdos(SET_DMA, out[block]);
		bdos(RAND_WRITE, ffcb);
		ffcb.rand_rec++;
		}

	/* all done! */
	if (255==bdos(CLOSE,ffcb))
		printf("Could not close %s\n",SUBNAME);
}
