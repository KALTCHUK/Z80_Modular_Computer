/* LOGGER.C - Reads data from port TTY1, displays on console
   and appends it to a file previously provided by user.

  In order to use it with the bluetooth module, baud rate
  must be set to 38400bps. */

#include <stdio.h>
#include i2c2.h

#define TTY1		0xc1
#define i2c_card	0xa0
#define rtc		0x68
#define Baud		7		/* i.e. 38400bps */
#define LF		0x0a
#define CR		0x0d

main() {
	char rcvd[10], stamp[10], log[24];
	int i;

	outp(TTY1 + 2, Baud);		/* set baud rate */

	i = 0;
	while(1) {
		while(inp(TTY1 + 2) == 0);
		rcvd[i] = inp(TTY1);
		if(rcvd[i++] == CR) {
			getTime(stamp);
			rcvd[i-1] = 0;
			printf("%s, %s\n", rcvd, stamp);
			/*printf("%s", log);*/
			i = 0;
		}
	}
}


getTime(s)
char *s; {
	char	buf[3];

	I2Crr(i2c_card, rtc, 1, 0, 3, buf);
	sprintf(s, "%02x:%02x:%02x", buf[2], buf[1], buf[0]);
}

