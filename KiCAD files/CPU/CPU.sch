EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "CPU Card for Z80 Modular Computer"
Date ""
Rev ""
Comp ""
Comment1 "Z80 CPU + clock + reset"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CPU:Z80CPU U3
U 1 1 5DE101B7
P 8700 3300
F 0 "U3" H 8306 4981 50  0000 C CNN
F 1 "Z80CPU" H 8306 4890 50  0000 C CNN
F 2 "" H 8700 3700 50  0001 C CNN
F 3 "www.zilog.com/manage_directlink.php?filepath=docs/z80/um0080" H 8700 3700 50  0001 C CNN
	1    8700 3300
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x05_Odd_Even J1
U 1 1 5DE110BD
P 1500 2450
F 0 "J1" H 1550 2867 50  0000 C CNN
F 1 "Power Bus" H 1550 2776 50  0000 C CNN
F 2 "" H 1500 2450 50  0001 C CNN
F 3 "~" H 1500 2450 50  0001 C CNN
	1    1500 2450
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J2
U 1 1 5DE11A6D
P 2200 4400
F 0 "J2" H 2250 5517 50  0000 C CNN
F 1 "Signal Bus" H 2250 5426 50  0000 C CNN
F 2 "" H 2200 4400 50  0001 C CNN
F 3 "~" H 2200 4400 50  0001 C CNN
	1    2200 4400
	1    0    0    -1  
$EndComp
Text Label 1800 2250 0    50   ~ 0
gnd
Text Label 1800 2350 0    50   ~ 0
+5V
Text Label 1800 2450 0    50   ~ 0
+12V
Text Label 1800 2550 0    50   ~ 0
v1
Text Label 1800 2650 0    50   ~ 0
gnd
Text Label 1300 2250 2    50   ~ 0
gnd
Text Label 1300 2350 2    50   ~ 0
+5V
Text Label 1300 2450 2    50   ~ 0
+12V
Text Label 1300 2550 2    50   ~ 0
v1
Text Label 1300 2650 2    50   ~ 0
gnd
Text Label 2000 3500 2    50   ~ 0
a01
Text Label 2000 3600 2    50   ~ 0
a03
Text Label 2000 3700 2    50   ~ 0
a05
Text Label 2000 3800 2    50   ~ 0
a07
Text Label 2000 3900 2    50   ~ 0
a09
Text Label 2000 4000 2    50   ~ 0
a11
Text Label 2000 4100 2    50   ~ 0
a13
Text Label 2000 4200 2    50   ~ 0
a15
Text Label 2000 4300 2    50   ~ 0
d01
Text Label 2000 4400 2    50   ~ 0
d03
Text Label 2000 4500 2    50   ~ 0
d05
Text Label 2000 4600 2    50   ~ 0
d07
Text Label 2000 4700 2    50   ~ 0
wr
Text Label 2000 4800 2    50   ~ 0
rd
Text Label 2000 4900 2    50   ~ 0
busack
Text Label 2000 5000 2    50   ~ 0
halt
Text Label 2000 5100 2    50   ~ 0
int
Text Label 2000 5200 2    50   ~ 0
s1
Text Label 2000 5300 2    50   ~ 0
m1
Text Label 2000 5400 2    50   ~ 0
clk
Text Label 2500 3500 0    50   ~ 0
a00
Text Label 2500 3600 0    50   ~ 0
a02
Text Label 2500 3700 0    50   ~ 0
a04
Text Label 2500 3800 0    50   ~ 0
a06
Text Label 2500 3900 0    50   ~ 0
a08
Text Label 2500 4000 0    50   ~ 0
a10
Text Label 2500 4100 0    50   ~ 0
a12
Text Label 2500 4200 0    50   ~ 0
a14
Text Label 2500 4300 0    50   ~ 0
d00
Text Label 2500 4400 0    50   ~ 0
d02
Text Label 2500 4500 0    50   ~ 0
d04
Text Label 2500 4600 0    50   ~ 0
d06
Text Label 2500 4700 0    50   ~ 0
mreq
Text Label 2500 4800 0    50   ~ 0
iorq
Text Label 2500 4900 0    50   ~ 0
busrq
Text Label 2500 5000 0    50   ~ 0
wait
Text Label 2500 5100 0    50   ~ 0
nmi
Text Label 2500 5200 0    50   ~ 0
s0
Text Label 2500 5300 0    50   ~ 0
rfsh
Text Label 2500 5400 0    50   ~ 0
reset
Text Label 9400 2100 0    50   ~ 0
a00
Text Label 9400 2200 0    50   ~ 0
a01
Text Label 9400 2300 0    50   ~ 0
a02
Text Label 9400 2400 0    50   ~ 0
a03
Text Label 9400 2500 0    50   ~ 0
a04
Text Label 9400 2600 0    50   ~ 0
a05
Text Label 9400 2700 0    50   ~ 0
a06
Text Label 9400 2800 0    50   ~ 0
a07
Text Label 9400 2900 0    50   ~ 0
a08
Text Label 9400 3000 0    50   ~ 0
a09
Text Label 9400 3100 0    50   ~ 0
a10
Text Label 9400 3200 0    50   ~ 0
a11
Text Label 9400 3300 0    50   ~ 0
a12
Text Label 9400 3400 0    50   ~ 0
a13
Text Label 9400 3500 0    50   ~ 0
a14
Text Label 9400 3600 0    50   ~ 0
a15
Text Label 9400 3800 0    50   ~ 0
d00
Text Label 9400 3900 0    50   ~ 0
d01
Text Label 9400 4000 0    50   ~ 0
d02
Text Label 9400 4100 0    50   ~ 0
d03
Text Label 9400 4200 0    50   ~ 0
d04
Text Label 9400 4300 0    50   ~ 0
d05
Text Label 9400 4400 0    50   ~ 0
d06
Text Label 9400 4500 0    50   ~ 0
d07
Text Label 8000 2700 2    50   ~ 0
nmi
Text Label 8000 2800 2    50   ~ 0
int
Text Label 8000 3300 2    50   ~ 0
wait
Text Label 8000 3400 2    50   ~ 0
halt
Text Label 8000 4400 2    50   ~ 0
busrq
Text Label 8000 4500 2    50   ~ 0
busack
$Comp
L power:GND #PWR08
U 1 1 5E3474E1
P 8700 4800
F 0 "#PWR08" H 8700 4550 50  0001 C CNN
F 1 "GND" H 8705 4627 50  0000 C CNN
F 2 "" H 8700 4800 50  0001 C CNN
F 3 "" H 8700 4800 50  0001 C CNN
	1    8700 4800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR07
U 1 1 5E347F82
P 8700 1600
F 0 "#PWR07" H 8700 1450 50  0001 C CNN
F 1 "+5V" H 8715 1773 50  0000 C CNN
F 2 "" H 8700 1600 50  0001 C CNN
F 3 "" H 8700 1600 50  0001 C CNN
	1    8700 1600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR01
U 1 1 5E34AA96
P 2300 2050
F 0 "#PWR01" H 2300 1900 50  0001 C CNN
F 1 "+5V" H 2315 2223 50  0000 C CNN
F 2 "" H 2300 2050 50  0001 C CNN
F 3 "" H 2300 2050 50  0001 C CNN
	1    2300 2050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5E34BF5A
P 2300 2750
F 0 "#PWR02" H 2300 2500 50  0001 C CNN
F 1 "GND" H 2305 2577 50  0000 C CNN
F 2 "" H 2300 2750 50  0001 C CNN
F 3 "" H 2300 2750 50  0001 C CNN
	1    2300 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 2750 2300 2650
Wire Wire Line
	2300 2650 1800 2650
Wire Wire Line
	2300 2050 2300 2350
Wire Wire Line
	2300 2350 1800 2350
NoConn ~ 2000 5200
NoConn ~ 2500 5200
$Comp
L 74xx:74LS00 U1
U 1 1 5E3503C0
P 3850 2350
F 0 "U1" H 3850 2675 50  0000 C CNN
F 1 "74LS00" H 3850 2584 50  0000 C CNN
F 2 "" H 3850 2350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 3850 2350 50  0001 C CNN
	1    3850 2350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS00 U1
U 2 1 5E351A86
P 4750 2250
F 0 "U1" H 4750 2575 50  0000 C CNN
F 1 "74LS00" H 4750 2484 50  0000 C CNN
F 2 "" H 4750 2250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 4750 2250 50  0001 C CNN
	2    4750 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5E354E74
P 4750 2700
F 0 "R2" V 4957 2700 50  0000 C CNN
F 1 "330R" V 4866 2700 50  0000 C CNN
F 2 "" V 4680 2700 50  0001 C CNN
F 3 "~" H 4750 2700 50  0001 C CNN
	1    4750 2700
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R1
U 1 1 5E3559CA
P 3800 2800
F 0 "R1" V 4007 2800 50  0000 C CNN
F 1 "330R" V 3916 2800 50  0000 C CNN
F 2 "" V 3730 2800 50  0001 C CNN
F 3 "~" H 3800 2800 50  0001 C CNN
	1    3800 2800
	0    -1   -1   0   
$EndComp
$Comp
L Device:Crystal_Small Y1
U 1 1 5E35DD18
P 4300 3050
F 0 "Y1" H 4300 3250 50  0000 C CNN
F 1 "4MHz" H 4300 3150 50  0000 C CNN
F 2 "" H 4300 3050 50  0001 C CNN
F 3 "~" H 4300 3050 50  0001 C CNN
	1    4300 3050
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 5E35F358
P 3550 3350
F 0 "C1" H 3665 3396 50  0000 L CNN
F 1 "22p" H 3665 3305 50  0000 L CNN
F 2 "" H 3588 3200 50  0001 C CNN
F 3 "~" H 3550 3350 50  0001 C CNN
	1    3550 3350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 5E365D8F
P 3550 3500
F 0 "#PWR03" H 3550 3250 50  0001 C CNN
F 1 "GND" H 3555 3327 50  0000 C CNN
F 2 "" H 3550 3500 50  0001 C CNN
F 3 "" H 3550 3500 50  0001 C CNN
	1    3550 3500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 5E399443
P 6200 1450
F 0 "R4" H 6270 1496 50  0000 L CNN
F 1 "10k" H 6270 1405 50  0000 L CNN
F 2 "" V 6130 1450 50  0001 C CNN
F 3 "~" H 6200 1450 50  0001 C CNN
	1    6200 1450
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 5E399F34
P 5950 1200
F 0 "R3" V 6157 1200 50  0000 C CNN
F 1 "100" V 6066 1200 50  0000 C CNN
F 2 "" V 5880 1200 50  0001 C CNN
F 3 "~" H 5950 1200 50  0001 C CNN
	1    5950 1200
	0    -1   -1   0   
$EndComp
$Comp
L Diode:1N4148 D1
U 1 1 5E39EA66
P 6500 1450
F 0 "D1" V 6454 1529 50  0000 L CNN
F 1 "1N4148" V 6545 1529 50  0000 L CNN
F 2 "Diode_THT:D_DO-35_SOD27_P7.62mm_Horizontal" H 6500 1275 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/d-sheet/1N4148_1N4448.pdf" H 6500 1450 50  0001 C CNN
	1    6500 1450
	0    1    1    0   
$EndComp
Wire Wire Line
	6100 1200 6200 1200
Connection ~ 6200 1200
$Comp
L power:+5V #PWR05
U 1 1 5E3A301B
P 6200 800
F 0 "#PWR05" H 6200 650 50  0001 C CNN
F 1 "+5V" H 6215 973 50  0000 C CNN
F 2 "" H 6200 800 50  0001 C CNN
F 3 "" H 6200 800 50  0001 C CNN
	1    6200 800 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR06
U 1 1 5E3A564C
P 6200 1700
F 0 "#PWR06" H 6200 1450 50  0001 C CNN
F 1 "GND" H 6205 1527 50  0000 C CNN
F 2 "" H 6200 1700 50  0001 C CNN
F 3 "" H 6200 1700 50  0001 C CNN
	1    6200 1700
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x02 J3
U 1 1 5E3A7ED6
P 5350 1200
F 0 "J3" H 5268 1417 50  0000 C CNN
F 1 "reset button" H 5268 1326 50  0000 C CNN
F 2 "" H 5350 1200 50  0001 C CNN
F 3 "~" H 5350 1200 50  0001 C CNN
	1    5350 1200
	-1   0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5E3C8BDE
P 1550 1200
F 0 "#FLG0101" H 1550 1275 50  0001 C CNN
F 1 "PWR_FLAG" H 1550 1373 50  0000 C CNN
F 2 "" H 1550 1200 50  0001 C CNN
F 3 "~" H 1550 1200 50  0001 C CNN
	1    1550 1200
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5E3C9F2A
P 2500 1200
F 0 "#FLG0102" H 2500 1275 50  0001 C CNN
F 1 "PWR_FLAG" H 2500 1373 50  0000 C CNN
F 2 "" H 2500 1200 50  0001 C CNN
F 3 "~" H 2500 1200 50  0001 C CNN
	1    2500 1200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5E3CA8BD
P 2500 1300
F 0 "#PWR0101" H 2500 1050 50  0001 C CNN
F 1 "GND" H 2505 1127 50  0000 C CNN
F 2 "" H 2500 1300 50  0001 C CNN
F 3 "" H 2500 1300 50  0001 C CNN
	1    2500 1300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0102
U 1 1 5E3CB5D9
P 1850 1200
F 0 "#PWR0102" H 1850 1050 50  0001 C CNN
F 1 "+5V" H 1865 1373 50  0000 C CNN
F 2 "" H 1850 1200 50  0001 C CNN
F 3 "" H 1850 1200 50  0001 C CNN
	1    1850 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 1200 1550 1350
Wire Wire Line
	1550 1350 1850 1350
Wire Wire Line
	1850 1350 1850 1200
Wire Wire Line
	2500 1200 2500 1300
$Comp
L Device:C C4
U 1 1 5E3D39D4
P 9000 1700
F 0 "C4" V 9252 1700 50  0000 C CNN
F 1 "10n" V 9161 1700 50  0000 C CNN
F 2 "" H 9038 1550 50  0001 C CNN
F 3 "~" H 9000 1700 50  0001 C CNN
	1    9000 1700
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR04
U 1 1 5E3D7E97
P 9250 1700
F 0 "#PWR04" H 9250 1450 50  0001 C CNN
F 1 "GND" H 9255 1527 50  0000 C CNN
F 2 "" H 9250 1700 50  0001 C CNN
F 3 "" H 9250 1700 50  0001 C CNN
	1    9250 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	8700 1600 8700 1700
Wire Wire Line
	9250 1700 9150 1700
Wire Wire Line
	8850 1700 8700 1700
Connection ~ 8700 1700
Wire Wire Line
	8700 1700 8700 1800
$Comp
L 74xx:74LS74 U4
U 1 1 5E5A7BF0
P 6400 3100
F 0 "U4" H 6150 3500 50  0000 C CNN
F 1 "74LS74" H 6150 3400 50  0000 C CNN
F 2 "" H 6400 3100 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 6400 3100 50  0001 C CNN
	1    6400 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 3100 6100 3100
Wire Wire Line
	6100 3000 6000 3000
Wire Wire Line
	6000 3000 6000 3600
Wire Wire Line
	6000 3600 6700 3600
Wire Wire Line
	6700 3600 6700 3200
$Comp
L power:+5V #PWR09
U 1 1 5E5B027D
P 6400 2800
F 0 "#PWR09" H 6400 2650 50  0001 C CNN
F 1 "+5V" H 6500 2900 50  0000 C CNN
F 2 "" H 6400 2800 50  0001 C CNN
F 3 "" H 6400 2800 50  0001 C CNN
	1    6400 2800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR010
U 1 1 5E5B0DC3
P 6400 3400
F 0 "#PWR010" H 6400 3250 50  0001 C CNN
F 1 "+5V" V 6415 3573 50  0000 C CNN
F 2 "" H 6400 3400 50  0001 C CNN
F 3 "" H 6400 3400 50  0001 C CNN
	1    6400 3400
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5550 1200 5800 1200
$Comp
L 74xx:74LS74 U4
U 2 1 5E632ACD
P 7150 3100
F 0 "U4" H 6900 3500 50  0000 C CNN
F 1 "74LS74" H 6900 3400 50  0000 C CNN
F 2 "" H 7150 3100 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 7150 3100 50  0001 C CNN
	2    7150 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6700 3000 6700 3100
Wire Wire Line
	6700 3100 6850 3100
Wire Wire Line
	6850 3000 6800 3000
Wire Wire Line
	6800 3000 6800 3600
Wire Wire Line
	6800 3600 7450 3600
Wire Wire Line
	7450 3600 7450 3200
$Comp
L power:+5V #PWR011
U 1 1 5E639152
P 7150 2800
F 0 "#PWR011" H 7150 2650 50  0001 C CNN
F 1 "+5V" H 7250 2900 50  0000 C CNN
F 2 "" H 7150 2800 50  0001 C CNN
F 3 "" H 7150 2800 50  0001 C CNN
	1    7150 2800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR012
U 1 1 5E639CC5
P 7150 3400
F 0 "#PWR012" H 7150 3250 50  0001 C CNN
F 1 "+5V" V 7165 3528 50  0000 L CNN
F 2 "" H 7150 3400 50  0001 C CNN
F 3 "" H 7150 3400 50  0001 C CNN
	1    7150 3400
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_02x03_Top_Bottom J4
U 1 1 5E640B5B
P 6650 2250
F 0 "J4" H 6700 2567 50  0000 C CNN
F 1 "clock rate" H 6700 2476 50  0000 C CNN
F 2 "" H 6650 2250 50  0001 C CNN
F 3 "~" H 6650 2250 50  0001 C CNN
	1    6650 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 2250 6050 2600
Wire Wire Line
	6050 2600 6700 2600
Wire Wire Line
	6700 2600 6700 3000
Connection ~ 6700 3000
Wire Wire Line
	6200 2350 6200 2500
Wire Wire Line
	6200 2500 7450 2500
Wire Wire Line
	7450 2500 7450 3000
Wire Wire Line
	6950 2150 6950 2250
Wire Wire Line
	6950 2250 6950 2350
Connection ~ 6950 2250
Wire Wire Line
	8000 2250 8000 2400
Wire Wire Line
	5900 3100 5900 2150
$Comp
L 74xx:74LS00 U1
U 5 1 5E65AC95
P 4650 6550
F 0 "U1" H 4880 6596 50  0000 L CNN
F 1 "74LS00" H 4880 6505 50  0000 L CNN
F 2 "" H 4650 6550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 4650 6550 50  0001 C CNN
	5    4650 6550
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS74 U4
U 3 1 5E65DE93
P 5550 6550
F 0 "U4" H 5780 6596 50  0000 L CNN
F 1 "74LS74" H 5780 6505 50  0000 L CNN
F 2 "" H 5550 6550 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 5550 6550 50  0001 C CNN
	3    5550 6550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 6050 5550 6050
Wire Wire Line
	4650 7050 5550 7050
$Comp
L power:+5V #PWR013
U 1 1 5E670778
P 5550 6050
F 0 "#PWR013" H 5550 5900 50  0001 C CNN
F 1 "+5V" H 5565 6223 50  0000 C CNN
F 2 "" H 5550 6050 50  0001 C CNN
F 3 "" H 5550 6050 50  0001 C CNN
	1    5550 6050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR014
U 1 1 5E67141E
P 5550 7050
F 0 "#PWR014" H 5550 6800 50  0001 C CNN
F 1 "GND" H 5555 6877 50  0000 C CNN
F 2 "" H 5550 7050 50  0001 C CNN
F 3 "" H 5550 7050 50  0001 C CNN
	1    5550 7050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 5E6B9516
P 3050 4600
F 0 "R5" H 3120 4646 50  0000 L CNN
F 1 "8k2" H 3120 4555 50  0000 L CNN
F 2 "" V 2980 4600 50  0001 C CNN
F 3 "~" H 3050 4600 50  0001 C CNN
	1    3050 4600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R6
U 1 1 5E6BBDBF
P 3350 4600
F 0 "R6" H 3420 4646 50  0000 L CNN
F 1 "8k2" H 3420 4555 50  0000 L CNN
F 2 "" V 3280 4600 50  0001 C CNN
F 3 "~" H 3350 4600 50  0001 C CNN
	1    3350 4600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R7
U 1 1 5E6BE77A
P 3650 4600
F 0 "R7" H 3720 4646 50  0000 L CNN
F 1 "8k2" H 3720 4555 50  0000 L CNN
F 2 "" V 3580 4600 50  0001 C CNN
F 3 "~" H 3650 4600 50  0001 C CNN
	1    3650 4600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R8
U 1 1 5E6C1910
P 3950 4600
F 0 "R8" H 4020 4646 50  0000 L CNN
F 1 "8k2" H 4020 4555 50  0000 L CNN
F 2 "" V 3880 4600 50  0001 C CNN
F 3 "~" H 3950 4600 50  0001 C CNN
	1    3950 4600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 4900 3050 4900
Wire Wire Line
	3050 4750 3050 4900
Wire Wire Line
	3350 4750 3350 5000
Wire Wire Line
	3650 4750 3650 5100
$Comp
L power:+5V #PWR016
U 1 1 5E6F3954
P 3950 4350
F 0 "#PWR016" H 3950 4200 50  0001 C CNN
F 1 "+5V" H 3965 4523 50  0000 C CNN
F 2 "" H 3950 4350 50  0001 C CNN
F 3 "" H 3950 4350 50  0001 C CNN
	1    3950 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 5100 3650 5100
Wire Wire Line
	2500 5000 3350 5000
Wire Wire Line
	3050 4450 3050 4400
Wire Wire Line
	3050 4400 3350 4400
Wire Wire Line
	3650 4400 3650 4450
Wire Wire Line
	3350 4450 3350 4400
Connection ~ 3350 4400
Wire Wire Line
	3350 4400 3650 4400
$Comp
L Device:C C2
U 1 1 5E35E6E4
P 4300 2350
F 0 "C2" V 4550 2300 50  0000 L CNN
F 1 "100n" V 4450 2250 50  0000 L CNN
F 2 "" H 4338 2200 50  0001 C CNN
F 3 "~" H 4300 2350 50  0001 C CNN
	1    4300 2350
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS00 U1
U 3 1 5E80D8F7
P 5600 2150
F 0 "U1" H 5600 2475 50  0000 C CNN
F 1 "74LS00" H 5600 2384 50  0000 C CNN
F 2 "" H 5600 2150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 5600 2150 50  0001 C CNN
	3    5600 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3550 3200 3550 3050
Wire Wire Line
	3650 2800 3550 2800
Connection ~ 3550 2800
Wire Wire Line
	3550 2800 3550 2450
Wire Wire Line
	3950 2800 4150 2800
Wire Wire Line
	4150 2800 4150 2350
Connection ~ 4150 2350
Wire Wire Line
	4600 2700 4450 2700
Wire Wire Line
	4450 2700 4450 2350
Connection ~ 4450 2350
Wire Wire Line
	5050 2250 5050 2700
Wire Wire Line
	5050 2700 4900 2700
Wire Wire Line
	5050 2250 5300 2250
Connection ~ 5050 2250
Wire Wire Line
	4200 3050 3550 3050
Connection ~ 3550 3050
Wire Wire Line
	3550 3050 3550 2800
Wire Wire Line
	4400 3050 5050 3050
Wire Wire Line
	5050 3050 5050 2700
Connection ~ 5050 2700
Connection ~ 5900 2150
Text Notes 6350 2150 0    50   ~ 0
f
Text Notes 6300 2250 0    50   ~ 0
f/2
Text Notes 6300 2350 0    50   ~ 0
f/4
Wire Wire Line
	3950 4750 3950 5550
Wire Wire Line
	3950 5550 1550 5550
Wire Wire Line
	1550 5550 1550 5100
Wire Wire Line
	1550 5100 2000 5100
Wire Wire Line
	3650 4400 3950 4400
Wire Wire Line
	3950 4400 3950 4450
Connection ~ 3650 4400
Wire Wire Line
	3950 4350 3950 4400
Connection ~ 3950 4400
Text Label 8000 3800 2    50   ~ 0
rd
Text Label 8000 3900 2    50   ~ 0
wr
Text Label 8000 4000 2    50   ~ 0
mreq
Text Label 8000 2400 2    50   ~ 0
clk
Text Label 8000 2100 2    50   ~ 0
reset
Wire Wire Line
	5550 6150 5550 6050
Connection ~ 5550 6050
Wire Wire Line
	5550 6950 5550 7050
Connection ~ 5550 7050
Text Label 8000 4100 2    50   ~ 0
iorq
Wire Wire Line
	6950 2250 8000 2250
Wire Wire Line
	5900 2150 6450 2150
Wire Wire Line
	6050 2250 6450 2250
Wire Wire Line
	6450 2350 6200 2350
Text Label 8000 3100 2    50   ~ 0
m1
Text Label 8000 3200 2    50   ~ 0
rfsh
Wire Wire Line
	5300 2050 5300 2250
Connection ~ 5300 2250
Wire Wire Line
	4450 2150 4450 2350
Wire Wire Line
	3550 2250 3550 2450
Connection ~ 3550 2450
$Comp
L Device:CP C5
U 1 1 5EFE3FDA
P 2300 2500
F 0 "C5" H 2418 2546 50  0000 L CNN
F 1 "10uF" H 2418 2455 50  0000 L CNN
F 2 "" H 2338 2350 50  0001 C CNN
F 3 "~" H 2300 2500 50  0001 C CNN
	1    2300 2500
	1    0    0    -1  
$EndComp
Connection ~ 2300 2350
Connection ~ 2300 2650
$Comp
L power:GND #PWR015
U 1 1 5EFE592A
P 5550 1400
F 0 "#PWR015" H 5550 1150 50  0001 C CNN
F 1 "GND" H 5555 1227 50  0000 C CNN
F 2 "" H 5550 1400 50  0001 C CNN
F 3 "" H 5550 1400 50  0001 C CNN
	1    5550 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 1300 5550 1400
$Comp
L Transistor_BJT:BC328 Q1
U 1 1 5F30EBE9
P 6300 4400
F 0 "Q1" H 6491 4354 50  0000 L CNN
F 1 "BC328" H 6491 4445 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 6500 4325 50  0001 L CIN
F 3 "http://www.redrok.com/PNP_BC327_-45V_-800mA_0.625W_Hfe100_TO-92.pdf" H 6300 4400 50  0001 L CNN
	1    6300 4400
	-1   0    0    1   
$EndComp
$Comp
L Device:R R9
U 1 1 5F316219
P 6200 4750
F 0 "R9" H 6270 4796 50  0000 L CNN
F 1 "3.3k" H 6270 4705 50  0000 L CNN
F 2 "" V 6130 4750 50  0001 C CNN
F 3 "~" H 6200 4750 50  0001 C CNN
	1    6200 4750
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D2
U 1 1 5F31708F
P 6200 5050
F 0 "D2" V 6250 5200 50  0000 C CNN
F 1 "LED" V 6150 5200 50  0000 C CNN
F 2 "" H 6200 5050 50  0001 C CNN
F 3 "~" H 6200 5050 50  0001 C CNN
	1    6200 5050
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R10
U 1 1 5F318E5E
P 6650 4400
F 0 "R10" V 6850 4350 50  0000 L CNN
F 1 "180" V 6750 4350 50  0000 L CNN
F 2 "" V 6580 4400 50  0001 C CNN
F 3 "~" H 6650 4400 50  0001 C CNN
	1    6650 4400
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR018
U 1 1 5F3288C7
P 6200 5300
F 0 "#PWR018" H 6200 5050 50  0001 C CNN
F 1 "GND" H 6205 5127 50  0000 C CNN
F 2 "" H 6200 5300 50  0001 C CNN
F 3 "" H 6200 5300 50  0001 C CNN
	1    6200 5300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR017
U 1 1 5F32B519
P 6200 4100
F 0 "#PWR017" H 6200 3950 50  0001 C CNN
F 1 "+5V" H 6215 4273 50  0000 C CNN
F 2 "" H 6200 4100 50  0001 C CNN
F 3 "" H 6200 4100 50  0001 C CNN
	1    6200 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6200 4100 6200 4200
Wire Wire Line
	6200 5200 6200 5300
Wire Wire Line
	8000 3400 7550 3400
Wire Wire Line
	7550 3400 7550 4400
Wire Wire Line
	7550 4400 6800 4400
Text Notes 6350 5100 0    50   ~ 0
CPU halted
$Comp
L 74xx:74LS00 U1
U 4 1 5F33B6E6
P 7150 1200
F 0 "U1" H 7150 1525 50  0000 C CNN
F 1 "74LS00" H 7150 1434 50  0000 C CNN
F 2 "" H 7150 1200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 7150 1200 50  0001 C CNN
	4    7150 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	6850 1100 6850 1200
Connection ~ 6850 1200
Wire Wire Line
	6850 1200 6850 1300
Wire Wire Line
	7650 2100 8000 2100
Wire Wire Line
	6200 1200 6200 1300
Wire Wire Line
	6200 1200 6500 1200
Wire Wire Line
	6500 1300 6500 1200
Connection ~ 6500 1200
Wire Wire Line
	6500 1200 6850 1200
Wire Wire Line
	6200 1100 6200 1200
Wire Wire Line
	6200 1650 6500 1650
Wire Wire Line
	6500 1650 6500 1600
Wire Wire Line
	6200 1600 6200 1650
Wire Wire Line
	6200 1700 6200 1650
Connection ~ 6200 1650
Wire Wire Line
	7450 1200 7650 1200
Wire Wire Line
	7650 1200 7650 2100
$Comp
L Device:CP C3
U 1 1 5F38F7A8
P 6200 950
F 0 "C3" H 6318 996 50  0000 L CNN
F 1 "10uF" H 6318 905 50  0000 L CNN
F 2 "" H 6238 800 50  0001 C CNN
F 3 "~" H 6200 950 50  0001 C CNN
	1    6200 950 
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D3
U 1 1 60CBC165
P 3800 1300
F 0 "D3" V 3850 1450 50  0000 C CNN
F 1 "LED" V 3750 1450 50  0000 C CNN
F 2 "" H 3800 1300 50  0001 C CNN
F 3 "~" H 3800 1300 50  0001 C CNN
	1    3800 1300
	0    -1   -1   0   
$EndComp
Text Notes 3950 1350 0    50   ~ 0
Power On
$Comp
L power:GND #PWR020
U 1 1 60CBEDD9
P 3800 1550
F 0 "#PWR020" H 3800 1300 50  0001 C CNN
F 1 "GND" H 3805 1377 50  0000 C CNN
F 2 "" H 3800 1550 50  0001 C CNN
F 3 "" H 3800 1550 50  0001 C CNN
	1    3800 1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3800 1550 3800 1450
$Comp
L Device:R R11
U 1 1 60CC4F5F
P 3800 1000
F 0 "R11" H 3870 1046 50  0000 L CNN
F 1 "270" H 3870 955 50  0000 L CNN
F 2 "" V 3730 1000 50  0001 C CNN
F 3 "~" H 3800 1000 50  0001 C CNN
	1    3800 1000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR019
U 1 1 60CC8077
P 3800 850
F 0 "#PWR019" H 3800 700 50  0001 C CNN
F 1 "+5V" H 3815 1023 50  0000 C CNN
F 2 "" H 3800 850 50  0001 C CNN
F 3 "" H 3800 850 50  0001 C CNN
	1    3800 850 
	1    0    0    -1  
$EndComp
$EndSCHEMATC
