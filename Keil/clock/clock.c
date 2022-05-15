// read time from RTC once.

#include "i2c.h"

// RTC (slave) addresses definitions
#define RTC_addr				0x68
#define RTC_write				RTC_addr<<1
#define RTC_read				(RTC_write)|0x01

char	counter=0;

/*------------------------------------------------
query_RTC Function
Read 3 bytes from RTC
------------------------------------------------*/
void query_RTC(void) {
	I2C_start();
	I2C_write(RTC_write);
	I2C_write(0x8);
	I2C_stop();

	I2C_delay();
	
	I2C_start();
	I2C_write(RTC_read);
	I2C_read(ACK);
	I2C_read(ACK);
	I2C_read(NAK);
	I2C_stop();
}

/*------------------------------------------------
write_RTC Function
Write 3 bytes to RTC
------------------------------------------------*/
void write_RTC(void) {
	I2C_start();
	I2C_write(RTC_write);
	I2C_write(0x8);
	I2C_write(counter++);
	I2C_write(counter++);
	I2C_write(counter++);
	I2C_stop();
}

/*------------------------------------------------
free_wait Function
Release the wait line
------------------------------------------------*/
void free_wait(void) {
	_release = 0;
	_release = 1;
}

/*------------------------------------------------
MAIN C Function
------------------------------------------------*/
void main (void) {
	free_wait();
	query_RTC();
	while (1) {
		if (_CS==0) {
			if (_A00==0) {
				query_RTC();
			} else {
				write_RTC();
			}
		free_wait();
		}
	}
}
