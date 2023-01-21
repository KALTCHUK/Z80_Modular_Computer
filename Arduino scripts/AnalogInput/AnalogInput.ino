/*
  Analog Input

  Demonstrates analog input by reading an analog sensor on analog pin 0 and
  sending the value through the serial port.
  
  The circuit:
  - potentiometer
    center pin of the potentiometer to the analog input 0
    one side pin (either one) to ground
    the other side pin to +5V

  created by David Cuartielles
  modified 30 Aug 2011
  By Tom Igoe

  This example code is in the public domain.

  https://www.arduino.cc/en/Tutorial/BuiltInExamples/AnalogInput
*/

int sensorPin = A0;   // select the input pin for the potentiometer
int ledPin = 13;      // select the pin for the LED
int sensorValue = 0;  // variable to store the value coming from the sensor

void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(ledPin, OUTPUT);

  //Initialize serial and wait for port to open:
  Serial.begin(9600);
  while (!Serial);    // wait for serial port to connect. Needed for native USB port only
}

void loop() {
  float T;
  
  // read the value from the sensor:
  sensorValue = analogRead(sensorPin);

  T = ((float)sensorValue - 51)*100/973;
  
  Serial.println(T, 1);
  delay(1000);                       // wait for a second
}
