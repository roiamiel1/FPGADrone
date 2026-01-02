`timescale 1ns / 1ps

`include "signal_def.v"

module TESTBENCH;
    integer cycles;
    reg clk = 0;
    wire uart_tx_out;

    // Clock generation: 27MHz -> Period ≈ 37.037 ns
    always #18.518 clk = ~clk;  // Half-period

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

    // Memory declaration: (16384 x 4) x 8 bits
    reg [7:0] InternalMem [0:65536];
    reg [15:0] SDCardMem   [0:16384];

    string SDCardMemPath;

    initial begin
        if (!$value$plusargs("SDCARD_MEM_PATH=%s", SDCardMemPath)) begin
            $fatal(1, "Usage: vvp +SDCARD_MEM_PATH=path/to/file.bin");
        end
        
        $display("Loading %s", SDCardMemPath);
        $readmemh(SDCardMemPath, SDCardMem);

        $dumpfile("./build/hardware/tests/startup_test/test.vcd");
        $dumpvars;
        
        U_MIPS_R2000.U_IFIDReg.StageReg = 0;
        U_MIPS_R2000.U_IDEXReg.StageReg = 0;
        U_MIPS_R2000.U_EXMEMReg.StageReg = 0;
        U_MIPS_R2000.U_MEMWBReg.StageReg = 0;

        cycles = 0;

        $display("Starting UART receiver...");
        uart_rx();
    end

    MIPS_R2000 U_MIPS_R2000(
        .clk(clk),
        .rst(1'b0),
        .sdclk(sdclk),
        .sdcmd(sdcmd),
        .sddat0(sddat[0]),
        .uart_tx_out(uart_tx_out)
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
    
    // UART receiver task
    task uart_rx;
        integer i;
        reg [7:0] data;
        reg [9:0] uart_frame;
        integer bit_time_ns;
        begin
            bit_time_ns = 37 * 2;  // ≈ 1e9 / (27000000 / 2) baud (in ns)

            forever begin
                // Wait for start bit (falling edge)
                @(negedge uart_tx_out);
                #(bit_time_ns / 2);  // Sample in middle of start bit

                uart_frame = 0;

                // Sample 10 bits: start, data[7:0], stop
                for (i = 0; i < 10; i = i + 1) begin
                    uart_frame[i] = uart_tx_out;
                    #(bit_time_ns);
                end

                // Only proceed if framing is valid
                if (uart_frame[0] === 0 && uart_frame[9] === 1) begin
                    data = uart_frame[8:1];
                    $write("%c", data);
                end else begin
                    $display("Invalid UART frame at time %t: start=%b stop=%b", $time, uart_frame[0], uart_frame[9]);
                end
            end
        end
    endtask

    always @(posedge U_MIPS_R2000.MemoryReady) begin
        $display("\n\n***************  Memory ready  ***************\n\n");
    end

    always @(posedge clk) begin
        if (U_MIPS_R2000.MemoryReady == 1'b1) begin
            cycles = cycles + 1;
            if(cycles > 10000) begin
                $display("\n\n***************  Done  ***************\n\n");
                $finish;
            end
        end
    end

    // Fake content of the fake SD card
    always @ (posedge sdclk) begin
        if (rom_req) begin
            rom_data <= SDCardMem[rom_addr];
        end
    end
endmodule
