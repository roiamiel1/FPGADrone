// AUTO-GENERATED - DO NOT CHNAGE!
`timescale 1ns / 1ps

`include "signal_def.v"

module Control(
    input wire clk,
    input wire rst,
    input wire [5:0] OpCode,
    input wire [5:0] Funct,
    output reg [1:0] InstType,
    output reg Jump,
    output reg [1:0] ReadReg1,
    output reg [1:0] ReadReg2,
    output reg [1:0] RegDst,
    output reg Branch,
    output reg MemRead,
    output reg MemWrite,
    output reg RegWrite,
    output reg ALUSrc,
    output reg ExtOp,
    output reg [4:0] ALUOp,
    output reg [3:0] SpecialOP,
    output wire nBranch
);
    assign nBranch = ~Branch;

    initial begin
        InstType  <= 2'b00;
        Jump      <= 1'b0;
        ReadReg1  <= 2'b00;
        ReadReg2  <= 2'b00;
        RegDst    <= 2'b00;
        Branch    <= 1'b0;
        MemRead   <= 1'b0;
        MemWrite  <= 1'b0;
        RegWrite  <= 1'b0;
        ALUSrc    <= 1'b0;
        ExtOp     <= 1'b0;
        ALUOp     <= 5'b0;
        SpecialOP <= 4'b0;
    end

    always @(negedge clk, posedge rst) begin
        if (rst) begin
            InstType  <= 2'b00;
            Jump      <= 1'b0;
            ReadReg1  <= 2'b00;
            ReadReg2 <= 2'b00;
            RegDst    <= 2'b00;
            Branch    <= 1'b0;
            MemRead   <= 1'b0;
            MemWrite  <= 1'b0;
            RegWrite  <= 1'b0;
            ALUSrc    <= 1'b0;
            ExtOp     <= 1'b0;
            ALUOp     <= 5'b0;
            SpecialOP <= 4'b0;
        end else if (OpCode == 6'h0 && Funct == 6'h20) begin
            // add case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h8) begin
            // addi case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h9) begin
            // addiu case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h21) begin
            // addu case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h24) begin
            // and case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_AND;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'hc) begin
            // andi case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_ZERO;
            ALUOp     <= `ALUOp_AND;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h4) begin
            // beq case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= 0;
            Branch    <= 1;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SUB;
            SpecialOP <= `SpecialOP_BEQ;
        end else if (OpCode == 6'h5) begin
            // bne case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= 0;
            Branch    <= 1;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SUB;
            SpecialOP <= `SpecialOP_BNE;
        end else if (OpCode == 6'h2) begin
            // j case:
            InstType  <= `INST_TYPE_J;
            Jump      <= 1;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= 0;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 0;
            ALUSrc    <= 0;
            ExtOp     <= 0;
            ALUOp     <= 0;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h3) begin
            // jal case:
            InstType  <= `INST_TYPE_J;
            Jump      <= 1;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= 0;
            ALUOp     <= `ALUOp_IN1;
            SpecialOP <= `SpecialOP_JAL;
        end else if (OpCode == 6'h0 && Funct == 6'h8) begin
            // jr case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 1;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= 0;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= 0;
            ALUOp     <= `ALUOp_IN1;
            SpecialOP <= `SpecialOP_JR;
        end else if (OpCode == 6'h24) begin
            // lbu case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 1;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_DM_BYTE;
        end else if (OpCode == 6'h25) begin
            // lhu case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 1;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_DM_HW;
        end else if (OpCode == 6'hf) begin
            // lui case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_ZERO;
            ALUOp     <= `ALUOp_LUI;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h23) begin
            // lw case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 1;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h26) begin
            // xor case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_XOR;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'he) begin
            // xori case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_ZERO;
            ALUOp     <= `ALUOp_XOR;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h27) begin
            // nor case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_NOR;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h25) begin
            // or case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_OR;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'hd) begin
            // ori case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_ZERO;
            ALUOp     <= `ALUOp_OR;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h2a) begin
            // slt case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SLT;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'ha) begin
            // slti case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SLT;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'hb) begin
            // sltiu case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_ZERO;
            ALUOp     <= `ALUOp_SLT;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h2b) begin
            // sltu case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_ZERO;
            ALUOp     <= `ALUOp_SLT;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h0) begin
            // sll case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RT;
            ReadReg2  <= 0;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SLL;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h4) begin
            // sllv case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RT;
            ReadReg2  <= `REG_RS;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SLL;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h2) begin
            // srl case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RT;
            ReadReg2  <= 0;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SRL;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h6) begin
            // srlv case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RT;
            ReadReg2  <= `REG_RS;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SRL;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h3) begin
            // sra case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RT;
            ReadReg2  <= 0;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SRA;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h7) begin
            // srav case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RT;
            ReadReg2  <= `REG_RS;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SRA;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h28) begin
            // sb case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= 0;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 1;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_DM_BYTE;
        end else if (OpCode == 6'h29) begin
            // sh case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= 0;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 1;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_DM_HW;
        end else if (OpCode == 6'h2b) begin
            // sw case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= 0;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 1;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h22) begin
            // sub case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SUB;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h23) begin
            // subu case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SUB;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h20) begin
            // lb case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RT;
            Branch    <= 0;
            MemRead   <= 1;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_DM_BYTE;
        end else if (OpCode == 6'h0 && Funct == 6'h0) begin
            // nop case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= 0;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 0;
            ALUSrc    <= 0;
            ExtOp     <= 0;
            ALUOp     <= 0;
            SpecialOP <= 0;
        end else if (OpCode == 6'h7) begin
            // bgtz case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= 0;
            Branch    <= 1;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_IN1;
            SpecialOP <= `SpecialOP_BGTZ;
        end else if (OpCode == 6'h6) begin
            // blez case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= 0;
            Branch    <= 1;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_IN1;
            SpecialOP <= `SpecialOP_BLEZ;
        end else if (OpCode == 6'h1) begin
            // bgezal case:
            InstType  <= `INST_TYPE_I;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= 0;
            RegDst    <= `REG_RD;
            Branch    <= 1;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_IN1;
            SpecialOP <= `SpecialOP_BGEZAL;
        end else if (OpCode == 6'h0 && Funct == 6'h18) begin
            // mult case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= 0;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= 0;
            ALUOp     <= `ALUOp_MULT;
            SpecialOP <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h19) begin
            // multu case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= `REG_RS;
            ReadReg2  <= `REG_RT;
            RegDst    <= 0;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 0;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= 0;
            ALUOp     <= `ALUOp_MULTU;
            SpecialOP <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h10) begin
            // mfhi case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= 0;
            ReadReg2  <= 0;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= 0;
            ExtOp     <= 0;
            ALUOp     <= `ALUOp_MFHI;
            SpecialOP <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h12) begin
            // mtlo case:
            InstType  <= `INST_TYPE_R;
            Jump      <= 0;
            ReadReg1  <= 0;
            ReadReg2  <= 0;
            RegDst    <= `REG_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= 0;
            ExtOp     <= 0;
            ALUOp     <= `ALUOp_MFLO;
            SpecialOP <= 0;
        end else  begin
            // default case:
            InstType  <= 2'b00;
            Jump      <= 1'b0;
            ReadReg1  <= 2'b00;
            ReadReg2  <= 2'b00;
            RegDst    <= 2'b00;
            Branch    <= 1'b0;
            MemRead   <= 1'b0;
            MemWrite  <= 1'b0;
            RegWrite  <= 1'b0;
            ALUSrc    <= 1'b0;
            ExtOp     <= 1'b0;
            ALUOp     <= 5'b0;
            SpecialOP <= 4'b0;
            `ifdef DEBUG
            if (OpCode !== 6'bx && Funct !== 6'bx) begin
                $display("\n*************** Warning ***************"); 
                $display(   "  Unsupported instruction encountered  ");
                $display("Time: %t", $time);
                $display("OpCode: 0x%h", OpCode);
                $display("Funct: 0x%h", Funct);
                $display("Inst: 0x%h", TESTBENCH.U_MIPS_R2000.IFID_Instr);
                $display("PCU: 0x%h", TESTBENCH.U_MIPS_R2000.U_PCU_PC);
                $display("***************************************\n"); 
            end
            `endif
        end
    end
endmodule
