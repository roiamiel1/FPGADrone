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
40'h0000000003: rom_data <= 16'h3FF0;
40'h0000000004: rom_data <= 16'h3C1E;
40'h0000000005: rom_data <= 16'h0000;
40'h0000000006: rom_data <= 16'h37DE;
40'h0000000007: rom_data <= 16'h3FF0;
40'h0000000008: rom_data <= 16'h0800;
40'h0000000009: rom_data <= 16'h000C;
40'h000000000A: rom_data <= 16'hA7E3;
40'h000000000B: rom_data <= 16'hCA2D;
40'h000000000C: rom_data <= 16'h75A2;
40'h000000000D: rom_data <= 16'h99F1;
40'h000000000E: rom_data <= 16'h63C1;
40'h000000000F: rom_data <= 16'h2CB7;
40'h0000000010: rom_data <= 16'h54A3;
40'h0000000011: rom_data <= 16'hF95D;
40'h0000000012: rom_data <= 16'h0000;
40'h0000000013: rom_data <= 16'h0000;
40'h0000000014: rom_data <= 16'h0000;
40'h0000000015: rom_data <= 16'h0000;
40'h0000000016: rom_data <= 16'h0000;
40'h0000000017: rom_data <= 16'h0000;
40'h0000000018: rom_data <= 16'h27BD;
40'h0000000019: rom_data <= 16'hFFE8;
40'h000000001A: rom_data <= 16'hAFBE;
40'h000000001B: rom_data <= 16'h0014;
40'h000000001C: rom_data <= 16'h03A0;
40'h000000001D: rom_data <= 16'hF025;
40'h000000001E: rom_data <= 16'h3C02;
40'h000000001F: rom_data <= 16'h0000;
40'h0000000020: rom_data <= 16'h2442;
40'h0000000021: rom_data <= 16'h0150;
40'h0000000022: rom_data <= 16'hAFC2;
40'h0000000023: rom_data <= 16'h0008;
40'h0000000024: rom_data <= 16'h0000;
40'h0000000025: rom_data <= 16'h0000;
40'h0000000026: rom_data <= 16'h2402;
40'h0000000027: rom_data <= 16'h03EB;
40'h0000000028: rom_data <= 16'h8042;
40'h0000000029: rom_data <= 16'h0000;
40'h000000002A: rom_data <= 16'h0000;
40'h000000002B: rom_data <= 16'h0000;
40'h000000002C: rom_data <= 16'h1440;
40'h000000002D: rom_data <= 16'hFFFC;
40'h000000002E: rom_data <= 16'h0000;
40'h000000002F: rom_data <= 16'h0000;
40'h0000000030: rom_data <= 16'h2402;
40'h0000000031: rom_data <= 16'h03E8;
40'h0000000032: rom_data <= 16'h8FC3;
40'h0000000033: rom_data <= 16'h0008;
40'h0000000034: rom_data <= 16'h0000;
40'h0000000035: rom_data <= 16'h0000;
40'h0000000036: rom_data <= 16'h8063;
40'h0000000037: rom_data <= 16'h0000;
40'h0000000038: rom_data <= 16'h0000;
40'h0000000039: rom_data <= 16'h0000;
40'h000000003A: rom_data <= 16'hA043;
40'h000000003B: rom_data <= 16'h0000;
40'h000000003C: rom_data <= 16'h2402;
40'h000000003D: rom_data <= 16'h03E9;
40'h000000003E: rom_data <= 16'h2403;
40'h000000003F: rom_data <= 16'h0001;
40'h0000000040: rom_data <= 16'hA043;
40'h0000000041: rom_data <= 16'h0000;
40'h0000000042: rom_data <= 16'h2402;
40'h0000000043: rom_data <= 16'h03EA;
40'h0000000044: rom_data <= 16'h8042;
40'h0000000045: rom_data <= 16'h0000;
40'h0000000046: rom_data <= 16'h0000;
40'h0000000047: rom_data <= 16'h0000;
40'h0000000048: rom_data <= 16'h1040;
40'h0000000049: rom_data <= 16'hFFFC;
40'h000000004A: rom_data <= 16'h0000;
40'h000000004B: rom_data <= 16'h0000;
40'h000000004C: rom_data <= 16'h2402;
40'h000000004D: rom_data <= 16'h03E9;
40'h000000004E: rom_data <= 16'hA040;
40'h000000004F: rom_data <= 16'h0000;
40'h0000000050: rom_data <= 16'h2402;
40'h0000000051: rom_data <= 16'h03EB;
40'h0000000052: rom_data <= 16'h8042;
40'h0000000053: rom_data <= 16'h0000;
40'h0000000054: rom_data <= 16'h0000;
40'h0000000055: rom_data <= 16'h0000;
40'h0000000056: rom_data <= 16'h1440;
40'h0000000057: rom_data <= 16'hFFFC;
40'h0000000058: rom_data <= 16'h0000;
40'h0000000059: rom_data <= 16'h0000;
40'h000000005A: rom_data <= 16'h8FC2;
40'h000000005B: rom_data <= 16'h0008;
40'h000000005C: rom_data <= 16'h0000;
40'h000000005D: rom_data <= 16'h0000;
40'h000000005E: rom_data <= 16'h2443;
40'h000000005F: rom_data <= 16'h0015;
40'h0000000060: rom_data <= 16'h2402;
40'h0000000061: rom_data <= 16'h03E8;
40'h0000000062: rom_data <= 16'h8063;
40'h0000000063: rom_data <= 16'h0000;
40'h0000000064: rom_data <= 16'h0000;
40'h0000000065: rom_data <= 16'h0000;
40'h0000000066: rom_data <= 16'hA043;
40'h0000000067: rom_data <= 16'h0000;
40'h0000000068: rom_data <= 16'h2402;
40'h0000000069: rom_data <= 16'h03E9;
40'h000000006A: rom_data <= 16'h2403;
40'h000000006B: rom_data <= 16'h0001;
40'h000000006C: rom_data <= 16'hA043;
40'h000000006D: rom_data <= 16'h0000;
40'h000000006E: rom_data <= 16'h2402;
40'h000000006F: rom_data <= 16'h03EA;
40'h0000000070: rom_data <= 16'h8042;
40'h0000000071: rom_data <= 16'h0000;
40'h0000000072: rom_data <= 16'h0000;
40'h0000000073: rom_data <= 16'h0000;
40'h0000000074: rom_data <= 16'h1040;
40'h0000000075: rom_data <= 16'hFFFC;
40'h0000000076: rom_data <= 16'h0000;
40'h0000000077: rom_data <= 16'h0000;
40'h0000000078: rom_data <= 16'h2402;
40'h0000000079: rom_data <= 16'h03E9;
40'h000000007A: rom_data <= 16'hA040;
40'h000000007B: rom_data <= 16'h0000;
40'h000000007C: rom_data <= 16'h2402;
40'h000000007D: rom_data <= 16'h03EB;
40'h000000007E: rom_data <= 16'h8042;
40'h000000007F: rom_data <= 16'h0000;
40'h0000000080: rom_data <= 16'h0000;
40'h0000000081: rom_data <= 16'h0000;
40'h0000000082: rom_data <= 16'h1440;
40'h0000000083: rom_data <= 16'hFFFC;
40'h0000000084: rom_data <= 16'h0000;
40'h0000000085: rom_data <= 16'h0000;
40'h0000000086: rom_data <= 16'h2402;
40'h0000000087: rom_data <= 16'h03E8;
40'h0000000088: rom_data <= 16'h2403;
40'h0000000089: rom_data <= 16'h0041;
40'h000000008A: rom_data <= 16'hA043;
40'h000000008B: rom_data <= 16'h0000;
40'h000000008C: rom_data <= 16'h2402;
40'h000000008D: rom_data <= 16'h03E9;
40'h000000008E: rom_data <= 16'h2403;
40'h000000008F: rom_data <= 16'h0001;
40'h0000000090: rom_data <= 16'hA043;
40'h0000000091: rom_data <= 16'h0000;
40'h0000000092: rom_data <= 16'h2402;
40'h0000000093: rom_data <= 16'h03EA;
40'h0000000094: rom_data <= 16'h8042;
40'h0000000095: rom_data <= 16'h0000;
40'h0000000096: rom_data <= 16'h0000;
40'h0000000097: rom_data <= 16'h0000;
40'h0000000098: rom_data <= 16'h1040;
40'h0000000099: rom_data <= 16'hFFFC;
40'h000000009A: rom_data <= 16'h0000;
40'h000000009B: rom_data <= 16'h0000;
40'h000000009C: rom_data <= 16'h2402;
40'h000000009D: rom_data <= 16'h03E9;
40'h000000009E: rom_data <= 16'hA040;
40'h000000009F: rom_data <= 16'h0000;
40'h00000000A0: rom_data <= 16'h1000;
40'h00000000A1: rom_data <= 16'hFFC2;
40'h00000000A2: rom_data <= 16'h0000;
40'h00000000A3: rom_data <= 16'h0000;
40'h00000000A4: rom_data <= 16'h0000;
40'h00000000A5: rom_data <= 16'h0000;
40'h00000000A6: rom_data <= 16'h0000;
40'h00000000A7: rom_data <= 16'h0000;
40'h00000000A8: rom_data <= 16'h526F;
40'h00000000A9: rom_data <= 16'h6920;
40'h00000000AA: rom_data <= 16'h5761;
40'h00000000AB: rom_data <= 16'h7320;
40'h00000000AC: rom_data <= 16'h4865;
40'h00000000AD: rom_data <= 16'h7265;
40'h00000000AE: rom_data <= 16'h2120;
40'h00000000AF: rom_data <= 16'h0A20;
40'h00000000B0: rom_data <= 16'h416E;
40'h00000000B1: rom_data <= 16'h6420;
40'h00000000B2: rom_data <= 16'h4865;
40'h00000000B3: rom_data <= 16'h7265;
40'h00000000B4: rom_data <= 16'h2120;
40'h00000000B5: rom_data <= 16'h0A20;
40'h00000000B6: rom_data <= 16'h416E;
40'h00000000B7: rom_data <= 16'h6420;
40'h00000000B8: rom_data <= 16'h4D6F;
40'h00000000B9: rom_data <= 16'h7265;
40'h00000000BA: rom_data <= 16'h2048;
40'h00000000BB: rom_data <= 16'h6572;
40'h00000000BC: rom_data <= 16'h6521;
40'h00000000BD: rom_data <= 16'h0A00;
40'h00000000BE: rom_data <= 16'h0000;
40'h00000000BF: rom_data <= 16'h0000;
40'h00000000C0: rom_data <= 16'h6000;
40'h00000000C1: rom_data <= 16'h000C;
40'h00000000C2: rom_data <= 16'h0000;
40'h00000000C3: rom_data <= 16'h0000;
40'h00000000C4: rom_data <= 16'h0000;
40'h00000000C5: rom_data <= 16'h0000;
40'h00000000C6: rom_data <= 16'h0000;
40'h00000000C7: rom_data <= 16'h0000;
40'h00000000C8: rom_data <= 16'h0000;
40'h00000000C9: rom_data <= 16'h0000;
40'h00000000CA: rom_data <= 16'h0000;
40'h00000000CB: rom_data <= 16'h0000;
40'h00000000CC: rom_data <= 16'h0000;
40'h00000000CD: rom_data <= 16'h0100;
40'h00000000CE: rom_data <= 16'h0101;
40'h00000000CF: rom_data <= 16'h0001;
40'h00000000D0: rom_data <= 16'h0000;
40'h00000000D1: rom_data <= 16'h0000;
40'h00000000D2: rom_data <= 16'h0000;
40'h00000000D3: rom_data <= 16'h0000;
40'h00000000D4: rom_data <= 16'h0000;
40'h00000000D5: rom_data <= 16'h0000;
40'h00000000D6: rom_data <= 16'h0000;
40'h00000000D7: rom_data <= 16'h0000;
default:        rom_data <= 16'h0000;
    
    endcase
    end
    end

    // Show SD command requests
    always @ (posedge sdclk) begin
        if (show_sdcmd_en) begin 
            $display("sdcmd request:  %2d  %08x", show_sdcmd_cmd, show_sdcmd_arg);
        end
    end
endmodule
