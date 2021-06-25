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
NoConn ~ 13250 1100
$Comp
L Connector_Generic:Conn_02x05_Odd_Even J1
U 1 1 5DE110BD
P 2700 4150
F 0 "J1" H 2750 4567 50  0000 C CNN
F 1 "Power Bus" H 2750 4476 50  0000 C CNN
F 2 "" H 2700 4150 50  0001 C CNN
F 3 "~" H 2700 4150 50  0001 C CNN
	1    2700 4150
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J2
U 1 1 5DE11A6D
P 4750 3650
F 0 "J2" H 4800 4767 50  0000 C CNN
F 1 "Signal Buss" H 4800 4676 50  0000 C CNN
F 2 "" H 4750 3650 50  0001 C CNN
F 3 "~" H 4750 3650 50  0001 C CNN
	1    4750 3650
	1    0    0    -1  
$EndComp
Text Label 3000 3950 0    50   ~ 0
gnd
Text Label 3000 4050 0    50   ~ 0
+5V
Text Label 3000 4150 0    50   ~ 0
+12V
Text Label 3000 4250 0    50   ~ 0
v1
Text Label 3000 4350 0    50   ~ 0
gnd
Text Label 2500 3950 2    50   ~ 0
gnd
Text Label 2500 4050 2    50   ~ 0
+5V
Text Label 2500 4150 2    50   ~ 0
+12V
Text Label 2500 4250 2    50   ~ 0
v1
Text Label 2500 4350 2    50   ~ 0
gnd
Text Label 4550 2750 2    50   ~ 0
a01
Text Label 4550 2850 2    50   ~ 0
a03
Text Label 4550 2950 2    50   ~ 0
a05
Text Label 4550 3050 2    50   ~ 0
a07
Text Label 4550 3150 2    50   ~ 0
a09
Text Label 4550 3250 2    50   ~ 0
a11
Text Label 4550 3350 2    50   ~ 0
a13
Text Label 4550 3450 2    50   ~ 0
a15
Text Label 4550 3550 2    50   ~ 0
d01
Text Label 4550 3650 2    50   ~ 0
d03
Text Label 4550 3750 2    50   ~ 0
d05
Text Label 4550 3850 2    50   ~ 0
d07
Text Label 4550 3950 2    50   ~ 0
wr
Text Label 4550 4050 2    50   ~ 0
rd
Text Label 4550 4150 2    50   ~ 0
busack
Text Label 4550 4250 2    50   ~ 0
halt
Text Label 4550 4350 2    50   ~ 0
int
Text Label 4550 4450 2    50   ~ 0
s1
Text Label 4550 4550 2    50   ~ 0
m1
Text Label 4550 4650 2    50   ~ 0
clk
Text Label 5050 2750 0    50   ~ 0
a00
Text Label 5050 2850 0    50   ~ 0
a02
Text Label 5050 2950 0    50   ~ 0
a04
Text Label 5050 3050 0    50   ~ 0
a06
Text Label 5050 3150 0    50   ~ 0
a08
Text Label 5050 3250 0    50   ~ 0
a10
Text Label 5050 3350 0    50   ~ 0
a12
Text Label 5050 3450 0    50   ~ 0
a14
Text Label 5050 3550 0    50   ~ 0
d00
Text Label 5050 3650 0    50   ~ 0
d02
Text Label 5050 3750 0    50   ~ 0
d04
Text Label 5050 3850 0    50   ~ 0
d06
Text Label 5050 3950 0    50   ~ 0
mreq
Text Label 5050 4050 0    50   ~ 0
iorq
Text Label 5050 4150 0    50   ~ 0
busrq
Text Label 5050 4250 0    50   ~ 0
wait
Text Label 5050 4350 0    50   ~ 0
nmi
Text Label 5050 4450 0    50   ~ 0
s0
Text Label 5050 4550 0    50   ~ 0
s2
$Comp
L power:+5V #PWR03
U 1 1 5E34AA96
P 3500 3750
F 0 "#PWR03" H 3500 3600 50  0001 C CNN
F 1 "+5V" H 3515 3923 50  0000 C CNN
F 2 "" H 3500 3750 50  0001 C CNN
F 3 "" H 3500 3750 50  0001 C CNN
	1    3500 3750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR04
U 1 1 5E34BF5A
P 3500 4450
F 0 "#PWR04" H 3500 4200 50  0001 C CNN
F 1 "GND" H 3505 4277 50  0000 C CNN
F 2 "" H 3500 4450 50  0001 C CNN
F 3 "" H 3500 4450 50  0001 C CNN
	1    3500 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 4450 3500 4350
Wire Wire Line
	3500 4350 3000 4350
Wire Wire Line
	3500 3750 3500 4050
Wire Wire Line
	3500 4050 3000 4050
NoConn ~ 4550 4550
NoConn ~ 4550 4450
NoConn ~ 5050 4450
NoConn ~ 5050 4550
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5E3C8BDE
P 2550 2900
F 0 "#FLG01" H 2550 2975 50  0001 C CNN
F 1 "PWR_FLAG" H 2550 3073 50  0000 C CNN
F 2 "" H 2550 2900 50  0001 C CNN
F 3 "~" H 2550 2900 50  0001 C CNN
	1    2550 2900
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5E3C9F2A
P 3500 2900
F 0 "#FLG02" H 3500 2975 50  0001 C CNN
F 1 "PWR_FLAG" H 3500 3073 50  0000 C CNN
F 2 "" H 3500 2900 50  0001 C CNN
F 3 "~" H 3500 2900 50  0001 C CNN
	1    3500 2900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5E3CA8BD
P 3500 3000
F 0 "#PWR02" H 3500 2750 50  0001 C CNN
F 1 "GND" H 3505 2827 50  0000 C CNN
F 2 "" H 3500 3000 50  0001 C CNN
F 3 "" H 3500 3000 50  0001 C CNN
	1    3500 3000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR01
U 1 1 5E3CB5D9
P 2850 2900
F 0 "#PWR01" H 2850 2750 50  0001 C CNN
F 1 "+5V" H 2865 3073 50  0000 C CNN
F 2 "" H 2850 2900 50  0001 C CNN
F 3 "" H 2850 2900 50  0001 C CNN
	1    2850 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 2900 2550 3050
Wire Wire Line
	2550 3050 2850 3050
Wire Wire Line
	2850 3050 2850 2900
Wire Wire Line
	3500 2900 3500 3000
NoConn ~ 4550 4250
NoConn ~ 5050 4350
NoConn ~ 5050 4250
NoConn ~ 5050 4150
NoConn ~ 4550 4150
NoConn ~ 5050 3150
NoConn ~ 5050 3250
NoConn ~ 5050 3350
NoConn ~ 5050 3450
NoConn ~ 4550 3450
NoConn ~ 4550 3350
NoConn ~ 4550 3250
NoConn ~ 4550 3150
NoConn ~ 4550 2850
NoConn ~ 5050 2850
NoConn ~ 5050 3950
Text Label 5050 4650 0    50   ~ 0
reset
$Comp
L Device:CP C1
U 1 1 5F4D8A65
P 3500 4200
F 0 "C1" H 3618 4246 50  0000 L CNN
F 1 "10uF" H 3618 4155 50  0000 L CNN
F 2 "" H 3538 4050 50  0001 C CNN
F 3 "~" H 3500 4200 50  0001 C CNN
	1    3500 4200
	1    0    0    -1  
$EndComp
Connection ~ 3500 4050
Connection ~ 3500 4350
$Comp
L preTTY-rescue:Arduino_Nano_v3.x-MCU_Module-USARTv2-rescue A1
U 1 1 60CCDAA2
P 7250 3700
F 0 "A1" H 6650 2600 50  0000 C CNN
F 1 "Arduino_Nano_v3.x" H 6650 2450 50  0000 C CNN
F 2 "Module:Arduino_Nano" H 7250 3700 50  0001 C CIN
F 3 "http://www.mouser.com/pdfdocs/Gravitech_Arduino_Nano3_0.pdf" H 7250 3700 50  0001 C CNN
	1    7250 3700
	1    0    0    -1  
$EndComp
Text Label 6750 3300 2    50   ~ 0
d00
Text Label 6750 3400 2    50   ~ 0
d01
Text Label 6750 3500 2    50   ~ 0
d02
Text Label 6750 3600 2    50   ~ 0
d03
Text Label 6750 3700 2    50   ~ 0
d04
Text Label 6750 3800 2    50   ~ 0
d05
Text Label 6750 3900 2    50   ~ 0
d06
Text Label 6750 4000 2    50   ~ 0
d07
Text Label 6750 4100 2    50   ~ 0
a01
Text Label 6750 4200 2    50   ~ 0
rd
Text Label 6750 4300 2    50   ~ 0
wr
Wire Wire Line
	7350 4700 7250 4700
Wire Wire Line
	7750 3100 7750 3200
NoConn ~ 7150 2700
NoConn ~ 7350 2700
$Comp
L power:GND #PWR05
U 1 1 60CEFC17
P 7250 4800
F 0 "#PWR05" H 7250 4550 50  0001 C CNN
F 1 "GND" H 7255 4627 50  0000 C CNN
F 2 "" H 7250 4800 50  0001 C CNN
F 3 "" H 7250 4800 50  0001 C CNN
	1    7250 4800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR06
U 1 1 60CF1BC7
P 7450 2600
F 0 "#PWR06" H 7450 2450 50  0001 C CNN
F 1 "+5V" H 7465 2773 50  0000 C CNN
F 2 "" H 7450 2600 50  0001 C CNN
F 3 "" H 7450 2600 50  0001 C CNN
	1    7450 2600
	1    0    0    -1  
$EndComp
Wire Wire Line
	7450 2600 7450 2700
Wire Wire Line
	7250 4800 7250 4700
Connection ~ 7250 4700
Wire Wire Line
	7750 3100 7850 3100
Connection ~ 7750 3100
Text Label 7850 3100 0    50   ~ 0
reset
NoConn ~ 4550 4350
NoConn ~ 4550 4650
NoConn ~ 7750 4300
NoConn ~ 7750 4400
NoConn ~ 7750 3500
NoConn ~ 7750 4200
NoConn ~ 6750 4400
NoConn ~ 6750 3100
NoConn ~ 6750 3200
Text Label 7750 3700 0    50   ~ 0
a04
Text Label 7750 3800 0    50   ~ 0
a05
Text Label 7750 3900 0    50   ~ 0
a06
Text Label 7750 4000 0    50   ~ 0
a07
Text Label 7750 4100 0    50   ~ 0
iorq
NoConn ~ 5050 2750
$EndSCHEMATC
