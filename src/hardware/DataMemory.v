module DataMemory(
    input clk,
    output [31:0] data_out,
    input [31:0] address,
    input [31:0] data_in, 
    input write_enable
);
    reg [31:0] memory [0:500];

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in;
        end
    end

    assign data_out = memory[address];

endmodule
