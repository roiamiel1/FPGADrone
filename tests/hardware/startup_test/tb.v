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
                40'h0000000000: rom_data <= 16'h1111;
                40'h0000000001: rom_data <= 16'h2222;
                40'h0000000002: rom_data <= 16'h3333;
                40'h0000000003: rom_data <= 16'h4444;
                40'h0000000004: rom_data <= 16'h5555;
                40'h0000000005: rom_data <= 16'h6666;
                40'h0000000006: rom_data <= 16'h7777;
                40'h0000000007: rom_data <= 16'h8888;
                40'h0000000008: rom_data <= 16'h9999;
                40'h0000000009: rom_data <= 16'hAAAA;
                40'h000000000A: rom_data <= 16'hBBBB;
                40'h000000000B: rom_data <= 16'hCCCC;
                40'h000000000C: rom_data <= 16'hDDDD;
                40'h000000000D: rom_data <= 16'hEEEE;
                40'h000000000E: rom_data <= 16'hFFFF;
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
