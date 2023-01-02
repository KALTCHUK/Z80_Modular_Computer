/*
 EEPROM.H - Header file for I2C EEPROM read/write - Specifically for use with Modbus.

 Functions:
		char EEPROMread(unsigned int address) - Read 1 byte.
		void EEPROMwrite(unsigned int address, char word) - Write 1 byte.

 Primitives:
 		void I2C_start(void)
 		void I2C_stop(void)
 		char I2C_write(char byte) - Send <byte> to slave and return answer from slave (ACK or NAK).
 		char I2C_read(char condition) - Read 1 byte from slave and reply with <condition> (ACK or NAK).

 Port3 has two especial pins:
	P3.2: SDA
	P3.3: SCL

*/

// Definitions
#define _SCL					INT1	// SCL pin (P3.3)
#define _SDA					INT0	// SDA pin (P3.2)

#define ACK						1
#define NAK						0
#define slaveWrite              0xa0
#define slaveRead               0xa1

#define SDA_HI					_SDA = 1
#define SDA_LO					_SDA = 0
#define SCL_HI					_SCL = 1
#define SCL_LO					_SCL = 0

// Function Prototyping
void I2C_delay(int d);
void I2C_start(void);
void I2C_stop(void);
char I2C_write(char byte);
char I2C_read(char condition);

unsigned int EEPROMread(unsigned int address);
void EEPROMwrite(unsigned int address, unsigned int word);

/*------------------------------------------------
I2C_delay Function
Propagation delay
------------------------------------------------*/
void I2C_delay(int d) {
/*	int	i, j=0;
	
    if(d == 0)
        return;
    for(i=0; i<d; )
        j++;*/
}

/*------------------------------------------------
I2C_start Function
------------------------------------------------*/
void I2C_start(void) {
	SDA_LO;
	I2C_delay(0);
	SCL_LO;
}

/*------------------------------------------------
I2C_stop Function
------------------------------------------------*/
void I2C_stop(void) {
    int c=0;

    //while (_SDA == 0 && c++ < 5);

	I2C_delay(0);
	SCL_HI;
	I2C_delay(0);
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
		I2C_delay(0);
		SCL_HI;
		I2C_delay(0);
		SCL_LO;
		byte <<= 1;
	}
    //SDA_HI;
    SCL_HI;
	I2C_delay(0);
	reply = _SDA;
    //SDA_LO;
	SCL_LO;
	I2C_delay(0);
	return reply;
}

/*------------------------------------------------
I2C_read Function
------------------------------------------------*/
char I2C_read(char condition) {
	char	bt, byte=0;

    for (bt = 0; bt < 8; bt++) {
		SDA_HI;
		I2C_delay(0);
		SCL_HI;
		I2C_delay(0);
		while (_SCL == 0) {}	// clock stretching
		byte = (byte << 1) | _SDA;
		SCL_LO;
  }
	if(condition == ACK) {
		SDA_LO;
	} else {
		SDA_HI;
	}
	I2C_delay(0);
	SCL_HI;
	I2C_delay(0);
	while(_SCL == 0);		// clock stretching
	SCL_LO;
	I2C_delay(0);
    return byte;
}

/*------------------------------------------------
EEPROMread Function
------------------------------------------------*/
unsigned int EEPROMread(unsigned int address) {
	unsigned int word;

    address *= 2;
	I2C_start();
	I2C_write(slaveWrite);
	I2C_write((char)(address>>8));      // Address HI
	I2C_write((char)address);           // Address LO
	I2C_stop();
	I2C_delay(0);
	I2C_start();
	I2C_write(slaveRead);
	word = (I2C_read(ACK)<<8) | I2C_read(NAK);
	I2C_stop();
	
	return word;
}

/*------------------------------------------------
EEPROMwrite Function
------------------------------------------------*/
void EEPROMwrite(unsigned int address, unsigned int word) {
    address *= 2;
	I2C_start();
	I2C_write(slaveWrite);
	I2C_write((char)(address>>8));      // Address HI
	I2C_write((char)address);           // Address LO
	I2C_write((char)(word>>8));         // Word HI
	I2C_write((char)word);              // Word LO
    I2C_delay(0);
	I2C_stop();
}

