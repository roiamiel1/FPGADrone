`timescale 1ns / 1ps

`include "signal_def.v"
`include "../../build/hardware/tests/instruction_set_test/tb_test_code.v"
`include "../../build/hardware/tests/instruction_set_test/rom_switch_case.v"

module TESTBENCH;
    reg clk = 0;
    wire uart_tx_out;

    // Clock generation: 27MHz -> Period ≈ 37.037 ns
    always #18.518 clk = ~clk;  // Half-period

    // SD card stuff
    wire sdclk;
    tri sdcmd;
    wire [3:0] sddat;
    wire rom_req;
    wire [39:0] rom_addr;
    reg [15:0] rom_data;

    // Memory declaration: (16384 x 4) x 8 bits
    reg [7:0] InternalMem [0:65536];

    MIPS_R2000 U_MIPS_R2000(
        .clk(clk),
        .rst(1'b0),
        .sdclk(sdclk),
        .sdcmd(sdcmd),
        .sddat0(sddat[0]),
        .uart_tx_out(uart_tx_out)
    );
    
    sd_fake sd_fake_i (
        .rstn_async(1'b1),
        .sdclk(sdclk),
        .sdcmd(sdcmd),
        .sddat(sddat),
        .rdreq(rom_req),
        .rdaddr(rom_addr),
        .rddata(rom_data),
        .show_status_bits(                ),
        .show_sdcmd_en   (                ),
        .show_sdcmd_cmd  (                ),
        .show_sdcmd_arg  (                )
    );

    `TEST_CODE
    
    // Fake content of the fake SD card
    always @ (posedge sdclk) begin
        if (rom_req) begin
            case (rom_addr)
                `ROM_SWITCH_CASE
            endcase
        end
    end
endmodule
