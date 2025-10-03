`include "signal_def.v"

module MemoryAccess(
    input  wire clk,
    input  wire rst,

    input  wire [13:0] address,
    input  wire [1:0]  mode,
    input  wire        write_enable,
    
    output wire [13:0] addr_block_0,
    output wire [13:0] addr_block_1,
    output wire [13:0] addr_block_2,
    output wire [13:0] addr_block_3,

    input  wire [7:0]  data_in_block_0,
    input  wire [7:0]  data_in_block_1,
    input  wire [7:0]  data_in_block_2,
    input  wire [7:0]  data_in_block_3,

    output wire [7:0]  data_out_block_0,
    output wire [7:0]  data_out_block_1,
    output wire [7:0]  data_out_block_2,
    output wire [7:0]  data_out_block_3,

    output reg         write_enable_block_0,
    output reg         write_enable_block_1,
    output reg         write_enable_block_2,
    output reg         write_enable_block_3,

    input  wire [31:0] data_in,
    output wire [31:0] data_out
);
    wire [1:0]  addr_module_4;
    wire [31:0] data_in_internal;
    wire [31:0] data_out_internal;

    initial begin
        write_enable_block_0 = 1'b0;
        write_enable_block_1 = 1'b0;
        write_enable_block_2 = 1'b0;
        write_enable_block_3 = 1'b0;
    end

    /************************ Address logic ************************/

    assign addr_module_4 = address & 2'b11;

    assign addr_block_0 = addr_module_4 == 2'b00 ? ( (address + 14'h0) >> 2 ) :
                          addr_module_4 == 2'b01 ? ( (address + 14'h3) >> 2 ) :
                          addr_module_4 == 2'b10 ? ( (address + 14'h2) >> 2 ) :
                          addr_module_4 == 2'b11 ? ( (address + 14'h1) >> 2 ) :
                          14'h0;
    assign addr_block_1 = addr_module_4 == 2'b00 ? ( (address + 14'h0) >> 2 ) :
                          addr_module_4 == 2'b01 ? ( (address - 14'h1) >> 2 ) :
                          addr_module_4 == 2'b10 ? ( (address + 14'h2) >> 2 ) :
                          addr_module_4 == 2'b11 ? ( (address + 14'h1) >> 2 ) :
                          14'h0;
    assign addr_block_2 = addr_module_4 == 2'b00 ? ( (address + 14'h0) >> 2 ) :
                          addr_module_4 == 2'b01 ? ( (address - 14'h1) >> 2 ) :
                          addr_module_4 == 2'b10 ? ( (address - 14'h2) >> 2 ) :
                          addr_module_4 == 2'b11 ? ( (address + 14'h1) >> 2 ) :
                          14'h0;
    assign addr_block_3 = addr_module_4 == 2'b00 ? ( (address + 14'h0) >> 2 ) :
                          addr_module_4 == 2'b01 ? ( (address - 14'h1) >> 2 ) :
                          addr_module_4 == 2'b10 ? ( (address - 14'h2) >> 2 ) :
                          addr_module_4 == 2'b11 ? ( (address - 14'h3) >> 2 ) : 
                          14'h0;

    /************************ Read logic ************************/

    assign data_in_internal = addr_module_4 == 2'b00 ? { data_in_block_0, data_in_block_1, data_in_block_2, data_in_block_3 } :
                              addr_module_4 == 2'b01 ? { data_in_block_1, data_in_block_2, data_in_block_3, data_in_block_0 } :
                              addr_module_4 == 2'b10 ? { data_in_block_2, data_in_block_3, data_in_block_0, data_in_block_1 } :
                              addr_module_4 == 2'b11 ? { data_in_block_3, data_in_block_0, data_in_block_1, data_in_block_2 } : 
                              32'h0;
    
    assign data_out = mode == `DataMemoryMode_BYTE      ? data_in_internal >> 24 :
                      mode == `DataMemoryMode_HALFWORD ? data_in_internal >> 16 :
                      mode == `DataMemoryMode_WORD      ? data_in_internal >> 00 :
                      32'h0;

    /************************ Write logic ************************/

    assign data_out_internal = mode == `DataMemoryMode_BYTE      ? data_in << 24 :
                               mode == `DataMemoryMode_HALFWORD ? data_in << 16 :
                               mode == `DataMemoryMode_WORD      ? data_in << 00 :
                               32'h0;

    assign data_out_block_0 = addr_module_4 == 2'b00 ? data_out_internal[31:24] :
                              addr_module_4 == 2'b01 ? data_out_internal[23:16] :
                              addr_module_4 == 2'b10 ? data_out_internal[15:08] :
                              addr_module_4 == 2'b11 ? data_out_internal[07:00] :
                              32'h0;
    assign data_out_block_1 = addr_module_4 == 2'b00 ? data_out_internal[23:16] :
                              addr_module_4 == 2'b01 ? data_out_internal[15:08] :
                              addr_module_4 == 2'b10 ? data_out_internal[07:00] :
                              addr_module_4 == 2'b11 ? data_out_internal[31:24] :
                              32'h0;
    assign data_out_block_2 = addr_module_4 == 2'b00 ? data_out_internal[15:08] :
                              addr_module_4 == 2'b01 ? data_out_internal[07:00] :
                              addr_module_4 == 2'b10 ? data_out_internal[31:24] :
                              addr_module_4 == 2'b11 ? data_out_internal[23:16] :
                              32'h0;
    assign data_out_block_3 = addr_module_4 == 2'b00 ? data_out_internal[07:00] :
                              addr_module_4 == 2'b01 ? data_out_internal[31:24] :
                              addr_module_4 == 2'b10 ? data_out_internal[23:16] :
                              addr_module_4 == 2'b11 ? data_out_internal[15:08] :
                              32'h0;

    always @(negedge clk, posedge rst) begin
        if (rst || !write_enable) begin
            write_enable_block_0 <= 1'b0;
            write_enable_block_1 <= 1'b0;
            write_enable_block_2 <= 1'b0;
            write_enable_block_3 <= 1'b0;      
        end else begin
            write_enable_block_0 <= mode == `DataMemoryMode_BYTE     ? (addr_module_4 == 2'b00) :
                                    mode == `DataMemoryMode_HALFWORD ? (addr_module_4 == 2'b00 || addr_module_4 == 2'b01) :
                                    mode == `DataMemoryMode_WORD     ? 1'b1 :
                                    1'b0;
            write_enable_block_1 <= mode == `DataMemoryMode_BYTE     ? (addr_module_4 == 2'b01) :
                                    mode == `DataMemoryMode_HALFWORD ? (addr_module_4 == 2'b01 || addr_module_4 == 2'b10) :
                                    mode == `DataMemoryMode_WORD     ? 1'b1 :
                                    1'b0;
            write_enable_block_2 <= mode == `DataMemoryMode_BYTE     ? (addr_module_4 == 2'b10) :
                                    mode == `DataMemoryMode_HALFWORD ? (addr_module_4 == 2'b10 || addr_module_4 == 2'b11) :
                                    mode == `DataMemoryMode_WORD     ? 1'b1 :
                                    1'b0;
            write_enable_block_3 <= mode == `DataMemoryMode_BYTE     ? (addr_module_4 == 2'b11) :
                                    mode == `DataMemoryMode_HALFWORD ? (addr_module_4 == 2'b11 || addr_module_4 == 2'b00) :
                                    mode == `DataMemoryMode_WORD     ? 1'b1 :
                                    1'b0;
        end
    end

endmodule

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
    wire [13:0] addr_a_block_0;
    wire [13:0] addr_a_block_1;
    wire [13:0] addr_a_block_2;
    wire [13:0] addr_a_block_3;
    wire [7:0]  data_in_a_block_0;
    wire [7:0]  data_in_a_block_1;
    wire [7:0]  data_in_a_block_2;
    wire [7:0]  data_in_a_block_3;
    wire [7:0]  data_out_a_block_0;
    wire [7:0]  data_out_a_block_1;
    wire [7:0]  data_out_a_block_2;
    wire [7:0]  data_out_a_block_3;
    wire        write_enable_a_block_0;
    wire        write_enable_a_block_1;
    wire        write_enable_a_block_2;
    wire        write_enable_a_block_3;

    MemoryAccess MemoryAccessChannelA(
        .clk(clk),
        .rst(rst),
        .address(address_a),
        .mode(mode_a),
        .write_enable(write_enable_a),
        .addr_block_0(addr_a_block_0),
        .addr_block_1(addr_a_block_1),
        .addr_block_2(addr_a_block_2),
        .addr_block_3(addr_a_block_3),
        .data_in_block_0(data_in_a_block_0),
        .data_in_block_1(data_in_a_block_1),
        .data_in_block_2(data_in_a_block_2),
        .data_in_block_3(data_in_a_block_3),
        .data_out_block_0(data_out_a_block_0),
        .data_out_block_1(data_out_a_block_1),
        .data_out_block_2(data_out_a_block_2),
        .data_out_block_3(data_out_a_block_3),
        .write_enable_block_0(write_enable_a_block_0),
        .write_enable_block_1(write_enable_a_block_1),
        .write_enable_block_2(write_enable_a_block_2),
        .write_enable_block_3(write_enable_a_block_3),
        .data_in(data_in_a),
        .data_out(data_out_a)
    );

    wire [13:0] addr_b_block_0;
    wire [13:0] addr_b_block_1;
    wire [13:0] addr_b_block_2;
    wire [13:0] addr_b_block_3;
    wire [7:0]  data_in_b_block_0;
    wire [7:0]  data_in_b_block_1;
    wire [7:0]  data_in_b_block_2;
    wire [7:0]  data_in_b_block_3;
    wire [7:0]  data_out_b_block_0;
    wire [7:0]  data_out_b_block_1;
    wire [7:0]  data_out_b_block_2;
    wire [7:0]  data_out_b_block_3;
    wire        write_enable_b_block_0;
    wire        write_enable_b_block_1;
    wire        write_enable_b_block_2;
    wire        write_enable_b_block_3;

    MemoryAccess MemoryAccessChannelB(
        .clk(clk),
        .rst(rst),
        .address(address_b),
        .mode(mode_b),
        .write_enable(write_enable_b),
        .addr_block_0(addr_b_block_0),
        .addr_block_1(addr_b_block_1),
        .addr_block_2(addr_b_block_2),
        .addr_block_3(addr_b_block_3),
        .data_in_block_0(data_in_b_block_0),
        .data_in_block_1(data_in_b_block_1),
        .data_in_block_2(data_in_b_block_2),
        .data_in_block_3(data_in_b_block_3),
        .data_out_block_0(data_out_b_block_0),
        .data_out_block_1(data_out_b_block_1),
        .data_out_block_2(data_out_b_block_2),
        .data_out_block_3(data_out_b_block_3),
        .write_enable_block_0(write_enable_b_block_0),
        .write_enable_block_1(write_enable_b_block_1),
        .write_enable_block_2(write_enable_b_block_2),
        .write_enable_block_3(write_enable_b_block_3),
        .data_in(data_in_b),
        .data_out(data_out_b)
    );

    Gowin_DPB_16384_8 MemBlock0(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(addr_a_block_0),
        .wrea(write_enable_a_block_0),
        .douta(data_in_a_block_0),
        .dina(data_out_a_block_0),
        // Port B
        .clkb(!clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(addr_b_block_0),
        .wreb(write_enable_b_block_0),
        .doutb(data_in_b_block_0),
        .dinb(data_out_b_block_0)
    );
    
    Gowin_DPB_16384_8 MemBlock1(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(addr_a_block_1),
        .wrea(write_enable_a_block_1),
        .douta(data_in_a_block_1),
        .dina(data_out_a_block_1),
        // Port B
        .clkb(!clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(addr_b_block_1),
        .wreb(write_enable_b_block_1),
        .doutb(data_in_b_block_1),
        .dinb(data_out_b_block_1)
    );

    Gowin_DPB_16384_8 MemBlock2(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(addr_a_block_2),
        .wrea(write_enable_a_block_2),
        .douta(data_in_a_block_2),
        .dina(data_out_a_block_2),
        // Port B
        .clkb(!clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(addr_b_block_2),
        .wreb(write_enable_b_block_2),
        .doutb(data_in_b_block_2),
        .dinb(data_out_b_block_2)
    );

    Gowin_DPB_16384_8 MemBlock3(
        // Port A
        .clka(clk),
        .reseta(rst),
        .ocea(1'b1),
        .cea(1'b1),
        .ada(addr_a_block_3),
        .wrea(write_enable_a_block_3),
        .douta(data_in_a_block_3),
        .dina(data_out_a_block_3),
        // Port B
        .clkb(!clk),
        .resetb(rst),
        .oceb(1'b1),
        .ceb(1'b1),
        .adb(addr_b_block_3),
        .wreb(write_enable_b_block_3),
        .doutb(data_in_b_block_3),
        .dinb(data_out_b_block_3)
    );
endmodule
