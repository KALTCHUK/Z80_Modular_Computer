/*
 Graphic functions
*/

#include <stdio.h>

#define FBLACK		30
#define FRED		31
#define FGREEN		32
#define FYELLOW		33
#define FBLUE		34
#define FMAGENTA	35
#define FCYAN		36
#define FWHITE		37

#define BBLACK		40
#define BRED		41
#define BGREEN		42
#define BYELLOW		43
#define BBLUE		44
#define BMAGENTA	45
#define BCYAN		46
#define BWHITE		47

#define	ESC		0x1b

void	setColor(fcolor, bcolor)
int	fcolor, bcolor; {
	printf("%c[%um%c[%um", ESC, bcolor, ESC, fcolor);
}

void	plot(sign, x, y)
char	sign;
int	x, y; {

	x++;
	y = 40 - y;
	printf("%c[%u;%uH%c", ESC, y, x, sign);
}

void	line(sign, x1, y1, x2, y2)
char	sign;
int	x1, x2, y1, y2; {

	x1++;
	x2++;
	y1 = 40 - y1;
	y2 = 40 - y2;

}

void	frame(wid, hite)
int	wid, hite; {
	int	i;

	for(i=1; i<=wid; i++) {
		printf("%c[%u;%uH ", ESC, 1, i);
		printf("%c[%u;%uH ", ESC, hite, i);
	}

	for(i=1; i<=hite; i++) {
		printf("%c[%u;%uH ", ESC, i, 1);
		printf("%c[%u;%uH ", ESC, i, wid);
	}
}

void	clear() {
	printf("%c[2J", ESC);
}

main() {
	int	i;


	clear();
	setColor(FYELLOW, BRED);
	for(i=0; i<40; i++){
		plot('@', 2*i, i);

	}
	setColor(FGREEN, BBLUE);
	for(i=0; i<40; i++){
		plot('@', i, i);

	}
	setColor(FWHITE,BRED);
	frame(80, 40);
	setColor(FGREEN,BBLACK);
}
