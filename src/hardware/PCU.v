module PCU(
    input wire clk,
    input wire rst,
    input wire en,
    input wire PCSrc,
    input wire [31:0] BranchAddress,
    output reg [31:0] PC,
    output wire [31:0] NextPC
);
    assign NextPC = en ? (PC + 32'd4) : 32'b0;

    always@(posedge clk, posedge rst) begin
        if (rst || !en) begin
            PC <= 32'b0;
        end else begin
            PC <= PCSrc ? BranchAddress : NextPC;
        end
    end
endmodule
