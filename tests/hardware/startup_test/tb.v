`include "signal_def.v"

module TESTBENCH (
    input clk,
    input rst
);
    reg clk_debug;
    reg rst_debug;
    reg [31:0] cycles;

    // SD card stuff
    wire sdclk;
    tri sdcmd;
    wire [3:0] sddat;
    wire rom_req;
    wire [39:0] rom_addr;
    reg [15:0] rom_data;
    wire show_sdcmd_en;
    wire [5:0] show_sdcmd_cmd;
    wire [31:0] show_sdcmd_arg;

    MIPS_R2000 U_MIPS_R2000(
        .clk(clk_debug),
        .rst(rst_debug),
        .sdclk(sdclk),
        .sdcmd(sdcmd),
        .sddat0(sddat[0])
    );
    
    sd_fake sd_fake_i (
        .rstn_async(1'b1),
        .sdclk(sdclk),
        .sdcmd(sdcmd),
        .sddat(sddat),
        .rdreq(rom_req),
        .rdaddr(rom_addr),
        .rddata(rom_data),

        .show_status_bits (                ),
        .show_sdcmd_en    ( show_sdcmd_en  ),
        .show_sdcmd_cmd   ( show_sdcmd_cmd ),
        .show_sdcmd_arg   ( show_sdcmd_arg )
    );

    initial begin        
        $dumpfile("./build/hardware/tests/startup_test/test.vcd");
        $dumpvars;
        // $readmemh("./build/hardware/tests/uart_test/test.hex", U_MIPS_R2000.U_InstructionMemory.IMem);
        
        U_MIPS_R2000.U_IFIDReg.StageReg = 0;
        U_MIPS_R2000.U_IDEXReg.StageReg = 0;
        U_MIPS_R2000.U_EXMEMReg.StageReg = 0;
        U_MIPS_R2000.U_MEMWBReg.StageReg = 0;
        
        clk_debug = 1;
        rst_debug = 0;
        cycles = 0;
        
        rst_debug = 1;
        #2 rst_debug = 0;
    end
    
    always begin
        #10 clk_debug = ~clk_debug;
    end
    
    always @ (posedge rst_debug) begin
        cycles = 0;
    end
    
    always@(posedge clk_debug) begin
        if (U_MIPS_R2000.MemoryReady == 1'b1) begin
            cycles = cycles + 1;
            if(cycles > 40000) begin
                $display("\n\n***************  Done  ***************\n\n");
                $finish;
            end
        end
    end

    // Fake content of the fake SD card
    always @ (posedge sdclk) begin
        if (rom_req) begin
            case (rom_addr)
40'h0000000000: rom_data <= 16'h3C1D;
40'h0000000001: rom_data <= 16'h0000;
40'h0000000002: rom_data <= 16'h37BD;
40'h0000000003: rom_data <= 16'h3FFF;
40'h0000000004: rom_data <= 16'h3C1E;
40'h0000000005: rom_data <= 16'h0000;
40'h0000000006: rom_data <= 16'h37DE;
40'h0000000007: rom_data <= 16'h3FFF;
40'h0000000008: rom_data <= 16'h0800;
40'h0000000009: rom_data <= 16'h000C;
40'h000000000A: rom_data <= 16'h2FBB;
40'h000000000B: rom_data <= 16'hFF4B;
40'h000000000C: rom_data <= 16'h032B;
40'h000000000D: rom_data <= 16'h8B15;
40'h000000000E: rom_data <= 16'hBB97;
40'h000000000F: rom_data <= 16'h13A6;
40'h0000000010: rom_data <= 16'h84C6;
40'h0000000011: rom_data <= 16'hB288;
40'h0000000012: rom_data <= 16'h0000;
40'h0000000013: rom_data <= 16'h0000;
40'h0000000014: rom_data <= 16'h0000;
40'h0000000015: rom_data <= 16'h0000;
40'h0000000016: rom_data <= 16'h0000;
40'h0000000017: rom_data <= 16'h0000;
40'h0000000018: rom_data <= 16'h3C1C;
40'h0000000019: rom_data <= 16'h0000;
40'h000000001A: rom_data <= 16'h279C;
40'h000000001B: rom_data <= 16'hFFD0;
40'h000000001C: rom_data <= 16'h0399;
40'h000000001D: rom_data <= 16'hE021;
40'h000000001E: rom_data <= 16'h27BD;
40'h000000001F: rom_data <= 16'hFFE0;
40'h0000000020: rom_data <= 16'hAFBE;
40'h0000000021: rom_data <= 16'h001C;
40'h0000000022: rom_data <= 16'h03A0;
40'h0000000023: rom_data <= 16'hF025;
40'h0000000024: rom_data <= 16'hAFBC;
40'h0000000025: rom_data <= 16'h0000;
40'h0000000026: rom_data <= 16'h8F82;
40'h0000000027: rom_data <= 16'h0338;
40'h0000000028: rom_data <= 16'h0000;
40'h0000000029: rom_data <= 16'h0000;
40'h000000002A: rom_data <= 16'h8C45;
40'h000000002B: rom_data <= 16'h0320;
40'h000000002C: rom_data <= 16'h2443;
40'h000000002D: rom_data <= 16'h0320;
40'h000000002E: rom_data <= 16'h8C64;
40'h000000002F: rom_data <= 16'h0004;
40'h0000000030: rom_data <= 16'h2443;
40'h0000000031: rom_data <= 16'h0320;
40'h0000000032: rom_data <= 16'h8C63;
40'h0000000033: rom_data <= 16'h0008;
40'h0000000034: rom_data <= 16'h2442;
40'h0000000035: rom_data <= 16'h0320;
40'h0000000036: rom_data <= 16'h8C42;
40'h0000000037: rom_data <= 16'h000C;
40'h0000000038: rom_data <= 16'hAFC5;
40'h0000000039: rom_data <= 16'h0008;
40'h000000003A: rom_data <= 16'hAFC4;
40'h000000003B: rom_data <= 16'h000C;
40'h000000003C: rom_data <= 16'hAFC3;
40'h000000003D: rom_data <= 16'h0010;
40'h000000003E: rom_data <= 16'hAFC2;
40'h000000003F: rom_data <= 16'h0014;
40'h0000000040: rom_data <= 16'h0000;
40'h0000000041: rom_data <= 16'h0000;
40'h0000000042: rom_data <= 16'h2402;
40'h0000000043: rom_data <= 16'h03EB;
40'h0000000044: rom_data <= 16'h8042;
40'h0000000045: rom_data <= 16'h0000;
40'h0000000046: rom_data <= 16'h0000;
40'h0000000047: rom_data <= 16'h0000;
40'h0000000048: rom_data <= 16'h1440;
40'h0000000049: rom_data <= 16'hFFFC;
40'h000000004A: rom_data <= 16'h0000;
40'h000000004B: rom_data <= 16'h0000;
40'h000000004C: rom_data <= 16'h2402;
40'h000000004D: rom_data <= 16'h03E8;
40'h000000004E: rom_data <= 16'h83C3;
40'h000000004F: rom_data <= 16'h0008;
40'h0000000050: rom_data <= 16'h0000;
40'h0000000051: rom_data <= 16'h0000;
40'h0000000052: rom_data <= 16'hA043;
40'h0000000053: rom_data <= 16'h0000;
40'h0000000054: rom_data <= 16'h2402;
40'h0000000055: rom_data <= 16'h03E9;
40'h0000000056: rom_data <= 16'h2403;
40'h0000000057: rom_data <= 16'h0001;
40'h0000000058: rom_data <= 16'hA043;
40'h0000000059: rom_data <= 16'h0000;
40'h000000005A: rom_data <= 16'h2402;
40'h000000005B: rom_data <= 16'h03EA;
40'h000000005C: rom_data <= 16'h8042;
40'h000000005D: rom_data <= 16'h0000;
40'h000000005E: rom_data <= 16'h0000;
40'h000000005F: rom_data <= 16'h0000;
40'h0000000060: rom_data <= 16'h1040;
40'h0000000061: rom_data <= 16'hFFFC;
40'h0000000062: rom_data <= 16'h0000;
40'h0000000063: rom_data <= 16'h0000;
40'h0000000064: rom_data <= 16'h2402;
40'h0000000065: rom_data <= 16'h03E9;
40'h0000000066: rom_data <= 16'hA040;
40'h0000000067: rom_data <= 16'h0000;
40'h0000000068: rom_data <= 16'h2402;
40'h0000000069: rom_data <= 16'h03EB;
40'h000000006A: rom_data <= 16'h8042;
40'h000000006B: rom_data <= 16'h0000;
40'h000000006C: rom_data <= 16'h0000;
40'h000000006D: rom_data <= 16'h0000;
40'h000000006E: rom_data <= 16'h1440;
40'h000000006F: rom_data <= 16'hFFFC;
40'h0000000070: rom_data <= 16'h0000;
40'h0000000071: rom_data <= 16'h0000;
40'h0000000072: rom_data <= 16'h2402;
40'h0000000073: rom_data <= 16'h03E8;
40'h0000000074: rom_data <= 16'h83C3;
40'h0000000075: rom_data <= 16'h0009;
40'h0000000076: rom_data <= 16'h0000;
40'h0000000077: rom_data <= 16'h0000;
40'h0000000078: rom_data <= 16'hA043;
40'h0000000079: rom_data <= 16'h0000;
40'h000000007A: rom_data <= 16'h2402;
40'h000000007B: rom_data <= 16'h03E9;
40'h000000007C: rom_data <= 16'h2403;
40'h000000007D: rom_data <= 16'h0001;
40'h000000007E: rom_data <= 16'hA043;
40'h000000007F: rom_data <= 16'h0000;
40'h0000000080: rom_data <= 16'h2402;
40'h0000000081: rom_data <= 16'h03EA;
40'h0000000082: rom_data <= 16'h8042;
40'h0000000083: rom_data <= 16'h0000;
40'h0000000084: rom_data <= 16'h0000;
40'h0000000085: rom_data <= 16'h0000;
40'h0000000086: rom_data <= 16'h1040;
40'h0000000087: rom_data <= 16'hFFFC;
40'h0000000088: rom_data <= 16'h0000;
40'h0000000089: rom_data <= 16'h0000;
40'h000000008A: rom_data <= 16'h2402;
40'h000000008B: rom_data <= 16'h03E9;
40'h000000008C: rom_data <= 16'hA040;
40'h000000008D: rom_data <= 16'h0000;
40'h000000008E: rom_data <= 16'h2402;
40'h000000008F: rom_data <= 16'h03EB;
40'h0000000090: rom_data <= 16'h8042;
40'h0000000091: rom_data <= 16'h0000;
40'h0000000092: rom_data <= 16'h0000;
40'h0000000093: rom_data <= 16'h0000;
40'h0000000094: rom_data <= 16'h1440;
40'h0000000095: rom_data <= 16'hFFFC;
40'h0000000096: rom_data <= 16'h0000;
40'h0000000097: rom_data <= 16'h0000;
40'h0000000098: rom_data <= 16'h2402;
40'h0000000099: rom_data <= 16'h03E8;
40'h000000009A: rom_data <= 16'h83C3;
40'h000000009B: rom_data <= 16'h000A;
40'h000000009C: rom_data <= 16'h0000;
40'h000000009D: rom_data <= 16'h0000;
40'h000000009E: rom_data <= 16'hA043;
40'h000000009F: rom_data <= 16'h0000;
40'h00000000A0: rom_data <= 16'h2402;
40'h00000000A1: rom_data <= 16'h03E9;
40'h00000000A2: rom_data <= 16'h2403;
40'h00000000A3: rom_data <= 16'h0001;
40'h00000000A4: rom_data <= 16'hA043;
40'h00000000A5: rom_data <= 16'h0000;
40'h00000000A6: rom_data <= 16'h2402;
40'h00000000A7: rom_data <= 16'h03EA;
40'h00000000A8: rom_data <= 16'h8042;
40'h00000000A9: rom_data <= 16'h0000;
40'h00000000AA: rom_data <= 16'h0000;
40'h00000000AB: rom_data <= 16'h0000;
40'h00000000AC: rom_data <= 16'h1040;
40'h00000000AD: rom_data <= 16'hFFFC;
40'h00000000AE: rom_data <= 16'h0000;
40'h00000000AF: rom_data <= 16'h0000;
40'h00000000B0: rom_data <= 16'h2402;
40'h00000000B1: rom_data <= 16'h03E9;
40'h00000000B2: rom_data <= 16'hA040;
40'h00000000B3: rom_data <= 16'h0000;
40'h00000000B4: rom_data <= 16'h2402;
40'h00000000B5: rom_data <= 16'h03EB;
40'h00000000B6: rom_data <= 16'h8042;
40'h00000000B7: rom_data <= 16'h0000;
40'h00000000B8: rom_data <= 16'h0000;
40'h00000000B9: rom_data <= 16'h0000;
40'h00000000BA: rom_data <= 16'h1440;
40'h00000000BB: rom_data <= 16'hFFFC;
40'h00000000BC: rom_data <= 16'h0000;
40'h00000000BD: rom_data <= 16'h0000;
40'h00000000BE: rom_data <= 16'h2402;
40'h00000000BF: rom_data <= 16'h03E8;
40'h00000000C0: rom_data <= 16'h83C3;
40'h00000000C1: rom_data <= 16'h000B;
40'h00000000C2: rom_data <= 16'h0000;
40'h00000000C3: rom_data <= 16'h0000;
40'h00000000C4: rom_data <= 16'hA043;
40'h00000000C5: rom_data <= 16'h0000;
40'h00000000C6: rom_data <= 16'h2402;
40'h00000000C7: rom_data <= 16'h03E9;
40'h00000000C8: rom_data <= 16'h2403;
40'h00000000C9: rom_data <= 16'h0001;
40'h00000000CA: rom_data <= 16'hA043;
40'h00000000CB: rom_data <= 16'h0000;
40'h00000000CC: rom_data <= 16'h2402;
40'h00000000CD: rom_data <= 16'h03EA;
40'h00000000CE: rom_data <= 16'h8042;
40'h00000000CF: rom_data <= 16'h0000;
40'h00000000D0: rom_data <= 16'h0000;
40'h00000000D1: rom_data <= 16'h0000;
40'h00000000D2: rom_data <= 16'h1040;
40'h00000000D3: rom_data <= 16'hFFFC;
40'h00000000D4: rom_data <= 16'h0000;
40'h00000000D5: rom_data <= 16'h0000;
40'h00000000D6: rom_data <= 16'h2402;
40'h00000000D7: rom_data <= 16'h03E9;
40'h00000000D8: rom_data <= 16'hA040;
40'h00000000D9: rom_data <= 16'h0000;
40'h00000000DA: rom_data <= 16'h2402;
40'h00000000DB: rom_data <= 16'h03EB;
40'h00000000DC: rom_data <= 16'h8042;
40'h00000000DD: rom_data <= 16'h0000;
40'h00000000DE: rom_data <= 16'h0000;
40'h00000000DF: rom_data <= 16'h0000;
40'h00000000E0: rom_data <= 16'h1440;
40'h00000000E1: rom_data <= 16'hFFFC;
40'h00000000E2: rom_data <= 16'h0000;
40'h00000000E3: rom_data <= 16'h0000;
40'h00000000E4: rom_data <= 16'h2402;
40'h00000000E5: rom_data <= 16'h03E8;
40'h00000000E6: rom_data <= 16'h83C3;
40'h00000000E7: rom_data <= 16'h000C;
40'h00000000E8: rom_data <= 16'h0000;
40'h00000000E9: rom_data <= 16'h0000;
40'h00000000EA: rom_data <= 16'hA043;
40'h00000000EB: rom_data <= 16'h0000;
40'h00000000EC: rom_data <= 16'h2402;
40'h00000000ED: rom_data <= 16'h03E9;
40'h00000000EE: rom_data <= 16'h2403;
40'h00000000EF: rom_data <= 16'h0001;
40'h00000000F0: rom_data <= 16'hA043;
40'h00000000F1: rom_data <= 16'h0000;
40'h00000000F2: rom_data <= 16'h2402;
40'h00000000F3: rom_data <= 16'h03EA;
40'h00000000F4: rom_data <= 16'h8042;
40'h00000000F5: rom_data <= 16'h0000;
40'h00000000F6: rom_data <= 16'h0000;
40'h00000000F7: rom_data <= 16'h0000;
40'h00000000F8: rom_data <= 16'h1040;
40'h00000000F9: rom_data <= 16'hFFFC;
40'h00000000FA: rom_data <= 16'h0000;
40'h00000000FB: rom_data <= 16'h0000;
40'h00000000FC: rom_data <= 16'h2402;
40'h00000000FD: rom_data <= 16'h03E9;
40'h00000000FE: rom_data <= 16'hA040;
40'h00000000FF: rom_data <= 16'h0000;
40'h0000000100: rom_data <= 16'h2402;
40'h0000000101: rom_data <= 16'h03EB;
40'h0000000102: rom_data <= 16'h8042;
40'h0000000103: rom_data <= 16'h0000;
40'h0000000104: rom_data <= 16'h0000;
40'h0000000105: rom_data <= 16'h0000;
40'h0000000106: rom_data <= 16'h1440;
40'h0000000107: rom_data <= 16'hFFFC;
40'h0000000108: rom_data <= 16'h0000;
40'h0000000109: rom_data <= 16'h0000;
40'h000000010A: rom_data <= 16'h2402;
40'h000000010B: rom_data <= 16'h03E8;
40'h000000010C: rom_data <= 16'h83C3;
40'h000000010D: rom_data <= 16'h000D;
40'h000000010E: rom_data <= 16'h0000;
40'h000000010F: rom_data <= 16'h0000;
40'h0000000110: rom_data <= 16'hA043;
40'h0000000111: rom_data <= 16'h0000;
40'h0000000112: rom_data <= 16'h2402;
40'h0000000113: rom_data <= 16'h03E9;
40'h0000000114: rom_data <= 16'h2403;
40'h0000000115: rom_data <= 16'h0001;
40'h0000000116: rom_data <= 16'hA043;
40'h0000000117: rom_data <= 16'h0000;
40'h0000000118: rom_data <= 16'h2402;
40'h0000000119: rom_data <= 16'h03EA;
40'h000000011A: rom_data <= 16'h8042;
40'h000000011B: rom_data <= 16'h0000;
40'h000000011C: rom_data <= 16'h0000;
40'h000000011D: rom_data <= 16'h0000;
40'h000000011E: rom_data <= 16'h1040;
40'h000000011F: rom_data <= 16'hFFFC;
40'h0000000120: rom_data <= 16'h0000;
40'h0000000121: rom_data <= 16'h0000;
40'h0000000122: rom_data <= 16'h2402;
40'h0000000123: rom_data <= 16'h03E9;
40'h0000000124: rom_data <= 16'hA040;
40'h0000000125: rom_data <= 16'h0000;
40'h0000000126: rom_data <= 16'h2402;
40'h0000000127: rom_data <= 16'h03EB;
40'h0000000128: rom_data <= 16'h8042;
40'h0000000129: rom_data <= 16'h0000;
40'h000000012A: rom_data <= 16'h0000;
40'h000000012B: rom_data <= 16'h0000;
40'h000000012C: rom_data <= 16'h1440;
40'h000000012D: rom_data <= 16'hFFFC;
40'h000000012E: rom_data <= 16'h0000;
40'h000000012F: rom_data <= 16'h0000;
40'h0000000130: rom_data <= 16'h2402;
40'h0000000131: rom_data <= 16'h03E8;
40'h0000000132: rom_data <= 16'h83C3;
40'h0000000133: rom_data <= 16'h000E;
40'h0000000134: rom_data <= 16'h0000;
40'h0000000135: rom_data <= 16'h0000;
40'h0000000136: rom_data <= 16'hA043;
40'h0000000137: rom_data <= 16'h0000;
40'h0000000138: rom_data <= 16'h2402;
40'h0000000139: rom_data <= 16'h03E9;
40'h000000013A: rom_data <= 16'h2403;
40'h000000013B: rom_data <= 16'h0001;
40'h000000013C: rom_data <= 16'hA043;
40'h000000013D: rom_data <= 16'h0000;
40'h000000013E: rom_data <= 16'h2402;
40'h000000013F: rom_data <= 16'h03EA;
40'h0000000140: rom_data <= 16'h8042;
40'h0000000141: rom_data <= 16'h0000;
40'h0000000142: rom_data <= 16'h0000;
40'h0000000143: rom_data <= 16'h0000;
40'h0000000144: rom_data <= 16'h1040;
40'h0000000145: rom_data <= 16'hFFFC;
40'h0000000146: rom_data <= 16'h0000;
40'h0000000147: rom_data <= 16'h0000;
40'h0000000148: rom_data <= 16'h2402;
40'h0000000149: rom_data <= 16'h03E9;
40'h000000014A: rom_data <= 16'hA040;
40'h000000014B: rom_data <= 16'h0000;
40'h000000014C: rom_data <= 16'h2402;
40'h000000014D: rom_data <= 16'h03EB;
40'h000000014E: rom_data <= 16'h8042;
40'h000000014F: rom_data <= 16'h0000;
40'h0000000150: rom_data <= 16'h0000;
40'h0000000151: rom_data <= 16'h0000;
40'h0000000152: rom_data <= 16'h1440;
40'h0000000153: rom_data <= 16'hFFFC;
40'h0000000154: rom_data <= 16'h0000;
40'h0000000155: rom_data <= 16'h0000;
40'h0000000156: rom_data <= 16'h2402;
40'h0000000157: rom_data <= 16'h03E8;
40'h0000000158: rom_data <= 16'h83C3;
40'h0000000159: rom_data <= 16'h000F;
40'h000000015A: rom_data <= 16'h0000;
40'h000000015B: rom_data <= 16'h0000;
40'h000000015C: rom_data <= 16'hA043;
40'h000000015D: rom_data <= 16'h0000;
40'h000000015E: rom_data <= 16'h2402;
40'h000000015F: rom_data <= 16'h03E9;
40'h0000000160: rom_data <= 16'h2403;
40'h0000000161: rom_data <= 16'h0001;
40'h0000000162: rom_data <= 16'hA043;
40'h0000000163: rom_data <= 16'h0000;
40'h0000000164: rom_data <= 16'h2402;
40'h0000000165: rom_data <= 16'h03EA;
40'h0000000166: rom_data <= 16'h8042;
40'h0000000167: rom_data <= 16'h0000;
40'h0000000168: rom_data <= 16'h0000;
40'h0000000169: rom_data <= 16'h0000;
40'h000000016A: rom_data <= 16'h1040;
40'h000000016B: rom_data <= 16'hFFFC;
40'h000000016C: rom_data <= 16'h0000;
40'h000000016D: rom_data <= 16'h0000;
40'h000000016E: rom_data <= 16'h2402;
40'h000000016F: rom_data <= 16'h03E9;
40'h0000000170: rom_data <= 16'hA040;
40'h0000000171: rom_data <= 16'h0000;
40'h0000000172: rom_data <= 16'h1000;
40'h0000000173: rom_data <= 16'hFF67;
40'h0000000174: rom_data <= 16'h0000;
40'h0000000175: rom_data <= 16'h0000;
40'h0000000176: rom_data <= 16'h0000;
40'h0000000177: rom_data <= 16'h0000;
40'h0000000178: rom_data <= 16'h7200;
40'h0000000179: rom_data <= 16'h003C;
40'h000000017A: rom_data <= 16'h0000;
40'h000000017B: rom_data <= 16'h0000;
40'h000000017C: rom_data <= 16'h0000;
40'h000000017D: rom_data <= 16'h0000;
40'h000000017E: rom_data <= 16'h0000;
40'h000000017F: rom_data <= 16'h0000;
40'h0000000180: rom_data <= 16'h0000;
40'h0000000181: rom_data <= 16'h0000;
40'h0000000182: rom_data <= 16'h0000;
40'h0000000183: rom_data <= 16'h0000;
40'h0000000184: rom_data <= 16'h0000;
40'h0000000185: rom_data <= 16'h0100;
40'h0000000186: rom_data <= 16'h0101;
40'h0000000187: rom_data <= 16'h0001;
40'h0000000188: rom_data <= 16'h0000;
40'h0000000189: rom_data <= 16'h0000;
40'h000000018A: rom_data <= 16'h0000;
40'h000000018B: rom_data <= 16'h0000;
40'h000000018C: rom_data <= 16'h0000;
40'h000000018D: rom_data <= 16'h0000;
40'h000000018E: rom_data <= 16'h0000;
40'h000000018F: rom_data <= 16'h0000;
40'h0000000190: rom_data <= 16'h526F;
40'h0000000191: rom_data <= 16'h6920;
40'h0000000192: rom_data <= 16'h5761;
40'h0000000193: rom_data <= 16'h7320;
40'h0000000194: rom_data <= 16'h4865;
40'h0000000195: rom_data <= 16'h7265;
40'h0000000196: rom_data <= 16'h2120;
40'h0000000197: rom_data <= 16'h0A00;
40'h0000000198: rom_data <= 16'h0000;
40'h0000000199: rom_data <= 16'h0000;
40'h000000019A: rom_data <= 16'h8000;
40'h000000019B: rom_data <= 16'h0000;
40'h000000019C: rom_data <= 16'h0000;
40'h000000019D: rom_data <= 16'h0000;
default:        rom_data <= 16'h0000;            endcase
        end
    end

    // Show SD command requests
    always @ (posedge sdclk) begin
        if (show_sdcmd_en) begin 
            $display("sdcmd request:  %2d  %08x", show_sdcmd_cmd, show_sdcmd_arg);
        end
    end
endmodule
