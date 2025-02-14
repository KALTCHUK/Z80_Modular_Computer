EESchema Schematic File Version 4
LIBS:MEM-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Memory Card for Z80 Modular Computer"
Date ""
Rev ""
Comp ""
Comment1 "Also RAM bank (0 or 1) can be selected by hardware or software."
Comment2 "CPU can disable ROM and work with full 64KB RAM, allowing bootstrap for CP/M."
Comment3 "User can select which 16KB block of ROM will be used via jumpers (blocks 0, 1, 2 or 3)."
Comment4 "During initialization, bottom 16KB are ROM and the remaining 48KB are RAM."
$EndDescr
$Comp
L Connector_Generic:Conn_02x05_Odd_Even J2
U 1 1 5DE110BD
P 1700 2400
F 0 "J2" H 1750 2817 50  0000 C CNN
F 1 "Power Bus" H 1750 2726 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x05_P2.54mm_Vertical" H 1700 2400 50  0001 C CNN
F 3 "~" H 1700 2400 50  0001 C CNN
	1    1700 2400
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J3
U 1 1 5DE11A6D
P 3850 1900
F 0 "J3" H 3900 3017 50  0000 C CNN
F 1 "Signal Bus" H 3900 2926 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x20_P2.54mm_Vertical" H 3850 1900 50  0001 C CNN
F 3 "~" H 3850 1900 50  0001 C CNN
	1    3850 1900
	1    0    0    -1  
$EndComp
Text Label 2000 2200 0    50   ~ 0
gnd
Text Label 2000 2300 0    50   ~ 0
+5V
Text Label 2000 2400 0    50   ~ 0
+12V
Text Label 2000 2500 0    50   ~ 0
v1
Text Label 2000 2600 0    50   ~ 0
gnd
Text Label 1500 2200 2    50   ~ 0
gnd
Text Label 1500 2300 2    50   ~ 0
+5V
Text Label 1500 2400 2    50   ~ 0
+12V
Text Label 1500 2500 2    50   ~ 0
v1
Text Label 1500 2600 2    50   ~ 0
gnd
Text Label 3650 1000 2    50   ~ 0
a01
Text Label 3650 1100 2    50   ~ 0
a03
Text Label 3650 1200 2    50   ~ 0
a05
Text Label 3650 1300 2    50   ~ 0
a07
Text Label 3650 1400 2    50   ~ 0
a09
Text Label 3650 1500 2    50   ~ 0
a11
Text Label 3650 1600 2    50   ~ 0
a13
Text Label 3650 1700 2    50   ~ 0
a15
Text Label 3650 1800 2    50   ~ 0
d01
Text Label 3650 1900 2    50   ~ 0
d03
Text Label 3650 2000 2    50   ~ 0
d05
Text Label 3650 2100 2    50   ~ 0
d07
Text Label 3650 2200 2    50   ~ 0
wr
Text Label 3650 2300 2    50   ~ 0
rd
Text Label 3650 2400 2    50   ~ 0
busack
Text Label 3650 2500 2    50   ~ 0
halt
Text Label 3650 2600 2    50   ~ 0
int
Text Label 3650 2700 2    50   ~ 0
s1
Text Label 3650 2800 2    50   ~ 0
m1
Text Label 3650 2900 2    50   ~ 0
clk
Text Label 4150 1000 0    50   ~ 0
a00
Text Label 4150 1100 0    50   ~ 0
a02
Text Label 4150 1200 0    50   ~ 0
a04
Text Label 4150 1300 0    50   ~ 0
a06
Text Label 4150 1400 0    50   ~ 0
a08
Text Label 4150 1500 0    50   ~ 0
a10
Text Label 4150 1600 0    50   ~ 0
a12
Text Label 4150 1700 0    50   ~ 0
a14
Text Label 4150 1800 0    50   ~ 0
d00
Text Label 4150 1900 0    50   ~ 0
d02
Text Label 4150 2000 0    50   ~ 0
d04
Text Label 4150 2100 0    50   ~ 0
d06
Text Label 4150 2200 0    50   ~ 0
mreq
Text Label 4150 2300 0    50   ~ 0
iorq
Text Label 4150 2400 0    50   ~ 0
busrq
Text Label 4150 2500 0    50   ~ 0
wait
Text Label 4150 2600 0    50   ~ 0
nmi
Text Label 4150 2700 0    50   ~ 0
s0
Text Label 4150 2800 0    50   ~ 0
s2
$Comp
L power:+5V #PWR09
U 1 1 5E34AA96
P 2500 2000
F 0 "#PWR09" H 2500 1850 50  0001 C CNN
F 1 "+5V" H 2515 2173 50  0000 C CNN
F 2 "" H 2500 2000 50  0001 C CNN
F 3 "" H 2500 2000 50  0001 C CNN
	1    2500 2000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR010
U 1 1 5E34BF5A
P 2500 2700
F 0 "#PWR010" H 2500 2450 50  0001 C CNN
F 1 "GND" H 2505 2527 50  0000 C CNN
F 2 "" H 2500 2700 50  0001 C CNN
F 3 "" H 2500 2700 50  0001 C CNN
	1    2500 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 2700 2500 2600
Wire Wire Line
	2500 2600 2000 2600
Wire Wire Line
	2500 2000 2500 2300
Wire Wire Line
	2500 2300 2000 2300
NoConn ~ 3650 2900
NoConn ~ 3650 2800
NoConn ~ 3650 2700
NoConn ~ 4150 2700
NoConn ~ 4150 2800
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5E3C8BDE
P 1550 1150
F 0 "#FLG01" H 1550 1225 50  0001 C CNN
F 1 "PWR_FLAG" H 1550 1323 50  0000 C CNN
F 2 "" H 1550 1150 50  0001 C CNN
F 3 "~" H 1550 1150 50  0001 C CNN
	1    1550 1150
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5E3C9F2A
P 2500 1150
F 0 "#FLG02" H 2500 1225 50  0001 C CNN
F 1 "PWR_FLAG" H 2500 1323 50  0000 C CNN
F 2 "" H 2500 1150 50  0001 C CNN
F 3 "~" H 2500 1150 50  0001 C CNN
	1    2500 1150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR08
U 1 1 5E3CA8BD
P 2500 1250
F 0 "#PWR08" H 2500 1000 50  0001 C CNN
F 1 "GND" H 2505 1077 50  0000 C CNN
F 2 "" H 2500 1250 50  0001 C CNN
F 3 "" H 2500 1250 50  0001 C CNN
	1    2500 1250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR07
U 1 1 5E3CB5D9
P 1850 1150
F 0 "#PWR07" H 1850 1000 50  0001 C CNN
F 1 "+5V" H 1865 1323 50  0000 C CNN
F 2 "" H 1850 1150 50  0001 C CNN
F 3 "" H 1850 1150 50  0001 C CNN
	1    1850 1150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 1150 1550 1300
Wire Wire Line
	1550 1300 1850 1300
Wire Wire Line
	1850 1300 1850 1150
Wire Wire Line
	2500 1150 2500 1250
$Comp
L Memory_EPROM:27C512 U7
U 1 1 5E35B5E0
P 10400 2150
F 0 "U7" H 10050 3350 50  0000 C CNN
F 1 "W27C512" H 10050 3250 50  0000 C CNN
F 2 "Socket:DIP_Socket-28_W11.9_W12.7_W15.24_W17.78_W18.5_3M_228-1277-00-0602J" H 10400 2150 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0015.pdf" H 10400 2150 50  0001 C CNN
	1    10400 2150
	1    0    0    -1  
$EndComp
$Comp
L Memory_RAM:628128_DIP32_SSOP32 U6
U 1 1 5E35B99A
P 7050 2150
F 0 "U6" H 6650 3250 50  0000 C CNN
F 1 "628128" H 6650 3150 50  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm_Socket_LongPads" H 7050 2150 50  0001 C CNN
F 3 "http://www.futurlec.com/Datasheet/Memory/628128.pdf" H 7050 2150 50  0001 C CNN
	1    7050 2150
	1    0    0    -1  
$EndComp
Text Label 10800 1250 0    50   ~ 0
d00
Text Label 10800 1350 0    50   ~ 0
d01
Text Label 10800 1450 0    50   ~ 0
d02
Text Label 10800 1550 0    50   ~ 0
d03
Text Label 10800 1650 0    50   ~ 0
d04
Text Label 10800 1750 0    50   ~ 0
d05
Text Label 10800 1850 0    50   ~ 0
d06
Text Label 10800 1950 0    50   ~ 0
d07
Text Label 7550 1350 0    50   ~ 0
d00
Text Label 7550 1450 0    50   ~ 0
d01
Text Label 7550 1550 0    50   ~ 0
d02
Text Label 7550 1650 0    50   ~ 0
d03
Text Label 7550 1750 0    50   ~ 0
d04
Text Label 7550 1850 0    50   ~ 0
d05
Text Label 7550 1950 0    50   ~ 0
d06
Text Label 7550 2050 0    50   ~ 0
d07
Text Label 10000 1250 2    50   ~ 0
a00
Text Label 10000 1350 2    50   ~ 0
a01
Text Label 10000 1450 2    50   ~ 0
a02
Text Label 10000 1550 2    50   ~ 0
a03
Text Label 10000 1650 2    50   ~ 0
a04
Text Label 10000 1750 2    50   ~ 0
a05
Text Label 10000 1850 2    50   ~ 0
a06
Text Label 10000 1950 2    50   ~ 0
a07
Text Label 10000 2050 2    50   ~ 0
a08
Text Label 10000 2150 2    50   ~ 0
a09
Text Label 10000 2250 2    50   ~ 0
a10
Text Label 10000 2350 2    50   ~ 0
a11
Text Label 10000 2450 2    50   ~ 0
a12
Text Label 10000 2550 2    50   ~ 0
a13
Text Label 6550 1350 2    50   ~ 0
a00
Text Label 6550 1450 2    50   ~ 0
a01
Text Label 6550 1550 2    50   ~ 0
a02
Text Label 6550 1650 2    50   ~ 0
a03
Text Label 6550 1750 2    50   ~ 0
a04
Text Label 6550 1850 2    50   ~ 0
a05
Text Label 6550 1950 2    50   ~ 0
a06
Text Label 6550 2050 2    50   ~ 0
a07
Text Label 6550 2150 2    50   ~ 0
a08
Text Label 6550 2250 2    50   ~ 0
a09
Text Label 6550 2350 2    50   ~ 0
a10
Text Label 6550 2450 2    50   ~ 0
a11
Text Label 6550 2550 2    50   ~ 0
a12
Text Label 6550 2650 2    50   ~ 0
a13
Text Label 6550 2750 2    50   ~ 0
a14
Text Label 6550 2850 2    50   ~ 0
a15
$Comp
L power:+5V #PWR042
U 1 1 5E363E91
P 7550 2350
F 0 "#PWR042" H 7550 2200 50  0001 C CNN
F 1 "+5V" V 7565 2478 50  0000 L CNN
F 2 "" H 7550 2350 50  0001 C CNN
F 3 "" H 7550 2350 50  0001 C CNN
	1    7550 2350
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR045
U 1 1 5E3651CC
P 10400 1050
F 0 "#PWR045" H 10400 900 50  0001 C CNN
F 1 "+5V" H 10415 1223 50  0000 C CNN
F 2 "" H 10400 1050 50  0001 C CNN
F 3 "" H 10400 1050 50  0001 C CNN
	1    10400 1050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR040
U 1 1 5E365899
P 7050 1150
F 0 "#PWR040" H 7050 1000 50  0001 C CNN
F 1 "+5V" H 7065 1323 50  0000 C CNN
F 2 "" H 7050 1150 50  0001 C CNN
F 3 "" H 7050 1150 50  0001 C CNN
	1    7050 1150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR041
U 1 1 5E365DEB
P 7050 3150
F 0 "#PWR041" H 7050 2900 50  0001 C CNN
F 1 "GND" H 7055 2977 50  0000 C CNN
F 2 "" H 7050 3150 50  0001 C CNN
F 3 "" H 7050 3150 50  0001 C CNN
	1    7050 3150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR046
U 1 1 5E36620A
P 10400 3250
F 0 "#PWR046" H 10400 3000 50  0001 C CNN
F 1 "GND" H 10405 3077 50  0000 C CNN
F 2 "" H 10400 3250 50  0001 C CNN
F 3 "" H 10400 3250 50  0001 C CNN
	1    10400 3250
	1    0    0    -1  
$EndComp
Text Label 7550 2550 0    50   ~ 0
wr
Text Label 7550 2450 0    50   ~ 0
rd
Text Label 10000 3050 2    50   ~ 0
rd
$Comp
L 74xx:74LS74 U3
U 1 1 5E384400
P 5700 5200
F 0 "U3" H 5400 4900 50  0000 C CNN
F 1 "74LS74" H 5400 4800 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5700 5200 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 5700 5200 50  0001 C CNN
	1    5700 5200
	1    0    0    -1  
$EndComp
NoConn ~ 3650 2500
NoConn ~ 3650 2600
NoConn ~ 4150 2600
NoConn ~ 4150 2500
NoConn ~ 4150 2400
Text Notes 9950 6000 0    50   ~ 0
ROM at memory base
$Comp
L power:GND #PWR06
U 1 1 5E67707E
P 1800 7000
F 0 "#PWR06" H 1800 6750 50  0001 C CNN
F 1 "GND" H 1805 6827 50  0000 C CNN
F 2 "" H 1800 7000 50  0001 C CNN
F 3 "" H 1800 7000 50  0001 C CNN
	1    1800 7000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR05
U 1 1 5E677E2E
P 1800 6000
F 0 "#PWR05" H 1800 5850 50  0001 C CNN
F 1 "+5V" H 1815 6173 50  0000 C CNN
F 2 "" H 1800 6000 50  0001 C CNN
F 3 "" H 1800 6000 50  0001 C CNN
	1    1800 6000
	1    0    0    -1  
$EndComp
NoConn ~ 3650 2400
$Comp
L 74xx:74LS85 U4
U 1 1 5E8AE503
P 2900 4350
F 0 "U4" H 2650 5150 50  0000 C CNN
F 1 "74LS85" H 2650 5050 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm_Socket_LongPads" H 2900 4350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS85" H 2900 4350 50  0001 C CNN
	1    2900 4350
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x04_Odd_Even J1
U 1 1 5E8D5E71
P 1200 4050
F 0 "J1" H 1250 4367 50  0000 C CNN
F 1 "card addr" H 1250 4276 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x04_P2.54mm_Vertical" H 1200 4050 50  0001 C CNN
F 3 "~" H 1200 4050 50  0001 C CNN
	1    1200 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 3950 1000 4050
Wire Wire Line
	1000 4050 1000 4150
Connection ~ 1000 4050
Wire Wire Line
	1000 4150 1000 4250
Connection ~ 1000 4150
$Comp
L power:+5V #PWR013
U 1 1 5E8E97E6
P 2900 3650
F 0 "#PWR013" H 2900 3500 50  0001 C CNN
F 1 "+5V" H 2915 3823 50  0000 C CNN
F 2 "" H 2900 3650 50  0001 C CNN
F 3 "" H 2900 3650 50  0001 C CNN
	1    2900 3650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR014
U 1 1 5E8EA827
P 2900 5050
F 0 "#PWR014" H 2900 4800 50  0001 C CNN
F 1 "GND" H 2905 4877 50  0000 C CNN
F 2 "" H 2900 5050 50  0001 C CNN
F 3 "" H 2900 5050 50  0001 C CNN
	1    2900 5050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR017
U 1 1 5E8EB844
P 3800 3950
F 0 "#PWR017" H 3800 3700 50  0001 C CNN
F 1 "GND" H 3805 3777 50  0000 C CNN
F 2 "" H 3800 3950 50  0001 C CNN
F 3 "" H 3800 3950 50  0001 C CNN
	1    3800 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	3800 3950 3400 3950
Wire Wire Line
	3400 3950 3400 4050
Connection ~ 3400 3950
$Comp
L power:+5V #PWR04
U 1 1 5E914060
P 1750 3300
F 0 "#PWR04" H 1750 3150 50  0001 C CNN
F 1 "+5V" H 1765 3473 50  0000 C CNN
F 2 "" H 1750 3300 50  0001 C CNN
F 3 "" H 1750 3300 50  0001 C CNN
	1    1750 3300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR01
U 1 1 5E917E68
P 1000 4400
F 0 "#PWR01" H 1000 4150 50  0001 C CNN
F 1 "GND" H 1005 4227 50  0000 C CNN
F 2 "" H 1000 4400 50  0001 C CNN
F 3 "" H 1000 4400 50  0001 C CNN
	1    1000 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 4400 1000 4250
Connection ~ 1000 4250
Text Label 2400 4450 2    50   ~ 0
a07
Text Label 2400 4550 2    50   ~ 0
a06
Text Label 2400 4650 2    50   ~ 0
a05
Text Label 2400 4750 2    50   ~ 0
a04
Text Label 5700 5500 0    50   ~ 0
reset
Text Label 4150 2900 0    50   ~ 0
reset
NoConn ~ 3400 4550
NoConn ~ 3400 4650
$Comp
L Connector_Generic:Conn_02x02_Odd_Even J5
U 1 1 5E9CC17B
P 8750 1550
F 0 "J5" H 8800 1767 50  0000 C CNN
F 1 "ROM block" H 8800 1676 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x02_P2.54mm_Vertical" H 8750 1550 50  0001 C CNN
F 3 "~" H 8750 1550 50  0001 C CNN
	1    8750 1550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5E9CF50B
P 9400 1250
F 0 "R1" V 9500 1350 50  0000 C CNN
F 1 "10k" V 9500 1200 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 9330 1250 50  0001 C CNN
F 3 "~" H 9400 1250 50  0001 C CNN
	1    9400 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5E9CF511
P 9600 1250
F 0 "R2" V 9700 1350 50  0000 C CNN
F 1 "10k" V 9700 1200 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 9530 1250 50  0001 C CNN
F 3 "~" H 9600 1250 50  0001 C CNN
	1    9600 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	9400 1100 9400 1000
Wire Wire Line
	9400 1000 9600 1000
Wire Wire Line
	9600 1100 9600 1000
Connection ~ 9600 1000
$Comp
L power:+5V #PWR044
U 1 1 5E9CF51B
P 9600 850
F 0 "#PWR044" H 9600 700 50  0001 C CNN
F 1 "+5V" H 9615 1023 50  0000 C CNN
F 2 "" H 9600 850 50  0001 C CNN
F 3 "" H 9600 850 50  0001 C CNN
	1    9600 850 
	1    0    0    -1  
$EndComp
Wire Wire Line
	9600 850  9600 1000
Wire Wire Line
	9050 1650 9400 1650
Wire Wire Line
	9400 1650 9400 1400
$Comp
L power:GND #PWR043
U 1 1 5E9DE2CB
P 8550 1800
F 0 "#PWR043" H 8550 1550 50  0001 C CNN
F 1 "GND" H 8555 1627 50  0000 C CNN
F 2 "" H 8550 1800 50  0001 C CNN
F 3 "" H 8550 1800 50  0001 C CNN
	1    8550 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	8550 1800 8550 1650
Wire Wire Line
	8550 1650 8550 1550
Connection ~ 8550 1650
Wire Wire Line
	9400 1650 9400 2750
Wire Wire Line
	9400 2750 10000 2750
Connection ~ 9400 1650
Text Label 5400 5100 2    50   ~ 0
a00
$Comp
L power:+5V #PWR036
U 1 1 5EA9FC22
P 5700 4900
F 0 "#PWR036" H 5700 4750 50  0001 C CNN
F 1 "+5V" H 5715 5073 50  0000 C CNN
F 2 "" H 5700 4900 50  0001 C CNN
F 3 "" H 5700 4900 50  0001 C CNN
	1    5700 4900
	1    0    0    -1  
$EndComp
Text Notes 5550 4950 2    50   ~ 0
ROM\nenable\nFF
Text Label 6650 4000 2    50   ~ 0
a14
Text Label 6650 3900 2    50   ~ 0
a15
Text Label 6650 5050 2    50   ~ 0
mreq
$Comp
L power:GND #PWR039
U 1 1 5EAC5102
P 6650 4750
F 0 "#PWR039" H 6650 4500 50  0001 C CNN
F 1 "GND" V 6550 4700 50  0000 C CNN
F 2 "" H 6650 4750 50  0001 C CNN
F 3 "" H 6650 4750 50  0001 C CNN
	1    6650 4750
	0    1    1    0   
$EndComp
$Comp
L 74xx:74LS139 U1
U 2 1 5EAE1BDB
P 7150 4850
F 0 "U1" H 7150 5217 50  0000 C CNN
F 1 "74LS139" H 7150 5126 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm_Socket_LongPads" H 7150 4850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS139" H 7150 4850 50  0001 C CNN
	2    7150 4850
	1    0    0    -1  
$EndComp
NoConn ~ 7650 4000
NoConn ~ 7650 4100
NoConn ~ 7650 4200
$Comp
L 74xx:74LS139 U1
U 3 1 5EB3F131
P 1000 6500
F 0 "U1" H 1230 6546 50  0000 L CNN
F 1 "74LS139" H 1230 6455 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm_Socket_LongPads" H 1000 6500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS139" H 1000 6500 50  0001 C CNN
	3    1000 6500
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D4
U 1 1 5E4221DC
P 10000 5750
F 0 "D4" H 10000 5850 50  0000 C CNN
F 1 "LED" H 10000 5650 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm" H 10000 5750 50  0001 C CNN
F 3 "~" H 10000 5750 50  0001 C CNN
	1    10000 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D2
U 1 1 5EB98DDE
P 10000 4750
F 0 "D2" H 10000 4850 50  0000 C CNN
F 1 "LED" H 10000 4650 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm" H 10000 4750 50  0001 C CNN
F 3 "~" H 10000 4750 50  0001 C CNN
	1    10000 4750
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 5EBBE45A
P 10000 4250
F 0 "D1" H 10000 4350 50  0000 C CNN
F 1 "LED" H 10000 4150 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm" H 10000 4250 50  0001 C CNN
F 3 "~" H 10000 4250 50  0001 C CNN
	1    10000 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	9600 1400 9600 1550
Wire Wire Line
	9600 2650 10000 2650
Wire Wire Line
	9050 1550 9600 1550
Connection ~ 9600 1550
Wire Wire Line
	9600 1550 9600 2650
Wire Wire Line
	7550 2250 8150 2250
Text Notes 10100 4250 0    50   ~ 0
low\nbit
Text Notes 9200 1550 2    50   ~ 0
low\nbit
Text Notes 10100 4750 0    50   ~ 0
high\nbit
Text Notes 9250 1800 2    50   ~ 0
high\nbit
NoConn ~ 7650 5050
NoConn ~ 7650 4950
Text Notes 6950 2150 0    50   ~ 0
 RAM\n128KB
Text Notes 10300 2200 0    50   ~ 0
ROM\n64KB
$Comp
L power:GND #PWR032
U 1 1 5EA36479
P 5450 2950
F 0 "#PWR032" H 5450 2700 50  0001 C CNN
F 1 "GND" H 5455 2777 50  0000 C CNN
F 2 "" H 5450 2950 50  0001 C CNN
F 3 "" H 5450 2950 50  0001 C CNN
	1    5450 2950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS139 U1
U 1 1 5EAD758D
P 7150 4000
F 0 "U1" H 7150 4367 50  0000 C CNN
F 1 "74LS139" H 7150 4276 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm_Socket_LongPads" H 7150 4000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS139" H 7150 4000 50  0001 C CNN
	1    7150 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8150 4850 7650 4850
Wire Wire Line
	8150 2250 8150 4850
Wire Wire Line
	7650 4750 7950 4750
Wire Wire Line
	6000 5100 6250 5100
Wire Wire Line
	6250 5100 6250 4200
Wire Wire Line
	6250 4200 6650 4200
Wire Wire Line
	5400 5200 5000 5200
Wire Wire Line
	7650 3900 7800 3900
Wire Wire Line
	7800 3900 7800 4350
Wire Wire Line
	7800 4350 6400 4350
Wire Wire Line
	6400 4350 6400 4850
Wire Wire Line
	6400 4850 6650 4850
Text Notes 750  3950 0    50   ~ 0
msb
Text Notes 800  4250 0    50   ~ 0
lsb
$Comp
L 74xx:74LS74 U3
U 2 1 5EC37612
P 5700 3900
F 0 "U3" H 5450 3650 50  0000 C CNN
F 1 "74LS74" H 5450 3550 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5700 3900 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 5700 3900 50  0001 C CNN
	2    5700 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 3900 5000 3900
Wire Wire Line
	5000 3900 5000 4750
Text Label 5400 3800 2    50   ~ 0
a01
Text Label 5700 4200 0    50   ~ 0
reset
$Comp
L Connector_Generic:Conn_02x03_Odd_Even J4
U 1 1 5EC42B6B
P 5650 2850
F 0 "J4" H 5700 3167 50  0000 C CNN
F 1 "RAM bank" H 5700 3076 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x03_P2.54mm_Vertical" H 5650 2850 50  0001 C CNN
F 3 "~" H 5650 2850 50  0001 C CNN
	1    5650 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5950 2950 5950 2850
Connection ~ 5950 2950
Wire Wire Line
	5950 2850 5950 2750
Connection ~ 5950 2850
Wire Wire Line
	5950 2950 6550 2950
$Comp
L power:+5V #PWR031
U 1 1 5EC51CBA
P 5450 2550
F 0 "#PWR031" H 5450 2400 50  0001 C CNN
F 1 "+5V" H 5465 2723 50  0000 C CNN
F 2 "" H 5450 2550 50  0001 C CNN
F 3 "" H 5450 2550 50  0001 C CNN
	1    5450 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 2550 5450 2750
Wire Wire Line
	5250 2850 5450 2850
$Comp
L Device:LED D3
U 1 1 5EC5F24A
P 10000 5250
F 0 "D3" H 10000 5150 50  0000 C CNN
F 1 "LED" H 9993 5375 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm" H 10000 5250 50  0001 C CNN
F 3 "~" H 10000 5250 50  0001 C CNN
	1    10000 5250
	1    0    0    1   
$EndComp
Text Notes 5200 3650 0    50   ~ 0
RAM bank\nselect FF
NoConn ~ 6000 4000
$Comp
L power:+5V #PWR035
U 1 1 5EC7EA5C
P 5700 3600
F 0 "#PWR035" H 5700 3450 50  0001 C CNN
F 1 "+5V" H 5715 3773 50  0000 C CNN
F 2 "" H 5700 3600 50  0001 C CNN
F 3 "" H 5700 3600 50  0001 C CNN
	1    5700 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 3350 5250 3350
Wire Wire Line
	5250 3350 5250 2850
Wire Wire Line
	6000 3350 6000 3800
$Comp
L Device:CP C1
U 1 1 5EFF5AEE
P 2500 2450
F 0 "C1" H 2618 2496 50  0000 L CNN
F 1 "10uF" H 2618 2405 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 2538 2300 50  0001 C CNN
F 3 "~" H 2500 2450 50  0001 C CNN
	1    2500 2450
	1    0    0    -1  
$EndComp
Connection ~ 2500 2300
Connection ~ 2500 2600
Wire Wire Line
	3400 4750 5000 4750
Connection ~ 5000 4750
Wire Wire Line
	5000 4750 5000 5200
Wire Wire Line
	4450 2300 4150 2300
Text Notes 10050 6100 0    50   ~ 0
(ROM enabled)
$Comp
L Device:R_Network04 RN1
U 1 1 60D326E0
P 1950 3600
F 0 "RN1" H 2138 3646 50  0000 L CNN
F 1 "4x10k" H 2138 3555 50  0000 L CNN
F 2 "Resistor_THT:R_Array_SIP5" V 2225 3600 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 1950 3600 50  0001 C CNN
	1    1950 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	1500 3950 1750 3950
Wire Wire Line
	1500 4050 1850 4050
Wire Wire Line
	1500 4150 1950 4150
Wire Wire Line
	1500 4250 2050 4250
Wire Wire Line
	1750 3800 1750 3950
Connection ~ 1750 3950
Wire Wire Line
	1750 3950 2400 3950
Wire Wire Line
	1850 3800 1850 4050
Connection ~ 1850 4050
Wire Wire Line
	1850 4050 2400 4050
Wire Wire Line
	1950 3800 1950 4150
Connection ~ 1950 4150
Wire Wire Line
	1950 4150 2400 4150
Wire Wire Line
	2050 3800 2050 4250
Connection ~ 2050 4250
Wire Wire Line
	2050 4250 2400 4250
Wire Wire Line
	1750 3300 1750 3400
$Comp
L 74xx:74LS74 U3
U 3 1 5E66B03C
P 2550 6500
F 0 "U3" H 2780 6546 50  0000 L CNN
F 1 "74LS74" H 2780 6455 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 2550 6500 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 2550 6500 50  0001 C CNN
	3    2550 6500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U2
U 7 1 60E333D3
P 1800 6500
F 0 "U2" H 2030 6546 50  0000 L CNN
F 1 "74LS04" H 2030 6455 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 1800 6500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 1800 6500 50  0001 C CNN
	7    1800 6500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U2
U 1 1 60E358D5
P 4050 4400
F 0 "U2" H 4050 4717 50  0000 C CNN
F 1 "74LS04" H 4050 4626 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 4050 4400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 4050 4400 50  0001 C CNN
	1    4050 4400
	-1   0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U2
U 2 1 60E36F6F
P 8950 5250
F 0 "U2" H 9050 5400 50  0000 R CNN
F 1 "74LS04" H 9100 5050 50  0000 R CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 8950 5250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 8950 5250 50  0001 C CNN
	2    8950 5250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U2
U 3 1 60E38357
P 8950 5750
F 0 "U2" H 8950 5900 50  0000 C CNN
F 1 "74LS04" H 8950 5550 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 8950 5750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 8950 5750 50  0001 C CNN
	3    8950 5750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U2
U 4 1 60E39555
P 8950 4250
F 0 "U2" H 9000 4400 50  0000 C CNN
F 1 "74LS04" H 8950 4050 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 8950 4250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 8950 4250 50  0001 C CNN
	4    8950 4250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U2
U 5 1 60E3AA7D
P 8950 4750
F 0 "U2" H 9000 4900 50  0000 C CNN
F 1 "74LS04" H 8950 4550 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 8950 4750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 8950 4750 50  0001 C CNN
	5    8950 4750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:SN74LS07N U5
U 7 1 60E3C863
P 3300 6500
F 0 "U5" H 3530 6546 50  0000 L CNN
F 1 "SN74LS07N" H 3530 6455 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 3300 6500 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 3300 6500 50  0001 C CNN
	7    3300 6500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:SN74LS07N U5
U 1 1 60E3DF50
P 9550 5250
F 0 "U5" H 9650 5400 50  0000 R CNN
F 1 "SN74LS07N" H 9750 5050 50  0000 R CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 9550 5250 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 9550 5250 50  0001 C CNN
	1    9550 5250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:SN74LS07N U5
U 2 1 60E3F588
P 9550 5750
F 0 "U5" H 9600 5900 50  0000 C CNN
F 1 "SN74LS07N" H 9550 5550 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 9550 5750 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 9550 5750 50  0001 C CNN
	2    9550 5750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:SN74LS07N U5
U 3 1 60E40E93
P 9550 4250
F 0 "U5" H 9600 4400 50  0000 C CNN
F 1 "SN74LS07N" H 9550 4050 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 9550 4250 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 9550 4250 50  0001 C CNN
	3    9550 4250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:SN74LS07N U5
U 4 1 60E42EB6
P 9550 4750
F 0 "U5" H 9600 4900 50  0000 C CNN
F 1 "SN74LS07N" H 9550 4550 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 9550 4750 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 9550 4750 50  0001 C CNN
	4    9550 4750
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR02
U 1 1 60E5755C
P 1000 6000
F 0 "#PWR02" H 1000 5850 50  0001 C CNN
F 1 "+5V" H 1015 6173 50  0000 C CNN
F 2 "" H 1000 6000 50  0001 C CNN
F 3 "" H 1000 6000 50  0001 C CNN
	1    1000 6000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR011
U 1 1 60E59C65
P 2550 6000
F 0 "#PWR011" H 2550 5850 50  0001 C CNN
F 1 "+5V" H 2565 6173 50  0000 C CNN
F 2 "" H 2550 6000 50  0001 C CNN
F 3 "" H 2550 6000 50  0001 C CNN
	1    2550 6000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR015
U 1 1 60E5C317
P 3300 6000
F 0 "#PWR015" H 3300 5850 50  0001 C CNN
F 1 "+5V" H 3315 6173 50  0000 C CNN
F 2 "" H 3300 6000 50  0001 C CNN
F 3 "" H 3300 6000 50  0001 C CNN
	1    3300 6000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 60E6593D
P 1000 7000
F 0 "#PWR03" H 1000 6750 50  0001 C CNN
F 1 "GND" H 1005 6827 50  0000 C CNN
F 2 "" H 1000 7000 50  0001 C CNN
F 3 "" H 1000 7000 50  0001 C CNN
	1    1000 7000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 60E67F8B
P 3300 7000
F 0 "#PWR016" H 3300 6750 50  0001 C CNN
F 1 "GND" H 3305 6827 50  0000 C CNN
F 2 "" H 3300 7000 50  0001 C CNN
F 3 "" H 3300 7000 50  0001 C CNN
	1    3300 7000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 60E6A49A
P 2550 7000
F 0 "#PWR012" H 2550 6750 50  0001 C CNN
F 1 "GND" H 2555 6827 50  0000 C CNN
F 2 "" H 2550 7000 50  0001 C CNN
F 3 "" H 2550 7000 50  0001 C CNN
	1    2550 7000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 6000 2550 6100
Wire Wire Line
	2550 6900 2550 7000
Wire Wire Line
	6000 5300 6100 5300
Wire Wire Line
	4450 2300 4450 4400
Wire Wire Line
	4450 4400 4350 4400
Wire Wire Line
	3750 4400 3400 4400
Wire Wire Line
	3400 4150 3400 4400
$Comp
L Device:C C2
U 1 1 60EDCFB6
P 4600 6250
F 0 "C2" H 4715 6296 50  0000 L CNN
F 1 "10nF" H 4715 6205 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 4638 6100 50  0001 C CNN
F 3 "~" H 4600 6250 50  0001 C CNN
	1    4600 6250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR018
U 1 1 60EDDC57
P 4600 6100
F 0 "#PWR018" H 4600 5950 50  0001 C CNN
F 1 "+5V" H 4615 6273 50  0000 C CNN
F 2 "" H 4600 6100 50  0001 C CNN
F 3 "" H 4600 6100 50  0001 C CNN
	1    4600 6100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR019
U 1 1 60EDEC36
P 4600 6400
F 0 "#PWR019" H 4600 6150 50  0001 C CNN
F 1 "GND" H 4605 6227 50  0000 C CNN
F 2 "" H 4600 6400 50  0001 C CNN
F 3 "" H 4600 6400 50  0001 C CNN
	1    4600 6400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 60EECB1B
P 5000 6250
F 0 "C4" H 5115 6296 50  0000 L CNN
F 1 "10nF" H 5115 6205 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 5038 6100 50  0001 C CNN
F 3 "~" H 5000 6250 50  0001 C CNN
	1    5000 6250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR022
U 1 1 60EECB21
P 5000 6100
F 0 "#PWR022" H 5000 5950 50  0001 C CNN
F 1 "+5V" H 5015 6273 50  0000 C CNN
F 2 "" H 5000 6100 50  0001 C CNN
F 3 "" H 5000 6100 50  0001 C CNN
	1    5000 6100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR023
U 1 1 60EECB27
P 5000 6400
F 0 "#PWR023" H 5000 6150 50  0001 C CNN
F 1 "GND" H 5005 6227 50  0000 C CNN
F 2 "" H 5000 6400 50  0001 C CNN
F 3 "" H 5000 6400 50  0001 C CNN
	1    5000 6400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 60EEF184
P 5400 6250
F 0 "C6" H 5515 6296 50  0000 L CNN
F 1 "10nF" H 5515 6205 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 5438 6100 50  0001 C CNN
F 3 "~" H 5400 6250 50  0001 C CNN
	1    5400 6250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR029
U 1 1 60EEF18A
P 5400 6100
F 0 "#PWR029" H 5400 5950 50  0001 C CNN
F 1 "+5V" H 5415 6273 50  0000 C CNN
F 2 "" H 5400 6100 50  0001 C CNN
F 3 "" H 5400 6100 50  0001 C CNN
	1    5400 6100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR030
U 1 1 60EEF190
P 5400 6400
F 0 "#PWR030" H 5400 6150 50  0001 C CNN
F 1 "GND" H 5405 6227 50  0000 C CNN
F 2 "" H 5400 6400 50  0001 C CNN
F 3 "" H 5400 6400 50  0001 C CNN
	1    5400 6400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 60EF1DE5
P 5800 6250
F 0 "C8" H 5915 6296 50  0000 L CNN
F 1 "10nF" H 5915 6205 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 5838 6100 50  0001 C CNN
F 3 "~" H 5800 6250 50  0001 C CNN
	1    5800 6250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR037
U 1 1 60EF1DEB
P 5800 6100
F 0 "#PWR037" H 5800 5950 50  0001 C CNN
F 1 "+5V" H 5815 6273 50  0000 C CNN
F 2 "" H 5800 6100 50  0001 C CNN
F 3 "" H 5800 6100 50  0001 C CNN
	1    5800 6100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR038
U 1 1 60EF1DF1
P 5800 6400
F 0 "#PWR038" H 5800 6150 50  0001 C CNN
F 1 "GND" H 5805 6227 50  0000 C CNN
F 2 "" H 5800 6400 50  0001 C CNN
F 3 "" H 5800 6400 50  0001 C CNN
	1    5800 6400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 60EF43E5
P 4800 7000
F 0 "C3" H 4915 7046 50  0000 L CNN
F 1 "10nF" H 4915 6955 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 4838 6850 50  0001 C CNN
F 3 "~" H 4800 7000 50  0001 C CNN
	1    4800 7000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR020
U 1 1 60EF43EB
P 4800 6850
F 0 "#PWR020" H 4800 6700 50  0001 C CNN
F 1 "+5V" H 4815 7023 50  0000 C CNN
F 2 "" H 4800 6850 50  0001 C CNN
F 3 "" H 4800 6850 50  0001 C CNN
	1    4800 6850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR021
U 1 1 60EF43F1
P 4800 7150
F 0 "#PWR021" H 4800 6900 50  0001 C CNN
F 1 "GND" H 4805 6977 50  0000 C CNN
F 2 "" H 4800 7150 50  0001 C CNN
F 3 "" H 4800 7150 50  0001 C CNN
	1    4800 7150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 60EF6E3B
P 5200 7000
F 0 "C5" H 5315 7046 50  0000 L CNN
F 1 "10nF" H 5315 6955 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 5238 6850 50  0001 C CNN
F 3 "~" H 5200 7000 50  0001 C CNN
	1    5200 7000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR027
U 1 1 60EF6E41
P 5200 6850
F 0 "#PWR027" H 5200 6700 50  0001 C CNN
F 1 "+5V" H 5215 7023 50  0000 C CNN
F 2 "" H 5200 6850 50  0001 C CNN
F 3 "" H 5200 6850 50  0001 C CNN
	1    5200 6850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR028
U 1 1 60EF6E47
P 5200 7150
F 0 "#PWR028" H 5200 6900 50  0001 C CNN
F 1 "GND" H 5205 6977 50  0000 C CNN
F 2 "" H 5200 7150 50  0001 C CNN
F 3 "" H 5200 7150 50  0001 C CNN
	1    5200 7150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C7
U 1 1 60EF99A2
P 5600 7000
F 0 "C7" H 5715 7046 50  0000 L CNN
F 1 "10nF" H 5715 6955 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 5638 6850 50  0001 C CNN
F 3 "~" H 5600 7000 50  0001 C CNN
	1    5600 7000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR033
U 1 1 60EF99A8
P 5600 6850
F 0 "#PWR033" H 5600 6700 50  0001 C CNN
F 1 "+5V" H 5615 7023 50  0000 C CNN
F 2 "" H 5600 6850 50  0001 C CNN
F 3 "" H 5600 6850 50  0001 C CNN
	1    5600 6850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR034
U 1 1 60EF99AE
P 5600 7150
F 0 "#PWR034" H 5600 6900 50  0001 C CNN
F 1 "GND" H 5605 6977 50  0000 C CNN
F 2 "" H 5600 7150 50  0001 C CNN
F 3 "" H 5600 7150 50  0001 C CNN
	1    5600 7150
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS04 U2
U 6 1 60F07295
P 5450 2100
F 0 "U2" H 5450 2417 50  0000 C CNN
F 1 "74LS04" H 5450 2326 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5450 2100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS04" H 5450 2100 50  0001 C CNN
	6    5450 2100
	1    0    0    -1  
$EndComp
$Comp
L 74xx:SN74LS07N U5
U 5 1 60F092E5
P 5450 1050
F 0 "U5" H 5450 1367 50  0000 C CNN
F 1 "SN74LS07N" H 5450 1276 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5450 1050 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 5450 1050 50  0001 C CNN
	5    5450 1050
	1    0    0    -1  
$EndComp
$Comp
L 74xx:SN74LS07N U5
U 6 1 60F0ADBD
P 5450 1600
F 0 "U5" H 5450 1917 50  0000 C CNN
F 1 "SN74LS07N" H 5450 1826 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5450 1600 50  0001 C CNN
F 3 "www.ti.com/lit/ds/symlink/sn74ls07.pdf" H 5450 1600 50  0001 C CNN
	6    5450 1600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR025
U 1 1 60F1071C
P 5150 1600
F 0 "#PWR025" H 5150 1350 50  0001 C CNN
F 1 "GND" V 5155 1427 50  0000 C CNN
F 2 "" H 5150 1600 50  0001 C CNN
F 3 "" H 5150 1600 50  0001 C CNN
	1    5150 1600
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR026
U 1 1 60F1A351
P 5150 2100
F 0 "#PWR026" H 5150 1850 50  0001 C CNN
F 1 "GND" V 5155 1927 50  0000 C CNN
F 2 "" H 5150 2100 50  0001 C CNN
F 3 "" H 5150 2100 50  0001 C CNN
	1    5150 2100
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR024
U 1 1 60F1C60B
P 5150 1050
F 0 "#PWR024" H 5150 800 50  0001 C CNN
F 1 "GND" V 5155 877 50  0000 C CNN
F 2 "" H 5150 1050 50  0001 C CNN
F 3 "" H 5150 1050 50  0001 C CNN
	1    5150 1050
	0    1    1    0   
$EndComp
NoConn ~ 5750 2100
NoConn ~ 5750 1050
NoConn ~ 5750 1600
Wire Wire Line
	7950 2950 7950 4750
Wire Wire Line
	7950 2950 10000 2950
$Comp
L Device:R_Network04 RN2
U 1 1 60E3415D
P 10600 4450
F 0 "RN2" V 10200 4400 50  0000 L CNN
F 1 "4x220" V 10300 4350 50  0000 L CNN
F 2 "Resistor_THT:R_Array_SIP5" V 10875 4450 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 10600 4450 50  0001 C CNN
	1    10600 4450
	0    1    1    0   
$EndComp
Wire Wire Line
	10400 4550 10400 5750
Wire Wire Line
	10400 5750 10150 5750
Wire Wire Line
	10400 4450 10350 4450
Wire Wire Line
	10350 4450 10350 5250
Wire Wire Line
	10350 5250 10150 5250
Wire Wire Line
	10400 4350 10300 4350
Wire Wire Line
	10300 4350 10300 4750
Wire Wire Line
	10300 4750 10150 4750
Wire Wire Line
	10400 4250 10150 4250
Wire Wire Line
	8650 4250 8650 2650
Connection ~ 9600 2650
Wire Wire Line
	8650 4750 8550 4750
Wire Wire Line
	8550 4750 8550 2750
Connection ~ 9400 2750
Wire Wire Line
	8650 5750 6100 5750
Wire Wire Line
	6100 5300 6100 5750
Text Label 8650 5250 2    50   ~ 0
ram_bank
Text Label 6550 2950 2    50   ~ 0
ram_bank
Text Notes 10100 5250 0    50   ~ 0
ram\nbank
Wire Wire Line
	8650 2650 9600 2650
Wire Wire Line
	8550 2750 9400 2750
$Comp
L power:+5V #PWR047
U 1 1 60E73BBA
P 10800 4250
F 0 "#PWR047" H 10800 4100 50  0001 C CNN
F 1 "+5V" V 10815 4378 50  0000 L CNN
F 2 "" H 10800 4250 50  0001 C CNN
F 3 "" H 10800 4250 50  0001 C CNN
	1    10800 4250
	0    1    1    0   
$EndComp
$EndSCHEMATC
