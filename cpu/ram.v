module RAM32 (
    input wire rst,
    input wire clk,
    input [31:0] address,
    output reg [31:0] read_data,
    input wire [31:0] write_data,
    input wire read,
    input wire write
);
    parameter RAM_LEN = 6693;

    reg [31:0] ram [RAM_LEN:0];

    always @(posedge clk) begin
        if (read)
            read_data = ram[address];
    end

    always @(negedge clk) begin
        if (write)
            ram[address] = write_data;
    end
endmodule
