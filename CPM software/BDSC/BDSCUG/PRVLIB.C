/*------------------------------------------------------------------*/
/*                                                                  */
/*  This is a library of private routines for use with BDS C prog-  */
/*  grams.  The comment lines preceding each entry are intended     */
/*  to give a sufficient explanation of the routine that follows.   */
/*  To link any of these routines to a BDS C program, merely name   */
/*  PRVLIB as a argument following the name of the main program in  */
/*  the CLINK command line.                                         */
/*                                                                  */
/*------------------------------------------------------------------*/
 
 
/*
    Move k bytes from blk1 to blk2.  
    The two blocks may overlap.
    Since k must be positive, this routine is limited to
    moving blocks less than 32k in length.
    Added by M. Goldberg, 25-DEC-79. 
*/
movblk(blk1, blk2, k) 
    char *blk1, *blk2;
    int k;
    {
    int m,n,t,u;
    if ((k <= 0) || (!(t = blk1 - blk2))) return;
    if (t > 0) {m = 0; n = k;}
    else {m = 1 - k; n = 1;}
    for (t = m; t < n; ++t) 
        {
        u = (t < 0 ? -t : t);
        *(blk2 + u) = *(blk1 + u);
        }
    }
 
 
/*
    ASCII counter -- increments a field of ASCII digits by one. 
    Arguments are a pointer to the field (high-order digit) 
    and the length of the field. 
    The routine stops if it encounters a non-digit character 
    in the field.
    Added by M. Goldberg, 25-DEC-79. 
*/
asc_cntr(addr, len) 
    char *addr;
    int len;
    {
    addr += len;
    do 
        {
        if (!isdigit(*(--addr))) break;
        if (++(*addr) <= '9') break;
        *addr = '0';
        }
        while (--len);
    }
 
 
/*
    Sends a CR-LF pair to the CP/M LIST device.
    Added by M. Goldberg, 25-DEC-79. 
*/
#define    LF          0x0A
#define    CR          0x0D
newline()
    {
    bdos(5, CR); bdos(5,LF);
    }
 
 
/* 
    Sends a line of dashes to the CP/M LIST device.
    The argument is the number of dashes in the line.
    Added by M. Goldberg, 16-FEB-80.
*/ 
dashes(n) 
    char n;
    {
    char i;
    for (i = 0; i < n; ++i) bdos(5, '-');
    newline();
    }
 
 
/*
    Causes a block of bytes to be displayed at the CP/M
    console device as a vector of two-digit hex numbers.
    Spaces are used to separate one hex number from another.
    It was written as a debug aid, that is, to be used to take 
    a snapshot of a memory during program execution.

    The arguments are: 
        blkp = a pointer to the beginning of the memory block 
    and
        n = the number of bytes in the block.

    Added by M. Goldberg, 6-MAR-80.
*/
puthx(blkp, n)
    char *blkp;
    int n;
    {
    char c;
    while (n-- > 0)
        {
        prhd(((c = *blkp++) & 0xF0) >> 4);
        prhd(c & 0x0F);
        putchar(' ');
        }
    }


/*
    Outputs a message to the CP/M console device and 
    stops the program.  The argument is a pointer to the
    message string.
    Added by M. Goldberg, 15-MAR-80.
*/
stop(msg)
    char msg[];
    {
    puts(msg);
    exit();
    }
