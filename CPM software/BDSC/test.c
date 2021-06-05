main() {
	char	s[] = "ABCDEFGHIJ";
	int		slen;
	
	slen = strlen(s);
	
	for (i = slen; i > 0, i--) {
		*(s + 1) = '\0';
		puts(s);
		putchar('\n');
	}
}


/*
putchar(c)
char c;


puts(str)
char *str;


char *strcpy(s1,s2)
char *s1, *s2;


char *strcat(s1,s2)
char *s1, *s2;



Also test TARGET.C

*/
