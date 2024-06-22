module REG32(
    input wire rst,
    input wire clk,
    input wire [4:0] read_address1,
    input wire [4:0] read_address2,
    input wire [4:0] write_address,
    input wire write_enable,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2,
    input wire [31:0] write_data
);
    integer i;
    reg [31:0] registers [31:0];

    always @(posedge rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 0;
        end
    end

    always @(posedge clk) begin
        read_data1 = registers[read_address1];
        read_data2 = registers[read_address2];
    end

    always @(negedge clk) begin
        if (write_enable)
            registers[write_address] = write_data;
    end
endmodule
