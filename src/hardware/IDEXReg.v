`timescale 1ns / 1ps

module IDEXReg (
    input clk,
    input rst,
    input HazardFlush,

    // Debugging instruction
    input  [31:0] Instr_in,
    output [31:0] Instr_out,

    // EX signal
    input [31:0] NextPC_in,
    input [1:0] RegDst_in,
    input [4:0] ALUOp_in,
    input ALUSrc_in,
    input [3:0] SpecialOP_in,

    // MEM signal
    input Branch_in,
    input Jump_in,
    input [25:0] JumpAddress_in,
    input MemRead_in,
    input MemWrite_in,

    // WB signal
    input RegWrite_in,

    // FPU signals
    input [5:0] FPUOp_in,
    input FPUWrite_in,

    // data (integer)
    input [31:0] Reg1_in,
    input [31:0] Reg2_in,
    input [31:0] ExtImm_in,
    input [4:0] Rs_in,
    input [4:0] Rt_in,
    input [4:0] Rd_in,

    // data (FP — from FPR read ports)
    input [63:0] FPReg1_in,
    input [63:0] FPReg2_in,

    // EX signal
    output [31:0] NextPC_out,
    output [1:0] RegDst_out,
    output [4:0] ALUOp_out,
    output ALUSrc_out,
    output [3:0] SpecialOP_out,

    // MEM signal
    output Branch_out,
    output Jump_out,
    output [25:0] JumpAddress_out,
    output MemRead_out,
    output MemWrite_out,

    // WB signal
    output RegWrite_out,

    // FPU signals
    output [5:0] FPUOp_out,
    output FPUWrite_out,

    // data (integer)
    output [31:0] Reg1_out,
    output [31:0] Reg2_out,
    output [31:0] ExtImm_out,
    output [4:0] Rs_out,
    output [4:0] Rt_out,
    output [4:0] Rd_out,

    // data (FP)
    output [63:0] FPReg1_out,
    output [63:0] FPReg2_out
);
    // 218 (original) + 6 (FPUOp) + 1 (FPUWrite) + 64 (FPReg1) + 64 (FPReg2) = 353 bits
    reg [352:0] StageReg;

    assign {
        Instr_out[31:0],
        NextPC_out[31:0],
        RegDst_out[1:0],
        ALUOp_out[4:0],
        ALUSrc_out,
        SpecialOP_out[3:0],
        Branch_out,
        Jump_out,
        JumpAddress_out[25:0],
        MemRead_out,
        MemWrite_out,
        RegWrite_out,
        FPUOp_out[5:0],
        FPUWrite_out,
        Reg1_out[31:0],
        Reg2_out[31:0],
        ExtImm_out[31:0],
        Rs_out[4:0],
        Rt_out[4:0],
        Rd_out[4:0],
        FPReg1_out[63:0],
        FPReg2_out[63:0]
    } = StageReg;

    initial begin
        StageReg <= 353'b0;
    end

    always @(posedge clk, posedge rst) begin
        if (rst || HazardFlush)
            StageReg <= 353'b0;
        else begin
            StageReg <= {
                Instr_in[31:0],
                NextPC_in[31:0],
                RegDst_in[1:0],
                ALUOp_in[4:0],
                ALUSrc_in,
                SpecialOP_in[3:0],
                Branch_in,
                Jump_in,
                JumpAddress_in[25:0],
                MemRead_in,
                MemWrite_in,
                RegWrite_in,
                FPUOp_in[5:0],
                FPUWrite_in,
                Reg1_in[31:0],
                Reg2_in[31:0],
                ExtImm_in[31:0],
                Rs_in[4:0],
                Rt_in[4:0],
                Rd_in[4:0],
                FPReg1_in[63:0],
                FPReg2_in[63:0]
            };
        end
    end

endmodule
