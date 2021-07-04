EESchema Schematic File Version 4
LIBS:preTTY-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector_Generic:Conn_02x05_Odd_Even J1
U 1 1 5DE110BD
P 1450 2550
F 0 "J1" H 1500 2967 50  0000 C CNN
F 1 "Power Bus" H 1500 2876 50  0000 C CNN
F 2 "" H 1450 2550 50  0001 C CNN
F 3 "~" H 1450 2550 50  0001 C CNN
	1    1450 2550
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J2
U 1 1 5DE11A6D
P 3500 2050
F 0 "J2" H 3550 3167 50  0000 C CNN
F 1 "Signal Buss" H 3550 3076 50  0000 C CNN
F 2 "" H 3500 2050 50  0001 C CNN
F 3 "~" H 3500 2050 50  0001 C CNN
	1    3500 2050
	1    0    0    -1  
$EndComp
Text Label 1750 2350 0    50   ~ 0
gnd
Text Label 1750 2450 0    50   ~ 0
+5V
Text Label 1750 2550 0    50   ~ 0
+12V
Text Label 1750 2650 0    50   ~ 0
v1
Text Label 1750 2750 0    50   ~ 0
gnd
Text Label 1250 2350 2    50   ~ 0
gnd
Text Label 1250 2450 2    50   ~ 0
+5V
Text Label 1250 2550 2    50   ~ 0
+12V
Text Label 1250 2650 2    50   ~ 0
v1
Text Label 1250 2750 2    50   ~ 0
gnd
Text Label 3300 1150 2    50   ~ 0
a01
Text Label 3300 1250 2    50   ~ 0
a03
Text Label 3300 1350 2    50   ~ 0
a05
Text Label 3300 1450 2    50   ~ 0
a07
Text Label 3300 1550 2    50   ~ 0
a09
Text Label 3300 1650 2    50   ~ 0
a11
Text Label 3300 1750 2    50   ~ 0
a13
Text Label 3300 1850 2    50   ~ 0
a15
Text Label 3300 1950 2    50   ~ 0
d01
Text Label 3300 2050 2    50   ~ 0
d03
Text Label 3300 2150 2    50   ~ 0
d05
Text Label 3300 2250 2    50   ~ 0
d07
Text Label 3300 2350 2    50   ~ 0
wr
Text Label 3300 2450 2    50   ~ 0
rd
Text Label 3300 2550 2    50   ~ 0
busack
Text Label 3300 2650 2    50   ~ 0
halt
Text Label 3300 2750 2    50   ~ 0
int
Text Label 3300 2850 2    50   ~ 0
s1
Text Label 3300 2950 2    50   ~ 0
m1
Text Label 3300 3050 2    50   ~ 0
clk
Text Label 3800 1150 0    50   ~ 0
a00
Text Label 3800 1250 0    50   ~ 0
a02
Text Label 3800 1350 0    50   ~ 0
a04
Text Label 3800 1450 0    50   ~ 0
a06
Text Label 3800 1550 0    50   ~ 0
a08
Text Label 3800 1650 0    50   ~ 0
a10
Text Label 3800 1750 0    50   ~ 0
a12
Text Label 3800 1850 0    50   ~ 0
a14
Text Label 3800 1950 0    50   ~ 0
d00
Text Label 3800 2050 0    50   ~ 0
d02
Text Label 3800 2150 0    50   ~ 0
d04
Text Label 3800 2250 0    50   ~ 0
d06
Text Label 3800 2350 0    50   ~ 0
mreq
Text Label 3800 2450 0    50   ~ 0
iorq
Text Label 3800 2550 0    50   ~ 0
busrq
Text Label 3800 2650 0    50   ~ 0
wait
Text Label 3800 2750 0    50   ~ 0
nmi
Text Label 3800 2850 0    50   ~ 0
s0
Text Label 3800 2950 0    50   ~ 0
s2
$Comp
L power:+5V #PWR09
U 1 1 5E34AA96
P 2250 2150
F 0 "#PWR09" H 2250 2000 50  0001 C CNN
F 1 "+5V" H 2265 2323 50  0000 C CNN
F 2 "" H 2250 2150 50  0001 C CNN
F 3 "" H 2250 2150 50  0001 C CNN
	1    2250 2150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR010
U 1 1 5E34BF5A
P 2250 2850
F 0 "#PWR010" H 2250 2600 50  0001 C CNN
F 1 "GND" H 2255 2677 50  0000 C CNN
F 2 "" H 2250 2850 50  0001 C CNN
F 3 "" H 2250 2850 50  0001 C CNN
	1    2250 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2250 2850 2250 2750
Wire Wire Line
	2250 2750 1750 2750
Wire Wire Line
	2250 2150 2250 2450
Wire Wire Line
	2250 2450 1750 2450
NoConn ~ 3300 2950
NoConn ~ 3300 2850
NoConn ~ 3800 2850
NoConn ~ 3800 2950
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5E3C8BDE
P 1300 1300
F 0 "#FLG01" H 1300 1375 50  0001 C CNN
F 1 "PWR_FLAG" H 1300 1473 50  0000 C CNN
F 2 "" H 1300 1300 50  0001 C CNN
F 3 "~" H 1300 1300 50  0001 C CNN
	1    1300 1300
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5E3C9F2A
P 2250 1300
F 0 "#FLG02" H 2250 1375 50  0001 C CNN
F 1 "PWR_FLAG" H 2250 1473 50  0000 C CNN
F 2 "" H 2250 1300 50  0001 C CNN
F 3 "~" H 2250 1300 50  0001 C CNN
	1    2250 1300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR08
U 1 1 5E3CA8BD
P 2250 1400
F 0 "#PWR08" H 2250 1150 50  0001 C CNN
F 1 "GND" H 2255 1227 50  0000 C CNN
F 2 "" H 2250 1400 50  0001 C CNN
F 3 "" H 2250 1400 50  0001 C CNN
	1    2250 1400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR04
U 1 1 5E3CB5D9
P 1600 1300
F 0 "#PWR04" H 1600 1150 50  0001 C CNN
F 1 "+5V" H 1615 1473 50  0000 C CNN
F 2 "" H 1600 1300 50  0001 C CNN
F 3 "" H 1600 1300 50  0001 C CNN
	1    1600 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1300 1300 1300 1450
Wire Wire Line
	1300 1450 1600 1450
Wire Wire Line
	1600 1450 1600 1300
Wire Wire Line
	2250 1300 2250 1400
NoConn ~ 3300 2650
NoConn ~ 3800 2750
NoConn ~ 3800 2650
NoConn ~ 3800 2550
NoConn ~ 3300 2550
NoConn ~ 3800 1550
NoConn ~ 3800 1650
NoConn ~ 3800 1750
NoConn ~ 3800 1850
NoConn ~ 3300 1850
NoConn ~ 3300 1750
NoConn ~ 3300 1650
NoConn ~ 3300 1550
NoConn ~ 3300 1250
NoConn ~ 3800 1250
NoConn ~ 3800 2350
Text Label 3800 3050 0    50   ~ 0
reset
$Comp
L Device:CP C2
U 1 1 5F4D8A65
P 2250 2600
F 0 "C2" H 2368 2646 50  0000 L CNN
F 1 "10uF" H 2368 2555 50  0000 L CNN
F 2 "" H 2288 2450 50  0001 C CNN
F 3 "~" H 2250 2600 50  0001 C CNN
	1    2250 2600
	1    0    0    -1  
$EndComp
Connection ~ 2250 2450
Connection ~ 2250 2750
$Comp
L preTTY-rescue:Arduino_Nano_v3.x-MCU_Module-USARTv2-rescue A1
U 1 1 60CCDAA2
P 1500 4550
F 0 "A1" H 950 5750 50  0000 C CNN
F 1 "Arduino_Nano_v3.x" H 950 5650 50  0000 C CNN
F 2 "Module:Arduino_Nano" H 1500 4550 50  0001 C CIN
F 3 "http://www.mouser.com/pdfdocs/Gravitech_Arduino_Nano3_0.pdf" H 1500 4550 50  0001 C CNN
	1    1500 4550
	1    0    0    -1  
$EndComp
Text Label 1000 4150 2    50   ~ 0
d00
Text Label 1000 4250 2    50   ~ 0
d01
Text Label 1000 4350 2    50   ~ 0
d02
Text Label 1000 4450 2    50   ~ 0
d03
Text Label 1000 4550 2    50   ~ 0
d04
Text Label 1000 4650 2    50   ~ 0
d05
Text Label 1000 4750 2    50   ~ 0
d06
Text Label 1000 4850 2    50   ~ 0
d07
Wire Wire Line
	1600 5550 1500 5550
Wire Wire Line
	2000 3950 2000 4050
NoConn ~ 1400 3550
NoConn ~ 1600 3550
$Comp
L power:GND #PWR03
U 1 1 60CEFC17
P 1500 5650
F 0 "#PWR03" H 1500 5400 50  0001 C CNN
F 1 "GND" H 1505 5477 50  0000 C CNN
F 2 "" H 1500 5650 50  0001 C CNN
F 3 "" H 1500 5650 50  0001 C CNN
	1    1500 5650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR05
U 1 1 60CF1BC7
P 1700 3450
F 0 "#PWR05" H 1700 3300 50  0001 C CNN
F 1 "+5V" H 1715 3623 50  0000 C CNN
F 2 "" H 1700 3450 50  0001 C CNN
F 3 "" H 1700 3450 50  0001 C CNN
	1    1700 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	1700 3450 1700 3550
Wire Wire Line
	1500 5650 1500 5550
Connection ~ 1500 5550
Wire Wire Line
	2000 3950 2100 3950
Connection ~ 2000 3950
Text Label 2100 3950 0    50   ~ 0
reset
NoConn ~ 3300 2750
NoConn ~ 3300 3050
NoConn ~ 2000 5150
NoConn ~ 2000 5250
NoConn ~ 2000 4350
NoConn ~ 1000 5250
Text Label 2000 4550 0    50   ~ 0
a04
Text Label 2000 4650 0    50   ~ 0
a05
Text Label 2000 4750 0    50   ~ 0
a06
Text Label 2000 4850 0    50   ~ 0
a07
Text Label 2000 4950 0    50   ~ 0
iorq
$Comp
L 74xx:74LS07 U1
U 5 1 60DCCFC5
P 6000 7400
F 0 "U1" H 6000 7717 50  0000 C CNN
F 1 "74LS07" H 6000 7626 50  0000 C CNN
F 2 "" H 6000 7400 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 6000 7400 50  0001 C CNN
	5    6000 7400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS07 U1
U 6 1 60DCDD77
P 4800 7400
F 0 "U1" H 4800 7717 50  0000 C CNN
F 1 "74LS07" H 4800 7626 50  0000 C CNN
F 2 "" H 4800 7400 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 4800 7400 50  0001 C CNN
	6    4800 7400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS07 U1
U 7 1 60DCED10
P 1400 6850
F 0 "U1" H 1630 6896 50  0000 L CNN
F 1 "74LS07" H 1630 6805 50  0000 L CNN
F 2 "" H 1400 6850 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 1400 6850 50  0001 C CNN
	7    1400 6850
	1    0    0    -1  
$EndComp
NoConn ~ 6300 7400
NoConn ~ 5100 7400
$Comp
L power:GND #PWR022
U 1 1 60DDB74D
P 5700 7400
F 0 "#PWR022" H 5700 7150 50  0001 C CNN
F 1 "GND" V 5705 7272 50  0000 R CNN
F 2 "" H 5700 7400 50  0001 C CNN
F 3 "" H 5700 7400 50  0001 C CNN
	1    5700 7400
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR021
U 1 1 60DDC6F2
P 4500 7400
F 0 "#PWR021" H 4500 7150 50  0001 C CNN
F 1 "GND" V 4505 7272 50  0000 R CNN
F 2 "" H 4500 7400 50  0001 C CNN
F 3 "" H 4500 7400 50  0001 C CNN
	1    4500 7400
	0    1    1    0   
$EndComp
$Comp
L Connector:DB9_Male_MountingHoles J6
U 1 1 60DDD781
P 10050 4100
F 0 "J6" H 10230 4102 50  0000 L CNN
F 1 "DB9" H 10230 4011 50  0000 L CNN
F 2 "" H 10050 4100 50  0001 C CNN
F 3 " ~" H 10050 4100 50  0001 C CNN
	1    10050 4100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 60DF25B1
P 1400 7350
F 0 "#PWR02" H 1400 7100 50  0001 C CNN
F 1 "GND" H 1405 7177 50  0000 C CNN
F 2 "" H 1400 7350 50  0001 C CNN
F 3 "" H 1400 7350 50  0001 C CNN
	1    1400 7350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR01
U 1 1 60DF2FD4
P 1400 6350
F 0 "#PWR01" H 1400 6200 50  0001 C CNN
F 1 "+5V" H 1415 6523 50  0000 C CNN
F 2 "" H 1400 6350 50  0001 C CNN
F 3 "" H 1400 6350 50  0001 C CNN
	1    1400 6350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 60DF4FE2
P 2200 6900
F 0 "C1" H 2315 6946 50  0000 L CNN
F 1 "10nF" H 2315 6855 50  0000 L CNN
F 2 "" H 2238 6750 50  0001 C CNN
F 3 "~" H 2200 6900 50  0001 C CNN
	1    2200 6900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 60DF5DCB
P 2600 6900
F 0 "C3" H 2715 6946 50  0000 L CNN
F 1 "10nF" H 2715 6855 50  0000 L CNN
F 2 "" H 2638 6750 50  0001 C CNN
F 3 "~" H 2600 6900 50  0001 C CNN
	1    2600 6900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 60DF65E4
P 3000 6900
F 0 "C4" H 3115 6946 50  0000 L CNN
F 1 "10nF" H 3115 6855 50  0000 L CNN
F 2 "" H 3038 6750 50  0001 C CNN
F 3 "~" H 3000 6900 50  0001 C CNN
	1    3000 6900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR07
U 1 1 60DF7483
P 2200 7050
F 0 "#PWR07" H 2200 6800 50  0001 C CNN
F 1 "GND" H 2205 6877 50  0000 C CNN
F 2 "" H 2200 7050 50  0001 C CNN
F 3 "" H 2200 7050 50  0001 C CNN
	1    2200 7050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 60DF7D3F
P 2600 7050
F 0 "#PWR012" H 2600 6800 50  0001 C CNN
F 1 "GND" H 2605 6877 50  0000 C CNN
F 2 "" H 2600 7050 50  0001 C CNN
F 3 "" H 2600 7050 50  0001 C CNN
	1    2600 7050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR014
U 1 1 60DF8B94
P 3000 7050
F 0 "#PWR014" H 3000 6800 50  0001 C CNN
F 1 "GND" H 3005 6877 50  0000 C CNN
F 2 "" H 3000 7050 50  0001 C CNN
F 3 "" H 3000 7050 50  0001 C CNN
	1    3000 7050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR06
U 1 1 60DF949A
P 2200 6750
F 0 "#PWR06" H 2200 6600 50  0001 C CNN
F 1 "+5V" H 2215 6923 50  0000 C CNN
F 2 "" H 2200 6750 50  0001 C CNN
F 3 "" H 2200 6750 50  0001 C CNN
	1    2200 6750
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR011
U 1 1 60DF9D1A
P 2600 6750
F 0 "#PWR011" H 2600 6600 50  0001 C CNN
F 1 "+5V" H 2615 6923 50  0000 C CNN
F 2 "" H 2600 6750 50  0001 C CNN
F 3 "" H 2600 6750 50  0001 C CNN
	1    2600 6750
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR013
U 1 1 60DFA516
P 3000 6750
F 0 "#PWR013" H 3000 6600 50  0001 C CNN
F 1 "+5V" H 3015 6923 50  0000 C CNN
F 2 "" H 3000 6750 50  0001 C CNN
F 3 "" H 3000 6750 50  0001 C CNN
	1    3000 6750
	1    0    0    -1  
$EndComp
$Comp
L preTTY-rescue:ATmega328P-PU-MCU_Microchip_ATmega U2
U 1 1 60DFBC7C
P 4500 4900
F 0 "U2" H 5200 6450 50  0000 R CNN
F 1 "ATmega328P-PU" H 5450 6350 50  0000 R CNN
F 2 "Package_DIP:DIP-28_W7.62mm" H 4500 4900 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/ATmega328_P%20AVR%20MCU%20with%20picoPower%20Technology%20Data%20Sheet%2040001984A.pdf" H 4500 4900 50  0001 C CNN
	1    4500 4900
	-1   0    0    -1  
$EndComp
$Comp
L Interface_UART:MAX232 U3
U 1 1 60DC8936
P 7500 4650
F 0 "U3" H 7050 5850 50  0000 C CNN
F 1 "MAX232" H 7050 5750 50  0000 C CNN
F 2 "" H 7550 3600 50  0001 L CNN
F 3 "http://www.ti.com/lit/ds/symlink/max232.pdf" H 7500 4750 50  0001 C CNN
	1    7500 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 2400 8200 2400
Wire Wire Line
	7650 1700 8200 1700
$Comp
L 74xx:74LS07 U1
U 1 1 60DC689C
P 7900 1350
F 0 "U1" H 7900 1667 50  0000 C CNN
F 1 "74LS07" H 7900 1576 50  0000 C CNN
F 2 "" H 7900 1350 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 7900 1350 50  0001 C CNN
	1    7900 1350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS07 U1
U 3 1 60DCA060
P 7900 2050
F 0 "U1" H 7900 2367 50  0000 C CNN
F 1 "74LS07" H 7900 2276 50  0000 C CNN
F 2 "" H 7900 2050 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 7900 2050 50  0001 C CNN
	3    7900 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 2050 8800 2050
$Comp
L power:+5V #PWR025
U 1 1 60DD9472
P 9250 1350
F 0 "#PWR025" H 9250 1200 50  0001 C CNN
F 1 "+5V" V 9265 1478 50  0000 L CNN
F 2 "" H 9250 1350 50  0001 C CNN
F 3 "" H 9250 1350 50  0001 C CNN
	1    9250 1350
	0    1    1    0   
$EndComp
Wire Wire Line
	8850 1350 8500 1350
Wire Wire Line
	8750 1700 8500 1700
Wire Wire Line
	8750 1450 8750 1700
Wire Wire Line
	8850 1450 8750 1450
Wire Wire Line
	8800 1550 8800 2050
Wire Wire Line
	8850 1550 8800 1550
Wire Wire Line
	8850 2400 8500 2400
Wire Wire Line
	8850 1650 8850 2400
$Comp
L Device:R_Network04 RN1
U 1 1 60DD2A34
P 9050 1550
F 0 "RN1" V 8633 1550 50  0000 C CNN
F 1 "4x220" V 8724 1550 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP5" V 9325 1550 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 9050 1550 50  0001 C CNN
	1    9050 1550
	0    1    1    0   
$EndComp
$Comp
L Device:LED D4
U 1 1 60DD1D50
P 8350 2400
F 0 "D4" H 8350 2500 50  0000 C CNN
F 1 "LED" H 8350 2300 50  0000 C CNN
F 2 "" H 8350 2400 50  0001 C CNN
F 3 "~" H 8350 2400 50  0001 C CNN
	1    8350 2400
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D3
U 1 1 60DD1065
P 8350 2050
F 0 "D3" H 8350 2150 50  0000 C CNN
F 1 "LED" H 8350 1950 50  0000 C CNN
F 2 "" H 8350 2050 50  0001 C CNN
F 3 "~" H 8350 2050 50  0001 C CNN
	1    8350 2050
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D2
U 1 1 60DD06ED
P 8350 1700
F 0 "D2" H 8350 1800 50  0000 C CNN
F 1 "LED" H 8350 1600 50  0000 C CNN
F 2 "" H 8350 1700 50  0001 C CNN
F 3 "~" H 8350 1700 50  0001 C CNN
	1    8350 1700
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 60DCFD5F
P 8350 1350
F 0 "D1" H 8350 1450 50  0000 C CNN
F 1 "LED" H 8350 1250 50  0000 C CNN
F 2 "" H 8350 1350 50  0001 C CNN
F 3 "~" H 8350 1350 50  0001 C CNN
	1    8350 1350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS07 U1
U 4 1 60DCBA6B
P 7350 2400
F 0 "U1" H 7350 2717 50  0000 C CNN
F 1 "74LS07" H 7350 2626 50  0000 C CNN
F 2 "" H 7350 2400 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 7350 2400 50  0001 C CNN
	4    7350 2400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS07 U1
U 2 1 60DC8AA1
P 7350 1700
F 0 "U1" H 7350 2017 50  0000 C CNN
F 1 "74LS07" H 7350 1926 50  0000 C CNN
F 2 "" H 7350 1700 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 7350 1700 50  0001 C CNN
	2    7350 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	9750 4200 9700 4200
Wire Wire Line
	9700 4200 9700 4000
Wire Wire Line
	9700 4000 9750 4000
Wire Wire Line
	9750 3900 9650 3900
Wire Wire Line
	9650 3900 9650 4400
Wire Wire Line
	9650 4500 9750 4500
Wire Wire Line
	9750 4400 9650 4400
Connection ~ 9650 4400
Wire Wire Line
	9650 4400 9650 4500
NoConn ~ 9750 3800
$Comp
L power:GND #PWR028
U 1 1 60DF388E
P 9750 3700
F 0 "#PWR028" H 9750 3450 50  0001 C CNN
F 1 "GND" V 9755 3572 50  0000 R CNN
F 2 "" H 9750 3700 50  0001 C CNN
F 3 "" H 9750 3700 50  0001 C CNN
	1    9750 3700
	0    1    1    0   
$EndComp
NoConn ~ 10050 4700
$Comp
L Device:CP C11
U 1 1 60E02E04
P 8450 4550
F 0 "C11" V 8500 4700 50  0000 C CNN
F 1 "1uF" V 8600 4700 50  0000 C CNN
F 2 "" H 8488 4400 50  0001 C CNN
F 3 "~" H 8450 4550 50  0001 C CNN
	1    8450 4550
	0    1    1    0   
$EndComp
$Comp
L Device:CP C8
U 1 1 60E08ED4
P 6700 3900
F 0 "C8" H 6500 3900 50  0000 L CNN
F 1 "1uF" H 6450 3800 50  0000 L CNN
F 2 "" H 6738 3750 50  0001 C CNN
F 3 "~" H 6700 3900 50  0001 C CNN
	1    6700 3900
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C9
U 1 1 60E09EFE
P 8300 3900
F 0 "C9" H 8400 4100 50  0000 L CNN
F 1 "1uF" H 8350 4000 50  0000 L CNN
F 2 "" H 8338 3750 50  0001 C CNN
F 3 "~" H 8300 3900 50  0001 C CNN
	1    8300 3900
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C10
U 1 1 60E0ADDC
P 8450 4250
F 0 "C10" V 8600 4100 50  0000 C CNN
F 1 "1uF" V 8500 4100 50  0000 C CNN
F 2 "" H 8488 4100 50  0001 C CNN
F 3 "~" H 8450 4250 50  0001 C CNN
	1    8450 4250
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR027
U 1 1 60E1AA77
P 8600 4550
F 0 "#PWR027" H 8600 4300 50  0001 C CNN
F 1 "GND" V 8605 4422 50  0000 R CNN
F 2 "" H 8600 4550 50  0001 C CNN
F 3 "" H 8600 4550 50  0001 C CNN
	1    8600 4550
	0    -1   -1   0   
$EndComp
$Comp
L power:+5V #PWR023
U 1 1 60E1D811
P 7500 3450
F 0 "#PWR023" H 7500 3300 50  0001 C CNN
F 1 "+5V" H 7500 3600 50  0000 C CNN
F 2 "" H 7500 3450 50  0001 C CNN
F 3 "" H 7500 3450 50  0001 C CNN
	1    7500 3450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR026
U 1 1 60E1EAA5
P 8600 4250
F 0 "#PWR026" H 8600 4100 50  0001 C CNN
F 1 "+5V" V 8615 4378 50  0000 L CNN
F 2 "" H 8600 4250 50  0001 C CNN
F 3 "" H 8600 4250 50  0001 C CNN
	1    8600 4250
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR024
U 1 1 60E20711
P 7500 5850
F 0 "#PWR024" H 7500 5600 50  0001 C CNN
F 1 "GND" H 7505 5677 50  0000 C CNN
F 2 "" H 7500 5850 50  0001 C CNN
F 3 "" H 7500 5850 50  0001 C CNN
	1    7500 5850
	1    0    0    -1  
$EndComp
Wire Wire Line
	9750 4100 9000 4100
Wire Wire Line
	9000 4100 9000 4750
Wire Wire Line
	9000 4750 8300 4750
Wire Wire Line
	9150 4300 9150 5150
Wire Wire Line
	9150 5150 8300 5150
Wire Wire Line
	9150 4300 9750 4300
Wire Wire Line
	8300 4950 9000 4950
Wire Wire Line
	8300 5350 8850 5350
Text Label 6700 4750 2    50   ~ 0
TX0
Text Label 6700 4950 2    50   ~ 0
TX1
Text Label 6700 5150 2    50   ~ 0
RX0RS232
Text Label 6700 5350 2    50   ~ 0
RX1RS232
Text Notes 8600 1350 2    50   ~ 0
TX0
Text Notes 8600 1700 2    50   ~ 0
RX0
Text Notes 8600 2050 2    50   ~ 0
TX1
Text Notes 8600 2400 2    50   ~ 0
RX1
Text Label 7600 1350 2    50   ~ 0
TX0
Text Label 7600 2050 2    50   ~ 0
TX1
Text Label 7050 1700 2    50   ~ 0
RX0
Text Label 7050 2400 2    50   ~ 0
RX1
$Comp
L Device:CP C7
U 1 1 60E8B5C2
P 3400 6900
F 0 "C7" H 3500 6950 50  0000 L CNN
F 1 "1uF" H 3500 6850 50  0000 L CNN
F 2 "" H 3438 6750 50  0001 C CNN
F 3 "~" H 3400 6900 50  0001 C CNN
	1    3400 6900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR016
U 1 1 60E8DB35
P 3400 6750
F 0 "#PWR016" H 3400 6600 50  0001 C CNN
F 1 "+5V" H 3415 6923 50  0000 C CNN
F 2 "" H 3400 6750 50  0001 C CNN
F 3 "" H 3400 6750 50  0001 C CNN
	1    3400 6750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR017
U 1 1 60E8E4E5
P 3400 7050
F 0 "#PWR017" H 3400 6800 50  0001 C CNN
F 1 "GND" H 3405 6877 50  0000 C CNN
F 2 "" H 3400 7050 50  0001 C CNN
F 3 "" H 3400 7050 50  0001 C CNN
	1    3400 7050
	1    0    0    -1  
$EndComp
Text Label 1000 5150 2    50   ~ 0
wr
Text Label 1000 5050 2    50   ~ 0
rd
Text Label 1000 4950 2    50   ~ 0
a01
Text Label 2000 5050 0    50   ~ 0
a00
Text Label 1000 4050 2    50   ~ 0
TX0
Text Label 3900 5200 2    50   ~ 0
reset
$Comp
L Device:Crystal Y1
U 1 1 60E080E5
P 3500 4350
F 0 "Y1" V 3150 4350 50  0000 C CNN
F 1 "16MHz" V 3250 4350 50  0000 C CNN
F 2 "" H 3500 4350 50  0001 C CNN
F 3 "~" H 3500 4350 50  0001 C CNN
	1    3500 4350
	0    1    1    0   
$EndComp
$Comp
L Device:C C6
U 1 1 60E09257
P 3250 4500
F 0 "C6" V 3400 4500 50  0000 C CNN
F 1 "22pF" V 3500 4550 50  0000 C CNN
F 2 "" H 3288 4350 50  0001 C CNN
F 3 "~" H 3250 4500 50  0001 C CNN
	1    3250 4500
	0    1    1    0   
$EndComp
$Comp
L Device:C C5
U 1 1 60E0A1F0
P 3250 4200
F 0 "C5" V 3000 4150 50  0000 L CNN
F 1 "22pF" V 3100 4100 50  0000 L CNN
F 2 "" H 3288 4050 50  0001 C CNN
F 3 "~" H 3250 4200 50  0001 C CNN
	1    3250 4200
	0    1    1    0   
$EndComp
Wire Wire Line
	3900 4300 3700 4300
Wire Wire Line
	3700 4300 3700 4200
Wire Wire Line
	3900 4400 3700 4400
Wire Wire Line
	3700 4400 3700 4500
Wire Wire Line
	3500 4200 3700 4200
Wire Wire Line
	3500 4500 3700 4500
Wire Wire Line
	3400 4200 3500 4200
Connection ~ 3500 4200
Wire Wire Line
	3400 4500 3500 4500
Connection ~ 3500 4500
Wire Wire Line
	3100 4200 3100 4500
Wire Wire Line
	3100 4500 3100 4600
Connection ~ 3100 4500
$Comp
L power:GND #PWR015
U 1 1 60E24A3F
P 3100 4600
F 0 "#PWR015" H 3100 4350 50  0001 C CNN
F 1 "GND" H 3105 4427 50  0000 C CNN
F 2 "" H 3100 4600 50  0001 C CNN
F 3 "" H 3100 4600 50  0001 C CNN
	1    3100 4600
	1    0    0    -1  
$EndComp
Text Label 3900 5500 2    50   ~ 0
TX1
Text Label 3900 5600 2    50   ~ 0
d00
Text Label 3900 5800 2    50   ~ 0
d02
Text Label 3900 5900 2    50   ~ 0
d03
Text Label 3900 6000 2    50   ~ 0
d04
Text Label 3900 6100 2    50   ~ 0
d05
Text Label 3900 3700 2    50   ~ 0
d06
Text Label 3900 3800 2    50   ~ 0
d07
Text Label 3900 3900 2    50   ~ 0
a01
Text Label 3900 4000 2    50   ~ 0
rd
Text Label 3900 4100 2    50   ~ 0
wr
NoConn ~ 3900 4200
Text Label 3900 4600 2    50   ~ 0
a04
Text Label 3900 4700 2    50   ~ 0
a05
Text Label 3900 4800 2    50   ~ 0
a06
Text Label 3900 4900 2    50   ~ 0
a07
Text Label 3900 5000 2    50   ~ 0
iorq
NoConn ~ 3900 5100
NoConn ~ 5100 3700
$Comp
L power:GND #PWR020
U 1 1 60E378A9
P 4500 6400
F 0 "#PWR020" H 4500 6150 50  0001 C CNN
F 1 "GND" H 4505 6227 50  0000 C CNN
F 2 "" H 4500 6400 50  0001 C CNN
F 3 "" H 4500 6400 50  0001 C CNN
	1    4500 6400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR019
U 1 1 60E385F3
P 4500 3400
F 0 "#PWR019" H 4500 3250 50  0001 C CNN
F 1 "+5V" H 4515 3573 50  0000 C CNN
F 2 "" H 4500 3400 50  0001 C CNN
F 3 "" H 4500 3400 50  0001 C CNN
	1    4500 3400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR018
U 1 1 60E391DA
P 4400 3400
F 0 "#PWR018" H 4400 3250 50  0001 C CNN
F 1 "+5V" H 4415 3573 50  0000 C CNN
F 2 "" H 4400 3400 50  0001 C CNN
F 3 "" H 4400 3400 50  0001 C CNN
	1    4400 3400
	1    0    0    -1  
$EndComp
Text Label 3900 5700 2    50   ~ 0
d01
$Comp
L Connector_Generic:Conn_02x02_Odd_Even J4
U 1 1 60E49EAC
P 9950 3100
F 0 "J4" H 10000 3317 50  0000 C CNN
F 1 "PORT0 TTL" H 10000 3226 50  0000 C CNN
F 2 "" H 9950 3100 50  0001 C CNN
F 3 "~" H 9950 3100 50  0001 C CNN
	1    9950 3100
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR029
U 1 1 60E4C2E7
P 10250 3100
F 0 "#PWR029" H 10250 2950 50  0001 C CNN
F 1 "+5V" V 10265 3228 50  0000 L CNN
F 2 "" H 10250 3100 50  0001 C CNN
F 3 "" H 10250 3100 50  0001 C CNN
	1    10250 3100
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR031
U 1 1 60E4E1C5
P 10250 5350
F 0 "#PWR031" H 10250 5200 50  0001 C CNN
F 1 "+5V" V 10265 5478 50  0000 L CNN
F 2 "" H 10250 5350 50  0001 C CNN
F 3 "" H 10250 5350 50  0001 C CNN
	1    10250 5350
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR030
U 1 1 60E507E3
P 10250 3200
F 0 "#PWR030" H 10250 2950 50  0001 C CNN
F 1 "GND" V 10255 3072 50  0000 R CNN
F 2 "" H 10250 3200 50  0001 C CNN
F 3 "" H 10250 3200 50  0001 C CNN
	1    10250 3200
	0    -1   -1   0   
$EndComp
Text Label 9750 3100 2    50   ~ 0
TX0
Text Label 9750 5350 2    50   ~ 0
TX1
Text Label 9750 3200 2    50   ~ 0
RX0TTL
Text Label 9750 5450 2    50   ~ 0
RX1TTL
$Comp
L Connector_Generic:Conn_02x03_Odd_Even J3
U 1 1 60E59D18
P 5400 1850
F 0 "J3" H 5450 2167 50  0000 C CNN
F 1 "TTL/RS232" H 5450 2076 50  0000 C CNN
F 2 "" H 5400 1850 50  0001 C CNN
F 3 "~" H 5400 1850 50  0001 C CNN
	1    5400 1850
	1    0    0    -1  
$EndComp
Text Label 5200 1750 2    50   ~ 0
RX0TTL
Text Label 5200 1850 2    50   ~ 0
RX0
Text Label 5200 1950 2    50   ~ 0
RX0RS232
Text Label 5700 1750 0    50   ~ 0
RX1TTL
Text Label 5700 1850 0    50   ~ 0
RX1
Text Label 5700 1950 0    50   ~ 0
RX1RS232
Text Label 1000 3950 2    50   ~ 0
RX0
Text Label 3900 5400 2    50   ~ 0
RX1
$Comp
L Connector_Generic:Conn_02x04_Odd_Even J5
U 1 1 60E7843F
P 9950 5450
F 0 "J5" H 10000 5767 50  0000 C CNN
F 1 "PORT1 TTL/RS232" H 10000 5676 50  0000 C CNN
F 2 "" H 9950 5450 50  0001 C CNN
F 3 "~" H 9950 5450 50  0001 C CNN
	1    9950 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9000 4950 9000 5550
Wire Wire Line
	8850 5350 8850 5650
Wire Wire Line
	10250 5450 10250 5550
Wire Wire Line
	10250 5550 10250 5650
Connection ~ 10250 5550
$Comp
L power:GND #PWR032
U 1 1 60E82357
P 10250 5800
F 0 "#PWR032" H 10250 5550 50  0001 C CNN
F 1 "GND" H 10255 5627 50  0000 C CNN
F 2 "" H 10250 5800 50  0001 C CNN
F 3 "" H 10250 5800 50  0001 C CNN
	1    10250 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	10250 5800 10250 5650
Connection ~ 10250 5650
Wire Wire Line
	9000 5550 9750 5550
Wire Wire Line
	8850 5650 9750 5650
$EndSCHEMATC