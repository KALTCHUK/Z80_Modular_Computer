// Generate square wave on P1.7 and counter on P3
#include <at892051.h>

/*------------------------------------------------
MAIN C Function
------------------------------------------------*/
void main (void)
{
	unsigned char pval;     /* temp variable for port values */

	pval = 0;

	while (1) {
		P3 = pval;
		pval++;
		
		P1_7 = ~P1_7;
	}

}
