/* I2C.H - Header file for I2C Card read/write fuctions */
/* 20/04/22, by Kaltchuk                                */

#define STOP	0
#define START	1

/* Primitive functions */
i2c_stop(i2c_card)
char	i2c_card; {
	outp(i2c_card,STOP);
}

i2c_start(i2c_card)
char	i2c_card; {
	outp(i2c_card,START);
}

i2c_wr(i2c_card, byte)
char	i2c_card, byte; {
	outp(i2c_card+1, byte);
}

char i2c_rd_ack(i2c_card)
char	i2c_card; {
	char	byte;

	byte = inp(i2c_card);
	return byte;
}

char i2c_rd_nak(i2c_card)
char	i2c_card; {
	char	byte;

	byte = inp(i2c_card+1);
	return byte;
}

/* High level functions */
writeI2C(i2c_card, slave_addr, address, num_bytes, buf)
char	i2c_card, slave_addr, *buf, num_bytes;
int	address; {
	char	i;

	i2c_start();
	i2c_wr(i2c_card,slave_addr<<1);
	if(address > 0xff) {
		i2c_wr(i2c_card, address>>8);
	}
	i2c_wr(i2c_card, address && 0xff);
	for(i=0; i<num_bytes; i++)
		i2c_wr(i2c_card, buf[i]);
	i2c_stop();
}

readI2C(i2c_card, slave_addr, num_bytes, buf)
char	i2c_card, slave_addr, *buf, num_bytes; {
	char	i;

	i2c_start();
	i2c_wr(i2c_card,(slave_addr<<1)+1);
	for(i=0; i<num_bytes-1; i++)
		buf[i] = i2c_rd_ack(i2c_card);
	buf[i] = i2c_rd_nak(i2c_card);
	i2c_stop();
}

read_randI2C(i2c_card, slave_addr, address, num_bytes, buf)
char	i2c_card, slave_addr, *buf, num_bytes;
int	address; {
	char	i;

	i2c_start();
	i2c_wr(i2c_card,slave_addr<<1);
	if(address > 0xff) {
		i2c_wr(i2c_card, address>>8);
	}
	i2c_wr(i2c_card, address && 0xff);
	readI2C(i2c_card, slave_addr, num_bytes, buf);
}
