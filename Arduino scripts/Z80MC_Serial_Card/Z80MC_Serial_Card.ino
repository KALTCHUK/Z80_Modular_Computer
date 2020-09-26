// Arduino connects to USB on computer running Termite (serial terminal emulator).
// It's a parallel<->serial converter. 
//
// When the arduino receives a character, it issues an interrupt (INT) to the Z80. The interrupt service routine
// does a "IN A,(USART_DAT_RD)" command, which gives a high signal on pin EN. The Arduino puts the received 
// character on the databus and resets the interrupt.
//
// When the CPU wants to send a character to the serial port, it does a "OUT (USART_DAT_WR),A" command. The
// Arduino reads the databus and sends the character to the serial port. 
//
// ATmega328 ports --------------->  +-----------PORT B----------+   +-----------PORT D----------+
//                                   7   6   5   4   3   2   1   0   7   6   5   4   3   2   1   0
// Arduino digital I/O ----------->  NA  NA  D13 D12 D11 D10 D9  D8  D7  D6  D5  D4  D3  D2  D1  D0
//                                    XTAL   ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  TX  RX
//                                           \/  ||  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/
// CPU LINES --------------------->          INT*||  WR  RD  D7  D6  D5  D4  D3  D2  D1  D0
//                                               \/
// Output A=B from 74LS85 -------->              EN
//
// *D13 doesn't really connect to the Z80 INT line. It connects to the RxREADY pin of the 8251. So when the Arduino
// wants to issue an interrupt signal, it puts HIGH on D13. This signal is inverted by a 74LS04 and sent to the 
// CPU's INT. So if the D13 LED is on, means that the Arduino received a character from the console and is requesting
// the CPU to interrupt.
//
// Nano pins    connect to...
// ---------    -------------------------
// D2-D9        CPU data bus d00-d07
// D10          CPU /RD
// D11          CPU /WR
// D13          8251 RxREADY (pin 14)
// D12          74LS85 Output A=B (pin 6)
//

#define CPU_RD    10
#define CPU_WR    11
#define CPU_INT   13
#define EN        12

#define OP_WR     1                   // CPU wants to write --> "OUT (USART_DAT_WR),A"
#define OP_RD     0                   // CPU wants to read ---> "IN  A,(USART_DAT_RD)"

void setup() {
  SetNanoPortsMode(OP_WR);            // set databus pins as input
  pinMode(CPU_INT, OUTPUT);
  digitalWrite(CPU_INT, LOW);
  pinMode(EN, INPUT);
  pinMode(CPU_RD, INPUT);
  pinMode(CPU_WR, INPUT);

  Serial.begin(9600);
  Serial.println(" ***   Z80MC_Serial_Card v.1   ***");
  Serial.println(" *** parallel/serial converter ***");
  Serial.println(" ");
  Serial.println(" Ready to start data relay");
  Serial.println("----------------------------------");
  
}

void loop() {
  if(Serial.available()>0) {
    digitalWrite(CPU_INT, HIGH);                  // set the interrupt signal
  }

  if(digitalRead(EN) == HIGH) {
    if(digitalRead(CPU_RD) == LOW) {             // CPU is requesting to read data from Arduino
      digitalWrite(CPU_INT, LOW);                // reset the interrupt signal
      SetNanoPortsMode(OP_RD);
      Write_databus(Serial.read());
      while(digitalRead(EN) == HIGH) {}
      SetNanoPortsMode(OP_WR);
    }

    if(digitalRead(CPU_WR) == LOW) {             // CPU is requesting to write data to Arduino
      Serial.write(Read_databus());
      while(digitalRead(EN) == HIGH) {}
    }   
  }
}

/************************************************************************************************/
void SetNanoPortsMode(bool Operation) {         //This is equivalent to function pinMode(), say if pins will be input or output
  if (Operation == OP_WR) {                     // CPU wants to WR  => Bus is input => PORT B = XXXXXX00, PORT D = 000000XX
    DDRB = DDRB & B11111100;
    DDRD = DDRD & B00000011;
  }
  if (Operation == OP_RD) {                     // CPU wants to RD => Bus is output => PORT B = XXXXXX11, PORT D = 111111XX
    DDRB = DDRB | B00000011;
    DDRD = DDRD | B11111100;
  }
}

/************************************************************************************************/
byte Read_databus(void) {
  byte  Received;

  Received = (PIND >> 2) | (PINB << 6);
  return Received;
}

/************************************************************************************************/
void Write_databus(byte Content) {
  
  PORTD = (PORTD & 0x03) | (Content << 2);
  PORTB = (PORTB & 0xfc) | (Content >> 6);
}
