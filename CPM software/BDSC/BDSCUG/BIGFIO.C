/*
	Large-buffer file I/O routines

	(W) Copywrong 1980 Scott W. Layson
	All Rights Reversed.

These routines are almost-exact replacements for fopen, fcreat, putc,
getc, ungetc and fflush, except that they allow use of an arbitrarily
large (instead of always 128 bytes) buffer.  The program using them should
declare the buffer as an array of [nb*128 + 8] chars, where nb is the
number of 128-byte blocks the buffer is to contain.  FOpenBig and
FCreatBig take nb as a third argument, but none of the other routines
need it.

*/


struct buf {
	int size, fd, nleft;	/* size is in blocks */
	char *nextp, buff;	/* really buff[][128] */
	};


/* Note that this routine is called with the size, in blocks, of the buffer */

FOpenBig (filename, iobuf, buffsize)
char *filename;
struct buf *iobuf;
int buffsize;
{
	if ( (iobuf->fd = open (filename, 0)) < 0) return -1;
	iobuf->size = buffsize;
	iobuf->nleft = 0;
	return iobuf->fd;
}


FCreatBig (filename, iobuf, buffsize)
char *filename;
struct buf *iobuf;
int buffsize;
{
	unlink (filename);
	if ( (iobuf->fd = creat(filename)) < 0) return -1;
	iobuf->size = buffsize;
	iobuf->nleft = buffsize * 128;
	iobuf->nextp = &(iobuf->buff);
}


GetcBig (iobuf)
struct buf *iobuf;
{
	int nsecs;
	if (iobuf == 0) return getchar();
	if (iobuf->nleft--)  return *iobuf->nextp++;
	if ( (nsecs = read (iobuf->fd, &(iobuf->buff), iobuf->size)) <= 0)
		return -1;
	iobuf->nleft = nsecs * 128 - 1;
	iobuf->nextp = &(iobuf->buff);
	return *iobuf->nextp++;
}


PutcBig (ochar, iobuf)
char ochar;
struct buf *iobuf;
{
	if (iobuf == 0)  {
		putchar(ochar);
		return 0;
	    }
	if (iobuf->nleft == 0
	    && FflushBig(iobuf) < 0)  return -1;
	--iobuf->nleft;
	*iobuf->nextp++ = ochar;
	return 0;
}


FflushBig (iobuf)
struct buf *iobuf;
{
	if (iobuf == 0) return 0;
	if (iobuf->nleft == iobuf->size * 128) return 0;
	if ( write (iobuf->fd, &(iobuf->buff), iobuf->size - iobuf->nleft/128)
		<=0) return -1;
	if (iobuf->nleft != 0)
		return seek (iobuf->fd, -iobuf->size, 1);
	iobuf->nleft = iobuf->size * 128;
	iobuf->nextp = & (iobuf->buff);
	return 0;
}


UngetcBig(c,iobuf)
char c;
struct buf *iobuf;
{
	if (!iobuf)  {
		ungetch(c);
		return;
	 }
	*--iobuf->nextp = c;
	iobuf->nleft++;
}

