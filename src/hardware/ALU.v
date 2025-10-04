`timescale 1ns / 1ps

`include "signal_def.v"

module sra_shifter_manual (
    input  [31:0] rt,       // Source register value
    input  [4:0]  shamt,    // Shift amount (MIPS standard is 5 bits)
    output [31:0] rd        // Destination register for the result
);
    wire sign_bit;
    wire [31:0] sign_extend_filler;

    assign sign_bit = rt[31];
    assign sign_extend_filler = {32{sign_bit}};
    assign rd = (sign_extend_filler << (32 - shamt)) | (rt >> shamt);
endmodule

module ALU(
    input wire clk,
    input wire [31:0] DataIn1,
    input wire [31:0] DataIn2,
    input wire [4:0] shamt,
    input wire [4:0] ALUOp,
    output reg [31:0] ALURes,
    output wire Zero
);
    wire [31:0] sra_shifter_out;

    assign Zero = ALURes == 32'b0 ? (ALUOp == `ALUOp_BNE ? 0 : 1) : (ALUOp == `ALUOp_BNE ? 1 : 0);

    sra_shifter_manual sra_shifter (
        .rt(DataIn2),
        .shamt(shamt),
        .rd(sra_shifter_out)
    );

    always @(negedge clk) begin
        case(ALUOp)
            `ALUOp_ADD:
                ALURes <= DataIn1 + DataIn2;
            `ALUOp_SUB, `ALUOp_BNE:
                ALURes <= DataIn1 - DataIn2;
            `ALUOp_MUL:
                ALURes <= DataIn1 * DataIn2;
            `ifdef DEBUG
            // TODO: Division in the ALU create a very log logic path combaining with ForwardingUnit.
            // TODO: In the future we should create a faster divider.
            `ALUOp_DIV:
                ALURes <= DataIn1 / DataIn2;
            `endif
            `ALUOp_SLL:
                ALURes <= DataIn2 << shamt;
            `ALUOp_SRL:
                ALURes <= DataIn2 >> shamt;
            `ALUOp_AND:
                ALURes <= DataIn1 & DataIn2;
            `ALUOp_OR:
                ALURes <= DataIn1 | DataIn2;
            `ALUOp_XOR:
                ALURes <= DataIn1 ^ DataIn2;
            `ALUOp_NOR:
                ALURes <= ~(DataIn1 | DataIn2);
            `ALUOp_NAND:
                ALURes <= ~(DataIn1 & DataIn2);
            `ALUOp_XNOR:
                ALURes <= ~(DataIn1 ^ DataIn2);
            `ALUOp_SLT: begin
                if (DataIn1[31] != DataIn2[31]) begin
                    if (DataIn1[31] > DataIn2[31])
                        ALURes <= 1;
                    else
                        ALURes <= 0;
                end else begin
                    if (DataIn1 < DataIn2)
                        ALURes <= 1;
                    else
                        ALURes <= 0;
                end
            end
            `ALUOp_LUI:
                ALURes <= {DataIn2[15:0], 16'b0};
            `ALUOp_IN1:
                ALURes <= DataIn1;
            `ALUOp_SRA: begin
                ALURes <= sra_shifter_out;
            end
            default:
                ALURes <= 32'b0;
        endcase
    end
endmodule