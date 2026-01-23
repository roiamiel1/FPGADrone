`timescale 1ns / 1ps

`include "signal_def.v"

module MMIO(
    input clk,
    input rst,

    // Memory API
    input  wire [`MMIO_ADDR_WIDTH - 1:0] MMIO_write_addr,
    input  wire [`MMIO_ADDR_WIDTH - 1:0] MMIO_read_addr,
    input  wire [31:0]                   MMIO_write_data,
    input  wire                          MMIO_write_enable,
    output wire [31:0]                   MMIO_read_data,
);



endmodule