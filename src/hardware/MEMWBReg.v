`timescale 1ns / 1ps

module MEMWBReg (
    input clk,
    input rst,

    // Debugging instruction
    input  [31:0] Instr_in,
    output [31:0] Instr_out,

    // WB signal
    input RegWrite_in,
    input MemRead_in,
    // data
    input [31:0] Mem_in,
    input [31:0] ALU_in,
    input [4:0] WriteBackRegAddr_in,
    // WB signal
    output RegWrite_out,
    output MemRead_out,
    // data
    output [31:0] Mem_out,
    output [31:0] ALU_out,
    output [4:0] WriteBackRegAddr_out
);
    reg[102:0] StageReg;

    assign {
        Instr_out[31:0],
        RegWrite_out,
        MemRead_out,
        Mem_out[31:0],
        ALU_out[31:0],
        WriteBackRegAddr_out[4:0]
    } = StageReg;

    initial begin
        StageReg <= 103'b0;
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            StageReg <= 103'b0;
        else begin
            StageReg <= {
                Instr_in[31:0],
                RegWrite_in,
                MemRead_in,
                Mem_in[31:0],
                ALU_in[31:0],
                WriteBackRegAddr_in[4:0]
            };
        end
    end

endmodule