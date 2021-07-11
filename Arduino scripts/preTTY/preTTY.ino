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
// The content of PORT_B defines the operation demmanded.
// ************************************************************************************************************************************

// Control signals
                                // Operation  _WR  _RD  A01
#define CMD_WR  B00001000       // CMD_WR      0    1    0
#define DAT_WR  B00001100       // DAT_WR      0    1    1
#define STA_RD  B00010000       // STA_RD      1    0    0
#define DAT_RD  B00010100       // DAT_RD      1    0    1

#define IORQed  true

// Global variables
bool  Status;                   // Tells if we are attending an I/O request from the CPU
byte  TTY_addr = 0xd0;          // The other port only changes one bit from address word (a00)
byte  pw;
int   TTY_speed = 38400;

// **********************************************************************************************************************
void setAllPinsInput(void) {
  // Set all pins as inputs (except for TX, RX, RESET and XTAL which remain "as are")
  DDRB = DDRB & B11000000;
  DDRD = DDRD & B00000011;
  DDRC = DDRC & B11000000;
}

// **********************************************************************************************************************
void setDataPinsOutput(void) {
  DDRB = DDRB | B00000011;
  DDRD = DDRD | B11111100;
}

// **********************************************************************************************************************
// setup()
// **********************************************************************************************************************
void setup() {
  setAllPinsInput();
  pw = (TTY_addr >> 4) | (TTY_addr <<5) | B00010000; 
  Status = ~IORQed;              // Not attending an interrupt request
  
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

// **********************************************************************************************************************
// main loop()
// **********************************************************************************************************************
void loop() {
  int operation;
  
  if ((PINC & 0x3F) == pw) {                // Is CPU is calling us?
    if (Status != IORQed) {                 // Yeah, it's a new IORQ
      Status = IORQed;
      operation = PINB & B00011100;         // Keep only, WR, RD and A01
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
void writeCommand(void) {               // CPU wants to write a command

}

// **********************************************************************************************************************
void writeData(void) {                 // CPU wants to write data (send data to the RTU via RS232)
  byte  data;

  if (Serial.availableForWrite() > 0) {
    data = (PINB << 6) | (PIND >> 2);
    Serial.write(data);
  }
}

// **********************************************************************************************************************
void readStatus(void) {               // CPU wants to read the status
  byte  data=0;                       // Status_word: X X X X X X IB OB
                                      //                          |  |
                                      //                          |  +---> 1 if out buffer is full
                                      //                          +------> 1 if in buffer has data to be read
  setPinsForOutput();
  if (Serial.availableForWrite() == 0)  data = B00000001;           // out buffer is full
  if (Serial.available() > 0)           data = data | B00000010;    // in buffer has data
  PORTB = (PINB & B11111100) | (data >> 6);
  PORTD = (PIND & B00000011) | (data << 2);
}

// **********************************************************************************************************************
void readData(void) {               // CPU wants to read data (receive data sent from RTU via RS232)
  byte  data;
  
  if (Serial.available() > 0){
    setPinsForOutput();
    data = Serial.read();
    PORTB = (PINB & B11111100) | (data >> 6);
    PORTD = (PIND & B00000011) | (data << 2);
  }
}
