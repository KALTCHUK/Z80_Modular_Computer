// i2c_manager.c - Manager for I2C Card.
// By Kaltchuk, 15/05/22.


#include "i2c.h"

#define Write				0
#define Read				1
#define ReadRandom	2
#define Scan				3
#define Null				0xff
#define SlaveWrite	(Slave << 1)
#define SlaveRead		SlaveWrite | 1

/*------------------------------------------------
Functions
------------------------------------------------*/
void free_wait(void) {
	_release = 0;
	_release = 1;
}

unsigned char get_command(void) {
	unsigned char Command=Null;
	
	while (Command == Null) {
		if (_CS == 0 && _WR == 0 && _A00 == 1) {
			P1 = 0xff;
			Command = P1;
			free_wait();
		}
		if (Command > ReadRandom)
			Command = Null;
	}
	return Command;
}
unsigned char get_data(void) {
	unsigned char Data;
	
	while (1) {
		if (_CS == 0 && _WR == 0 && _A00 == 0) {
			P1 = 0xff;
			Data = P1;
			free_wait();
			return Data;
		}
	}
}
void put_data(unsigned char Data) {
	while (1) {
		if ( _CS == 0 && _WR == 1 && _A00 == 0) {
			P1 = Data;
			free_wait();
			return;
		}
	}
}

void scan(void) {

}

/*------------------------------------------------
MAIN C Function
------------------------------------------------*/
void main (void) {
	free_wait();
	
	while (1) {
		unsigned char	Command, Slave, AddrSize, AddrLo, AddrHi, NumBytes;
		unsigned char	i, buf[16];

		Command = get_command();
		switch (Command) {
			case Write:
			case Read:
			case ReadRandom:
				Slave = get_data();
					
				if (Command == Write || Command == ReadRandom) {
					AddrSize = get_data();
					if (AddrSize == 2)
						AddrHi = get_data();
					AddrLo = get_data();
				}
				NumBytes = get_data();
					
				if (Command == Write) {
					for (i=0; i<NumBytes; i++) {
						buf[i] = get_data();
					}
					I2C_start();
					I2C_write(SlaveWrite);
					if (AddrSize == 2)
						I2C_write(AddrHi);
					I2C_write(AddrLo);
					for (i=0; i<NumBytes; i++) {
						I2C_write(buf[i]);
					}
					I2C_stop();
				} else {
					if (Command == ReadRandom) {
						I2C_start();
						I2C_write(SlaveWrite);
						if (AddrSize == 2)
							I2C_write(AddrHi);
						I2C_write(AddrLo);
						I2C_stop();
					}
					I2C_start();
					I2C_write(SlaveRead);
					for (i=0; i<NumBytes; i++) {
						if (i == NumBytes-1)
							buf[i] = I2C_read(NAK);
						else
							buf[i] = I2C_read(ACK);
					}
					I2C_stop();
					
					for (i=0; i<NumBytes; i++) {
						put_data(buf[i]);
					}
				}
				break;
			case Scan:
				scan();
				break;
			default:
		}
	}
}
