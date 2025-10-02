`include "signal_def.v"

module DataMemory(
    input wire clk,
    input wire rst,
    // Port A
    input wire write_enable_a,
    input wire [1:0] mode_a,
    input wire [13:0] address_a,
    input wire [31:0] data_in_a, 
    output wire [31:0] data_out_a,
    // Port B
    input wire write_enable_b,
    input wire [1:0] mode_b,
    input wire [13:0] address_b,
    input wire [31:0] data_in_b, 
    output wire [31:0] data_out_b
);
    // Internal signals for Port A
    reg [3:0] internal_write_enable_a;
    wire [13:0] internal_address_a;
    reg [31:0] internal_data_in_a;
    wire [31:0] internal_data_out_a;

    // Internal signals for Port B
    reg [3:0] internal_write_enable_b;
    wire [13:0] internal_address_b;
    reg [31:0] internal_data_in_b;
    wire [31:0] internal_data_out_b;
    
    Gowin_DPB_16384_8 MemBlock0(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(internal_address_a),
        .wrea(internal_write_enable_a[0]),
        .douta(internal_data_out_a[7:0]),
        .dina(internal_data_in_a[7:0]),
        // Port B
        .clkb(!clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(internal_address_b),
        .wreb(internal_write_enable_b[0]),
        .doutb(internal_data_out_b[7:0]),
        .dinb(internal_data_in_b[7:0])
    );
    
    Gowin_DPB_16384_8 MemBlock1(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(internal_address_a),
        .wrea(internal_write_enable_a[1]),
        .douta(internal_data_out_a[15:8]),
        .dina(internal_data_in_a[15:8]),
        // Port B
        .clkb(!clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(internal_address_b),
        .wreb(internal_write_enable_b[1]),
        .doutb(internal_data_out_b[15:8]),
        .dinb(internal_data_in_b[15:8])
    );

    Gowin_DPB_16384_8 MemBlock2(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(internal_address_a),
        .wrea(internal_write_enable_a[2]),
        .douta(internal_data_out_a[23:16]),
        .dina(internal_data_in_a[23:16]),
        // Port B
        .clkb(!clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(internal_address_b),
        .wreb(internal_write_enable_b[2]),
        .doutb(internal_data_out_b[23:16]),
        .dinb(internal_data_in_b[23:16])
    );

    Gowin_DPB_16384_8 MemBlock3(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(internal_address_a),
        .wrea(internal_write_enable_a[3]),
        .douta(internal_data_out_a[31:24]),
        .dina(internal_data_in_a[31:24]),
        // Port B
        .clkb(!clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(internal_address_b),
        .wreb(internal_write_enable_b[3]),
        .doutb(internal_data_out_b[31:24]),
        .dinb(internal_data_in_b[31:24])
    );

    assign internal_address_a = address_a;
    assign internal_address_b = address_b;

    assign data_out_a = mode_a == `DataMemoryMode_BYTE     ? {24'b0, internal_data_out_a[7:0]}  :
                        mode_a == `DataMemoryMode_HALFWORD ? {16'b0, internal_data_out_a[15:0]} :
                        internal_data_out_a;

    assign data_out_b = mode_b == `DataMemoryMode_BYTE     ? {24'b0, internal_data_out_b[7:0]}  :
                        mode_b == `DataMemoryMode_HALFWORD ? {16'b0, internal_data_out_b[15:0]} :
                        internal_data_out_b;

    initial begin
        internal_write_enable_a = 4'b0;
        internal_data_in_a = 32'b0;

        internal_write_enable_b = 4'b0;
        internal_data_in_b = 32'b0;
    end

    always @(negedge clk) begin
        if (write_enable_a) begin
            case (mode_a)
                `DataMemoryMode_HALFWORD: internal_write_enable_a <= 4'b0011;
                `DataMemoryMode_BYTE:     internal_write_enable_a <= 4'b0001;
                default:                  internal_write_enable_a <= 4'b1111;
            endcase
            case (mode_a)
                `DataMemoryMode_HALFWORD: internal_data_in_a <= {16'b0, data_in_a[15:0]};
                `DataMemoryMode_BYTE:     internal_data_in_a <= {24'b0, data_in_a[7:0]};
                default:                  internal_data_in_a <= data_in_a;
            endcase
        end else begin
            internal_write_enable_a <= 4'b0;
            internal_data_in_a <= 32'b0;
        end

        if (write_enable_b) begin
            case (mode_b)
                `DataMemoryMode_HALFWORD: internal_write_enable_b <= 4'b0011;
                `DataMemoryMode_BYTE:     internal_write_enable_b <= 4'b0001;
                default:                  internal_write_enable_b <= 4'b1111;
            endcase
            case (mode_b)
                `DataMemoryMode_HALFWORD: internal_data_in_b <= {16'b0, data_in_b[15:0]};
                `DataMemoryMode_BYTE:     internal_data_in_b <= {24'b0, data_in_b[7:0]};
                default:                  internal_data_in_b <= data_in_b;
            endcase
        end else begin
            internal_write_enable_b <= 4'b0;
            internal_data_in_b <= 32'b0;
        end
    end
endmodule
