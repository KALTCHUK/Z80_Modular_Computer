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
// ATmega328 ports ----------------->   +-----------PORT B----------+   +-----------PORT D----------+   +-----------PORT C----------+
//                                      7   6   5   4   3   2   1   0   7   6   5   4   3   2   1   0   7   6   5   4   3   2   1   0
// Arduino digital I/O ------------->  NA  NA  D13 D12 D11 D10 D9  D8  D7  D6  D5  D4  D3  D2  D1  D0  A7  A6  A5  A4  A3  A2  A1  A0
//                                      XTAL       ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  TX  RX              ||  ||  ||  ||  ||
//                                                 \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/                      \/  \/  \/  \/  \/
// Signals from CPU ---------------->              WR  RD  A1  D7  D6  D5  D4  D3  D2  D1  D0                     IORQ A7  A6  A5  A4
//
// (WR, RD and IORQ are active low)
// **********************************************************************************************************************************

// Control and addressing signals
<<<<<<< Updated upstream
=======
#define TTY_ADDR  0x0D          // Serial port's address
>>>>>>> Stashed changes
                                // Operation  _WR  _RD  A01
#define CMD_WR  B00001000       // CMD_WR      0    1    0
#define DAT_WR  B00001100       // DAT_WR      0    1    1
#define STA_RD  B00010000       // STA_RD      1    0    0
#define DAT_RD  B00010100       // DAT_RD      1    0    1

#define IORQed  true

// Global variables
bool  Status;                   // Tells if we are attending an I/O request from the CPU
byte  Card_addr = 0xd0;
int   TTY_speed = 38400;

// **********************************************************************************************************************
void setAllPinsInput(void) {
  // Set all pins as inputs (except for TX, RX and XTAL which remain "as are")
  DDRB = DDRB & B11000000;
  DDRD = DDRD & B00000011;
  DDRC = B00000000;
}

// **********************************************************************************************************************
void setPinsForOutput(void) {
  DDRB = DDRB | B00000011;
  DDRD = DDRD | B11111100;
}

// **********************************************************************************************************************
// setup()
// **********************************************************************************************************************
void setup() {
  setAllPinsInput();
  
  Status = ~IORQed;              // Not attending an interrupt request
  Card_addr = Card_addr / 0x10;

  //Initialize serial and wait for port to open:
  Serial.begin(TTY_speed);
  Serial.setTimeout(100);
  while (!Serial) {}  ;           // wait for serial port to connect. Needed for native USB port only

  Serial.println(" ");
<<<<<<< Updated upstream
  Serial.print("*** Card address = ");
  Serial.println(Card_addr * 0x10, HEX);
  Serial.print("*** TTY baudrate = ");
  Serial.println(TTY_speed, DEC);
  Serial.print(" ");
=======
  Serial.println("***                             ***");
  Serial.println("***  TTY connected at 38400bps  ***");
  Serial.println("***     Card address = 0xD0     ***");
  Serial.println("***                             ***");
>>>>>>> Stashed changes
}

// **********************************************************************************************************************
// main loop()
// **********************************************************************************************************************
void loop() {
  int operation;
  
<<<<<<< Updated upstream
  if ((PINC & 0x1F) == Card_addr) {              // CS = 0 and ADDR_LO = 0DXH => CPU is calling us
=======
  if ((PINC & 0x1F) == TTY_ADDR) {          // CS = 0 and lower nibble = TTY_ADDR => CPU is calling us
>>>>>>> Stashed changes
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
