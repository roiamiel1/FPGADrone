module PCU (
    input clk,
    input rst,
    input Hazard,
    input PCSrc,
    input Jump,
    input [31:0] BranchAddr,
    input [31:0] JmpAddr,
    output reg [31:0] PC
);
    always@(posedge clk, posedge rst) begin
        if (rst)
            PC <= 32'h0000_3000;
        else
            PC <= Jump ? JmpAddr : (PCSrc ? BranchAddr : (Hazard ? PC : PC + 4));
    end
endmodule
