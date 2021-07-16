

int   TTY_speed = 38400;
byte  TTY_addr = 0xa0;          // The other port only changes one bit from address word (a00)


void setup() {
  // put your setup code here, to run once:
  //Initialize serial and wait for port to open:
  Serial.begin(TTY_speed);
  Serial.setTimeout(100);
  while (!Serial) {}  ;           // wait for serial port to connect. Needed for native USB port only

  Serial.println(" ");
  Serial.print("*** TTY address = ");
  Serial.println(TTY_addr, HEX);
  Serial.print("*** TTY speed   = ");
  Serial.println(TTY_speed, DEC);
  Serial.print(" ");

}

void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available() > 0){
    Serial.write(Serial.read());
  }
}
