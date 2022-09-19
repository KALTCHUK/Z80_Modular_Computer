char *buf;
char numCoils = 0;
char numDiscreteInputs = 0;
char numHoldingRegisters = 0;
char numInputRegisters = 0;
char id;
unsigned int charTimeout;
unsigned int frameTimeout;
uint32_t responseDelay;
int milli;


void processBoolRead(uint16_t numBools, BoolRead boolRead);
void processWordRead(uint16_t numWords, WordRead wordRead);
void exceptionResponse(uint8_t code);
void write(uint8_t len);
unsigned int crc(uint8_t len);
unsigned int div8RndUp(uint16_t value);
unsigned int bytesToWord(uint8_t high, uint8_t low);
};

#endif
