`include "signal_def.v"

// ################### Consts ###################
`define STAGE_NOT_IN_PIPE -1
`define STAGE_BEFORE_PIPE 5
`define STAGE_AFTER_IF 4
`define STAGE_AFTER_ID 3
`define STAGE_AFTER_EX 2
`define STAGE_AFTER_MEM 1
`define STAGE_AFTER_PIPE 0


module TESTBENCH (
    input clk,
    input rst
);
    reg clk_debug;
    reg rst_debug;
    reg [31:0] cycles;
    
    // ################# Initialize #################
    integer inst0_pipe_stage;
    integer inst1_pipe_stage;
    integer inst2_pipe_stage;
    integer inst3_pipe_stage;
    integer inst4_pipe_stage;
    integer inst5_pipe_stage;
    integer inst6_pipe_stage;
    integer inst7_pipe_stage;
    integer inst8_pipe_stage;
    integer inst9_pipe_stage;
    integer inst10_pipe_stage;
    integer inst11_pipe_stage;
    integer inst12_pipe_stage;
    integer inst13_pipe_stage;
    integer inst14_pipe_stage;
    integer inst15_pipe_stage;
    integer inst16_pipe_stage;
    integer inst17_pipe_stage;
    integer inst18_pipe_stage;
    integer inst19_pipe_stage;
    integer inst20_pipe_stage;
    integer inst21_pipe_stage;
    integer inst22_pipe_stage;
    integer inst23_pipe_stage;
    integer inst24_pipe_stage;
    integer inst25_pipe_stage;
    integer inst26_pipe_stage;
    integer inst27_pipe_stage;
    integer inst28_pipe_stage;
    integer inst29_pipe_stage;
    integer inst30_pipe_stage;
    integer inst31_pipe_stage;
    integer inst32_pipe_stage;
    
    // ############### Condition Vars ###############
    
    
    MIPS_R2000 U_MIPS_R2000(
        .clk(clk_debug),
        .rst(rst_debug)
    );
    
    initial begin
        // ################# Initialize #################
        inst0_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst1_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst2_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst3_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst4_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst5_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst6_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst7_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst8_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst9_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst10_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst11_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst12_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst13_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst14_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst15_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst16_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst17_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst18_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst19_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst20_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst21_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst22_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst23_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst24_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst25_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst26_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst27_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst28_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst29_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst30_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst31_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst32_pipe_stage = `STAGE_NOT_IN_PIPE;
        
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
        if(U_MIPS_R2000.U_PCU.PC > 532) begin
            $finish;
        end
        
        // ########### Update Pipe Stage Vars ###########
        if (inst0_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst0_pipe_stage -= 1;
        end
        
        if (inst1_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst1_pipe_stage -= 1;
        end
        
        if (inst2_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst2_pipe_stage -= 1;
        end
        
        if (inst3_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst3_pipe_stage -= 1;
        end
        
        if (inst4_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst4_pipe_stage -= 1;
        end
        
        if (inst5_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst5_pipe_stage -= 1;
        end
        
        if (inst6_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst6_pipe_stage -= 1;
        end
        
        if (inst7_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst7_pipe_stage -= 1;
        end
        
        if (inst8_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst8_pipe_stage -= 1;
        end
        
        if (inst9_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst9_pipe_stage -= 1;
        end
        
        if (inst10_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst10_pipe_stage -= 1;
        end
        
        if (inst11_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst11_pipe_stage -= 1;
        end
        
        if (inst12_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst12_pipe_stage -= 1;
        end
        
        if (inst13_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst13_pipe_stage -= 1;
        end
        
        if (inst14_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst14_pipe_stage -= 1;
        end
        
        if (inst15_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst15_pipe_stage -= 1;
        end
        
        if (inst16_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst16_pipe_stage -= 1;
        end
        
        if (inst17_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst17_pipe_stage -= 1;
        end
        
        if (inst18_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst18_pipe_stage -= 1;
        end
        
        if (inst19_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst19_pipe_stage -= 1;
        end
        
        if (inst20_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst20_pipe_stage -= 1;
        end
        
        if (inst21_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst21_pipe_stage -= 1;
        end
        
        if (inst22_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst22_pipe_stage -= 1;
        end
        
        if (inst23_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst23_pipe_stage -= 1;
        end
        
        if (inst24_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst24_pipe_stage -= 1;
        end
        
        if (inst25_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst25_pipe_stage -= 1;
        end
        
        if (inst26_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst26_pipe_stage -= 1;
        end
        
        if (inst27_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst27_pipe_stage -= 1;
        end
        
        if (inst28_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst28_pipe_stage -= 1;
        end
        
        if (inst29_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst29_pipe_stage -= 1;
        end
        
        if (inst30_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst30_pipe_stage -= 1;
        end
        
        if (inst31_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst31_pipe_stage -= 1;
        end
        
        if (inst32_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst32_pipe_stage -= 1;
        end
        
        // ################# PC Trigger #################
        if (U_MIPS_R2000.U_PCU.PC == 0) begin
            if (inst0_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst0_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 4) begin
            if (inst1_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst1_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 8) begin
            if (inst2_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst2_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 12) begin
            if (inst3_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst3_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 16) begin
            if (inst4_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst4_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 20) begin
            if (inst5_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst5_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 24) begin
            if (inst6_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst6_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 28) begin
            if (inst7_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst7_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 32) begin
            if (inst8_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst8_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 36) begin
            if (inst9_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst9_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 40) begin
            if (inst10_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst10_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 44) begin
            if (inst11_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst11_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 48) begin
            if (inst12_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst12_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 52) begin
            if (inst13_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst13_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 56) begin
            if (inst14_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst14_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 60) begin
            if (inst15_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst15_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 64) begin
            if (inst16_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst16_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 68) begin
            if (inst17_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst17_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 72) begin
            if (inst18_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst18_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 76) begin
            if (inst19_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst19_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 80) begin
            if (inst20_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst20_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 84) begin
            if (inst21_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst21_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 88) begin
            if (inst22_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst22_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 92) begin
            if (inst23_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst23_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 96) begin
            if (inst24_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst24_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 100) begin
            if (inst25_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst25_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 104) begin
            if (inst26_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst26_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 108) begin
            if (inst27_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst27_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 112) begin
            if (inst28_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst28_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 116) begin
            if (inst29_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst29_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 120) begin
            if (inst30_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst30_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 124) begin
            if (inst31_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst31_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 128) begin
            if (inst32_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst32_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        // ################# Conditions #################
        if (inst0_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[16] == 0)) begin
                $display("Error: addiu $s0, 0");
                $finish;
            end
        end
        
        if (inst1_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[17] == 1)) begin
                $display("Error: addiu $s1, 1");
                $finish;
            end
        end
        
        if (inst2_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[18] == 5)) begin
                $display("Error: addiu $s2, 5");
                $finish;
            end
        end
        
        if (inst3_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[19] == -1)) begin
                $display("Error: addiu $s3, -1");
                $finish;
            end
        end
        
        if (inst4_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[20] == -2)) begin
                $display("Error: addiu $s4, -2");
                $finish;
            end
        end
        
        if (inst5_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("Error: add $a0, $s0, $s1");
                $finish;
            end
        end
        
        if (inst6_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 2)) begin
                $display("Error: add $a0, $s1, $s1");
                $finish;
            end
        end
        
        if (inst7_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 6)) begin
                $display("Error: add $a0, $s1, $s2");
                $finish;
            end
        end
        
        if (inst8_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -3)) begin
                $display("Error: add $a0, $s3, $s4");
                $finish;
            end
        end
        
        if (inst9_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 0)) begin
                $display("Error: add $a0, $s3, $s1");
                $finish;
            end
        end
        
        if (inst10_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 4)) begin
                $display("Error: add $a0, $s3, $s2");
                $finish;
            end
        end
        
        if (inst11_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -1)) begin
                $display("Error: add $a0, $s1, $s4");
                $finish;
            end
        end
        
        if (inst12_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 5)) begin
                $display("Error: addi $a0, $s0, 5");
                $finish;
            end
        end
        
        if (inst13_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 10001)) begin
                $display("Error: addi $a0, $s1, 10000");
                $finish;
            end
        end
        
        if (inst14_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 9999)) begin
                $display("Error: addi $a0, $s3, 10000");
                $finish;
            end
        end
        
        if (inst15_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -1)) begin
                $display("Error: addi $a0, $s0, -1");
                $finish;
            end
        end
        
        if (inst16_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -2)) begin
                $display("Error: addi $a0, $s0, -2");
                $finish;
            end
        end
        
        if (inst17_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -10000)) begin
                $display("Error: addi $a0, $s0, -10000");
                $finish;
            end
        end
        
        if (inst18_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("Error: addu $a0, $s0, $s1");
                $finish;
            end
        end
        
        if (inst19_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 2)) begin
                $display("Error: addu $a0, $s1, $s1");
                $finish;
            end
        end
        
        if (inst20_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 6)) begin
                $display("Error: addu $a0, $s1, $s2");
                $finish;
            end
        end
        
        if (inst21_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -3)) begin
                $display("Error: addu $a0, $s3, $s4");
                $finish;
            end
        end
        
        if (inst22_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 0)) begin
                $display("Error: addu $a0, $s3, $s1");
                $finish;
            end
        end
        
        if (inst23_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 4)) begin
                $display("Error: addu $a0, $s3, $s2");
                $finish;
            end
        end
        
        if (inst24_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -1)) begin
                $display("Error: addu $a0, $s1, $s4");
                $finish;
            end
        end
        
        if (inst25_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 0)) begin
                $display("Error: and $a0, $s0, $s1");
                $finish;
            end
        end
        
        if (inst26_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("Error: and $a0, $s1, $s1");
                $finish;
            end
        end
        
        if (inst27_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("Error: and $a0, $s1, $s2");
                $finish;
            end
        end
        
        if (inst28_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 5)) begin
                $display("Error: and $a0, $s2, $s3");
                $finish;
            end
        end
        
        if (inst29_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 0)) begin
                $display("Error: andi $a0, $s1, 0");
                $finish;
            end
        end
        
        if (inst30_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("Error: andi $a0, $s1, 1");
                $finish;
            end
        end
        
        if (inst31_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("Error: andi $a0, $s1, 5");
                $finish;
            end
        end
        
        if (inst32_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 5)) begin
                $display("Error: andi $a0, $s3, 5");
                $finish;
            end
        end
        
    end
endmodule
