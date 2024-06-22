module ALU32(
    input wire rst,
    input wire clk,
    input wire op, // TODO: what it should be?
    input wire [31:0] arg1,
    input wire [31:0] arg2,
    output reg [31:0] result,
    output reg zero
);

    always @(posedge rst, posedge clk) begin
        if (rst == 1) begin
            result <= 0;
            zero <= 0;
        end else begin
            // TODO: dummy implementation.
            result = arg1 + arg2;
            zero <= result == 0; 
        end
    end

endmodule