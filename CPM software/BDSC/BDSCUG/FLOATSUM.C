
/* 
	This program is a simple example of how to use
	Bob Mathias's floating point package. To compile it,
	first compile (but do not link) both this file
	and FLOAT.C.
	Then, give the CLINK command:

	A>clink floatsum float <cr>

	and run the thing by saying:

	A>floatsum

	Note: the "printf" function resulting from this linkage
	will support the "e" and "f" floating point conversion
	characters, but the regular "printf" would not. The reason:
	the special version of "sprintf" in the FLOAT.C	source
	file causes that special version to take precedence over
	the library version, and thus support the extra features. See
	the comments in FLOAT.C for more details on this strangeness.
*/

main()
{
	char s1[5], s2[5], s3[5];
	char string[30];
	char sb[30];
	int i;
	atof(s1,"0");
	while (1) {
		printf("sum = %10.6f\n",s1);
		printf("\nEnter a floating number: ");
		fpadd(s3,s1,atof(s2,gets(string)));
		for (i=0; i<5; i++) s1[i] = s3[i];
	}
}

