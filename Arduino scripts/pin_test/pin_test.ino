#include <EEPROM.h>

const byte ledPin = 13, dePin = 11, initPin = 11;
const word bufSize = 256, numCoils = 1, ledAddress = 0;
const unsigned long responseDelay = 10;

byte id = 7;
unsigned long baud = 9600;

byte buf[bufSize];

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(initPin, INPUT);
}

void loop() {
  digitalWrite(ledPin, digitalRead(initPin));
}
