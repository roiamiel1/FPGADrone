`timescale 1ns / 1ps

`include "signal_def.v"
`include "../../tests/hardware/startup_test/rom_switch_case.v"

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

    initial begin        
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
    
    // UART receiver task
    task uart_rx;
        integer i;
        reg [7:0] data;
        reg [9:0] uart_frame;
        integer bit_time_ns;
        begin
            bit_time_ns = 104166;  // ≈ 1e9 / 9600 baud (in ns)

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
                    $display("Received char: %c (0x%02h) at time %t", data, data, $time);
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
            if(cycles > 200000) begin
                $display("\n\n***************  Done  ***************\n\n");
                $finish;
            end
        end
    end

    // Fake content of the fake SD card
    always @ (posedge sdclk) begin
        if (rom_req) begin
            case (rom_addr)
                `ROM_SWITCH_CASE
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
