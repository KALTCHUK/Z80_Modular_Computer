/* PLC.C - By P.R.Kaltchuk, 17/11/22 

*/

#include <stdio.h>

#define DO8	10

#define MAXNET	4
#define MAXTAG	128

char nCount;
char netTable[MAXNET];
int tCount;
struct tags {
	char net;
	char slave;
	unsigned reg;
}

struct tags tagTable[MAXTAG];

nCount = 0;
tCount = 0;

char defNet(port, baud)
char port;
char *baud; {
	if(nCount == MAXNET) {
		printf("ERROR: net table full. Increase MAXNET to allocate more memory.\n");
		exit();
	}
	
	netTable[nCount] = port;
	printf(Net %c @ port %h, %s bps", nCount, port, baud);
	/* config baud rate on port */
	return nCount++;
}

int defTag(net, slave, reg)
char net;
char slave;
unsigned reg; {
	if(tCount == MAXTAG) {
		printf("ERROR: tag table full. Increase MAXTAG to allocate more memory.\n");
		exit();
	}
	
	tagTable[tCount].net = net;
	tagTable[tCount].slave = slave;
	tagTable[tCount].reg = reg;
	
	printf("Tag %u @ net %c, slave %c, register %u.\n", tCount, net, slave, reg);
	return tCount++;
}

int readTag(tag)
int tag; {
	
}

void writeTag(tag, val)
int tag;
int val; {


}

void prints(lin, col, format)
char lin;
char col;
char *format; {


}

void screen(file)
char *file; {


}

main() {
	char net1, net2;
	int led1, led2, led3, led4;

	net1 = defNet(0xc1, "19200");
	net2 = defNet(0xc2, "57600");
	
	led1 = defTag(net1, 10, 1);
	led2 = defTag(net1, 10, 2);
	led3 = defTag(net1, 10, 3);
	led4 = defTag(net1, 10, 4);

}	