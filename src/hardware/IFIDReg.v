`timescale 1ns / 1ps

module IFIDReg (
    input clk,
    input rst,
    input HazardFlush,
    
    // Debugging instruction
    input  [31:0] Instr_in,
    output [31:0] Instr_out,

    input  [31:0] PC_in,
    output [31:0] PC_out
);
    reg[95:0] StageReg;

    assign {
        PC_out   [31:0],
        Instr_out[31:0]
    } = StageReg [63:0];

    initial begin
        StageReg <= 96'b0;
    end

    always @(posedge rst, posedge clk) begin
        if (rst || HazardFlush)
            StageReg <= 96'b0;
        else begin
            StageReg[63:0] <= {
                PC_in[31:0],
                Instr_in[31:0]
            };
        end
    end

endmodule