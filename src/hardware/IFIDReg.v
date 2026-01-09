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
    reg[61:0] StageReg;

    assign {
        NextPC_out[31:0],
        Instr_out [31:0]
    } = StageReg;

    initial begin
        StageReg <= 62'b0;
    end

    always @(posedge rst, posedge clk) begin
        if (rst || HazardFlush)
            StageReg <= 62'b0;
        else begin
            StageReg <= {
                NextPC_in[31:0],
                Instr_in [31:0]
            };
        end
    end

endmodule