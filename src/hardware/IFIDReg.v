`timescale 1ns / 1ps

module IFIDReg (
    input clk,
    input rst,
    input HazardFlush,
    
    // data
    input[31:0] PC_in,
    input[31:0] Instr_in,

    // data
    output[31:0]PC_out,
    output[31:0]Instr_out
);

    // 64 bit
    reg[63:0] StageReg;
    assign {
        PC_out   [31:0],
        Instr_out[31:0]
    } = StageReg [63:0];

    initial begin
        StageReg <= 64'b0;
    end

    always @(posedge rst, posedge clk) begin
        if (rst || HazardFlush)
            StageReg <= 64'b0;
        else begin
            StageReg[63:0] <= {
                PC_in[31:0],
                Instr_in[31:0]
            };
        end
    end

endmodule