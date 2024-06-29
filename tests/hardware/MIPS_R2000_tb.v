
`include "signal_def.v"

module TESTBENCH (
    input clk,
    input rst
);
    reg clk_debug;
    reg rst_debug;
    reg [31:0] cycles;
    
    MIPS_R2000 U_MIPS_R2000(
        .clk(clk_debug),
        .rst(rst_debug)
    );

    initial begin
        $dumpfile("MIPS_R2000_tb.vcd");
        $dumpvars;
        $readmemh("../../tests/hardware/asm/MIPS_R2000_tb.hex", U_MIPS_R2000.U_InstructionMemory.IMem);

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
		if (cycles == 4 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd0)) begin
		    $display("ASSERTION FAILED `li $a0, 0`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd0);
		    $finish;
		end

		if (cycles == 5 && !(U_MIPS_R2000.U_GPR.gprRegisters[5] == 32'd5)) begin
		    $display("ASSERTION FAILED `li $a1, 5`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[5], 32'd5);
		    $finish;
		end

		if (cycles == 6 && !(U_MIPS_R2000.U_GPR.gprRegisters[6] == 32'd4294967295)) begin
		    $display("ASSERTION FAILED `li $a1, -1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[6], 32'd4294967295);
		    $finish;
		end

		if (cycles >= 7)
		    $finish;
    end

endmodule
