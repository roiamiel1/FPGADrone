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

    Gowin_DPB_16384_8 MemBlock0(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(internal_address),
        .wrea(internal_write_enable[0]),
        .douta(internal_data_out[7:0]),
        .dina(internal_data_in[7:0]),
        // Port B
        .clkb(clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(14'b0),
        .wreb(1'b0),
        .doutb(),
        .dinb(8'b0)
    );
    
    Gowin_DPB_16384_8 MemBlock1(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(internal_address),
        .wrea(internal_write_enable[1]),
        .douta(internal_data_out[15:8]),
        .dina(internal_data_in[15:8]),
        // Port B
        .clkb(clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(14'b0),
        .wreb(1'b0),
        .doutb(),
        .dinb(8'b0)
    );

    Gowin_DPB_16384_8 MemBlock2(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(internal_address),
        .wrea(internal_write_enable[2]),
        .douta(internal_data_out[23:16]),
        .dina(internal_data_in[23:16]),
        // Port B
        .clkb(clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(14'b0),
        .wreb(1'b0),
        .doutb(),
        .dinb(8'b0)
    );

    Gowin_DPB_16384_8 MemBlock3(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(internal_address),
        .wrea(internal_write_enable[3]),
        .douta(internal_data_out[31:24]),
        .dina(internal_data_in[31:24]),
        // Port B
        .clkb(clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(14'b0),
        .wreb(1'b0),
        .doutb(),
        .dinb(8'b0)
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
