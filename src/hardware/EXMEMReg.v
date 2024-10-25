module EXMEMReg (
    input clk,
    input rst,
    input HazardFlush,

    // MEM signal
    input Branch_in,
    input Jump_in,
    input [31:0] BranchAddress_in,
    input MemRead_in,
    input MemWrite_in,
    input [31:0] Reg2_in,

    // WB signal
    input RegWrite_in,

    // ALU signal
    input Zero_in,

    // data
    input [31:0] ALU_in,
    input [4:0] Rd_in,

    // MEM signal
    output Branch_out,
    output Jump_out,
    output [31:0] BranchAddress_out,
    output MemRead_out,
    output MemWrite_out,
    output [31:0] Reg2_out,

    // WB signal
    output RegWrite_out,

    // ALU signal
    output Zero_out,
    
    // data
    output [31:0] ALU_out,
    output [4:0] Rd_out
);
    reg[106:0] StageReg;

    assign {
        Branch_out,
        Jump_out,
        BranchAddress_out,
        MemRead_out,
        MemWrite_out,
        Reg2_out,
        RegWrite_out,
        Zero_out,
        ALU_out[31:0],
        Rd_out[4:0]
    } = StageReg;

    initial begin
        StageReg <= 107'b0;
    end

    always @(posedge clk, posedge rst) begin
        if (rst || HazardFlush)
            StageReg <= 107'b0;
        else begin
            StageReg <= {
                Branch_in,
                Jump_in,
                BranchAddress_in,
                MemRead_in,
                MemWrite_in,
                Reg2_in,
                RegWrite_in,
                Zero_in,
                ALU_in[31:0],
                Rd_in[4:0]
            };
        end
    end

endmodule