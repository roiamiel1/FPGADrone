//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: V1.9.9 Beta-6
//Created Time: 2025-05-03 20:16:08
create_clock -name SystemClock -period 1000 -waveform {0 500} [get_ports {clk}] -add
create_clock -name UartClock -period 100000 -waveform {0 50000} [get_ports {uart_clk}] -add
