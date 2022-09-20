/*
	Modbus RTU Slave for DO-8 Card. By Kaltchuk, Sep/2022.
*/

#include <REG51.h>
#include <Serial.h>
#include <I2C.h>
#include <ModbusRTUSlave.h>

// Rewrite starting from here......................................................................................

char coilRead(word address) {
  if (address == ledAddress) return digitalRead(ledPin);
  else return false;
}

boolean coilWrite(word address, boolean value) {
  if (address == ledAddress) digitalWrite(ledPin, value);
  return true;
}

long holdingRegisterRead(word address) {
  switch (address) {
    case 0:           // baud
      EEPROM.get(0, baud);
      return baud;
      break;
    case 1:           // id
      EEPROM.get(2, id);
      return id;
      break;
    default:
      return false;
      break;
  }
}

boolean holdingRegisterWrite(word address, word value) {
  switch (address) {
    case 0:           // baud
      EEPROM.put(0, value);
      break;
    case 1:           // id
      EEPROM.put(2, value);
      break;
    default:
      return false;
      break;
  }
  return true;
}

void setup() {
  word EEid, EEbaud;
  
  pinMode(ledPin, OUTPUT);
  pinMode(initPin, INPUT);


  modbus.configureCoils(numCoils, coilRead, coilWrite);
  modbus.configureHoldingRegisters(numHoldingRegisters, holdingRegisterRead, holdingRegisterWrite);

  if (digitalRead(initPin) == LOW) {
    EEPROM.get(0, EEbaud);
    EEPROM.get(2, EEid);

    baud = baudVector[EEbaud];
    if (EEbaud > 7)    baud = 9600;
    id = (byte)EEid;
}
    

  Serial.begin(baud);
  modbus.begin(id, baud);
}

void loop() {
  modbus.poll();
}