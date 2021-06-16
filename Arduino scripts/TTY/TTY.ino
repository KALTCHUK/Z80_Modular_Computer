// **********************************************************************************************************************
// TTY - ARDUINO USED AS A USART
//
// *** ATTENTION *** 
// For communication protocol use 38400bps, 8N1, no line ending.
//
// Before compiling, check that HardwareSerial.h has been changed so that...
// #define SERIAL_TX_BUFFER_SIZE 256
// #define SERIAL_RX_BUFFER_SIZE 256

// *****************
//
// ATmega328 ports ------------>   +-----------PORT B----------+   +-----------PORT D----------+
//                                 7   6   5   4   3   2   1   0   7   6   5   4   3   2   1   0
// Arduino digital I/O -------->  NA  NA  D13 D12 D11 D10 D9  D8  D7  D6  D5  D4  D3  D2  D1  D0
//                                 XTAL   ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  TX  RX
//                                        ||  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/
// Signals from CPU ----------->          ||  WR  RD  A1  D7  D6  D5  D4  D3  D2  D1  D0
//                                        \/
// Signal card select logic --->          CS
//
// (WR, RD, IORQ and CS are active low)
// **********************************************************************************************************************

// Control and addressing signals
#define _CS     13
#define CMD_WR  B00010000
#define DAT_WR  B00011000
#define STA_RD  B00100000
#define DAT_RD  B00101000


#define IORQed  true

// Global variables
bool  Status;                   // Tells if we are attending an I/O request from the CPU

// **********************************************************************************************************************
// setAllPinsInput()
// **********************************************************************************************************************
void setAllPinsInput(void) {
  // Set all pins as inputs (except for TX, RX and XTAL which remain "as are")
  DDRB = DDRB & B11000000;
  DDRD = DDRD & B00000011;
}

// **********************************************************************************************************************
// setup()
// **********************************************************************************************************************
void setup() {
  setAllPinsInput();
  
  Status = ~IORQed;              // Not attending an interrupt request

  //Initialize serial and wait for port to open:
  Serial.begin(38400);
  Serial.setTimeout(100);
  while (!Serial) {}  ;           // wait for serial port to connect. Needed for native USB port only

  Serial.println(" ");
  Serial.println("***                           ***");
  Serial.println("***  TTY running at 38400bps  ***");
  Serial.println("***                           ***");
  Serial.print(" ");

}

// **********************************************************************************************************************
// main loop()
// **********************************************************************************************************************
void loop() {
  int operation;          // Operation  _WR  _RD  A01
                          // ---------  -------------
                          // CMD_WR      0    1    0
                          // DAT_WR      0    1    1
                          // STA_RD      1    0    0
                          // DAT_RD      1    0    1
  
  if (digitalRead(_CS) == LOW) {            // CS=0 => CPU is calling us
    if (Status != IORQed) {                 // Yeah, it's a new IORQ
      Status = IORQed;
      operation = PINB & B00011100;
      switch (operation) {
        case CMD_WR:
          writeCommand();
          break;
        case DAT_WR:
          writeData();
          break;
        case STA_RD:
          readStatus();
          break;
        case DAT_RD:
          readData();
          break;
        default:
          Status = ~IORQed;
          break;
      }
    }
  }
  else {                                    // CPU isn't calling us,
    if (Status == IORQed) {                 // so reset status flag
      Status = ~IORQed;
      setAllPinsInput();
    }
  }
}



// **********************************************************************************************************************
// writeCommand()
// **********************************************************************************************************************
void writeCommand(void) {
  // DO NOTHING
}

// **********************************************************************************************************************
// writeData()
// **********************************************************************************************************************
void writeData(void) {
  byte  data;

  if (Serial.availableForWrite() > 0) {
    data = ((PINB & B00000011) << 6) | ((PIND & B11111100) >> 2);
    Serial.write(data);
  }
}

// **********************************************************************************************************************
// readStatus()   Status_Word = X X X X X X <in_buf> <out_buf>. 
//                                             |         |
//                                             |         +---> 1 => out_buf if full
//                                             +-------------> 0 => in_buf is empty
// **********************************************************************************************************************
void readStatus(void) {
  
}

// **********************************************************************************************************************
// readData()
// **********************************************************************************************************************
void readData(void) {
  byte  data;
  
  if (Serial.available() > 0){
    setPinsForWrite();
    data = Serial.read();
    PORTB = (PINB & B11111100) | (data >> 6);
    PORTD = (PIND & B00000011) | (data << 2);
  }
}

// **********************************************************************************************************************
// setPinsForWrite()
// **********************************************************************************************************************
void setPinsForWrite(void) {
  DDRB = DDRB | B00000011;
  DDRD = DDRD | B11111100;

}
