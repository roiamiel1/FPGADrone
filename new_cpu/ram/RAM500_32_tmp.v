//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.9.03 Education
//Part Number: GW1NR-LV9QN88PC6/I5
//Device: GW1NR-9
//Device Version: C
//Created Time: Sat Jun 22 14:07:44 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    RAM500_32 your_instance_name(
        .dout(dout), //output [31:0] dout
        .wre(wre), //input wre
        .ad(ad), //input [8:0] ad
        .di(di), //input [31:0] di
        .clk(clk) //input clk
    );

//--------Copy end-------------------
