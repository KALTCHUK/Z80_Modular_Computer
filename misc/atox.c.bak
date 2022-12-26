
int atox(s)
char *s; {
	char idx, curr;
	int val;

	idx = 0;
	val = 0;
	do {
		curr = toupper(s[idx++]);
		if(curr >= '0' && curr <= '9') {
			val = (val * 0x10) + (curr - 0x30);
		} else if(curr >= 'A' && curr <= 'F') {
			val = (val * 0x10) + (curr - 0x37);
		}
	} while(curr != NULL);
	return val;
}

somewhere inside main()
	...
	comma_ant = 0;
	do {
		comma = index(line + comma_ant);
		if(comma != -1) {
			comma += comma_ant + 1;
			comma_ant = comma;
			value = atox(line + comma);
			I2Cwrite(addr++, value);
		}
	} while(comma != -1);