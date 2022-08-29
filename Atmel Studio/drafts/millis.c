/*___________________________________________________________________________________________________

Title:
	millis.h v1.0

Description:
	Library code for AVR microcontrollers that triggers an interrupt every 1 millisecond 
	and counts milliseconds up to 584.9 million years
	
	For complete details visit
	https://www.programming-electronics-diy.xyz/2021/01/millis-and-micros-library-for-avr.html

Author:
 	Liviu Istrate
	istrateliviu24@yahoo.com
	www.programming-electronics-diy.xyz

Donate:
	Software development takes time and effort so if you find this useful consider a small donation at:
	paypal.me/alientransducer
_____________________________________________________________________________________________________*/


/* ----------------------------- LICENSE - GNU GPL v3 -----------------------------------------------

* This license must be included in any redistribution.

* Copyright (C) 2021 Liviu Istrate, www.programming-electronics-diy.xyz (istrateliviu24@yahoo.com)

* Project URL: https://www.programming-electronics-diy.xyz/2021/01/millis-and-micros-library-for-avr.html

* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with this program. If not, see <https://www.gnu.org/licenses/>.

--------------------------------- END OF LICENSE --------------------------------------------------*/

#ifndef MILLIS_H_
#define MILLIS_H_

/*************************************************************
	INCLUDES
**************************************************************/
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/power.h>
#include <util/atomic.h>

/*************************************************************
	USER SETUP SECTION
**************************************************************/

/*
* Milliseconds data type
* Data type				- Max time span			- Memory used
* unsigned char			- 255 milliseconds		- 1 byte
* unsigned int			- 65.54 seconds			- 2 bytes
* unsigned long			- 49.71 days			- 4 bytes
* unsigned long long	- 584.9 million years	- 8 bytes
*/
typedef unsigned long millis_t; // on 1MHz CPU it takes around 77uS to increment long long variable

#define MILLIS_TIMER0 		0 // Use timer0
#define MILLIS_TIMER1 		1 // Use timer1
#define MILLIS_TIMER2 		2 // Use timer2

#define MILLIS_TIMER 		MILLIS_TIMER2 // Which timer to use

/*************************************************************
	--END OF USER SETUP SECTION
**************************************************************/

/*************************************************************
	SYSTEM SETTINGS
**************************************************************/

#if MILLIS_TIMER == MILLIS_TIMER0

	// Timer0
	#if F_CPU >= 18000000 // 18MHz - 20MHz
		#define CLOCKSEL 		(_BV(CS02))
		#define PRESCALER 		256
		
	#elif F_CPU >= 4000000 // 4MHz - 18MHz
		#define CLOCKSEL 		(_BV(CS01) | _BV(CS00))
		#define PRESCALER 		64
		
	#elif F_CPU >= 1000000 // 1MHz - 4MHz
		#define CLOCKSEL 		(_BV(CS01))
		#define PRESCALER 		8
		
	#elif F_CPU >= 125000 // 125KHz - 1MHz
		#define CLOCKSEL 		(_BV(CS00))
		#define PRESCALER 		1
		
	#else
		#error "F_CPU not supported. Please request support."
	#endif

	#define REG_TCCRA			TCCR0A
	#define REG_TCCRB			TCCR0B
	#define REG_TIMSK			TIMSK0
	#define REG_OCR				OCR0A
	#define BIT_WGM				WGM01
	#define BIT_OCIE			OCIE0A
	#define ISR_VECT			TIMER0_COMPA_vect
	#define pwr_enable()		power_timer0_enable()
	#define pwr_disable()		power_timer0_disable()

	#define SET_TCCRA()			(REG_TCCRA = _BV(BIT_WGM))
	#define SET_TCCRB()			(REG_TCCRB = CLOCKSEL)

#elif MILLIS_TIMER == MILLIS_TIMER1

	// Timer1

	// 125KHz - 20MHz
	#define CLOCKSEL 			(_BV(CS10))
	#define PRESCALER 			1

	#define REG_TCCRA			TCCR1A
	#define REG_TCCRB			TCCR1B
	#define REG_TIMSK			TIMSK1
	#define REG_OCR				OCR1A
	#define BIT_WGM				WGM12
	#define BIT_OCIE			OCIE1A
	#define ISR_VECT			TIMER1_COMPA_vect
	#define pwr_enable()		power_timer1_enable()
	#define pwr_disable()		power_timer1_disable()

	#define SET_TCCRA()			(REG_TCCRA = 0)
	#define SET_TCCRB()			(REG_TCCRB = _BV(BIT_WGM) | CLOCKSEL)

#elif MILLIS_TIMER == MILLIS_TIMER2

	// Timer2

	#if F_CPU >= 9600000	// 9.6MHz - 20MHz
		#define CLOCKSEL 		(_BV(CS22) | _BV(CS20))
		#define PRESCALER 		128
		
	#elif F_CPU >= 4800000	// 4.8MHz - 9.6MHz
		#define CLOCKSEL 		(_BV(CS22))
		#define PRESCALER 		64
		
	#elif F_CPU >= 4000000 // 4MHz - 4.8MHz
		#define CLOCKSEL 		(_BV(CS21) | _BV(CS20))
		#define PRESCALER 		32
		
	#elif F_CPU >= 1000000 // 1MHz - 4MHz
		#define CLOCKSEL 		(_BV(CS21))
		#define PRESCALER 		8
		
	#elif F_CPU >= 125000 // 125KHz - 1MHz
		#define CLOCKSEL 		(_BV(CS20))
		#define PRESCALER 		1
		
	#else
		#error "F_CPU not supported. Please request support."
	#endif

	#define REG_TCCRA			TCCR2A
	#define REG_TCCRB			TCCR2B
	#define REG_TIMSK			TIMSK2
	#define REG_OCR				OCR2A
	#define BIT_WGM				WGM21
	#define BIT_OCIE			OCIE2A
	#define ISR_VECT			TIMER2_COMPA_vect
	#define pwr_enable()		power_timer2_enable()
	#define pwr_disable()		power_timer2_disable()

	#define SET_TCCRA()			(REG_TCCRA = _BV(BIT_WGM))
	#define SET_TCCRB()			(REG_TCCRB = CLOCKSEL)

#else
	#error "Bad MILLIS_TIMER set"
#endif


/*************************************************************
	GLOBAL VARIABLES
**************************************************************/
static volatile millis_t milliseconds;


/*************************************************************
	FUNCTION PROTOTYPES
**************************************************************/
void millis_init(void);
millis_t millis_get(void);
void millis_resume(void);
void millis_pause(void);
void millis_reset(void);
void millis_add(millis_t ms);
void millis_subtract(millis_t ms);


/*************************************************************
	FUNCTIONS
**************************************************************/

// Initialise library
void millis_init(){
	// Timer settings
	SET_TCCRA();
	SET_TCCRB();
	REG_TIMSK = _BV(BIT_OCIE);
	REG_OCR = ((F_CPU / PRESCALER) / 1000) - 1; // 1000 is the frequency
	sei();
}

// Get current milliseconds
millis_t millis_get(){
	millis_t ms;
	
	ATOMIC_BLOCK(ATOMIC_RESTORESTATE){
		ms = milliseconds;
	}
	
	return ms;
}

// Turn on timer and resume time keeping
void millis_resume(){
	pwr_enable();
	SET_TCCRB();
	REG_TIMSK |= _BV(BIT_OCIE);
}

// Pause time keeping and turn off timer to save power
void millis_pause(){
	REG_TIMSK &= ~_BV(BIT_OCIE);
	REG_TCCRB = 0;
	pwr_disable();
}

// Reset milliseconds count to 0
void millis_reset(){
	ATOMIC_BLOCK(ATOMIC_RESTORESTATE){
		milliseconds = 0;
	}
}

// Add time
void millis_add(millis_t ms){
	ATOMIC_BLOCK(ATOMIC_RESTORESTATE){
		milliseconds += ms;
	}
}

// Subtract time
void millis_subtract(millis_t ms){
	ATOMIC_BLOCK(ATOMIC_RESTORESTATE){
		milliseconds -= ms;
	}
}


/*************************************************************
	ISR Handlers
**************************************************************/

ISR(ISR_VECT){
	++milliseconds;
}


#endif /* MILLIS_H_ */