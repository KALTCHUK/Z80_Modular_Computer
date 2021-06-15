// **********************************************************************************************************************
// EProg - Programmer for W27C512 EEPROM
// *** ATTENTION *** 
// For communication protocol use 9600bps, no parity, 1 stop bit, no line ending.
// *****************
// PPI data bus connects to Arduino lines D4...D11.
//
// ATmega328 ports ------>  +-----------PORT B----------+   +-----------PORT D----------+
//                          7   6   5   4   3   2   1   0   7   6   5   4   3   2   1   0
// Arduino digital I/O -->  NA  NA  D13 D12 D11 D10 D9  D8  D7  D6  D5  D4  D3  D2  D1  D0
//                           XTAL                   ||  ||  ||  ||  ||  ||  ||  ||  TX  RX
//                                                  \/  \/  \/  \/  \/  \/  \/  \/
// PPI data bus --------->                          D7  D6  D5  D4  D3  D2  D1  D0
//
// PPI port usage:
//
//  - PORT B = EEPROM data bus
//  - PORT A = EEPROM addr bus LO
//  - PORT C = EEPROM addr bus HI
//
// **********************************************************************************************************************

// Control signals for the PPI
#define PPI_A0  A3            
#define PPI_A1  A4
#define PPI_RD  A1
#define PPI_WR  A2
#define PPI_CS  A0

// Other control signals
#define ROM_CS      10        
#define ENABLE_12V  11
#define ENABLE_14V  12
#define LED         13

#define PPI_RD_ROM    0x82    // Control word to set PPI ports for read operation
#define PPI_WR_ROM    0x80    // Control word to set PPI ports for write operation

#define OP_WR     1
#define OP_RD     0

// Global variables
long    disp=0;
int     dsignal=1;

/************************************************************************************************/
void setup() {
  // Set pins of control signals as Inputs or Outputs and also set the initial values
  pinMode(PPI_A0, OUTPUT);
  pinMode(PPI_A1, OUTPUT);
  pinMode(PPI_RD, OUTPUT);
  pinMode(PPI_WR, OUTPUT);
  pinMode(PPI_CS, OUTPUT);
  pinMode(ROM_CS, OUTPUT);    
  pinMode(ENABLE_12V, OUTPUT);
  pinMode(ENABLE_14V, OUTPUT);
  pinMode(LED, OUTPUT);

  digitalWrite(PPI_RD, HIGH);
  digitalWrite(PPI_WR, HIGH);
  digitalWrite(PPI_CS, HIGH);
  digitalWrite(ROM_CS, HIGH);
  digitalWrite(ENABLE_12V, LOW);
  digitalWrite(ENABLE_14V, LOW);
  digitalWrite(LED, LOW);

  //Initialize serial and wait for port to open:
  Serial.begin(9600);
  Serial.setTimeout(100);
  while (!Serial) {}  ;           // wait for serial port to connect. Needed for native USB port only
  
  Serial.println(" ");
  Serial.println("***  EProg v 1.3 - Programmer for W27C512 type EEPROM  ***");
  Serial.println("*** (C) 2020 by P.R.Kaltchuk - Non commercial use only ***");
  Serial.print(">");
  Unknown_cmd();
}

/************************************************************************************************/
void loop() {
  char incomingByte = 0;

// WAIT FOR COMMAND
  
  if (Serial.available() > 0) {
    // read the incoming byte:
    incomingByte = Serial.read();
    Serial.print(incomingByte);
    switch (incomingByte) {
      case 'D':   // Displacement (for Hex format writing)
      case 'd':
        Displace_EPROM();
        break;
      case 'E':   // Erase
      case 'e':
        Erase_EPROM();
        break;
      case 'V':   // Verify
      case 'v':
        Verify_EPROM();
        break;
      case 'W':   // Write
      case 'w':
        Write_EPROM();
        break;
      case 'R':   // Read
      case 'r':
        Read_EPROM();
        break;

      case 'N':   // Upload
      case 'n':
        NOP_EPROM();
        break;
      
      case 'U':   // Upload
      case 'u':
        Upload_EPROM();
        break;
      default:    // Unknown command
        Unknown_cmd();
        break;
    }
  }
}

/************************************************************************************************/
void Displace_EPROM(void) {
  int     i;
  char    arguments[]="          ";
  char    incomingByte = 0;

  disp=0;
  dsignal=1;
  Serial.readBytes(arguments, 10);
  Serial.print(arguments);
  while (arguments[i] == ' ') {
    i++;
  }
  if (arguments[i] == '-')  {
    dsignal = -1;
    i++;
  } 

  while (isHexadecimalDigit(arguments[i])) {                  // Get disp
    if (isDigit(arguments[i])) {
      disp = disp * 0x10;
      disp = disp + (byte)arguments[i] - 0x30;
    } else {
      if (isLowerCase(arguments[i])) {
        disp = disp * 0x10;
        disp = disp + (byte)arguments[i] - 0x61 + 0xa;
      } else {
        disp = disp * 0x10;
        disp = disp + (byte)arguments[i] - 0x41 + 0xa;
      }
    }
    i++;
  }
  Serial.println();
  Serial.print(">");
}

/************************************************************************************************/
void Erase_EPROM(void) {
  char incomingByte = 0;

  Serial.println();
  Serial.println(">Erase EPROM? (Y or N)");
  do {} while (Serial.available() == 0);
  if (Serial.available() > 0) {
    // read the incoming byte:
    incomingByte = Serial.read();
    Serial.print(">");
    Serial.println(incomingByte);
    if ((incomingByte != 'y') && (incomingByte != 'Y')) {
      Serial.print(">");
      return;
    }
  }
  //Serial.println();
  Serial.print(">Erasing...");

  PPI_write(1, 1, PPI_WR_ROM);      // Set PPI to mode 0, with all ports output (control word = 0x80)

  PPI_write(0, 0, 0x00);            // Put 0x0000 on address bus
  PPI_write(1, 0, 0x00);
  PPI_write(0, 1, 0xff);            // Put 0xff on data bus
  
  digitalWrite(ENABLE_14V, HIGH);   // This puts 14V on OE/Vpp and A9
  digitalWrite(ROM_CS, LOW);        // Pulse CS low for 110ms
  delay(110);
  digitalWrite(ROM_CS, HIGH);
  digitalWrite(ENABLE_14V, LOW);

  Verify_EPROM();
}

/************************************************************************************************/
void Verify_EPROM(void) {
  long  not_erased=0;
  byte  byte_read;
  int   contador=6552;
  int   j=10;

  Serial.println();
  Serial.print(">Verifying... ");
  PPI_write(1, 1, PPI_RD_ROM);      // Set PPI to mode 0, with ports A and C output, port B input. control word = 0x82.
  for (long i = 0; i <= 0xffff; i++) {
    contador++;
    if (contador == 6553) {
      contador = 0;
      Serial.print(j--);
      Serial.print(" ");
    }
    byte_read = Read_byte(i);
    if (byte_read != 0xff)     not_erased++;
  }
  Serial.println();
  if (not_erased == 0) {
    Serial.println(">EPROM erased");
  } else {
    Serial.print(">CAUTION: EPROM NOT erased (");
    Serial.print(not_erased);
    Serial.println(" bytes not 0xFF)");
  }  
  Serial.print(">");  
}

/************************************************************************************************/
void Write_EPROM() {
  char    incomingByte = 0;
  long    i=0;
  char    arguments[]="          ";
  long    addr=0;
  long    addr_ini=0;
  byte    write_this=0;
  byte    equivalent;
  boolean lower_nibble=true;

  Serial.readBytes(arguments, 10);
  Serial.print(arguments);
  while (arguments[i] == ' ') {
    i++;
  }
  if ((arguments[i] == 'h') || (arguments[i] == 'H') ) {
    WriteHex_EPROM();
    return;
  }
  while (isHexadecimalDigit(arguments[i])) {                  // Get addr_ini
    if (isDigit(arguments[i])) {
      addr_ini = addr_ini * 0x10;
      addr_ini = addr_ini + (byte)arguments[i] - 0x30;
    } else {
      if (isLowerCase(arguments[i])) {
        addr_ini = addr_ini * 0x10;
        addr_ini = addr_ini + (byte)arguments[i] - 0x61 + 0xa;
      } else {
        addr_ini = addr_ini * 0x10;
        addr_ini = addr_ini + (byte)arguments[i] - 0x41 + 0xa;
      }
    }
    i++;
  }
  addr = addr_ini;
  // At this point we have addr_ini and addr both pointing to the place to start writing
  
  Serial.println();
  Serial.println(">Send data to be written");
  PPI_write(1, 1, PPI_WR_ROM);    // Set PPI to mode 0, with all ports output (control word = 0x80)

  do {} while (Serial.available() <= 0);
  Serial.print(">");
  do {
    incomingByte = Serial.read();
    if (isHexadecimalDigit(incomingByte)) {
      Serial.print(incomingByte);
      if (isDigit(incomingByte))      equivalent = incomingByte - 0x30;
      if (isUpperCase(incomingByte))  equivalent = incomingByte - 0x41 + 0xa;
      if (isLowerCase(incomingByte))  equivalent = incomingByte - 0x61 + 0xa;
      if (lower_nibble == true)       write_this = equivalent;
      else {
        write_this = (0x10 * write_this) + equivalent; 
        Write_byte(addr++, write_this);
      }
      lower_nibble = !lower_nibble;
    }
  } while (incomingByte != 'q');

  Serial.println();
  Serial.print(">Write Complete. ");
  Serial.print(addr - addr_ini);
  Serial.print(" bytes written, starting at ");
  Serial.print(addr_ini, HEX);
  Serial.println(".");
  Serial.print(">");
  
}

/************************************************************************************************/
void WriteHex_EPROM() {
  char    incomingByte = 0;
  int     i=0;
  long    addr=0;
  long    bytesWritten=0;
  byte    write_this=0;
  byte    byteCount=0;
  byte    equivalent;
  boolean lower_nibble=true;

// Intel Hex Format:
//
// : NN AAAA RR CCCCCCCC...CC XX
// |  |   |   |       |        |
// |  |   |   |       |        +- CHECKSUM      we ignore it
// |  |   |   |       +---------- DATA
// |  |   |   +------------------ RECORD TYPE   in our case, always 00
// |  |   +---------------------- ADDRESS
// |  +-------------------------- BYTE COUNT    if zero ==> EOF
// +----------------------------- START CODE    always ':'

  Serial.println();
  Serial.print(">Address displacement = ");
  if (dsignal == -1)    Serial.print("-");
  else                  Serial.print("+");
  Serial.println(disp, HEX);
  Serial.println(">Send Intel Hex format data to be written");
  PPI_write(1, 1, PPI_WR_ROM);    // Set PPI to mode 0, with all ports output (control word = 0x80)

  do {} while (Serial.available() <= 0);
  Serial.print(">");
  while (true) {
    while ((incomingByte=Serial.read()) != ':') {
      //Serial.print('#');
      //Serial.print(incomingByte, HEX);
    }
    Serial.print(":");
    // ok, we're good to go
    for (i = 0; i < 2; ) {    // Get byte count
      incomingByte = Serial.read();
      if (isHexadecimalDigit(incomingByte)) {
        Serial.print(incomingByte);
        if (isDigit(incomingByte))      equivalent = incomingByte - 0x30;
        if (isUpperCase(incomingByte))  equivalent = incomingByte - 0x41 + 0xa;
        if (isLowerCase(incomingByte))  equivalent = incomingByte - 0x61 + 0xa;
        if (lower_nibble == true)       byteCount = equivalent;
        else                            byteCount = (0x10 * byteCount) + equivalent; 
        lower_nibble = !lower_nibble;
        i++;
      }      
    }
    addr = 0;
    for (i = 0; i < 4; ) {    // Get address
      incomingByte = Serial.read();
      if (isHexadecimalDigit(incomingByte)) {
        Serial.print(incomingByte);
        if (isDigit(incomingByte)) {
          addr = addr * 0x10;
          addr = addr + (byte)incomingByte - 0x30;
        } else {
          if (isLowerCase(incomingByte)) {
            addr = addr * 0x10;
            addr = addr + (byte)incomingByte - 0x61 + 0xa;
          } else {
            addr = addr * 0x10;
            addr = addr + (byte)incomingByte - 0x41 + 0xa;
          }
        }
        i++;
      }      
    }
    if (dsignal == -1)    addr = addr - disp;
    else                  addr = addr + disp;
    
    for (i = 0; i < 2; ) {    // Get record type
      incomingByte = Serial.read();
      if (isHexadecimalDigit(incomingByte)) {
        Serial.print(incomingByte);
        i++;
      }      
    }
    for (i = 0; i < (2 * byteCount); ) {    // Get data
      incomingByte = Serial.read();
      if (isHexadecimalDigit(incomingByte)) {
        Serial.print(incomingByte);
        if (isDigit(incomingByte))      equivalent = incomingByte - 0x30;
        if (isUpperCase(incomingByte))  equivalent = incomingByte - 0x41 + 0xa;
        if (isLowerCase(incomingByte))  equivalent = incomingByte - 0x61 + 0xa;
        if (lower_nibble == true)       write_this = equivalent;
        else {
          bytesWritten++;
          write_this = (0x10 * write_this) + equivalent; 
          Write_byte(addr++, write_this);
        }
        lower_nibble = !lower_nibble;
        i++;
      }      
    }
    for (i = 0; i < 2; ) {    // Get checksum
      // we don't care about the checksum
      incomingByte = Serial.read();
      if (isHexadecimalDigit(incomingByte)) {
        Serial.print(incomingByte);
        i++;
      }      
    }
    if (byteCount == 0) {
      Serial.println();
      Serial.print(">Write Complete. ");
      Serial.print(bytesWritten);
      Serial.println(" bytes written.");
      Serial.print(">");
      return;
    }
  }
}

/************************************************************************************************/
void Read_EPROM() {
  long    i=0;
  char    arguments[]="          ";
  char    printables[16];
  long    addr_ini=0;
  long    addr_end=0;
  byte    byte_read;

  Serial.readBytes(arguments, 10);
  Serial.print(arguments);
  while (arguments[i] == ' ') {
    i++;
  }
  while (isHexadecimalDigit(arguments[i])) {                  // Get addr_ini
    if (isDigit(arguments[i])) {
      addr_ini = addr_ini * 0x10;
      addr_ini = addr_ini + (byte)arguments[i] - 0x30;
    } else {
      if (isLowerCase(arguments[i])) {
        addr_ini = addr_ini * 0x10;
        addr_ini = addr_ini + (byte)arguments[i] - 0x61 + 0xa;
      } else {
        addr_ini = addr_ini * 0x10;
        addr_ini = addr_ini + (byte)arguments[i] - 0x41 + 0xa;
      }
    }
    i++;
  }
  
  while (arguments[i] == ' ') {
    i++;
  }
  while (isHexadecimalDigit(arguments[i])) {                 // Get addr_end
    if (isDigit(arguments[i])) {
      addr_end = addr_end * 0x10;
      addr_end = addr_end + (byte)arguments[i] - 0x30;
    } else {
      if (isLowerCase(arguments[i])) {
        addr_end = addr_end * 0x10;
        addr_end = addr_end + (byte)arguments[i] - 0x61 + 0xa;
      } else {
        addr_end = addr_end * 0x10;
        addr_end = addr_end + (byte)arguments[i] - 0x41 + 0xa;
      }
    }
    i++;
  }
  
  // At this point we already have both arguments, addr start and end 
  PPI_write(1, 1, PPI_RD_ROM);      // Set PPI to mode 0, with ports A and C output, port B input. control word = 0x82.
  Serial.println();
  Serial.print(">");

  do {
    if ( addr_ini < 0x10 )   Serial.print("0");
    if ( addr_ini < 0x100 )   Serial.print("0");
    if ( addr_ini < 0x1000 )   Serial.print("0");
    Serial.print(addr_ini, HEX);
    Serial.print(":  ");
    for (long j = 0; j < 0x10; j++) {
      byte_read = Read_byte(addr_ini + j);
      
      if (isPrintable(byte_read))   printables[j] = (char)byte_read;
      else                          printables[j] = '.';
      
      if (byte_read < 0x10)   Serial.print("0");
      Serial.print(byte_read, HEX);
      Serial.print(" ");
    }
    printables[16] = 0;
    Serial.print("  ");
    Serial.println(printables);
    Serial.print(">");
    addr_ini = addr_ini + 0x10;
  } while ( addr_ini <= addr_end);
}

/************************************************************************************************/
void Upload_EPROM() {
  long    i=0;
  char    arguments[]="          ";
  char    printables[16];
  long    addr_ini=0;
  long    addr_end=0;
  byte    byte_read;

  Serial.readBytes(arguments, 10);
  Serial.print(arguments);
  while (arguments[i] == ' ') {
    i++;
  }
  while (isHexadecimalDigit(arguments[i])) {                  // Get addr_ini
    if (isDigit(arguments[i])) {
      addr_ini = addr_ini * 0x10;
      addr_ini = addr_ini + (byte)arguments[i] - 0x30;
    } else {
      if (isLowerCase(arguments[i])) {
        addr_ini = addr_ini * 0x10;
        addr_ini = addr_ini + (byte)arguments[i] - 0x61 + 0xa;
      } else {
        addr_ini = addr_ini * 0x10;
        addr_ini = addr_ini + (byte)arguments[i] - 0x41 + 0xa;
      }
    }
    i++;
  }
  
  while (arguments[i] == ' ') {
    i++;
  }
  while (isHexadecimalDigit(arguments[i])) {                 // Get addr_end
    if (isDigit(arguments[i])) {
      addr_end = addr_end * 0x10;
      addr_end = addr_end + (byte)arguments[i] - 0x30;
    } else {
      if (isLowerCase(arguments[i])) {
        addr_end = addr_end * 0x10;
        addr_end = addr_end + (byte)arguments[i] - 0x61 + 0xa;
      } else {
        addr_end = addr_end * 0x10;
        addr_end = addr_end + (byte)arguments[i] - 0x41 + 0xa;
      }
    }
    i++;
  }
  // At this point we already have both arguments, addr start and end 

  PPI_write(1, 1, PPI_RD_ROM);      // Set PPI to mode 0, with ports A and C output, port B input. control word = 0x82.
  Serial.println();
  Serial.print(">");

  for (i = addr_ini; i <= addr_end; i++) {
    byte_read = Read_byte(i);
    Serial.print(byte_read, HEX);
  }
  Serial.println();
  Serial.print(">");
}

/************************************************************************************************/
void NOP_EPROM(void) {
  Serial.println();
  Serial.println(">Writing...");

  PPI_write(1, 1, PPI_WR_ROM);    // Set PPI to mode 0, with all ports output (control word = 0x80)

  for (long i = 0; i <= 0xffff; i++) {
    Write_byte(i, 0);
  }
//  Serial.println();
  Serial.println(">EPROM NOPed");
  Serial.print(">");
}

/************************************************************************************************/
void Unknown_cmd() {
  Serial.println();
  Serial.println(">");
  Serial.println(">Use one of these options:");
  Serial.println(">  D dddd          to set address displacement to be used with 'Wh'. Can be negative also.");
  Serial.println(">  E               to erase EPROM.");
  Serial.println(">  N               to 'NOP' the EPROM.(Write 00 on all memory).");
  Serial.println(">  R aaaa bbbb     to read a block from aaaa to bbbb.");
  Serial.println(">  U aaaa bbbb     to upload a block from aaaa to bbbb.");
  Serial.println(">  V               to verify if EPROM is erased.");
  Serial.println(">  W aaaa          to write starting at aaaa. Data sequence must end with 'q'.");
  Serial.println(">  Wh              to write using Intel Hex format.");
  Serial.println(">");
  Serial.print(">");

}

/************************************************************************************************/
void SetNanoPortsMode(bool Operation) {      //This is equivalent to function pinMode(), say if pins will be input or output
  if (Operation == OP_RD) {                     // Read operation => Bus is input => PORT B = XXXXXX00, PORT D = 000000XX
    DDRB = DDRB & B11111100;
    DDRD = DDRD & B00000011;
  }
  if (Operation == OP_WR) {                     // Write operation => Bus is output => PORT B = XXXXXX11, PORT D = 111111XX
    DDRB = DDRB | B00000011;
    DDRD = DDRD | B11111100;
  }
}

/************************************************************************************************/
void PPI_write(bool A_1, bool A_0, byte Byte2write) {   
  SetNanoPortsMode(OP_WR);
                                                              //   A_1  A_0   PPI port
  PORTD = PORTD & 0x03;                                       //   --------------------
  PORTD = PORTD | (Byte2write << 2);                          //    0    0       A
  PORTB = PORTB & 0xfc;                                       //    0    1       B
  PORTB = PORTB | (Byte2write >> 6);                          //    1    0       C
                                                              //    1    1    ctrl word
  digitalWrite(PPI_A0, A_0);
  digitalWrite(PPI_A1, A_1);
  digitalWrite(PPI_CS, LOW);
  digitalWrite(PPI_WR, LOW);
  delayMicroseconds(1);
  digitalWrite(PPI_WR, HIGH);
  digitalWrite(PPI_CS, HIGH);
}

/************************************************************************************************/
byte PPI_read(bool A_1, bool A_0) {
  byte  Received;
  
  SetNanoPortsMode(OP_RD);
  
  digitalWrite(PPI_A0, A_0);
  digitalWrite(PPI_A1, A_1);
  digitalWrite(PPI_CS, LOW);
  digitalWrite(PPI_RD, LOW);
  delayMicroseconds(1);
  Received = (PIND >> 2) | (PINB << 6);
  digitalWrite(PPI_RD, HIGH);
  digitalWrite(PPI_CS, HIGH);

  return Received;
}

/************************************************************************************************/
byte Read_byte(long Address) {
  byte  Aux;
  byte  Received;

  Aux = Address & 0x00ff;
  PPI_write(0, 0, Aux);
  Aux = Address >> 8;
  PPI_write(1, 0, Aux);             // At this point, addr bus contains the address to be read
  digitalWrite(ENABLE_12V, LOW);    // ENABLE_12V=low and ENABLE_14V=low means OE/Vpp also is low
  digitalWrite(ENABLE_14V, LOW);
  digitalWrite(ROM_CS, LOW);
  Received = PPI_read(0, 1);
  digitalWrite(ROM_CS, HIGH);

  return Received;
}

/************************************************************************************************/
void Write_byte(long Address, byte Content) {
  byte  Aux;

  Aux = Address & 0x00ff;
  PPI_write(0, 0, Aux);
  Aux = Address >> 8;
  PPI_write(1, 0, Aux);             // At this point, addr bus contains the address to be written

  PPI_write(0, 1, Content);         // Data bus has the content to be written
  digitalWrite(ENABLE_12V, HIGH);   // This puts 12V on OE/Vpp
  digitalWrite(ROM_CS, LOW);        // Pulse CS low for 110us
  delayMicroseconds(110);
  digitalWrite(ROM_CS, HIGH);
  digitalWrite(ENABLE_12V, LOW);
}
