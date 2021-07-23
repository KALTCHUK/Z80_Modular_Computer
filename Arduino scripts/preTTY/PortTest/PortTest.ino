// **********************************************************************************************************************************
// preTTY - ARDUINO USED AS A USART BY Z80 MODULAR COMPUTER
//
// *** ATTENTION *** 
// For communication protocol use 38400bps, 8N1.
//
// Before compiling, check that HardwareSerial.h has been changed so that...
//    #define SERIAL_TX_BUFFER_SIZE 256
//    #define SERIAL_RX_BUFFER_SIZE 256
// *****************
//
// ATmega328 ports ----------------->   +-----------PORT B----------+   +-----------PORT D----------+   +-----------PORT C-----------+
//                                      7   6   5   4   3   2   1   0   7   6   5   4   3   2   1   0   7   6   5   4    3   2   1   0
// Arduino digital I/O ------------->  NA  NA  D13 D12 D11 D10 D9  D8  D7  D6  D5  D4  D3  D2  D1  D0  A7  A6  A5  A4   A3  A2  A1  A0
//                                      XTAL   ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  TX  RX          ||  ||   ||  ||  ||  ||
//                                             \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  ||  ||          \/  \/   \/  \/  \/  \/
// Signals from/to CPU ------------->          nc  wr  rd  a01 d07 d06 d05 d04 d03 d02 d01 d00 ||  ||          a00 iorq a07 a06 a05 a04
//                                                                                             \/  \/
// Signals from/to MAX232 ---------->                                                          tx  rx
// (wr, rd and iorq are active low)
//
// The content of PORT_C defines if this TTY is being demmanded by the CPU.
// The content of PORT_B defines the operation demanded.
// ************************************************************************************************************************************
#define TTY_speed 19200
#define LED       13

// **********************************************************************************************************************
// setup()
// **********************************************************************************************************************
void setup() {
  DDRB = DDRB & B11100000;
  DDRD = DDRD & B00000011;
  DDRC = DDRC & B11000000;
  pinMode(LED, OUTPUT);
  
  //Initialize serial and wait for port to open:
  Serial.begin(TTY_speed);
  Serial.setTimeout(100);
  //while (!Serial) {}  ;           // wait for serial port to connect. Needed for native USB port only

  Serial.println();
  Serial.print("TTY speed   = ");
  Serial.println(TTY_speed, DEC);
  Serial.println();
}

// **********************************************************************************************************************
// main loop()
// **********************************************************************************************************************
void loop() {

  if(Serial.available() > 0) {
    Serial.read();
    Serial.println();
    Serial.print("Port B = ");
    Serial.println(PINB, HEX);
    Serial.print("Port C = ");
    Serial.println(PINC, HEX);
    Serial.print("Port D = ");
    Serial.println(PIND, HEX);
    while (Serial.available()>0) {
      Serial.read();
    }
    delay(1000);
  }
}

// **********************************************************************************************************************
