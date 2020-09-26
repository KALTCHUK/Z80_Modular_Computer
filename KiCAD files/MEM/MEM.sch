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
L Connector_Generic:Conn_02x05_Odd_Even J1
U 1 1 5DE110BD
P 1700 2400
F 0 "J1" H 1750 2817 50  0000 C CNN
F 1 "Power Bus" H 1750 2726 50  0000 C CNN
F 2 "" H 1700 2400 50  0001 C CNN
F 3 "~" H 1700 2400 50  0001 C CNN
	1    1700 2400
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J2
U 1 1 5DE11A6D
P 3850 1900
F 0 "J2" H 3900 3017 50  0000 C CNN
F 1 "Signal Bus" H 3900 2926 50  0000 C CNN
F 2 "" H 3850 1900 50  0001 C CNN
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
L power:+5V #PWR03
U 1 1 5E34AA96
P 2500 2000
F 0 "#PWR03" H 2500 1850 50  0001 C CNN
F 1 "+5V" H 2515 2173 50  0000 C CNN
F 2 "" H 2500 2000 50  0001 C CNN
F 3 "" H 2500 2000 50  0001 C CNN
	1    2500 2000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR04
U 1 1 5E34BF5A
P 2500 2700
F 0 "#PWR04" H 2500 2450 50  0001 C CNN
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
L power:GND #PWR02
U 1 1 5E3CA8BD
P 2500 1250
F 0 "#PWR02" H 2500 1000 50  0001 C CNN
F 1 "GND" H 2505 1077 50  0000 C CNN
F 2 "" H 2500 1250 50  0001 C CNN
F 3 "" H 2500 1250 50  0001 C CNN
	1    2500 1250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR01
U 1 1 5E3CB5D9
P 1850 1150
F 0 "#PWR01" H 1850 1000 50  0001 C CNN
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
L Memory_EPROM:27C512 U5
U 1 1 5E35B5E0
P 10400 2150
F 0 "U5" H 10050 3350 50  0000 C CNN
F 1 "W27C512" H 10050 3250 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm" H 10400 2150 50  0001 C CNN
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
F 2 "" H 7050 2150 50  0001 C CNN
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
L power:+5V #PWR013
U 1 1 5E363E91
P 7550 2350
F 0 "#PWR013" H 7550 2200 50  0001 C CNN
F 1 "+5V" V 7565 2478 50  0000 L CNN
F 2 "" H 7550 2350 50  0001 C CNN
F 3 "" H 7550 2350 50  0001 C CNN
	1    7550 2350
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR07
U 1 1 5E3651CC
P 10400 750
F 0 "#PWR07" H 10400 600 50  0001 C CNN
F 1 "+5V" H 10415 923 50  0000 C CNN
F 2 "" H 10400 750 50  0001 C CNN
F 3 "" H 10400 750 50  0001 C CNN
	1    10400 750 
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR011
U 1 1 5E365899
P 7050 850
F 0 "#PWR011" H 7050 700 50  0001 C CNN
F 1 "+5V" H 7065 1023 50  0000 C CNN
F 2 "" H 7050 850 50  0001 C CNN
F 3 "" H 7050 850 50  0001 C CNN
	1    7050 850 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 5E365DEB
P 7050 3150
F 0 "#PWR012" H 7050 2900 50  0001 C CNN
F 1 "GND" H 7055 2977 50  0000 C CNN
F 2 "" H 7050 3150 50  0001 C CNN
F 3 "" H 7050 3150 50  0001 C CNN
	1    7050 3150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR08
U 1 1 5E36620A
P 10400 3250
F 0 "#PWR08" H 10400 3000 50  0001 C CNN
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
L Device:C C1
U 1 1 5E36977B
P 10700 900
F 0 "C1" V 10952 900 50  0000 C CNN
F 1 "10n" V 10861 900 50  0000 C CNN
F 2 "" H 10738 750 50  0001 C CNN
F 3 "~" H 10700 900 50  0001 C CNN
	1    10700 900 
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C2
U 1 1 5E36B178
P 7350 1000
F 0 "C2" V 7602 1000 50  0000 C CNN
F 1 "10n" V 7511 1000 50  0000 C CNN
F 2 "" H 7388 850 50  0001 C CNN
F 3 "~" H 7350 1000 50  0001 C CNN
	1    7350 1000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	10400 750  10400 900 
Wire Wire Line
	10550 900  10400 900 
Connection ~ 10400 900 
Wire Wire Line
	10400 900  10400 1050
Wire Wire Line
	7050 850  7050 1000
Wire Wire Line
	7200 1000 7050 1000
Connection ~ 7050 1000
Wire Wire Line
	7050 1000 7050 1150
$Comp
L power:GND #PWR014
U 1 1 5E36CA24
P 7650 1000
F 0 "#PWR014" H 7650 750 50  0001 C CNN
F 1 "GND" H 7655 827 50  0000 C CNN
F 2 "" H 7650 1000 50  0001 C CNN
F 3 "" H 7650 1000 50  0001 C CNN
	1    7650 1000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 5E36D143
P 11000 900
F 0 "#PWR09" H 11000 650 50  0001 C CNN
F 1 "GND" H 11005 727 50  0000 C CNN
F 2 "" H 11000 900 50  0001 C CNN
F 3 "" H 11000 900 50  0001 C CNN
	1    11000 900 
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 1000 7500 1000
Wire Wire Line
	11000 900  10850 900 
$Comp
L 74xx:74LS74 U4
U 1 1 5E384400
P 5700 5200
F 0 "U4" H 5400 4900 50  0000 C CNN
F 1 "74LS74" H 5400 4800 50  0000 C CNN
F 2 "" H 5700 5200 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 5700 5200 50  0001 C CNN
	1    5700 5200
	1    0    0    -1  
$EndComp
NoConn ~ 3650 2500
NoConn ~ 3650 2600
NoConn ~ 4150 2600
NoConn ~ 4150 2500
NoConn ~ 4150 2400
Text Notes 7750 5800 0    50   ~ 0
ROM at memory base
$Comp
L 74xx:74LS74 U4
U 3 1 5E66B03C
P 2700 6850
F 0 "U4" H 2930 6896 50  0000 L CNN
F 1 "74LS74" H 2930 6805 50  0000 L CNN
F 2 "" H 2700 6850 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 2700 6850 50  0001 C CNN
	3    2700 6850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2700 6350 2700 6450
Wire Wire Line
	2700 7350 2700 7250
$Comp
L power:GND #PWR018
U 1 1 5E67707E
P 1900 7350
F 0 "#PWR018" H 1900 7100 50  0001 C CNN
F 1 "GND" H 1905 7177 50  0000 C CNN
F 2 "" H 1900 7350 50  0001 C CNN
F 3 "" H 1900 7350 50  0001 C CNN
	1    1900 7350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR017
U 1 1 5E677E2E
P 1900 6350
F 0 "#PWR017" H 1900 6200 50  0001 C CNN
F 1 "+5V" H 1915 6523 50  0000 C CNN
F 2 "" H 1900 6350 50  0001 C CNN
F 3 "" H 1900 6350 50  0001 C CNN
	1    1900 6350
	1    0    0    -1  
$EndComp
NoConn ~ 3650 2400
$Comp
L 74xx:74LS85 U3
U 1 1 5E8AE503
P 2900 4350
F 0 "U3" H 2650 5150 50  0000 C CNN
F 1 "74LS85" H 2650 5050 50  0000 C CNN
F 2 "" H 2900 4350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS85" H 2900 4350 50  0001 C CNN
	1    2900 4350
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x04_Odd_Even J3
U 1 1 5E8D5E71
P 1200 4050
F 0 "J3" H 1250 4367 50  0000 C CNN
F 1 "card addr" H 1250 4276 50  0000 C CNN
F 2 "" H 1200 4050 50  0001 C CNN
F 3 "~" H 1200 4050 50  0001 C CNN
	1    1200 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 3950 1600 3950
Wire Wire Line
	1500 4050 1800 4050
Wire Wire Line
	2400 4150 2000 4150
Wire Wire Line
	1500 4250 2200 4250
Wire Wire Line
	1000 3950 1000 4050
Wire Wire Line
	1000 4050 1000 4150
Connection ~ 1000 4050
Wire Wire Line
	1000 4150 1000 4250
Connection ~ 1000 4150
$Comp
L power:+5V #PWR020
U 1 1 5E8E97E6
P 2900 3650
F 0 "#PWR020" H 2900 3500 50  0001 C CNN
F 1 "+5V" H 2915 3823 50  0000 C CNN
F 2 "" H 2900 3650 50  0001 C CNN
F 3 "" H 2900 3650 50  0001 C CNN
	1    2900 3650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR021
U 1 1 5E8EA827
P 2900 5050
F 0 "#PWR021" H 2900 4800 50  0001 C CNN
F 1 "GND" H 2905 4877 50  0000 C CNN
F 2 "" H 2900 5050 50  0001 C CNN
F 3 "" H 2900 5050 50  0001 C CNN
	1    2900 5050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR023
U 1 1 5E8EB844
P 3800 3950
F 0 "#PWR023" H 3800 3700 50  0001 C CNN
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
L Device:R R3
U 1 1 5E8F1A02
P 1600 3650
F 0 "R3" V 1700 3750 50  0000 C CNN
F 1 "10k" V 1700 3600 50  0000 C CNN
F 2 "" V 1530 3650 50  0001 C CNN
F 3 "~" H 1600 3650 50  0001 C CNN
	1    1600 3650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 5E8F954C
P 1800 3650
F 0 "R4" V 1900 3750 50  0000 C CNN
F 1 "10k" V 1900 3600 50  0000 C CNN
F 2 "" V 1730 3650 50  0001 C CNN
F 3 "~" H 1800 3650 50  0001 C CNN
	1    1800 3650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 5E8FB1E6
P 2000 3650
F 0 "R5" V 2100 3750 50  0000 C CNN
F 1 "10k" V 2100 3600 50  0000 C CNN
F 2 "" V 1930 3650 50  0001 C CNN
F 3 "~" H 2000 3650 50  0001 C CNN
	1    2000 3650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R6
U 1 1 5E8FCDB9
P 2200 3650
F 0 "R6" V 2300 3750 50  0000 C CNN
F 1 "10k" V 2300 3600 50  0000 C CNN
F 2 "" V 2130 3650 50  0001 C CNN
F 3 "~" H 2200 3650 50  0001 C CNN
	1    2200 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 3800 1600 3950
Connection ~ 1600 3950
Wire Wire Line
	1600 3950 1500 3950
Wire Wire Line
	1800 3800 1800 4050
Connection ~ 1800 4050
Wire Wire Line
	1800 4050 2400 4050
Wire Wire Line
	2000 3800 2000 4150
Connection ~ 2000 4150
Wire Wire Line
	2000 4150 1500 4150
Wire Wire Line
	2200 3800 2200 4250
Connection ~ 2200 4250
Wire Wire Line
	2200 4250 2400 4250
Wire Wire Line
	1600 3500 1600 3400
Wire Wire Line
	1600 3400 1800 3400
Wire Wire Line
	2200 3400 2200 3500
Wire Wire Line
	2000 3500 2000 3400
Connection ~ 2000 3400
Wire Wire Line
	2000 3400 2200 3400
Wire Wire Line
	1800 3500 1800 3400
Connection ~ 1800 3400
$Comp
L power:+5V #PWR019
U 1 1 5E914060
P 1800 3250
F 0 "#PWR019" H 1800 3100 50  0001 C CNN
F 1 "+5V" H 1815 3423 50  0000 C CNN
F 2 "" H 1800 3250 50  0001 C CNN
F 3 "" H 1800 3250 50  0001 C CNN
	1    1800 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	1800 3250 1800 3400
$Comp
L power:GND #PWR05
U 1 1 5E917E68
P 1000 4400
F 0 "#PWR05" H 1000 4150 50  0001 C CNN
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
Wire Wire Line
	1800 3400 2000 3400
$Comp
L Connector_Generic:Conn_02x02_Odd_Even J4
U 1 1 5E9CC17B
P 8750 1550
F 0 "J4" H 8800 1767 50  0000 C CNN
F 1 "ROM block" H 8800 1676 50  0000 C CNN
F 2 "" H 8750 1550 50  0001 C CNN
F 3 "~" H 8750 1550 50  0001 C CNN
	1    8750 1550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R7
U 1 1 5E9CF50B
P 9400 1250
F 0 "R7" V 9500 1350 50  0000 C CNN
F 1 "10k" V 9500 1200 50  0000 C CNN
F 2 "" V 9330 1250 50  0001 C CNN
F 3 "~" H 9400 1250 50  0001 C CNN
	1    9400 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R8
U 1 1 5E9CF511
P 9600 1250
F 0 "R8" V 9700 1350 50  0000 C CNN
F 1 "10k" V 9700 1200 50  0000 C CNN
F 2 "" V 9530 1250 50  0001 C CNN
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
L power:+5V #PWR025
U 1 1 5E9CF51B
P 9600 850
F 0 "#PWR025" H 9600 700 50  0001 C CNN
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
L power:GND #PWR024
U 1 1 5E9DE2CB
P 8550 1800
F 0 "#PWR024" H 8550 1550 50  0001 C CNN
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
L power:+5V #PWR06
U 1 1 5EA9FC22
P 5700 4900
F 0 "#PWR06" H 5700 4750 50  0001 C CNN
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
L power:GND #PWR028
U 1 1 5EAC5102
P 6650 4750
F 0 "#PWR028" H 6650 4500 50  0001 C CNN
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
F 2 "" H 7150 4850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS139" H 7150 4850 50  0001 C CNN
	2    7150 4850
	1    0    0    -1  
$EndComp
NoConn ~ 7650 4000
NoConn ~ 7650 4100
NoConn ~ 7650 4200
$Comp
L 74xx:74LS00 U2
U 1 1 5EB16077
P 4150 4300
F 0 "U2" H 4150 4625 50  0000 C CNN
F 1 "74LS00" H 4150 4534 50  0000 C CNN
F 2 "" H 4150 4300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 4150 4300 50  0001 C CNN
	1    4150 4300
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74LS00 U2
U 5 1 5EB1B53F
P 1900 6850
F 0 "U2" H 2130 6896 50  0000 L CNN
F 1 "74LS00" H 2130 6805 50  0000 L CNN
F 2 "" H 1900 6850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 1900 6850 50  0001 C CNN
	5    1900 6850
	1    0    0    -1  
$EndComp
Connection ~ 1900 6350
Wire Wire Line
	1900 6350 2700 6350
Connection ~ 1900 7350
Wire Wire Line
	1900 7350 2700 7350
$Comp
L 74xx:74LS139 U1
U 3 1 5EB3F131
P 1100 6850
F 0 "U1" H 1330 6896 50  0000 L CNN
F 1 "74LS139" H 1330 6805 50  0000 L CNN
F 2 "" H 1100 6850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS139" H 1100 6850 50  0001 C CNN
	3    1100 6850
	1    0    0    -1  
$EndComp
Wire Wire Line
	1100 6350 1900 6350
Wire Wire Line
	1100 7350 1900 7350
$Comp
L Transistor_BJT:BC547 Q2
U 1 1 5EB4DBA6
P 7100 5750
F 0 "Q2" H 7291 5796 50  0000 L CNN
F 1 "BC547" H 7291 5705 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 7300 5675 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 7100 5750 50  0001 L CNN
	1    7100 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	8050 5550 7950 5550
Wire Wire Line
	8050 5450 8050 5550
$Comp
L power:+5V #PWR016
U 1 1 5E4249E4
P 8050 5450
F 0 "#PWR016" H 8050 5300 50  0001 C CNN
F 1 "+5V" H 8065 5623 50  0000 C CNN
F 2 "" H 8050 5450 50  0001 C CNN
F 3 "" H 8050 5450 50  0001 C CNN
	1    8050 5450
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 5E4221DC
P 7800 5550
F 0 "D1" H 7793 5766 50  0000 C CNN
F 1 "LED" H 7793 5675 50  0000 C CNN
F 2 "" H 7800 5550 50  0001 C CNN
F 3 "~" H 7800 5550 50  0001 C CNN
	1    7800 5550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5E419B94
P 7500 5550
F 0 "R2" V 7707 5550 50  0000 C CNN
F 1 "470" V 7616 5550 50  0000 C CNN
F 2 "" V 7430 5550 50  0001 C CNN
F 3 "~" H 7500 5550 50  0001 C CNN
	1    7500 5550
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R9
U 1 1 5EB56591
P 6750 5750
F 0 "R9" V 6957 5750 50  0000 C CNN
F 1 "10k" V 6866 5750 50  0000 C CNN
F 2 "" V 6680 5750 50  0001 C CNN
F 3 "~" H 6750 5750 50  0001 C CNN
	1    6750 5750
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR026
U 1 1 5EB59573
P 7200 5950
F 0 "#PWR026" H 7200 5700 50  0001 C CNN
F 1 "GND" H 7205 5777 50  0000 C CNN
F 2 "" H 7200 5950 50  0001 C CNN
F 3 "" H 7200 5950 50  0001 C CNN
	1    7200 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 5550 7200 5550
$Comp
L Transistor_BJT:BC547 Q4
U 1 1 5EB94A03
P 9200 3150
F 0 "Q4" H 9391 3196 50  0000 L CNN
F 1 "BC547" H 9391 3105 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 9400 3075 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 9200 3150 50  0001 L CNN
	1    9200 3150
	-1   0    0    -1  
$EndComp
$Comp
L power:+5V #PWR031
U 1 1 5EB98DD8
P 9100 2350
F 0 "#PWR031" H 9100 2200 50  0001 C CNN
F 1 "+5V" H 9115 2523 50  0000 C CNN
F 2 "" H 9100 2350 50  0001 C CNN
F 3 "" H 9100 2350 50  0001 C CNN
	1    9100 2350
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D4
U 1 1 5EB98DDE
P 9100 2500
F 0 "D4" H 9093 2716 50  0000 C CNN
F 1 "LED" H 9093 2625 50  0000 C CNN
F 2 "" H 9100 2500 50  0001 C CNN
F 3 "~" H 9100 2500 50  0001 C CNN
	1    9100 2500
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R13
U 1 1 5EB98DE4
P 9100 2800
F 0 "R13" V 9307 2800 50  0000 C CNN
F 1 "470" V 9216 2800 50  0000 C CNN
F 2 "" V 9030 2800 50  0001 C CNN
F 3 "~" H 9100 2800 50  0001 C CNN
	1    9100 2800
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR032
U 1 1 5EBADB49
P 9100 3350
F 0 "#PWR032" H 9100 3100 50  0001 C CNN
F 1 "GND" H 9105 3177 50  0000 C CNN
F 2 "" H 9100 3350 50  0001 C CNN
F 3 "" H 9100 3350 50  0001 C CNN
	1    9100 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:R R14
U 1 1 5EBAE41A
P 9400 2900
F 0 "R14" V 9607 2900 50  0000 C CNN
F 1 "10k" V 9516 2900 50  0000 C CNN
F 2 "" V 9330 2900 50  0001 C CNN
F 3 "~" H 9400 2900 50  0001 C CNN
	1    9400 2900
	-1   0    0    1   
$EndComp
Wire Wire Line
	9400 3050 9400 3150
$Comp
L Transistor_BJT:BC547 Q3
U 1 1 5EBBE44E
P 8700 3850
F 0 "Q3" H 8891 3896 50  0000 L CNN
F 1 "BC547" H 8891 3805 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 8900 3775 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 8700 3850 50  0001 L CNN
	1    8700 3850
	-1   0    0    -1  
$EndComp
$Comp
L power:+5V #PWR029
U 1 1 5EBBE454
P 8600 2350
F 0 "#PWR029" H 8600 2200 50  0001 C CNN
F 1 "+5V" H 8615 2523 50  0000 C CNN
F 2 "" H 8600 2350 50  0001 C CNN
F 3 "" H 8600 2350 50  0001 C CNN
	1    8600 2350
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D3
U 1 1 5EBBE45A
P 8600 2500
F 0 "D3" H 8593 2716 50  0000 C CNN
F 1 "LED" H 8593 2625 50  0000 C CNN
F 2 "" H 8600 2500 50  0001 C CNN
F 3 "~" H 8600 2500 50  0001 C CNN
	1    8600 2500
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R11
U 1 1 5EBBE460
P 8600 2800
F 0 "R11" V 8807 2800 50  0000 C CNN
F 1 "470" V 8716 2800 50  0000 C CNN
F 2 "" V 8530 2800 50  0001 C CNN
F 3 "~" H 8600 2800 50  0001 C CNN
	1    8600 2800
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR030
U 1 1 5EBBE466
P 8600 4050
F 0 "#PWR030" H 8600 3800 50  0001 C CNN
F 1 "GND" H 8605 3877 50  0000 C CNN
F 2 "" H 8600 4050 50  0001 C CNN
F 3 "" H 8600 4050 50  0001 C CNN
	1    8600 4050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R12
U 1 1 5EBC1B45
P 9050 3850
F 0 "R12" V 9257 3850 50  0000 C CNN
F 1 "10k" V 9166 3850 50  0000 C CNN
F 2 "" V 8980 3850 50  0001 C CNN
F 3 "~" H 9050 3850 50  0001 C CNN
	1    9050 3850
	0    -1   -1   0   
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
Connection ~ 9400 2750
Wire Wire Line
	9600 2650 9600 3850
Wire Wire Line
	9600 3850 9200 3850
Connection ~ 9600 2650
Wire Wire Line
	8600 2950 8600 3650
Wire Wire Line
	7550 2250 8150 2250
Text Notes 8750 2450 2    50   ~ 0
low\nbit
Text Notes 9200 1550 2    50   ~ 0
low\nbit
Text Notes 9300 2450 2    50   ~ 0
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
L power:GND #PWR033
U 1 1 5EA36479
P 5450 2950
F 0 "#PWR033" H 5450 2700 50  0001 C CNN
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
F 2 "" H 7150 4000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS139" H 7150 4000 50  0001 C CNN
	1    7150 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8150 4850 7650 4850
Wire Wire Line
	8150 2250 8150 4850
Wire Wire Line
	7650 4750 9700 4750
Wire Wire Line
	6000 5100 6250 5100
Wire Wire Line
	6250 5100 6250 4200
Wire Wire Line
	6250 4200 6650 4200
Wire Wire Line
	6000 5300 6250 5300
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
L 74xx:74LS74 U4
U 2 1 5EC37612
P 5700 3900
F 0 "U4" H 5450 3650 50  0000 C CNN
F 1 "74LS74" H 5450 3550 50  0000 C CNN
F 2 "" H 5700 3900 50  0001 C CNN
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
L Connector_Generic:Conn_02x03_Odd_Even J5
U 1 1 5EC42B6B
P 5650 2850
F 0 "J5" H 5700 3167 50  0000 C CNN
F 1 "RAM bank" H 5700 3076 50  0000 C CNN
F 2 "" H 5650 2850 50  0001 C CNN
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
L power:+5V #PWR027
U 1 1 5EC51CBA
P 5450 2550
F 0 "#PWR027" H 5450 2400 50  0001 C CNN
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
L Transistor_BJT:BC547 Q1
U 1 1 5EC5F23E
P 5200 1900
F 0 "Q1" H 5391 1946 50  0000 L CNN
F 1 "BC547" H 5391 1855 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 5400 1825 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 5200 1900 50  0001 L CNN
	1    5200 1900
	-1   0    0    -1  
$EndComp
$Comp
L power:+5V #PWR010
U 1 1 5EC5F244
P 5100 1100
F 0 "#PWR010" H 5100 950 50  0001 C CNN
F 1 "+5V" H 5115 1273 50  0000 C CNN
F 2 "" H 5100 1100 50  0001 C CNN
F 3 "" H 5100 1100 50  0001 C CNN
	1    5100 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D2
U 1 1 5EC5F24A
P 5100 1250
F 0 "D2" H 5093 1466 50  0000 C CNN
F 1 "LED" H 5093 1375 50  0000 C CNN
F 2 "" H 5100 1250 50  0001 C CNN
F 3 "~" H 5100 1250 50  0001 C CNN
	1    5100 1250
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R1
U 1 1 5EC5F250
P 5100 1550
F 0 "R1" V 5307 1550 50  0000 C CNN
F 1 "470" V 5216 1550 50  0000 C CNN
F 2 "" V 5030 1550 50  0001 C CNN
F 3 "~" H 5100 1550 50  0001 C CNN
	1    5100 1550
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR015
U 1 1 5EC5F256
P 5100 2100
F 0 "#PWR015" H 5100 1850 50  0001 C CNN
F 1 "GND" H 5105 1927 50  0000 C CNN
F 2 "" H 5100 2100 50  0001 C CNN
F 3 "" H 5100 2100 50  0001 C CNN
	1    5100 2100
	1    0    0    -1  
$EndComp
$Comp
L Device:R R10
U 1 1 5EC5F25C
P 5650 1900
F 0 "R10" V 5857 1900 50  0000 C CNN
F 1 "10k" V 5766 1900 50  0000 C CNN
F 2 "" V 5580 1900 50  0001 C CNN
F 3 "~" H 5650 1900 50  0001 C CNN
	1    5650 1900
	0    -1   -1   0   
$EndComp
Text Notes 5300 1200 2    50   ~ 0
high\nbit
Wire Wire Line
	5400 1900 5500 1900
Wire Wire Line
	5800 1900 5950 1900
Wire Wire Line
	5950 1900 5950 2750
Connection ~ 5950 2750
Text Notes 5200 3650 0    50   ~ 0
RAM bank\nselect FF
NoConn ~ 6000 4000
$Comp
L power:+5V #PWR0101
U 1 1 5EC7EA5C
P 5700 3600
F 0 "#PWR0101" H 5700 3450 50  0001 C CNN
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
L Device:CP C3
U 1 1 5EFF5AEE
P 2500 2450
F 0 "C3" H 2618 2496 50  0000 L CNN
F 1 "10uF" H 2618 2405 50  0000 L CNN
F 2 "" H 2538 2300 50  0001 C CNN
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
Wire Wire Line
	9700 2950 9700 4750
Wire Wire Line
	9700 2950 10000 2950
Wire Wire Line
	4450 2300 4450 4200
Wire Wire Line
	4450 4200 4450 4400
Connection ~ 4450 4200
Wire Wire Line
	3850 4300 3400 4300
Wire Wire Line
	3400 4150 3400 4300
Wire Wire Line
	6250 5750 6600 5750
Wire Wire Line
	6250 5300 6250 5750
Text Notes 7900 5900 0    50   ~ 0
(ROM enabled)
$EndSCHEMATC
