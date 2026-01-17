`timescale 1ns / 1ps

module IFIDReg (
    input clk,
    input rst,
    input HazardFlush,
    
    // Debugging instruction
    input  [31:0] Instr_in,
    output [31:0] Instr_out,

    input  [31:0] NextPC_in,
    output [31:0] NextPC_out
);
    reg[63:0] StageReg;

    assign {
        NextPC_out,
        Instr_out
    } = StageReg;

    initial begin
        StageReg <= 64'b0;
    end

    always @(posedge rst, posedge clk) begin
        if (rst || HazardFlush)
            StageReg <= 64'b0;
        else begin
            StageReg <= {
                NextPC_in,
                Instr_in
            };
        end
    end

endmodule