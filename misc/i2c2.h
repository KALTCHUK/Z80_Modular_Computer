/* I2C.H - Header file for I2C Card read/write fuctions */
/* 20/04/22, by Kaltchuk                                */

#define WRITE	0
#define READ	1
#define RREAD	2

#define i2c_dat	i2c_card
#define i2c_cmd	i2c_card+1

/* Primitive functions 					*/

/* Write function					*/
I2Cwr(i2c_card, slave, size_addr, addr, num_bytes, buf)
char	i2c_card, slave, size_addr, num_bytes, *buf;
int	addr; {
	char	i;

	outp(i2c_cmd, WRITE);
	outp(i2c_dat, slave);
	outp(i2c_dat, size_addr);
	if(size_addr == 2)
		outp(i2c_dat, addr >> 8);
	outp(i2c_dat, addr & 0x00ff);
	outp(i2c_dat, num_bytes);
	for(i=0; i<num_bytes; i++) {
		outp(i2c_dat, buf[i]);
	}
}

/* Read function					*/
I2Crd(i2c_card, slave, num_bytes, buf)
char	i2c_card, slave, num_bytes, buf[]; {
	char	i;

	outp(i2c_cmd, READ);
	outp(i2c_dat, slave);
	outp(i2c_dat, num_bytes);
	for(i=0; i<num_bytes; i++) {
		buf[i] = inp(i2c_dat);
	}
}

/* Read random function					*/
I2Crr(i2c_card, slave, size_addr, addr, num_bytes, buf)
char	i2c_card, slave, size_addr, num_bytes, buf[];
int	addr; {
	char	i;;

	outp(i2c_cmd, RREAD);
	outp(i2c_dat, slave);
	outp(i2c_dat, size_addr);
	if(size_addr == 2)
		outp(i2c_dat, addr >> 8);
	outp(i2c_dat, addr & 0x00ff);
	outp(i2c_dat, num_bytes);
	for(i=0; i<num_bytes; i++) {
		buf[i] = inp(i2c_dat);
	}
}
