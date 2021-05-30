/* FIFO queue package 
 (W) Copywrong 1980 Scott W. Layson

These cute little routines implement First In, First Out queues.  There
are complete sets of routines provided: one to handle integer-sized
(2-byte) objects, and the other to handle byte-sized things.

The routines are good for applications such as I/O buffering in programs
that do several things at once.  For example, consider the following
program fragment (remember that all this text is one big comment!):

#define KBD_Q_SIZE 40

struct cqueue {
	char *cruft[4], space[KBD_Q_SIZE];
	} kbd_q;

/ * This program eats command characters and does something hairy with them * /

main()
{
	<... assorted declarations ...>
	CQInit (&kbd_q, KBD_Q_SIZE);
	while (1) do
	  {	cmd = get_qd_char();
		hairily_process (cmd);
	  }
}

/ * Return a character off the queue if there are any, otherwise wait
   for one to be typed * /

get_qd_char()
{
	if (!CQEmpty(&kbd_q)
		return CQGrab(&kbd_q);
		else return getchar();
}

/ * If a character has been typed, queue it * /

kbd_check()
{
	if (kbhit())
		CQShove (getchar(), &kbd_q);
}
	

Careful scattering of calls to kbd_check throughout hairily_process()
will prevent keyboard characters from being missed no matter how far
the user types ahead (up to the KBD_Q_SIZE, of course).

Small misfeature: the queue will actually hold one fewer object than
the size allocated for it.  E.g., the above kbd_q will hold
(KBD_Q_SIZE - 1) characters.  This usually doesn't matter, as usual
practice is just to make a queue much larger than it really has to be
anyway.

************** End of comments **********************************/


struct queue {
	int *head, *tail, *top, *bottom, space;
 };


/*  Initialization routine (must be called before any operation is done
	on the queue) */

QInit(queue_p,size)
struct queue *queue_p;
int size;
{
	queue_p->head = queue_p->tail = queue_p->top = &(queue_p->space);
	queue_p->bottom = queue_p->top +size -1;
}


/* Routine to grab something off the head of a queue
   Does no error checking!  Be careful of underflow! */

QGrab(queue_p)
struct queue *queue_p;
{
	return ((queue_p->head >= queue_p->bottom) ?
		*(queue_p->head = queue_p->top) :
		 *++(queue_p->head));
}


/* Routine to shove something onto the tail of a queue
   Does no error checking! BE careful of underflow! */

QShove(x,queue_p)
struct queue *queue_p;
int x;
{
	*((queue_p->tail >= queue_p->bottom) ?
		 (queue_p->tail = queue_p->top) :
		 ++(queue_p->tail)) = x;
}


/* Emptiness predicate */

QEmpty(queue_p)
struct queue *queue_p;
{
	return (queue_p->head == queue_p->tail);
}


/* Fullness predicate */

QFull(queue_p)
struct queue *queue_p;
{
	return((queue_p->tail+1 == queue_p->head) ||
		(queue_p->tail == queue_p->bottom &&
		 queue_p->head == queue_p->top));
}


/* Peek at head of queue without disturbing it */

QPeek(queue_p)
struct queue *queue_p;
{
	return (  (queue_p->head == queue_p->bottom) ?
			*queue_p->top :
			*(queue_p->head + 1) );
}






/* Here is the same repertoire of routines, but set up for
   characters instead of integers:
*/


struct cqueue {
	char *chead, *ctail, *ctop, *cbottom, cspace;
 };


/*  Initialization routine (must be called before any operation done
	on the queue) */

CQInit(queue_p,size)
struct cqueue *queue_p;
int size;
{
	queue_p->chead = queue_p->ctail = queue_p->ctop = &(queue_p->cspace);
	queue_p->cbottom = queue_p->ctop +size -1;
}


/* Routine to grab something off the head of a queue
Does no error checking!  Be careful of underflow! */

CQGrab(queue_p)
struct cqueue *queue_p;
{
	return ((queue_p->chead >= queue_p->cbottom) ?
		*(queue_p->chead = queue_p->ctop) :
		 *++(queue_p->chead));
}


/* Routine to shove something onto the tail of a queue
   Does no error checking!  Be careful of overflow! */

CQShove(x,queue_p)
struct cqueue *queue_p;
int x;
{
	*((queue_p->ctail >= queue_p->cbottom) ?
		 (queue_p->ctail = queue_p->ctop) :
		 ++(queue_p->ctail)) = x;
}


/* Emptiness predicate */

CQEmpty(queue_p)
struct cqueue *queue_p;
{
	return (queue_p->chead == queue_p->ctail);
}


/* Fullness predicate */

CQFull(queue_p)
struct cqueue *queue_p;
{
	return((queue_p->ctail+1 == queue_p->chead) ||
		(queue_p->ctail == queue_p->cbottom &&
		 queue_p->chead == queue_p->ctop));
}


/* Peek at head of queue without disturbing it */

CQPeek(queue_p)
struct cqueue *queue_p;
{
	return ( (queue_p->chead == queue_p->cbottom)  ?
		   *queue_p->ctop  :
		   queue_p->chead[1] );
}

