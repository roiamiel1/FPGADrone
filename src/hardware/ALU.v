`timescale 1ns / 1ps

`include "signal_def.v"

module ALU(
    input wire clk,
    input wire [31:0] DataIn1,
    input wire [31:0] DataIn2,
    input wire [4:0] ALUOp,
    output reg [31:0] ALURes,
    output wire Zero,
    output wire Sign
);
    assign Zero = ALURes == 32'b0;
    assign Sign = ALURes[31];

    always @(negedge clk) begin
        case(ALUOp)
            `ALUOp_ADD:
                ALURes <= DataIn1 + DataIn2;
            `ALUOp_SUB:
                ALURes <= DataIn1 - DataIn2;
            `ALUOp_MUL:
                ALURes <= DataIn1 * DataIn2;
            `ifdef DEBUG
            // TODO: Division in the ALU create a very long logic path combaining with ForwardingUnit.
            // TODO: In the future we should create a faster divider.
            `ALUOp_DIV:
                ALURes <= DataIn1 / DataIn2;
            `endif
            `ALUOp_SLL:
                ALURes <= DataIn1 << DataIn2;
            `ALUOp_SRL:
                ALURes <= DataIn1 >> DataIn2;
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
            `ALUOp_LUI: begin
                ALURes <= {DataIn2[15:0], 16'b0};
            end
            `ALUOp_IN1: begin
                ALURes <= DataIn1;
            end
            `ALUOp_SRA: begin
                ALURes <= ({32{DataIn1[31]}} << (32 - DataIn2)) | (DataIn1 >> DataIn2);
            end
            default: begin
                ALURes <= 32'b0;
            end
        endcase
    end
endmodule