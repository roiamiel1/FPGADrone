
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
        cycles = cycles + 1;
		if (cycles == 5 && !(U_MIPS_R2000.U_GPR.gprRegisters[16] == 32'd0)) begin
		    $display("ASSERTION FAILED `addiu $s0, 0`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[16], 32'd0);
		    $finish;
		end

		if (cycles == 6 && !(U_MIPS_R2000.U_GPR.gprRegisters[17] == 32'd1)) begin
		    $display("ASSERTION FAILED `addiu $s1, 1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[17], 32'd1);
		    $finish;
		end

		if (cycles == 7 && !(U_MIPS_R2000.U_GPR.gprRegisters[18] == 32'd5)) begin
		    $display("ASSERTION FAILED `addiu $s2, 5`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[18], 32'd5);
		    $finish;
		end

		if (cycles == 8 && !(U_MIPS_R2000.U_GPR.gprRegisters[19] == 32'd4294967295)) begin
		    $display("ASSERTION FAILED `addiu $s3, -1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[19], 32'd4294967295);
		    $finish;
		end

		if (cycles == 9 && !(U_MIPS_R2000.U_GPR.gprRegisters[20] == 32'd4294967294)) begin
		    $display("ASSERTION FAILED `addiu $s4, -2`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[20], 32'd4294967294);
		    $finish;
		end

		if (cycles == 10 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd1)) begin
		    $display("ASSERTION FAILED `add $a0, $s0, $s1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd1);
		    $finish;
		end

		if (cycles == 11 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd2)) begin
		    $display("ASSERTION FAILED `add $a0, $s1, $s1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd2);
		    $finish;
		end

		if (cycles == 12 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd6)) begin
		    $display("ASSERTION FAILED `add $a0, $s1, $s2`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd6);
		    $finish;
		end

		if (cycles == 13 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd4294967293)) begin
		    $display("ASSERTION FAILED `add $a0, $s3, $s4`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd4294967293);
		    $finish;
		end

		if (cycles == 14 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd0)) begin
		    $display("ASSERTION FAILED `add $a0, $s3, $s1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd0);
		    $finish;
		end

		if (cycles == 15 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd4)) begin
		    $display("ASSERTION FAILED `add $a0, $s3, $s2`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd4);
		    $finish;
		end

		if (cycles == 16 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd4294967295)) begin
		    $display("ASSERTION FAILED `add $a0, $s1, $s4`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd4294967295);
		    $finish;
		end

		if (cycles == 17 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd5)) begin
		    $display("ASSERTION FAILED `addi $a0, $s0, 5`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd5);
		    $finish;
		end

		if (cycles == 18 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd10001)) begin
		    $display("ASSERTION FAILED `addi $a0, $s1, 10000`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd10001);
		    $finish;
		end

		if (cycles == 19 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd9999)) begin
		    $display("ASSERTION FAILED `addi $a0, $s3, 10000`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd9999);
		    $finish;
		end

		if (cycles == 20 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd4294967295)) begin
		    $display("ASSERTION FAILED `addi $a0, $s0, -1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd4294967295);
		    $finish;
		end

		if (cycles == 21 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd4294967294)) begin
		    $display("ASSERTION FAILED `addi $a0, $s0, -2`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd4294967294);
		    $finish;
		end

		if (cycles == 22 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd4294957296)) begin
		    $display("ASSERTION FAILED `addi $a0, $s0, -10000`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd4294957296);
		    $finish;
		end

		if (cycles == 23 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd1)) begin
		    $display("ASSERTION FAILED `addu $a0, $s0, $s1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd1);
		    $finish;
		end

		if (cycles == 24 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd2)) begin
		    $display("ASSERTION FAILED `addu $a0, $s1, $s1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd2);
		    $finish;
		end

		if (cycles == 25 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd6)) begin
		    $display("ASSERTION FAILED `addu $a0, $s1, $s2`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd6);
		    $finish;
		end

		if (cycles == 26 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd4294967293)) begin
		    $display("ASSERTION FAILED `addu $a0, $s3, $s4`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd4294967293);
		    $finish;
		end

		if (cycles == 27 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd0)) begin
		    $display("ASSERTION FAILED `addu $a0, $s3, $s1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd0);
		    $finish;
		end

		if (cycles == 28 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd4)) begin
		    $display("ASSERTION FAILED `addu $a0, $s3, $s2`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd4);
		    $finish;
		end

		if (cycles == 29 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd4294967295)) begin
		    $display("ASSERTION FAILED `addu $a0, $s1, $s4`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd4294967295);
		    $finish;
		end

		if (cycles == 30 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd0)) begin
		    $display("ASSERTION FAILED `and $a0, $s0, $s1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd0);
		    $finish;
		end

		if (cycles == 31 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd1)) begin
		    $display("ASSERTION FAILED `and $a0, $s1, $s1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd1);
		    $finish;
		end

		if (cycles == 32 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd1)) begin
		    $display("ASSERTION FAILED `and $a0, $s1, $s2`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd1);
		    $finish;
		end

		if (cycles == 33 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd5)) begin
		    $display("ASSERTION FAILED `and $a0, $s2, $s3`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd5);
		    $finish;
		end

		if (cycles == 34 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd0)) begin
		    $display("ASSERTION FAILED `andi $a0, $s1, 0`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd0);
		    $finish;
		end

		if (cycles == 35 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd1)) begin
		    $display("ASSERTION FAILED `andi $a0, $s1, 1`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd1);
		    $finish;
		end

		if (cycles == 36 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd1)) begin
		    $display("ASSERTION FAILED `andi $a0, $s1, 5`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd1);
		    $finish;
		end

		if (cycles == 37 && !(U_MIPS_R2000.U_GPR.gprRegisters[4] == 32'd5)) begin
		    $display("ASSERTION FAILED `andi $a0, $s3, 5`: signal(%8X) != value(%8X)", U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd5);
		    $finish;
		end

		if (cycles >= 37)
		    $finish;
    end

endmodule
