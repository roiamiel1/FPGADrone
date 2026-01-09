`timescale 1ns / 1ps

module EXMEMReg (
    input clk,
    input rst,
    input HazardFlush,

    // Debugging instruction
    input  [31:0] Instr_in,
    output [31:0] Instr_out,

    // MEM signal
    input Branch_in,
    input Jump_in,
    input [31:0] BranchAddress_in,
    input MemRead_in,
    input MemWrite_in,
    input [31:0] Reg2_in,
    input [3:0] SpecialOP_in,

    // WB signal
    input RegWrite_in,

    // ALU signal
    input Zero_in,
    input Sign_in,

    // data
    input wire [31:0] ALU_in,
    input [4:0] WriteBackRegAddr_in,

    // For future branch or jump
    input [31:0] NextPC_in,

    // MEM signal
    output Branch_out,
    output Jump_out,
    output [31:0] BranchAddress_out,
    output MemRead_out,
    output MemWrite_out,
    output [31:0] Reg2_out,
    output [3:0] SpecialOP_out,

    // WB signal
    output RegWrite_out,

    // ALU signal
    output Zero_out,
    output Sign_out,
    
    // data
    output [31:0] ALU_out,
    output [4:0] WriteBackRegAddr_out,

    // For future branch or jump
    output [31:0] NextPC_out
);
    reg[175:0] StageReg;

    assign {
        Instr_out[31:0],
        Branch_out,
        Jump_out,
        BranchAddress_out[31:0],
        MemRead_out,
        MemWrite_out,
        Reg2_out[31:0],
        SpecialOP_out[3:0],
        RegWrite_out,
        Zero_out,
        Sign_out,
        ALU_out[31:0],
        WriteBackRegAddr_out[4:0],
        NextPC_out[31:0]
    } = StageReg;

    initial begin
        StageReg <= 176'b0;
    end

    always @(posedge clk, posedge rst) begin
        if (rst || HazardFlush)
            StageReg <= 176'b0;
        else begin
            StageReg <= {
                Instr_in[31:0],
                Branch_in,
                Jump_in,
                BranchAddress_in[31:0],
                MemRead_in,
                MemWrite_in,
                Reg2_in[31:0],
                SpecialOP_in[3:0],
                RegWrite_in,
                Zero_in,
                Sign_in,
                ALU_in[31:0],
                WriteBackRegAddr_in[4:0],
                NextPC_in[31:0]
            };
        end
    end

endmodule