module PCU (
    input clk,
    input rst,
    input PCSrc,
    input [31:0] BranchAddress,
    output reg [31:0] PC,
    output [31:0] NextPC
);
    assign NextPC = PC + 4;

    always@(posedge clk, posedge rst) begin
        if (rst)
            PC <= 32'h0000_0000;
        else
            PC <= PCSrc ? BranchAddress : NextPC;
    end
endmodule
