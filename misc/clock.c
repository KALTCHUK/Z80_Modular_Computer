/*
	CLOCK.C - SET/READ TIME AND DATE FROM I2C RTC

*/

#include <stdio.h>
#include i2c2.h

#define	time		't'
#define	date		'd'
#define	quit		'q'

#define i2c_card	0xa0
#define rtc		0x68

gtm() {
	char	buf[3];

	I2Crr(i2c_card, rtc, 1, 0, 3, buf);
	printf("  %02x:%02x:%02x\n", buf[2], buf[1], buf[0]);
}

stm(line)
char *line; {
	char	i, buf[3];

	buf[0] = ((line[8] - '0')<<4) | (line[9] - '0');
	buf[1] = ((line[5] - '0')<<4) | (line[6] - '0');
	buf[2] = ((line[2] - '0')<<4) | (line[3] - '0');

	I2Cwr(i2c_card, rtc, 1, 0, 3, buf);
}

gdt() {
	char	buf[4];
	char	*days[8];
	int	i;

	initptr(days,"ERR","Sun","Mon","Tue","Wed","Thu","Fri","Sat",0);

	I2Crr(i2c_card, rtc, 1, 3, 4, buf);
	printf("  %s %02x/%02x/%02x\n", days[buf[0]], buf[1], buf[2], buf[3]);

}

sdt(line)
char *line; {
	char	i, buf[4];

	buf[0] = line[2] - '0';
	buf[1] = ((line[4] - '0')<<4) | (line[5] - '0');
	buf[2] = ((line[7] - '0')<<4) | (line[8] - '0');
	buf[3] = ((line[10] - '0')<<4) | (line[11] - '0');

	I2Cwr(i2c_card, rtc, 1, 3, 4, buf);

}

main() {
	char	line[16];

	printf("Set/get time and date from RTC\n\n");
	printf("Commands: t?           Get time.\n");
	printf("          t=hh:mm:ss   Set time.\n");
	printf("          d?           Get date.\n");
	printf("	  d=w dd/mm/yy Set date.\n");
	printf("          q            Quit program.\n\n");

	while(1) {
		printf("# ");
		getline(line,15);

		switch(line[0]) {
			case time:
				if(line[1]=='?')
					gtm();
				else
					stm(line);
				break;
			case date:
				if(line[1]=='?')
					gdt();
				else
					sdt(line);
				break;
			case quit:
				exit();
			default:
				printf("Invalid command\n");
		}
	}
}