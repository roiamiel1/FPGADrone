module PCU(
    input clk,
    input rst,
    input PCSrc,
    input [31:0] BranchAddress,
    output reg [31:0] PC,
    output wire [31:0] NextPC
);
    assign NextPC = PC + 32'd4;

    always@(posedge clk, posedge rst) begin
        if (rst)
            PC <= 32'b0;
        else
            PC <= PCSrc ? BranchAddress : NextPC;
    end
endmodule
