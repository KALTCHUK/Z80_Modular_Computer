/*
 RS485_debug.c - Modbus RTU Slave controller (AT89C4051).
 
 including modbusBegin():                               didn't work
 taking out the final part of modbusBegin() (RI test):  OK
 restores original modbusBegin() and included milli=0:  OK
 back with modbusPoll():                                didn't work
 including milli=0 in modbusPoll():                     didn't work
 new approach for modbusPoll (wait for a character):
*/

#include <REG51.h>
#include "Serial.h"
#include "EEPROM.h"
#include "ModbusSlave.h"

void main() {
	numCoils = 8;
	numDiscreteInputs = 0;
	numHoldingRegisters = 4;

    _DE = 0;

baud = 19200;	// factory set baud rate.
	id = 1;			// factory set modbus slave id.

/*	if (_FS == 1) {
		baud = EEPROMread(0);
		id =  EEPROMread(1);
	}*/
	serialInit(baud);
	modbusBegin(baud);
	
	while (1) {
        modbusPoll();
    }
}
