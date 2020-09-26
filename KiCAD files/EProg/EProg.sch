EESchema Schematic File Version 4
LIBS:EProg-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "EEPROM (W27C512) Programmer"
Date "2019-09-23"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Interface:8255A U4
U 1 1 5D85E9D2
P 5800 3050
F 0 "U4" H 5800 4831 50  0000 C CNN
F 1 "8255A" H 5800 4740 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm" H 5800 3350 50  0001 C CNN
F 3 "http://aturing.umcs.maine.edu/~meadow/courses/cos335/Intel8255A.pdf" H 5800 3350 50  0001 C CNN
	1    5800 3050
	1    0    0    -1  
$EndComp
$Comp
L MCU_Module:Arduino_Nano_v3.x A1
U 1 1 5D861A2B
P 2550 2750
F 0 "A1" H 2550 1661 50  0000 C CNN
F 1 "Arduino_Nano_v3.x" H 2550 1570 50  0000 C CNN
F 2 "Module:Arduino_Nano" H 2700 1800 50  0001 L CNN
F 3 "http://www.mouser.com/pdfdocs/Gravitech_Arduino_Nano3_0.pdf" H 2550 1750 50  0001 C CNN
	1    2550 2750
	1    0    0    -1  
$EndComp
$Comp
L Memory_EPROM:27C512 U5
U 1 1 5D8649C1
P 9250 2900
F 0 "U5" H 9250 4181 50  0000 C CNN
F 1 "27C512" H 9250 4090 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm" H 9250 2900 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0015.pdf" H 9250 2900 50  0001 C CNN
	1    9250 2900
	1    0    0    -1  
$EndComp
Entry Wire Line
	1300 2250 1400 2350
Entry Wire Line
	1300 2350 1400 2450
Entry Wire Line
	1300 2450 1400 2550
Entry Wire Line
	1300 2550 1400 2650
Entry Wire Line
	1300 2650 1400 2750
Entry Wire Line
	1300 2750 1400 2850
Entry Wire Line
	1300 2850 1400 2950
Entry Wire Line
	1300 2950 1400 3050
Wire Wire Line
	1400 2350 2050 2350
Wire Wire Line
	1400 2550 2050 2550
Wire Wire Line
	1400 2650 2050 2650
Wire Wire Line
	1400 2750 2050 2750
Wire Wire Line
	1400 2850 2050 2850
Wire Wire Line
	1400 2950 2050 2950
Wire Wire Line
	2050 3050 1400 3050
Wire Wire Line
	1400 2450 2050 2450
Entry Wire Line
	4850 2850 4950 2950
Entry Wire Line
	4850 2950 4950 3050
Entry Wire Line
	4850 3050 4950 3150
Entry Wire Line
	4850 3150 4950 3250
Entry Wire Line
	4850 3250 4950 3350
Entry Wire Line
	4850 3350 4950 3450
Entry Wire Line
	4850 3450 4950 3550
Entry Wire Line
	4850 3550 4950 3650
Wire Wire Line
	4950 2950 5100 2950
Wire Wire Line
	4950 3050 5100 3050
Wire Wire Line
	4950 3150 5100 3150
Wire Wire Line
	4950 3250 5100 3250
Wire Wire Line
	4950 3350 5100 3350
Wire Wire Line
	4950 3450 5100 3450
Wire Wire Line
	4950 3550 5100 3550
Wire Wire Line
	4950 3650 5100 3650
Wire Bus Line
	1300 1400 4850 1400
Text Label 1400 2350 0    50   ~ 0
w0
Text Label 1400 2450 0    50   ~ 0
w1
Text Label 1400 2550 0    50   ~ 0
w2
Text Label 1400 2650 0    50   ~ 0
w3
Text Label 1400 2750 0    50   ~ 0
w4
Text Label 1400 2850 0    50   ~ 0
w5
Text Label 1400 2950 0    50   ~ 0
w6
Text Label 1400 3050 0    50   ~ 0
w7
Text Label 4950 2950 0    50   ~ 0
w0
Text Label 4950 3050 0    50   ~ 0
w1
Text Label 4950 3150 0    50   ~ 0
w2
Text Label 4950 3250 0    50   ~ 0
w3
Text Label 4950 3350 0    50   ~ 0
w4
Text Label 4950 3450 0    50   ~ 0
w5
Text Label 4950 3550 0    50   ~ 0
w6
Text Label 4950 3650 0    50   ~ 0
w7
Text Label 6500 1750 0    50   ~ 0
addr0
Text Label 6500 1850 0    50   ~ 0
addr1
Text Label 6500 1950 0    50   ~ 0
addr2
Text Label 6500 2050 0    50   ~ 0
addr3
Text Label 6500 2150 0    50   ~ 0
addr4
Text Label 6500 2250 0    50   ~ 0
addr5
Text Label 6500 2350 0    50   ~ 0
addr6
Text Label 6500 2450 0    50   ~ 0
addr7
Text Label 6500 2650 0    50   ~ 0
data0
Text Label 6500 2750 0    50   ~ 0
data1
Text Label 6500 2850 0    50   ~ 0
data2
Text Label 6500 2950 0    50   ~ 0
data3
Text Label 6500 3050 0    50   ~ 0
data4
Text Label 6500 3150 0    50   ~ 0
data5
Text Label 6500 3250 0    50   ~ 0
data6
Text Label 6500 3350 0    50   ~ 0
data7
Text Label 6500 3550 0    50   ~ 0
addr8
Text Label 6500 3650 0    50   ~ 0
addr9
Text Label 6500 3750 0    50   ~ 0
addr10
Text Label 6500 3850 0    50   ~ 0
addr11
Text Label 6500 3950 0    50   ~ 0
addr12
Text Label 6500 4050 0    50   ~ 0
addr13
Text Label 6500 4150 0    50   ~ 0
addr14
Text Label 6500 4250 0    50   ~ 0
addr15
Text Label 9650 2000 0    50   ~ 0
data0
Text Label 9650 2100 0    50   ~ 0
data1
Text Label 9650 2200 0    50   ~ 0
data2
Text Label 9650 2300 0    50   ~ 0
data3
Text Label 9650 2400 0    50   ~ 0
data4
Text Label 9650 2500 0    50   ~ 0
data5
Text Label 9650 2600 0    50   ~ 0
data6
Text Label 9650 2700 0    50   ~ 0
data7
Text Label 8850 2000 2    50   ~ 0
addr0
Text Label 8850 2100 2    50   ~ 0
addr1
Text Label 8850 2200 2    50   ~ 0
addr2
Text Label 8850 2300 2    50   ~ 0
addr3
Text Label 8850 2400 2    50   ~ 0
addr4
Text Label 8850 2500 2    50   ~ 0
addr5
Text Label 8850 2600 2    50   ~ 0
addr6
Text Label 8850 2700 2    50   ~ 0
addr7
Text Label 8850 2800 2    50   ~ 0
addr8
Text Label 8850 2900 2    50   ~ 0
addr09
Text Label 8850 3000 2    50   ~ 0
addr10
Text Label 8850 3100 2    50   ~ 0
addr11
Text Label 8850 3200 2    50   ~ 0
addr12
Text Label 8850 3300 2    50   ~ 0
addr13
Text Label 8850 3400 2    50   ~ 0
addr14
Text Label 8850 3500 2    50   ~ 0
addr15
Connection ~ 8500 1600
Wire Bus Line
	8500 1600 6850 1600
Wire Wire Line
	6500 1750 6750 1750
Wire Wire Line
	6500 1850 6750 1850
Wire Wire Line
	6500 1950 6750 1950
Entry Wire Line
	6750 1750 6850 1650
Entry Wire Line
	6750 1850 6850 1750
Entry Wire Line
	6750 1950 6850 1850
Wire Wire Line
	6500 2050 6750 2050
Wire Wire Line
	6500 2150 6750 2150
Wire Wire Line
	6500 2250 6750 2250
Wire Wire Line
	6500 2350 6750 2350
Wire Wire Line
	6500 2450 6750 2450
Wire Wire Line
	6500 2650 6750 2650
Wire Wire Line
	6500 2750 6750 2750
Wire Wire Line
	6500 2850 6750 2850
Wire Wire Line
	6500 2950 6750 2950
Wire Wire Line
	6500 3050 6750 3050
Wire Wire Line
	6500 3150 6750 3150
Wire Wire Line
	6500 3250 6750 3250
Wire Wire Line
	6500 3350 6750 3350
Entry Wire Line
	6750 2050 6850 1950
Entry Wire Line
	6750 2150 6850 2050
Entry Wire Line
	6750 2250 6850 2150
Entry Wire Line
	6750 2350 6850 2250
Entry Wire Line
	6750 2450 6850 2350
Entry Wire Line
	6750 2650 6850 2550
Entry Wire Line
	6750 2750 6850 2650
Entry Wire Line
	6750 2850 6850 2750
Entry Wire Line
	6750 2950 6850 2850
Entry Wire Line
	6750 3050 6850 2950
Entry Wire Line
	6750 3150 6850 3050
Entry Wire Line
	6750 3250 6850 3150
Entry Wire Line
	6750 3350 6850 3250
Wire Wire Line
	6500 3550 6750 3550
Wire Wire Line
	6500 3750 6750 3750
Wire Wire Line
	6500 3850 6750 3850
Wire Wire Line
	6500 3950 6750 3950
Wire Wire Line
	6500 4050 6750 4050
Wire Wire Line
	6500 4150 6750 4150
Wire Wire Line
	6500 4250 6750 4250
Entry Wire Line
	6750 3550 6850 3450
Entry Wire Line
	6750 3750 6850 3650
Entry Wire Line
	6750 3850 6850 3750
Entry Wire Line
	6750 3950 6850 3850
Entry Wire Line
	6750 4050 6850 3950
Entry Wire Line
	6750 4150 6850 4050
Entry Wire Line
	6750 4250 6850 4150
Wire Wire Line
	8850 2000 8600 2000
Wire Wire Line
	8850 2100 8600 2100
Wire Wire Line
	8850 2200 8600 2200
Wire Wire Line
	8850 2300 8600 2300
Wire Wire Line
	8850 2400 8600 2400
Wire Wire Line
	8850 2500 8600 2500
Wire Wire Line
	8850 2600 8600 2600
Wire Wire Line
	8850 2700 8600 2700
Wire Wire Line
	8850 2800 8600 2800
Wire Wire Line
	8850 3000 8600 3000
Wire Wire Line
	8850 3100 8600 3100
Wire Wire Line
	8850 3200 8600 3200
Wire Wire Line
	8850 3300 8600 3300
Wire Wire Line
	8850 3400 8600 3400
Wire Wire Line
	8850 3500 8600 3500
Entry Wire Line
	8500 1900 8600 2000
Entry Wire Line
	8500 2000 8600 2100
Entry Wire Line
	8500 2100 8600 2200
Entry Wire Line
	8500 2200 8600 2300
Entry Wire Line
	8500 2300 8600 2400
Entry Wire Line
	8500 2400 8600 2500
Entry Wire Line
	8500 2500 8600 2600
Entry Wire Line
	8500 2600 8600 2700
Entry Wire Line
	8500 2700 8600 2800
Entry Wire Line
	8500 2900 8600 3000
Entry Wire Line
	8500 3000 8600 3100
Entry Wire Line
	8500 3100 8600 3200
Entry Wire Line
	8500 3200 8600 3300
Entry Wire Line
	8500 3300 8600 3400
Entry Wire Line
	8500 3400 8600 3500
Wire Bus Line
	8500 1600 9950 1600
Wire Wire Line
	9650 2000 9850 2000
Wire Wire Line
	9650 2100 9850 2100
Wire Wire Line
	9650 2200 9850 2200
Wire Wire Line
	9650 2300 9850 2300
Wire Wire Line
	9650 2400 9850 2400
Wire Wire Line
	9650 2500 9850 2500
Wire Wire Line
	9650 2600 9850 2600
Wire Wire Line
	9650 2700 9850 2700
Entry Wire Line
	9850 2000 9950 1900
Entry Wire Line
	9850 2100 9950 2000
Entry Wire Line
	9850 2200 9950 2100
Entry Wire Line
	9850 2300 9950 2200
Entry Wire Line
	9850 2400 9950 2300
Entry Wire Line
	9850 2500 9950 2400
Entry Wire Line
	9850 2600 9950 2500
Entry Wire Line
	9850 2700 9950 2600
$Comp
L power:GND #PWR0101
U 1 1 5D8DF074
P 5800 4650
F 0 "#PWR0101" H 5800 4400 50  0001 C CNN
F 1 "GND" H 5805 4477 50  0000 C CNN
F 2 "" H 5800 4650 50  0001 C CNN
F 3 "" H 5800 4650 50  0001 C CNN
	1    5800 4650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 5D8ECCB8
P 2650 3750
F 0 "#PWR0106" H 2650 3500 50  0001 C CNN
F 1 "GND" H 2655 3577 50  0000 C CNN
F 2 "" H 2650 3750 50  0001 C CNN
F 3 "" H 2650 3750 50  0001 C CNN
	1    2650 3750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 5D8EF17C
P 9250 4000
F 0 "#PWR0107" H 9250 3750 50  0001 C CNN
F 1 "GND" H 9255 3827 50  0000 C CNN
F 2 "" H 9250 4000 50  0001 C CNN
F 3 "" H 9250 4000 50  0001 C CNN
	1    9250 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 3750 2650 3750
Connection ~ 2650 3750
Wire Wire Line
	5100 2050 3650 2050
Wire Wire Line
	3650 2050 3650 2750
Wire Wire Line
	3650 2750 3050 2750
Wire Wire Line
	5100 2150 3750 2150
Wire Wire Line
	3750 2150 3750 2850
Wire Wire Line
	3750 2850 3050 2850
Wire Wire Line
	5100 2250 3850 2250
Wire Wire Line
	3850 2250 3850 2950
Wire Wire Line
	3850 2950 3050 2950
Wire Wire Line
	5100 2550 3950 2550
Wire Wire Line
	3950 2550 3950 3050
Wire Wire Line
	3950 3050 3050 3050
Wire Wire Line
	5100 2650 4050 2650
Wire Wire Line
	4050 2650 4050 3150
Wire Wire Line
	4050 3150 3050 3150
Text Label 3050 2750 0    50   ~ 0
PPI_SELECT
Text Label 3050 2850 0    50   ~ 0
PPI_READ
Text Label 3050 2950 0    50   ~ 0
PPI_WRITE
Text Label 3050 3050 0    50   ~ 0
PPI_A0
Text Label 3050 3150 0    50   ~ 0
PPI_A1
$Comp
L power:GND #PWR0123
U 1 1 5DA515F1
P 5100 1750
F 0 "#PWR0123" H 5100 1500 50  0001 C CNN
F 1 "GND" H 5105 1577 50  0000 C CNN
F 2 "" H 5100 1750 50  0001 C CNN
F 3 "" H 5100 1750 50  0001 C CNN
	1    5100 1750
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0131
U 1 1 5DAE8F25
P 9250 1800
F 0 "#PWR0131" H 9250 1650 50  0001 C CNN
F 1 "+5V" V 9265 1928 50  0000 L CNN
F 2 "" H 9250 1800 50  0001 C CNN
F 3 "" H 9250 1800 50  0001 C CNN
	1    9250 1800
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C6
U 1 1 5DAF16A5
P 5950 1450
F 0 "C6" V 6202 1450 50  0000 C CNN
F 1 "10n" V 6111 1450 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 5988 1300 50  0001 C CNN
F 3 "~" H 5950 1450 50  0001 C CNN
	1    5950 1450
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C7
U 1 1 5DB029FA
P 9400 1800
F 0 "C7" V 9652 1800 50  0000 C CNN
F 1 "10n" V 9561 1800 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 9438 1650 50  0001 C CNN
F 3 "~" H 9400 1800 50  0001 C CNN
	1    9400 1800
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0132
U 1 1 5DB2C6BC
P 6100 1450
F 0 "#PWR0132" H 6100 1200 50  0001 C CNN
F 1 "GND" V 6105 1322 50  0000 R CNN
F 2 "" H 6100 1450 50  0001 C CNN
F 3 "" H 6100 1450 50  0001 C CNN
	1    6100 1450
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0133
U 1 1 5DB341AC
P 9550 1800
F 0 "#PWR0133" H 9550 1550 50  0001 C CNN
F 1 "GND" V 9555 1672 50  0000 R CNN
F 2 "" H 9550 1800 50  0001 C CNN
F 3 "" H 9550 1800 50  0001 C CNN
	1    9550 1800
	0    -1   -1   0   
$EndComp
$Comp
L power:+5V #PWR0134
U 1 1 5DB56AD0
P 5800 1450
F 0 "#PWR0134" H 5800 1300 50  0001 C CNN
F 1 "+5V" V 5815 1578 50  0000 L CNN
F 2 "" H 5800 1450 50  0001 C CNN
F 3 "" H 5800 1450 50  0001 C CNN
	1    5800 1450
	0    -1   -1   0   
$EndComp
Connection ~ 9250 1800
Connection ~ 5800 1450
NoConn ~ 2650 1750
NoConn ~ 3050 2150
NoConn ~ 3050 2250
NoConn ~ 3050 2550
NoConn ~ 3050 3250
NoConn ~ 3050 3350
NoConn ~ 3050 3450
NoConn ~ 2050 2150
NoConn ~ 2050 2250
$Comp
L power:+5V #PWR04
U 1 1 5DABEE31
P 2750 1750
F 0 "#PWR04" H 2750 1600 50  0001 C CNN
F 1 "+5V" H 2765 1923 50  0000 R CNN
F 2 "" H 2750 1750 50  0001 C CNN
F 3 "" H 2750 1750 50  0001 C CNN
	1    2750 1750
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5DAE3369
P 3000 6100
F 0 "#FLG01" H 3000 6175 50  0001 C CNN
F 1 "PWR_FLAG" H 3000 6273 50  0000 C CNN
F 2 "" H 3000 6100 50  0001 C CNN
F 3 "~" H 3000 6100 50  0001 C CNN
	1    3000 6100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR05
U 1 1 5DAEA9DE
P 3000 6200
F 0 "#PWR05" H 3000 5950 50  0001 C CNN
F 1 "GND" H 3005 6027 50  0000 C CNN
F 2 "" H 3000 6200 50  0001 C CNN
F 3 "" H 3000 6200 50  0001 C CNN
	1    3000 6200
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 6100 3000 6200
Text GLabel 1800 3250 0    50   Input ~ 0
ENABLE_12V
Text GLabel 1800 3350 0    50   Input ~ 0
ENABLE_14V
Wire Wire Line
	2050 3250 1800 3250
Wire Wire Line
	2050 3350 1800 3350
NoConn ~ 2050 3450
Text GLabel 8400 2900 0    50   Input ~ 0
ROM_A9
Text GLabel 6950 3650 2    50   Input ~ 0
PPI_A9
Text GLabel 8650 3800 0    50   Input ~ 0
ROM_OE_VPP
Wire Wire Line
	8850 3800 8650 3800
Wire Wire Line
	8850 3700 7700 3700
Wire Wire Line
	7700 3700 7700 4950
Wire Wire Line
	7700 4950 1250 4950
Wire Wire Line
	1250 4950 1250 3150
Wire Wire Line
	1250 3150 2050 3150
$Comp
L power:+5V #PWR02
U 1 1 5E1911A5
P 4800 6050
F 0 "#PWR02" H 4800 5900 50  0001 C CNN
F 1 "+5V" H 4815 6223 50  0000 C CNN
F 2 "" H 4800 6050 50  0001 C CNN
F 3 "" H 4800 6050 50  0001 C CNN
	1    4800 6050
	1    0    0    -1  
$EndComp
$Comp
L power:+12V #PWR01
U 1 1 5E19183B
P 4600 6050
F 0 "#PWR01" H 4600 5900 50  0001 C CNN
F 1 "+12V" H 4615 6223 50  0000 C CNN
F 2 "" H 4600 6050 50  0001 C CNN
F 3 "" H 4600 6050 50  0001 C CNN
	1    4600 6050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 5E191E63
P 4800 6350
F 0 "#PWR03" H 4800 6100 50  0001 C CNN
F 1 "GND" H 4805 6177 50  0000 C CNN
F 2 "" H 4800 6350 50  0001 C CNN
F 3 "" H 4800 6350 50  0001 C CNN
	1    4800 6350
	1    0    0    -1  
$EndComp
Text GLabel 4800 6700 0    50   Input ~ 0
ENABLE_12V
Text GLabel 4800 6800 0    50   Input ~ 0
ENABLE_14V
Text GLabel 4800 7050 0    50   Input ~ 0
PPI_A9
Text GLabel 4800 7150 0    50   Input ~ 0
ROM_A9
Text GLabel 4800 7250 0    50   Input ~ 0
ROM_OE_VPP
$Comp
L power:+12V #PWR0102
U 1 1 5E1C53BB
P 2050 6100
F 0 "#PWR0102" H 2050 5950 50  0001 C CNN
F 1 "+12V" H 2065 6273 50  0000 C CNN
F 2 "" H 2050 6100 50  0001 C CNN
F 3 "" H 2050 6100 50  0001 C CNN
	1    2050 6100
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5E1C9DD3
P 2500 6100
F 0 "#FLG0101" H 2500 6175 50  0001 C CNN
F 1 "PWR_FLAG" H 2500 6273 50  0000 C CNN
F 2 "" H 2500 6100 50  0001 C CNN
F 3 "~" H 2500 6100 50  0001 C CNN
	1    2500 6100
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 6100 2050 6300
Wire Wire Line
	2050 6300 2500 6300
Wire Wire Line
	2500 6300 2500 6100
$Comp
L power:+12V #PWR06
U 1 1 5E1DCC28
P 2450 1750
F 0 "#PWR06" H 2450 1600 50  0001 C CNN
F 1 "+12V" H 2465 1923 50  0000 C CNN
F 2 "" H 2450 1750 50  0001 C CNN
F 3 "" H 2450 1750 50  0001 C CNN
	1    2450 1750
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x01_Male J1
U 1 1 5E18E418
P 5150 6100
F 0 "J1" H 5050 6100 50  0000 C CNN
F 1 "Conn_01x01_Male" H 5258 6190 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 5150 6100 50  0001 C CNN
F 3 "~" H 5150 6100 50  0001 C CNN
	1    5150 6100
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x01_Male J2
U 1 1 5E19D810
P 5150 6200
F 0 "J2" H 5050 6200 50  0000 C CNN
F 1 "Conn_01x01_Male" H 5258 6290 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 5150 6200 50  0001 C CNN
F 3 "~" H 5150 6200 50  0001 C CNN
	1    5150 6200
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x01_Male J3
U 1 1 5E1A2546
P 5150 6300
F 0 "J3" H 5050 6300 50  0000 C CNN
F 1 "Conn_01x01_Male" H 5258 6390 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 5150 6300 50  0001 C CNN
F 3 "~" H 5150 6300 50  0001 C CNN
	1    5150 6300
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x01_Male J4
U 1 1 5E1A716B
P 5150 6700
F 0 "J4" H 5050 6700 50  0000 C CNN
F 1 "Conn_01x01_Male" H 5258 6790 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 5150 6700 50  0001 C CNN
F 3 "~" H 5150 6700 50  0001 C CNN
	1    5150 6700
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x01_Male J5
U 1 1 5E1ABD6C
P 5150 6800
F 0 "J5" H 5050 6800 50  0000 C CNN
F 1 "Conn_01x01_Male" H 5258 6890 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 5150 6800 50  0001 C CNN
F 3 "~" H 5150 6800 50  0001 C CNN
	1    5150 6800
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x01_Male J6
U 1 1 5E1B098C
P 5150 7050
F 0 "J6" H 5050 7050 50  0000 C CNN
F 1 "Conn_01x01_Male" H 5258 7140 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 5150 7050 50  0001 C CNN
F 3 "~" H 5150 7050 50  0001 C CNN
	1    5150 7050
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x01_Male J7
U 1 1 5E1B5583
P 5150 7150
F 0 "J7" H 5050 7150 50  0000 C CNN
F 1 "Conn_01x01_Male" H 5258 7240 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 5150 7150 50  0001 C CNN
F 3 "~" H 5150 7150 50  0001 C CNN
	1    5150 7150
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x01_Male J8
U 1 1 5E1BA1C8
P 5150 7250
F 0 "J8" H 5050 7250 50  0000 C CNN
F 1 "Conn_01x01_Male" H 5258 7340 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 5150 7250 50  0001 C CNN
F 3 "~" H 5150 7250 50  0001 C CNN
	1    5150 7250
	-1   0    0    1   
$EndComp
Wire Wire Line
	4950 6100 4800 6100
Wire Wire Line
	4800 6100 4800 6050
Wire Wire Line
	4950 6200 4600 6200
Wire Wire Line
	4600 6200 4600 6050
Wire Wire Line
	4950 6300 4800 6300
Wire Wire Line
	4800 6300 4800 6350
Wire Wire Line
	4950 6700 4800 6700
Wire Wire Line
	4800 6800 4950 6800
Wire Wire Line
	4950 7050 4800 7050
Wire Wire Line
	4800 7150 4950 7150
Wire Wire Line
	4950 7250 4800 7250
Wire Wire Line
	8400 2900 8850 2900
Wire Wire Line
	6500 3650 6950 3650
Wire Bus Line
	9950 1600 9950 2700
Wire Bus Line
	4850 1400 4850 3700
Wire Bus Line
	1300 1400 1300 3050
Wire Bus Line
	8500 1600 8500 3500
Wire Bus Line
	6850 1600 6850 4250
$EndSCHEMATC
