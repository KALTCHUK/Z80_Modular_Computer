void setup() {
  // put your setup code here, to run once:
  //Initialize serial and wait for port to open:

}

void loop() {
  int   TTY_speed;

  TTY_speed = 4800;
  Serial.begin(TTY_speed);
  Serial.setTimeout(100);
  while (!Serial) {}  ;           // wait for serial port to connect. Needed for native USB port only
  Serial.println(" ");
  Serial.print("*** TTY speed   = ");
  Serial.println(TTY_speed, DEC);
  Serial.end();

  TTY_speed = 9600;
  Serial.begin(TTY_speed);
  Serial.setTimeout(100);
  while (!Serial) {}  ;           // wait for serial port to connect. Needed for native USB port only
  Serial.println(" ");
  Serial.print("*** TTY speed   = ");
  Serial.println(TTY_speed, DEC);
  Serial.end();

  TTY_speed = 19200;
  Serial.begin(TTY_speed);
  Serial.setTimeout(100);
  while (!Serial) {}  ;           // wait for serial port to connect. Needed for native USB port only
  Serial.println(" ");
  Serial.print("*** TTY speed   = ");
  Serial.println(TTY_speed, DEC);
  Serial.end();

  TTY_speed = 57600;
  Serial.begin(TTY_speed);
  Serial.setTimeout(100);
  while (!Serial) {}  ;           // wait for serial port to connect. Needed for native USB port only
  Serial.println(" ");
  Serial.print("*** TTY speed   = ");
  Serial.println(TTY_speed, DEC);
  Serial.end();




}
