/*
  PX.C, version 1, by Kaltchuk, mar/2022.

  Programs the AT89Cx051 microcontroller, using PX051 Card.
*/

#include <stdio.h>

#define PX	0xd0
#define PA	PX
#define PB	PX | 1
#define PC	PX | 2
#define CW	PX | 3
#define PAout	0x89
#define PAin	0x99
#define read	0x59
#define readp	0x79
#define sign	0x41
#define signp	0x61
#define prog	0x9d
#define progp	0xbd
#define progpp	0x9c
#define lck1	0x5f
#define lck1pp	0x9e
#define lck2	0x47
#define lck2pp	0x86
#define rst	0

main() {
	char	linebuf[81];
	int	linelen;
	int	i;

	printf("PX v1.0 by Kaltchuk, mar/2022.\n");
	printf("AT89Cx051 programmer for PX051 card.\n\n");
	help();


	while(1) {

		do {
			printf("# ");
			linelen = getline(linebuf, 80);
		} while(linelen == 1);

		for(i=0; linebuf[i] !='\0'; i++) {
			if(linebuf[i] >= 'a' && linebuf[i] <= 'z') {
				linebuf[i] = linebuf[i] - 32;
			}
		}

		switch (linebuf[0]) {
			case 'R':
				readchip();
				break;
			case 'P':
				progchip();
				break;
			case 'L':
				lockbit();
				break;
			case 'E':
				erasechip();
				break;
			case 'V':
				verifychip();
				break;
			case 'S':
				signchip();
				break;
			case 'Q':
				exit();
				break;
			case '?':
				help();
				break;
			default:
				printf("Invalid option.\n");
		}
	}
}

readchip() {
	int	b, l, addr;
	char	val, line[16];

	addr = 00;

	outp(CW, PAin);		/* set PA as input */

	outp(PB, rst);		/* reset chip */
	outp(PB, read);		/* mode = read */

	while(1) {
		/* Print header */
		printf("ADDR  00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F  ");
		printf("0123456789ABCDEF\n\n");

		for(l=0; l<16; l++) {
			printf("%04x  ", addr);
			for(b=0; b<16; b++) {
				line[b] = inp(PA);	/* get byte */
				outp(PB, readp);	/* pulse XTAL1 */
				outp(PB, read);		/* mode = read */
				printf("%02x ", line[b]);
			}
			printf(" ");
			for(b=0; b<16; b++) {
				if((line[b] > 0x1f) && (line[b] < 0x7f))
					printf("%c", line[b]);
				else
					printf(".");
			}
			printf("\n");
			addr +=16;
		}
		printf("            <ENTER> = next page, <ESC> = abort\n");
		if(getchar() != '\n')
			return;
	}
	outp(PB, rst);		/* reset chip */
}

progchip() {
	FILE	*fp_bin;
	char	buf[16];
	int	c, bt, ct, vok, RDY;

	outp(CW, PAout);

	outp(PB, rst);		/* reset chip */

	printf("Source binary file? ");
	getline(buf, 15);

	fp_bin = fopen(buf, "rb");
	if(fp_bin == 0) {
		printf("\nERROR: %s.\n", errmsg(errno()));
		return;
	}

	printf("\nProgramming... ");

	bt = fgetc(fp_bin);
	c = 0;
	vok = 1;
	while(bt != -1) {
		/* write byte */
		outp(PA, bt);		/* PA=byte to be programmed */
		outp(PB, prog);		/* mode=prog */
		outp(PB, progpp);	/* pulse PROG pin */
		outp(PB, prog);
		do {
			RDY = inp(PC) & 1;
		} while(RDY == 0);
		outp(PB, progp);	/* pulse XTAL1 */
		outp(PB, prog);
		c++;
		bt = fgetc(fp_bin);
	}
	outp(PB, rst);			/* reset chip */
	printf("%d bytes programmed.\n", c);
	fclose(fp_bin);
	printf("Verifying... ");

	fp_bin = fopen(buf, "rb");
	if(fp_bin == 0) {
		printf("\nERROR: %s.\n", errmsg(errno()));
		return;
	}
	outp(CW, PAin);		/* set PA as input */

	outp(PB, rst);		/* reset chip */
	outp(PB, read);		/* mode = read */

	bt = fgetc(fp_bin);
	while(bt != -1) {
		ct = inp(PA);	/* get byte */
		if(ct != bt ) {
			vok = 0;
			printf("\nError");
		}
		bt = fgetc(fp_bin);
		outp(PB, readp);	/* pulse XTAL1 */
		outp(PB, read);		/* mode = read */
	}
	if(vok)
		printf("OK.\n");
	else
		printf("NOT OK!!!\n");
}

lockbit() {
	FILE	*fp_hex, *fp_bin;
	char	buf[16];

	outp(CW, PAout);

	outp(PB, rst);		/* reset chip */

	printf("Lockbit 1, 2 ou both (3)? ");
	getline(buf, 15);

	switch(buf[0]) {
		case '1':
			lock1();
			break;
		case '2':
			lock2();
			break;
		case '3':
			lock1();
			lock2();
			break;
		default:
			printf("Invalid option.\n");
	}
}

lock1() {
	int	RDY;

	outp(PB, lck1);
	outp(PB, lck1pp);	/* pulse PROG pin */
	outp(PB, lck1);
	do {
		RDY = inp(PC) & 1;
	} while(RDY == 0);
	outp(PB, rst);
}

lock2() {
	int	RDY;

	outp(PB, lck2);
	outp(PB, lck2pp);	/* pulse PROG pin */
	outp(PB, lck2);
	do {
		RDY = inp(PC) & 1;
	} while(RDY == 0);
	outp(PB, rst);
}

erasechip() {
	char	line[5];

	printf("Erase chip (y/n)? ");
	getline(line, 4);
	if((line[0] != 'y') && (line[0] != 'Y'))
		return;

	outp(PB, 0x83);				/* prepare for reset */
	outp(PB, 0x82);				/* reset pulse */
	sleep(2);				/* hold low at least 10ms */
	outp(PB, 0x40);				/* return to idle */
	verifychip();
}

verifychip() {
	int	i;

	printf("Verifying... ");
	outp(CW, PAin);				/* set PA as input */
	outp(PB, 0);				/* reset chip */

	for(i=0; i<4096; i++) {
		outp(PB, 0x59);		/* mode = read */
		if(inp(PA) != 0xff) {	/* get byte */
			printf("Chip NOT erased!!!\n");
			return;
		}
		outp(PB, 0x79);		/* pulse XTAL1 */
	}
	printf("Chip erased.\n");
}

signchip() {
	printf("Chip signature:\n");
	outp(CW, PAin);				/* set PA as input */
	outp(PB, rst);				/* reset chip */
	outp(PB, sign);				/* mode = signature */
	printf("1st byte = %x\n", inp(PA));	/* get byte */
	outp(PB, signp);			/* pulse XTAL1 */
	outp(PB, sign);				/* mode = signature */
	printf("2nd byte = %x\n", inp(PA));	/* get byte */
	outp(PB, signp);			/* pulse XTAL1 */
	outp(PB, sign);				/* mode = signature */
	printf("3rd byte = %x\n", inp(PA));	/* get byte */
	outp(PB, rst);				/* reset chip */
}

help() {
	printf("Use:	R	Read chip's memory.\n");
	printf("	P	Program chip with binary file.\n");
	printf("	L	Write lock bit.\n");
	printf("	E      	Erase chip.\n");
	printf("	V 	Verify if chip is erased.\n");
	printf("	S  	Read chip's signature.\n");
	printf("	Q      	Quit the program.\n");
	printf("	?      	Show this help screen.\n\n");
}
