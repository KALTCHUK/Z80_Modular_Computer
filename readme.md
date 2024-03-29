# Proton - Z80 Modular Computer #

## Licence ##
This project is made public under the terms of the strongly-reciprocal variant of the CERN Open Hardware Licence version 2. By using any part of this project you abide to this licence.

## Overview ##
Two years ago I was searching for some ICs in my component drawers and came across a Z80 CPU and an Intel 8251 USART. I had an instant flashback and remembered my first contact with a microprocessor back in 1982. It was a Z80. After a few minutes of nostalgia I decided to make good use of these components and build a computer. 

Of course I couldn't avoid thinking about this "new project" with my Systems Engineer mindset. So, I established a few initial goals:

- This project is a hobby, so it has to be fun.
- It should use mainly technologies available in the 1980's.
- The computer has to run commercial software.
- The architecture should be modular allowing for new cards with specific functions.
- It also has to be a hardware/software development platform for students, hobbyists and enthusiasts.

After some research I decided to design the hardware fully compatible with CP/M 2.2.

One and a half years later, I finally had my wire wrapped computer running CP/M. I could write programs using WordStar and compile them with BDS C compiler, Microsoft Basic compiler or SLR Z80 macro assembler. It was fun, exciting and challenging. After that, I decided it was time to turn the prototype into a finished product.

It's gratifying to see that in two years, alone, I was able to transform an idea into a commercial product.

The content of this repo is a small portion of the knowledge gathered during these two years developing the Proton Z80 Modular Computer. Most of the information and results are in my logbook - a notebook (paper, not a computer), where I write everything before executing. During this period, I was the system engineer, hardware engineer, software engineer and project manager. Why did it take me so long to complete this project? Because it's a weekend hobby and also because sometimes I had to wait many weeks to receive some components and PCBs.  

Ricardo Kaltchuk

Ashdod - IL, october 2021.

## About the final product. ##

Is it perfect? No. 
Is it state of the art? No. 
Does I meet the initial goal? Yes. 
Am I happy with it? For sure!

## Github directories ##

All directory names are self-explanatory and you'll find a readme file inside each one with some additional info.

## What's most important ##

Well, if you want to build your own Proton Z80 Modular Computer, you'll need to check at least these directories:

- CPM build,
- CPM software,
- KiCAD files,
- Monitor build,
- System manuals (Proton and Monitor) and
- pics.

## You want your own Proton? So follow these steps: ##

1) Order the PCBs. You can order from PCBway and JLC PCB with the codes in the Proton Manual.
2) Buy the components according to the bill of materials in the Proton Manual.
3) Assemble the cards.
4) Download the software from Github.
5) Burn the EEPROM and microcontrollers.
6) Configure the jumpers on the cards according to instructions in the Proton Manual.
7) Assemble the rack (optional) and insert the cards.

Ready to start! Now you can transfer all the CP/M software from your computer to the Proton.

In the Proton User's Manual there's a section called "Building Procedure" which describes in details all the steps listed above. I suggest you read ALL the manual before starting.
