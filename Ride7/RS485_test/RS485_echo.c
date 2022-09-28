/*
 DO-8.c - Modbus RTU Slave controller (AT89C4051) for DO-8 Card. By Kaltchuk, Sep/2022.
*/

#include <REG51.h>
#include "Serial485.h"

void main() {
	baud = 9600;	// factory set baud rate.
	serialInit(baud);
	
	while (1) {
        serialTX(serialRX());
	}
}
