/*
  ModbusRTUSlave Library - Coil

  This sketch demonstrates how to setup a ModbusRTUSlave to control an LED.
  This test will require a Modbus RTU master device.
  Common examples of master devices are industrial PLCs and HMIs.
  These will typically communicate using RS-232 or RS-485.
  The logic levels of the master device will need to be at or converted to TTL levels for your Arduino.
  
  Circuit:
  - TX of master to pin 10
  - RX of master to pin 11
  - LED from pin 13 to GND, with appropriate series resistor

  Note: On most Arduino boards there is already an LED attached to pin 13.

  Created: 2022-06-25
  By: C. M. Bulliner

  Adapted by P.R.Kaltchuk to use only Serial instead of SoftwareSerial.
  01/09/22.
*/
#include <ModbusRTUSlave.h>
#include <EEPROM.h>

// Here are some constants used elsewhere in the program.
const byte ledPin = 13, dePin = 11, initPin = 12;
const word bufSize = 256, numCoils = 1, numHoldingRegisters = 2,ledAddress = 0;
const unsigned long responseDelay = 10;

byte id = 7;
unsigned long baud = 9600;
unsigned long baudVector[] = {1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200};

byte buf[bufSize];

ModbusRTUSlave modbus(buf, bufSize, dePin, responseDelay);

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
