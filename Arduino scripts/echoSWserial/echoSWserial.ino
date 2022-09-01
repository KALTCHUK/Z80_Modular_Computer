/*
  Read serial port and echo back.
*/
#include <SoftwareSerial.h>

SoftwareSerial mySerial =  SoftwareSerial(0,1);

void setup() {
  // initialize serial:
  mySerial.begin(19200);
  mySerial.println("Echo SW serial test...");}

void loop() {
  if (mySerial.available()) {
    mySerial.write(mySerial.read());
  }
}
