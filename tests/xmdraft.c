main () {
	// Do all that initial BS



	something = NAK;
	do {
		Send(something);
		if(Recv(5) == TIMEOUT) {
			retryCount++;
			if (retryCount > MAXTRY) SyncErr();
		} else {
			switch(receivedByte) {
				case EOT:
					WrapUp();
					break;
				case SOH:
					retryCount = 0;
					something = ReceiveBlock()
					break;
				case CAN:
					if (lcd == ON) "\nRTU CANCEL      "
					exit();
				default:
					retryCout++;
					if (retryCount > MAXTRY) SyncErr();
			}
		}
	} while (1);
}


/* FUNCTIONS */

WrapUp() {
	Send(NAK);
	Recv(1);
	Send(ACK);
	if (close(fd) == -1) {
		if (lcd == ON) "\nFCLOSE ERROR    "
	} else {
		fprintf("Transmission completed. %d blocks received.\n", blockCount);
		if (lcd == ON)	"\nEND            "
	}
	exit();
}

char ReceiveBlock() {
	char	block, blockNeg;
	int 	byteCount;
	char	checkSum;
	char	buffer[129];
	
	if (Recv(1) == TIMEOUT)	TimeErr();
	block = receivedByte;
	if (Recv(1) == TIMEOUT)	TimeErr();
	blockNeg = receivedByte;
	if (block != !blockNeg)	BlockErr();
	if (block != blockCount != 0xff)	BlockErr();
	if (lcd == ON)	"\nBLOCK %u         ", blockCount
	checkSum = 0;
	for (byteCount = 0; byteCount < 128; byteCount++) {
		if(Recv(1) == TIMEOUT) TimeErr();
		buffer[byteCount] = receivedByte;
		checkSum = checkSum + receivedByte;
	}
	if (Recv(1) == TIMEOUT)	TimeErr();
	if (receivedByte == checkSum) {
		if (write(fd, buffer, 1) == -1)	WriteErr();
		blockCount++;
		return (ACK);
	} else {
		return (NAK);
	}
}

WriteErr() {
	Send(CAN);
	if (lcd == ON)	"\nFWRITE ERROR    "
	printf("File write error.\n")
	exit();
}

SyncErr() {
	if (lcd == ON)	"\nSYNC ERROR      "
	printf("Unable to sync with RTU.\n");
	exit();
}

TimeErr() {
	if (lcd == ON)	"\nRTU TIMEOUT     "
	printf("RTU Timeout.")
	exit();
}

BlockErr() {
	Send(CAN);
	if (lcd == ON)	"\nBLOCK ERROR     "
	Purge();
	printf("Block count error.\n");
	exit();

}

Purge() {
	do	while (Recv(3) != TIMEOUT);
}
