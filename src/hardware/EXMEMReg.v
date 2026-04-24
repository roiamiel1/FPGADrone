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

    // FPU signals
    input FPUWrite_in,
    input [63:0] FPU_in,
    input IsDouble_in,
    input CC_in,            // FP condition code (from FPR, sampled in EX)
    input [31:0] FPR2_in,  // FPR[ft] store data for swc1

    // FPR write address (computed in EX from RegDst)
    input [4:0] FPRWriteAddr_in,

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

    // FPU signals
    output FPUWrite_out,
    output [63:0] FPU_out,
    output IsDouble_out,
    output CC_out,
    output [31:0] FPR2_out,
    output [4:0] FPRWriteAddr_out,

    // For future branch or jump
    output [31:0] NextPC_out
);
    // 176 (original) + 1 (FPUWrite) + 64 (FPU) + 1 (IsDouble) + 1 (CC) + 32 (FPR2) + 5 (FPRWriteAddr) = 280 bits
    reg [279:0] StageReg;

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
        NextPC_out[31:0],
        FPUWrite_out,
        FPU_out[63:0],
        IsDouble_out,
        CC_out,
        FPR2_out[31:0],
        FPRWriteAddr_out[4:0]
    } = StageReg;

    initial begin
        StageReg <= 280'b0;
    end

    always @(posedge clk, posedge rst) begin
        if (rst || HazardFlush)
            StageReg <= 280'b0;
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
                NextPC_in[31:0],
                FPUWrite_in,
                FPU_in[63:0],
                IsDouble_in,
                CC_in,
                FPR2_in[31:0],
                FPRWriteAddr_in[4:0]
            };
        end
    end

endmodule
