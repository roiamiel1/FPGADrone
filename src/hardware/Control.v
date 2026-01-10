// AUTO-GENERATED - DO NOT CHNAGE!
`timescale 1ns / 1ps

`include "signal_def.v"

module Control(
    input wire clk,
    input wire rst,
    input wire [5:0] OpCode,
    input wire [5:0] Funct,
    output reg Jump,
    output reg RegDst,
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
        Jump      <= 1'b0;
        RegDst    <= 1'b0;
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
            Jump      <= 1'b0;
            RegDst    <= 1'b0;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
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
            Jump      <= 0;
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
            Jump      <= 0;
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
            Jump      <= 1;
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
            Jump      <= 1;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 1;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
            Branch    <= 0;
            MemRead   <= 1;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h27) begin
            // nor case:
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SRL;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h28) begin
            // sb case:
            Jump      <= 0;
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
            Jump      <= 0;
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
            Jump      <= 0;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RT;
            Branch    <= 0;
            MemRead   <= 1;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_EXT;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_ADD;
            SpecialOP <= `SpecialOP_DM_BYTE;
        end else if (OpCode == 6'h0 && Funct == 6'h3) begin
            // sra case:
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
            Branch    <= 0;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_SRA;
            SpecialOP <= `SpecialOP_NONE;
        end else if (OpCode == 6'h0 && Funct == 6'h0) begin
            // nop case:
            Jump      <= 0;
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
            Jump      <= 0;
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
            Jump      <= 0;
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
            Jump      <= 0;
            RegDst    <= `REG_DST_RD;
            Branch    <= 1;
            MemRead   <= 0;
            MemWrite  <= 0;
            RegWrite  <= 1;
            ALUSrc    <= `ALU_SRC_REG;
            ExtOp     <= `EXT_SIGNED;
            ALUOp     <= `ALUOp_IN1;
            SpecialOP <= `SpecialOP_BGEZAL;
        end else  begin
            // default case:
            Jump      <= 1'b0;
            RegDst    <= 1'b0;
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
