// I2C.H - Header file for I2C - Does not support restart.
//
// Functions:
// 		void I2C_start(void)
// 		void I2C_stop(void)
// 		char I2C_write(char byte) - Send <byte> to slave and return answer from slave (ACK or NAK).
// 		char I2C_read(char condition) - Read 1 byte from slave and reply with <condition> (ACK or NAK).

#include <at892051.h>

// Pin definitions
#define _release			 	P3_0
#define _WR							P3_1
#define _CS							P3_2
#define _SDA						P3_4
#define _SCL						P3_5
#define _A00						P3_7

#define ACK							1
#define NAK							0

#define SDA_HI					_SDA = 1
#define SDA_LO					_SDA = 0
#define SCL_HI					_SCL = 1
#define SCL_LO					_SCL = 0

/*------------------------------------------------
I2C_delay Function
Propagation delay
------------------------------------------------*/
void I2C_delay(void) {
	int	i;
	
	for(i=0; i<2; i++) {}
}

/*------------------------------------------------
I2C_start Function
------------------------------------------------*/
void I2C_start(void) {
	SDA_LO;
	I2C_delay();
	SCL_LO;
}

/*------------------------------------------------
I2C_stop Function
------------------------------------------------*/
void I2C_stop(void) {
	SCL_HI;
	I2C_delay();
	SDA_HI;
}

/*------------------------------------------------
I2C_write Function
------------------------------------------------*/
char I2C_write(char byte) {
	char	bt, reply;
	
	for (bt = 0; bt < 8; bt++) {
		if(byte & 0x80) {
			SDA_HI;
		} else {
			SDA_LO;
		}
		I2C_delay();
		SCL_HI;
		I2C_delay();
		SCL_LO;
		I2C_delay();
		byte <<= 1;
	}
	SCL_HI;
	I2C_delay();
	reply = _SDA;
	SCL_LO;
	I2C_delay();
	return reply;
}

/*------------------------------------------------
I2C_read Function
------------------------------------------------*/
char I2C_read(char condition) {
	char	bt, byte=0;

  for (bt = 0; bt < 8; bt++) {
		SDA_HI;
		I2C_delay();
		SCL_HI;
		I2C_delay();
		while (_SCL == 0) {}	// clock stretching
		byte = (byte << 1) | _SDA;
		SCL_LO;
  }
	if(condition == ACK) {
		SDA_LO;
	} else {
		SDA_HI;
	}
	I2C_delay();
	SCL_HI;
	I2C_delay();
	while(_SCL == 0) {}		// clock stretching
	SCL_LO;
	I2C_delay();
  return byte;
}
