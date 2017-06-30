# RISCME
Reduced Instruction Cortex M Educational


Jesus Cristo é o Senhor.

Jesus Christ is the Lord.

This a kind of Educational Kit for Computer Engineering Students .


Its an Very Simple Cortex M0 ARMV6-M architecture Single Cycle  (same architecture)  ultra ultra ultra risc open source processor, with only nine 16 bit opcode main instructions: adds,subs,ands,orrs,ldrs,str, bx, blx . It too supports ands,orrs,adds and subs, besides the useful arm conditions like beq or bne for example.

For more information about this micro architecture, please read ppt inside docs folder.

An part of the System Verilog modules sources cames from the book Computer Design Arm Edition of Harris and Harris . Essentialy, its everything in https://github.com/jardelufc/ARM7XilinxBasys3DesignKit/blob/master/ARM7-DesignKit/EXAMPLE_SoC/ARMSOC_1/arm_single.sv .

Before starting, you are supposed to install, in Rwindow$ OS, the free version of  Vivado (webpack) , MDK Keil and Mdk Keil Support for CM0DSK .

After the installation, you are ready to go:

1. Open the  	mycm0code.uvprojx mdk keil project in folder Software . Remember using only the nine implemented instructions and its derivations . Type F7 and F7 again for compiling and automatically generating (it calls fromelf and hex2sv programs) the system verilog ready for synthesis code memory imem.sv and ahbrom.sv. 

2. Open ARMSOC_1.xpr vivado project in Xilinx folder. You can Simulate or generate bit stream and download it to Basys 3 Artix 7 based board from digilent inc .

You have a few code examples in software folder ( .S files) . Creative solutions are needed , because you dont have mov or BL instructions. Look at the examples .

If you want to learn how to add more instructions, please, look lab 9 at https://booksite.elsevier.com/9780128000564/content/labs_companion.zip .


Vivavdo design is configured for running at 10mhz. You can easily increase or decrease it by reconfiguring the clock manager .

There are two AHB Lite bus peripherals: GPIO and Timer .

GPIO reg for defining direction is at 0x804 
GPIO reg for reading or writing pins is at 0x800

At his time, there is at least one bug: You need use str two times for writing at GPIO .

I've never tested the timers . 

You can find a few more AHB Lite peripherals here: https://www.arm.com/files/zip/CM0DS-DesignKit.zip

Enjoy it :) 

