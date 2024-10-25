module IDEXReg (
    input clk,
    input rst,
    input HazardFlush,

    // EX signal
    input [31:0] NextPC_in,
    input RegDst_in,
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

    // data
    input [31:0] Reg1_in,
    input [31:0] Reg2_in,
    input [31:0] ExtImm_in,
    input [4:0] Rs_in,
    input [4:0] Rt_in,
    input [4:0] Rd_in,
    input [4:0] shamt_in,

    // EX signal
    output [31:0] NextPC_out,
    output RegDst_out,
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

    // data
    output [31:0] Reg1_out,
    output [31:0] Reg2_out,
    output [31:0] ExtImm_out,
    output [4:0] Rs_out,
    output [4:0] Rt_out,
    output [4:0] Rd_out,
    output [4:0] shamt_out
);

    reg [189:0] StageReg;

    assign {
            NextPC_out[31:0],
            RegDst_out,
            ALUOp_out[4:0],
            ALUSrc_out,
            SpecialOP_out,
            Branch_out,
            Jump_out,
            JumpAddress_out,
            MemRead_out,
            MemWrite_out,
            RegWrite_out,
            Reg1_out[31:0],
            Reg2_out[31:0],
            ExtImm_out[31:0],
            Rs_out[4:0],
            Rt_out[4:0],
            Rd_out[4:0],
            shamt_out[4:0]
        } = StageReg;

    initial begin
        StageReg <= 190'b0;
    end

    always @(posedge clk, posedge rst) begin
        if (rst || HazardFlush)
            StageReg <= 190'b0;
        else begin
            StageReg <= {
                NextPC_in[31:0],
                RegDst_in,
                ALUOp_in[4:0],
                ALUSrc_in,
                SpecialOP_in,
                Branch_in,
                Jump_in,
                JumpAddress_in,
                MemRead_in,
                MemWrite_in,
                RegWrite_in,
                Reg1_in[31:0],
                Reg2_in[31:0],
                ExtImm_in[31:0],
                Rs_in[4:0],
                Rt_in[4:0],
                Rd_in[4:0],
                shamt_in[4:0]
            };
        end
    end

endmodule