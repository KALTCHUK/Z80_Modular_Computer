/*
 ModbusSlave.h - Header file for 2 modbus remote I/O cards - DI-16 (16 digital inputs) and DO-8 (8 digital outputs).

 DO-8 has 8 coils (registers 1 to 8) and 2 holding registers for baud rate (register 40001) and slave ID (register 40002).
 DI-16 has 16 discrete inputs (registers 10001 to 10016) and 2 holding registers for baud rate (register 40001) and slave ID (register 40002).
 
 Port1 is connected to the I/O bus. P1.0 and P1.1 need external pullup resistors.

 Port3 has a few especial pins:
	P3.4: FS (use factory set id and baud rate if signal low)
	P3.5: DE (RS485 drive enable)
	P3.7: SEL (select lower or upper word for digital input)

*/

// Bit Addresses
at 0xB7 sbit _SEL
at 0xB5 sbit _DE
at 0xB4 sbit _FS

#define MAXBUF	12

// Global Variables
char buf[MAXBUF];
char numCoils;
char numDiscreteInputs;
char numHoldingRegisters;

unsigned int charTimeout;
unsigned int frameTimeout;

unsigned int milli;
char id;

// Function Prototyping
void milliStart(void);
void modbusBegin(char id, unsigned int baud);
void modbusPoll(void);
void exceptionResponse(char code);
void write(char len);
unsigned int crc(char len);
unsigned int div8RndUp(unsigned int value);
unsigned int bytesToWord(char high, char low);
void milliStart(void);

void timer0_isr() interrupt 1
{
    TH0 = 0xfc;        //Reload the TIMER0.
    TL0 = 0x66;

    milli++;
}

void milliStart(void) {
	ET0 = 0				//Disable TIMER0 interrupt while configuring it.
    TMOD |= 0x01;      //TIMER0 = mode_1.
    TH0 = 0xfc;        //Load the timer value for 1ms tick (crystal = 11.059MHz).
    TL0 = 0x66;
    TR0 = 1;           //Turn ON TIMER0.
    ET0 = 1;           //Enable TIMER0 Interrupt.
    EA = 1;            //Enable Global Interrupt.
	
	milli = 0;
}

void modbusBegin(char id, unsigned int baud) {
  milliStart();

  if (baud >= 19200) {
    charTimeout = 1;
    frameTimeout = 2;
  }
  else {
    charTimeout = 15000/baud;		// in the range [1; 13]
    frameTimeout = 35000/baud;		// in the range [2; 30]
  }
  
  do {
    if (RI != 0) {
		milliStart();
		RI = 0;
    }
  } while (milli < frameTimeout);
}

void modbusPoll() {
  char i = 0, j;
  unsigned int startAddress, quantity, value;

  if (RI != 0) {
    milliStart();
    do {
      if (RI != 0) {
        milliStart();
        if(i < MAXBUF)	buf[i] = serialRX();
		else			RI = 0;
        i++;
      }
    } while (milli < charTimeout && i < MAXBUF);
	
    while (milli < frameTimeout);
	
    if (RI == 0 && (buf[0] == id || buf[0] == 0) && i < MAXBUF) {
	  if (crc(i - 2) != bytesToWord(buf[i - 1], buf[i - 2])) return;
      switch (buf[1]) {
        case 1: /* Read Coils */
		  startAddress = bytesToWord(buf[2], buf[3]);
		  quantity = bytesToWord(buf[4], buf[5]);
		  if (quantity == 0 || quantity > ((MAXBUF - 6) * 8)) exceptionResponse(3);
		  else if ((startAddress + quantity) > numCoils) exceptionResponse(2);
		  else {
			for (j = 0; j < quantity; j++) {
			  value = boolRead(startAddress + j);			//<<<<<<<<<<<<<<<<<implement boolRead()
			  if (value < 0) {
				exceptionResponse(4);
				return;
			  }
			  bitWrite(buf[3 + (j >> 3)], j & 7, value);	//<<<<<<<<<<<<<<<<<implement bitWrite()
			}
			buf[2] = div8RndUp(quantity);
			write(3 + buf[2]);
		  }
          break;
        case 3: /* Read Holding Registers */
		  startAddress = bytesToWord(buf[2], buf[3]);
		  quantity = bytesToWord(buf[4], buf[5]);
		  if (quantity == 0 || quantity > ((MAXBUF - 6) >> 1)) exceptionResponse(3);
		  else if ((startAddress + quantity) > numWords) exceptionResponse(2);
		  else {
			for (j = 0; j < quantity; j++) {
			  value = wordRead(startAddress + j);			//<<<<<<<<<<<<<<<<<implement wordRead()
			  if (value < 0) {
				exceptionResponse(4);
				return;
			  }
			  buf[3 + (j * 2)] = (char)(value >> 8);
			  buf[4 + (j * 2)] = (char)(value & 0x00ff);
			}
			buf[2] = quantity * 2;
			write(3 + buf[2]);
		  }
          break;
        case 5: /* Write Single Coil */
          {
            startAddress = bytesToWord(buf[2], buf[3]);
            value = bytesToWord(buf[4], buf[5]);
            if (value != 0 && value != 0xFF00) exceptionResponse(3);
            else if (startAddress >= numCoils) exceptionResponse(2);
            else if (!coilWrite(startAddress, value)) exceptionResponse(4);	//<<<<<<<<<<<<<<<<<implement coilWrite()
            else write(6);
          }
          break;
        case 6: /* Write Single Holding Register */
          {
            startAddress = bytesToWord(buf[2], buf[3]);
            value = bytesToWord(buf[4], buf[5]);
            if (startAddress >= numHoldingRegisters) exceptionResponse(2);
            else if (!holdingRegisterWrite(startAddress, value)) exceptionResponse(4);	//<<<<<<<<<<<<<<<<<implement holdingRegisterWrite()
            else write(6);
          }
          break;
        case 15: /* Write Multiple Coils */
          {
            startAddress = _bytesToWord(buf[2], buf[3]);
            quantity = _bytesToWord(_buf[4], buf[5]);
            if (quantity == 0 || quantity > ((MAXBUF - 10) << 3) || buf[6] != div8RndUp(quantity)) exceptionResponse(3);
            else if ((startAddress + quantity) > numCoils) exceptionResponse(2);
            else {
              for (j = 0; j < quantity; j++) {
                if (!coilWrite(startAddress + j, bitRead(buf[7 + (j >> 3)], j & 7))) {	//<<<<<<<<<<<<<<<<<implement bitRead()
                  exceptionResponse(4);
                  return;
                }
              }
              write(6);
            }
          }
          break;
        default:
          exceptionResponse(1);
          break;
      }
    }
  }
}

void exceptionResponse(char code) {
  buf[1] |= 0x80;
  buf[2] = code;
  write(3);
}

void write(char len) {
  if (buf[0] != 0) {
    unsigned int crc = crc(len);
	
    buf[len] = (char)(crc & 0x00ff);
    buf[len + 1] = (char)(crc >> 8);

    _DE = 1;
    for(char i=0; i<= len+2; i++)	serialTX(buf[i]);
    _DE = 0;
  }
}

unsigned int crc(char len) {
  unsigned int crc = 0xFFFF;
  for (char i = 0; i < len; i++) {
    crc ^= (unsigned int)buf[i];
    for (char j = 0; j < 8; j++) {
      bool lsb = crc & 1;
      crc >>= 1;
      if (lsb == true) {
        crc ^= 0xA001;
      }
    }
  }
  return crc;
}

unsigned int div8RndUp(unsigned int value) {
  return (value + 7) >> 3;
}

unsigned int bytesToWord(char high, char low) {
  return (high << 8) | low;
}

