/*
 EEPROM.H - Header file for I2C EEPROM read/write - Specifically for use with Modbus.

 Functions:
		unsigned int EEPROMread(unsigned int address) - Read 1 register (2 consecutive memory positions).
		void EEPROMwrite(unsigned int address, unsigned int word) - Write 1 register (2 consecutive memory positions).

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
#define _SCL						INT1	// SCL pin (P3.3)
#define _SDA						INT0	// SDA pin (P3.2)

#define ACK							1
#define NAK							0
#define slaveWrite					0xA0	// 24C64 address with write bit
#define slaveRead					0xA1	// 24C64 address with read bit

#define SDA_HI					_SDA = 1
#define SDA_LO					_SDA = 0
#define SCL_HI					_SCL = 1
#define SCL_LO					_SCL = 0

// Function Prototyping
void I2C_delay(void);
void I2C_start(void);
void I2C_stop(void);
char I2C_write(char byte);
char I2C_read(char condition);
unsigned int EEPROMread(unsigned int address);
void EEPROMwrite(unsigned int address, unsigned int word);
void EEPROMcommon(unsigned int address);

/*------------------------------------------------
I2C_delay Function
Propagation delay
------------------------------------------------*/
void I2C_delay(void) {
/*	int	i;
	
	for(i=0; i<2; i++) {} */
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

/*------------------------------------------------
EEPROMread Function
Read 2 bytes, MSB first.
------------------------------------------------*/
unsigned int EEPROMread(unsigned int address) {
	unsigned int word;

    address *= 2;
	EEPROMcommon(address);
	I2C_stop();

	I2C_start();
	I2C_write(slaveRead);
	word = I2C_read(NAK);
	word = (word<<8) | I2C_read(ACK);
	I2C_stop();
	
	return word;
}

/*------------------------------------------------
EEPROMwrite Function
Write 2 bytes, MSB first.
------------------------------------------------*/
void EEPROMwrite(unsigned int address, unsigned int word) {
    address *= 2;
	EEPROMcommon(address);
	I2C_write((char)(word>>8));
	I2C_write((char)(word & 0x00ff));
	I2C_stop();
}

/*------------------------------------------------
EEPROMcommon Function
------------------------------------------------*/
void EEPROMcommon(unsigned int address) {
	I2C_start();
	I2C_write(slaveWrite);
	I2C_write((char)(address>>8));
	I2C_write((char)address);
}
