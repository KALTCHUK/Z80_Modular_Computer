/*
  Read serial port and echo back.
*/

void setup() {
  // initialize serial:
  Serial.begin(19200);
  Serial.println("Echo HW serial test...");
}

void loop() {
  if (Serial.available() > 0) {
    Serial.write(Serial.read());
  }
}
