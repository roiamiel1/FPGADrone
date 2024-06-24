// AUTO-GENERATED - DO NOT CHNAGE!
`include "instruction_def.v"
`include "signal_def.v"

module Control(
    input [5:0] OpCode,
    input [5:0] Funct,
    output reg Jump,
    output reg RegDst,
    output reg Branch,
    output reg MemRead,
    output reg MemWrite,
    output reg RegWrite,
    output reg ALUSrc,
    output reg ExtOp,
    output reg [4:0] ALUOp,
    output nBranch
);
    assign nBranch = ~Branch;

    initial begin
        Jump <= 0;
        RegDst <= 0;
        Branch <= 0;
        MemRead <= 0;
        MemWrite <= 0;
        RegWrite <= 0;
        ALUSrc <= 0;
        ExtOp <= 0;
        ALUOp <= 5'b0;
    end

    always @(OpCode, Funct) begin
        if (OpCode == 6'h0 && Funct == 6'h20) begin
            // add case:
            Jump <= 0;
            RegDst <= `REG_DST_RD;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 1;
            ALUSrc <= `ALU_SRC_REG;
            ExtOp <= `EXT_SIGNED;
            ALUOp <= `ALUOp_ADD;
        end else if (OpCode == 6'h8) begin
            // addi case:
            Jump <= 0;
            RegDst <= `REG_DST_RT;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 1;
            ALUSrc <= `ALU_SRC_EXT;
            ExtOp <= `EXT_SIGNED;
            ALUOp <= `ALUOp_ADD;
        end else if (OpCode == 6'h9) begin
            // addiu case:
            Jump <= 0;
            RegDst <= `REG_DST_RT;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 1;
            ALUSrc <= `ALU_SRC_EXT;
            ExtOp <= `EXT_SIGNED;
            ALUOp <= `ALUOp_ADD;
        end else if (OpCode == 6'h0 && Funct == 6'h21) begin
            // addu case:
            Jump <= 0;
            RegDst <= `REG_DST_RD;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 1;
            ALUSrc <= `ALU_SRC_REG;
            ExtOp <= `EXT_ZERO;
            ALUOp <= `ALUOp_ADD;
        end else if (OpCode == 6'h0 && Funct == 6'h24) begin
            // and case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'hc) begin
            // andi case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h4) begin
            // beq case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h5) begin
            // bne case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h2) begin
            // j case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h3) begin
            // jal case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h8) begin
            // jr case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h24) begin
            // lbu case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h25) begin
            // lhu case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h30) begin
            // ll case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'hf) begin
            // lui case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h23) begin
            // lw case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h27) begin
            // nor case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h25) begin
            // or case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'hd) begin
            // ori case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h2a) begin
            // slt case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'ha) begin
            // slti case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'hb) begin
            // sltiu case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h2b) begin
            // sltu case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h0) begin
            // sll case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h2) begin
            // srl case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h28) begin
            // sb case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h38) begin
            // sc case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h29) begin
            // sh case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h2b) begin
            // sw case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h22) begin
            // sub case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else if (OpCode == 6'h0 && Funct == 6'h23) begin
            // subu case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 0;
        end else begin
            // default case:
            Jump <= 0;
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            ALUSrc <= 0;
            ExtOp <= 0;
            ALUOp <= 5'b0;
        end
    end
endmodule
