/* I2C.H - Header file for I2C Card read/write fuctions */
/* 20/04/22, by Kaltchuk                                */

#define WRITE	1
#define READ	2
#define RREAD	3

/* Primitive functions 					*/

/* Write function					*/
I2Cwr(i2c_card, slave, size_addr, addr, num_bytes, buf)
char	i2c_card, slave, size_addr, num_bytes, buf[];
int	addr; {
	char	i;

	outp(i2c_card, WRITE);
	outp(i2c_card, slave);
	outp(i2c_card, size_addr);
	if(size_addr == 2)
		outp(i2c_card, addr >> 8);
	outp(i2c_card, addr && 0xff);
	outp(i2c_card, num_bytes);
	for(i=0; i<num_bytes; i++)
		outp(i2c_card, buf[i]);
}

/* Read function					*/
I2Crd(i2c_card, slave, num_bytes, buf)
char	i2c_card, slave, num_bytes, buf[]; {
	char	i;

	outp(i2c_card, READ);
	outp(i2c_card, slave);
	outp(i2c_card, num_bytes);
	for(i=0; i<num_bytes; i++)
		buf[i] = inp(i2c_card);
}

/* Read random function					*/
I2Crr(i2c_card, slave, size_addr, addr, num_bytes, buf)
char	i2c_card, slave, size_addr, num_bytes, buf[];
int	addr; {
	char	i;

	outp(i2c_card, RREAD);
	outp(i2c_card, slave);
	outp(i2c_card, size_addr);
	if(size_addr == 2)
		outp(i2c_card, addr >> 8);
	outp(i2c_card, addr && 0xff);
	outp(i2c_card, num_bytes);
	for(i=0; i<num_bytes; i++)
		buf[i] = inp(i2c_card);
}
