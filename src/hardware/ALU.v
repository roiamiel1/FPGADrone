`include "signal_def.v"

module ALU(
    input wire clk,
    input wire [31:0] DataIn1,
    input wire [31:0] DataIn2,
    input wire [4:0] shamt,
    input wire [4:0] ALUOp,
    output reg [31:0] ALURes,
    output wire Zero
);
    assign Zero = ALURes == 32'b0 ? (ALUOp == `ALUOp_BNE ? 0 : 1) : (ALUOp == `ALUOp_BNE ? 1 : 0);

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
            default:
                ALURes <= 32'b0;
        endcase
    end
endmodule
