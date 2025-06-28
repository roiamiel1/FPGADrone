`include "signal_def.v"

module DataMemory(
    input wire clk,
    input wire rst,
    input wire write_enable,
    input wire [1:0] mode,
    input wire [13:0] address,
    input wire [31:0] data_in, 
    output reg [31:0] data_out
);
    reg [3:0] internal_write_enable;
    reg [13:0] internal_address;
    reg [31:0] internal_data_in;
    wire [31:0] internal_data_out;

    Gowin_SP_16384_8 MemBlock0(
        .clk(clk),
        .reset(rst),
        .dout(internal_data_out[7:0]),
        .wre(internal_write_enable[0]),
        .ad(internal_address),
        .din(internal_data_in[7:0]),
        .oce(1'b1),
        .ce(1'b1)
    );
    
    Gowin_SP_16384_8 MemBlock1(
        .clk(clk),
        .reset(rst),
        .dout(internal_data_out[15:8]),
        .wre(internal_write_enable[1]),
        .ad(internal_address),
        .din(internal_data_in[15:8]),
        .oce(1'b1),
        .ce(1'b1)
    );

    Gowin_SP_16384_8 MemBlock2(
        .clk(clk),
        .reset(rst),
        .dout(internal_data_out[23:16]),
        .wre(internal_write_enable[2]),
        .ad(internal_address),
        .din(internal_data_in[23:16]),
        .oce(1'b1),
        .ce(1'b1)
    );

    Gowin_SP_16384_8 MemBlock3(
        .clk(clk),
        .reset(rst),
        .dout(internal_data_out[31:24]),
        .wre(internal_write_enable[3]),
        .ad(internal_address),
        .din(internal_data_in[31:24]),
        .oce(1'b1),
        .ce(1'b1)
    );

    always @(posedge clk) begin
        internal_address = address;

        if (write_enable) begin
            case (mode)
                `DataMemoryMode_WORD:     internal_write_enable = 4'b1111;
                `DataMemoryMode_HALFWORD: internal_write_enable = 4'b0011;
                `DataMemoryMode_BYTE:     internal_write_enable = 4'b0001;
            endcase
            case (mode)
                `DataMemoryMode_WORD:     internal_data_in = data_in;
                `DataMemoryMode_HALFWORD: internal_data_in = {16'b0, data_in[15:0]};
                `DataMemoryMode_BYTE:     internal_data_in = {24'b0, data_in[7:0]};
            endcase
        end else begin
            internal_write_enable = 4'b0;
            internal_data_in = 32'b0;
        end
    end

    always @(negedge clk) begin
        if (!write_enable) begin
            case (mode)
                `DataMemoryMode_WORD:     data_out = internal_data_out;
                `DataMemoryMode_HALFWORD: data_out = {16'b0, internal_data_out[15:0]};
                `DataMemoryMode_BYTE:     data_out <= {24'b0, internal_data_out[7:0]};
            endcase
        end
    end

endmodule
