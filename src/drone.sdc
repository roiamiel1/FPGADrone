//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: V1.9.9 Beta-6
//Created Time: 2024-04-23 17:15:42
create_clock -name MicrosecondsUS -period 1000 -waveform {0 500} [get_ports {sys_clk}]
