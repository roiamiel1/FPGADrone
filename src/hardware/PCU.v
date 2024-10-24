module PCU (
    input clk,
    input rst,
    input PCSrc,
    input Jump,
    input [31:0] BranchAddr,
    input [31:0] JmpAddr,
    output reg [31:0] PC
);
    always@(posedge clk, posedge rst) begin
        if (rst)
            PC <= 32'h0000_0000;
        else
            PC <= Jump ? JmpAddr : (PCSrc ? BranchAddr : PC + 4);
    end
endmodule
