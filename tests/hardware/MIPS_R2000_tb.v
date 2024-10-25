// NOTE! THIS FILE IS AUTO GENERATED!
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
    integer inst33_pipe_stage;
    integer inst35_pipe_stage;
    integer inst36_pipe_stage;
    integer inst37_pipe_stage;
    integer inst39_pipe_stage;
    integer inst40_pipe_stage;
    integer inst41_pipe_stage;
    integer inst43_pipe_stage;
    integer inst44_pipe_stage;
    integer inst45_pipe_stage;
    integer inst47_pipe_stage;
    integer inst48_pipe_stage;
    integer inst49_pipe_stage;
    integer inst50_pipe_stage;
    integer inst51_pipe_stage;
    integer inst52_pipe_stage;
    integer inst53_pipe_stage;
    integer inst54_pipe_stage;
    integer inst56_pipe_stage;
    integer inst57_pipe_stage;
    
    // ############### Condition Vars ###############
    reg [31:0] future_33_pc_before = 32'd0;
    reg [31:0] future_37_pc_before = 32'd0;
    reg [31:0] future_41_pc_before = 32'd0;
    reg [31:0] future_45_pc_before = 32'd0;
    reg [31:0] future_54_pc_before = 32'd0;
    
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
        inst33_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst35_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst36_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst37_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst39_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst40_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst41_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst43_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst44_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst45_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst47_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst48_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst49_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst50_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst51_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst52_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst53_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst54_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst56_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst57_pipe_stage = `STAGE_NOT_IN_PIPE;
        
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
        if(U_MIPS_R2000.U_PCU.PC > 932) begin
            $display("\n\n***************  Done  ***************\n\n");
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
        
        if (inst33_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst33_pipe_stage -= 1;
        end
        
        if (inst35_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst35_pipe_stage -= 1;
        end
        
        if (inst36_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst36_pipe_stage -= 1;
        end
        
        if (inst37_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst37_pipe_stage -= 1;
        end
        
        if (inst39_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst39_pipe_stage -= 1;
        end
        
        if (inst40_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst40_pipe_stage -= 1;
        end
        
        if (inst41_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst41_pipe_stage -= 1;
        end
        
        if (inst43_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst43_pipe_stage -= 1;
        end
        
        if (inst44_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst44_pipe_stage -= 1;
        end
        
        if (inst45_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst45_pipe_stage -= 1;
        end
        
        if (inst47_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst47_pipe_stage -= 1;
        end
        
        if (inst48_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst48_pipe_stage -= 1;
        end
        
        if (inst49_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst49_pipe_stage -= 1;
        end
        
        if (inst50_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst50_pipe_stage -= 1;
        end
        
        if (inst51_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst51_pipe_stage -= 1;
        end
        
        if (inst52_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst52_pipe_stage -= 1;
        end
        
        if (inst53_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst53_pipe_stage -= 1;
        end
        
        if (inst54_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst54_pipe_stage -= 1;
        end
        
        if (inst56_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst56_pipe_stage -= 1;
        end
        
        if (inst57_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst57_pipe_stage -= 1;
        end
        
        // ################# PC Trigger #################
        if (U_MIPS_R2000.U_PCU.PC == 0) begin
            if (inst0_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst0_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst0_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 4) begin
            if (inst1_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst1_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst1_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 8) begin
            if (inst2_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst2_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst2_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 12) begin
            if (inst3_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst3_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst3_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 16) begin
            if (inst4_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst4_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst4_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 20) begin
            if (inst5_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst5_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst5_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 24) begin
            if (inst6_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst6_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst6_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 28) begin
            if (inst7_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst7_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst7_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 32) begin
            if (inst8_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst8_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst8_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 36) begin
            if (inst9_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst9_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst9_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 40) begin
            if (inst10_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst10_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst10_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 44) begin
            if (inst11_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst11_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst11_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 48) begin
            if (inst12_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst12_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst12_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 52) begin
            if (inst13_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst13_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst13_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 56) begin
            if (inst14_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst14_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst14_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 60) begin
            if (inst15_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst15_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst15_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 64) begin
            if (inst16_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst16_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst16_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 68) begin
            if (inst17_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst17_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst17_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 72) begin
            if (inst18_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst18_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst18_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 76) begin
            if (inst19_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst19_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst19_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 80) begin
            if (inst20_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst20_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst20_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 84) begin
            if (inst21_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst21_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst21_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 88) begin
            if (inst22_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst22_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst22_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 92) begin
            if (inst23_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst23_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst23_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 96) begin
            if (inst24_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst24_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst24_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 100) begin
            if (inst25_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst25_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst25_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 104) begin
            if (inst26_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst26_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst26_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 108) begin
            if (inst27_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst27_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst27_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 112) begin
            if (inst28_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst28_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst28_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 116) begin
            if (inst29_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst29_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst29_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 120) begin
            if (inst30_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst30_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst30_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 124) begin
            if (inst31_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst31_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst31_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 128) begin
            if (inst32_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst32_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst32_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 132) begin
            if (inst33_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst33_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst33_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 140) begin
            if (inst35_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst35_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst35_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 144) begin
            if (inst36_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst36_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst36_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 148) begin
            if (inst37_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst37_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst37_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 156) begin
            if (inst39_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst39_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst39_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 160) begin
            if (inst40_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst40_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst40_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 164) begin
            if (inst41_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst41_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst41_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 172) begin
            if (inst43_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst43_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst43_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 176) begin
            if (inst44_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst44_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst44_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 180) begin
            if (inst45_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst45_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst45_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 188) begin
            if (inst47_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst47_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst47_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 192) begin
            if (inst48_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst48_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst48_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 196) begin
            if (inst49_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst49_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst49_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 200) begin
            if (inst50_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst50_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst50_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 204) begin
            if (inst51_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst51_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst51_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 208) begin
            if (inst52_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst52_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst52_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 212) begin
            if (inst53_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst53_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst53_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 216) begin
            if (inst54_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst54_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst54_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 224) begin
            if (inst56_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst56_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst56_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 228) begin
            if (inst57_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("\n***************  Error  ***************");
                $display("Instruction inst57_pipe_stage already in pipeline");
                $display("\n");
                $finish;
            end
            
            inst57_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        // ########### Reset Pipe Stage Vars On Hazard ###########
        if (U_MIPS_R2000.U_HazardUnit.Hazard) begin
            // Drop IFID/IDEX/EXMEM instructions.
            if (`STAGE_AFTER_EX <= inst0_pipe_stage && inst0_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst0_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst1_pipe_stage && inst1_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst1_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst2_pipe_stage && inst2_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst2_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst3_pipe_stage && inst3_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst3_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst4_pipe_stage && inst4_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst4_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst5_pipe_stage && inst5_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst5_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst6_pipe_stage && inst6_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst6_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst7_pipe_stage && inst7_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst7_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst8_pipe_stage && inst8_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst8_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst9_pipe_stage && inst9_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst9_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst10_pipe_stage && inst10_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst10_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst11_pipe_stage && inst11_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst11_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst12_pipe_stage && inst12_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst12_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst13_pipe_stage && inst13_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst13_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst14_pipe_stage && inst14_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst14_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst15_pipe_stage && inst15_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst15_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst16_pipe_stage && inst16_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst16_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst17_pipe_stage && inst17_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst17_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst18_pipe_stage && inst18_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst18_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst19_pipe_stage && inst19_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst19_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst20_pipe_stage && inst20_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst20_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst21_pipe_stage && inst21_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst21_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst22_pipe_stage && inst22_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst22_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst23_pipe_stage && inst23_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst23_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst24_pipe_stage && inst24_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst24_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst25_pipe_stage && inst25_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst25_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst26_pipe_stage && inst26_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst26_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst27_pipe_stage && inst27_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst27_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst28_pipe_stage && inst28_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst28_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst29_pipe_stage && inst29_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst29_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst30_pipe_stage && inst30_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst30_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst31_pipe_stage && inst31_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst31_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst32_pipe_stage && inst32_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst32_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst33_pipe_stage && inst33_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst33_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst35_pipe_stage && inst35_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst35_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst36_pipe_stage && inst36_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst36_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst37_pipe_stage && inst37_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst37_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst39_pipe_stage && inst39_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst39_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst40_pipe_stage && inst40_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst40_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst41_pipe_stage && inst41_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst41_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst43_pipe_stage && inst43_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst43_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst44_pipe_stage && inst44_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst44_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst45_pipe_stage && inst45_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst45_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst47_pipe_stage && inst47_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst47_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst48_pipe_stage && inst48_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst48_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst49_pipe_stage && inst49_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst49_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst50_pipe_stage && inst50_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst50_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst51_pipe_stage && inst51_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst51_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst52_pipe_stage && inst52_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst52_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst53_pipe_stage && inst53_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst53_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst54_pipe_stage && inst54_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst54_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst56_pipe_stage && inst56_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst56_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst57_pipe_stage && inst57_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst57_pipe_stage = `STAGE_NOT_IN_PIPE;
        end
        
        // ################# Conditions #################
        if (inst0_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[16] == 0)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddiu $s0, 0\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[16] == 0\n\n* Variables:\n\tafter_mem(REGS.S0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[16]);
                $finish;
            end
        end
        
        if (inst1_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[17] == 1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddiu $s1, 1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[17] == 1\n\n* Variables:\n\tafter_mem(REGS.S1) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[17]);
                $finish;
            end
        end
        
        if (inst2_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[18] == 5)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddiu $s2, 5\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[18] == 5\n\n* Variables:\n\tafter_mem(REGS.S2) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[18]);
                $finish;
            end
        end
        
        if (inst3_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[19] == -1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddiu $s3, -1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[19] == -1\n\n* Variables:\n\tafter_mem(REGS.S3) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[19]);
                $finish;
            end
        end
        
        if (inst4_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[20] == -2)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddiu $s4, -2\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[20] == -2\n\n* Variables:\n\tafter_mem(REGS.S4) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[20]);
                $finish;
            end
        end
        
        if (inst5_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a0, $s0, $s1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 1\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst6_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 2)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a0, $s1, $s1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 2\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst7_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 6)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a0, $s1, $s2\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 6\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst8_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -3)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a0, $s3, $s4\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == -3\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst9_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 0)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a0, $s3, $s1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 0\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst10_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 4)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a0, $s3, $s2\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 4\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst11_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a0, $s1, $s4\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == -1\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst12_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 5)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddi $a0, $s0, 5\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 5\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst13_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 10001)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddi $a0, $s1, 10000\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 10001\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst14_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 9999)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddi $a0, $s3, 10000\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 9999\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst15_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddi $a0, $s0, -1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == -1\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst16_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -2)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddi $a0, $s0, -2\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == -2\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst17_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -10000)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddi $a0, $s0, -10000\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == -10000\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst18_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddu $a0, $s0, $s1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 1\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst19_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 2)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddu $a0, $s1, $s1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 2\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst20_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 6)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddu $a0, $s1, $s2\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 6\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst21_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -3)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddu $a0, $s3, $s4\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == -3\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst22_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 0)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddu $a0, $s3, $s1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 0\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst23_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 4)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddu $a0, $s3, $s2\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 4\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst24_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == -1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddu $a0, $s1, $s4\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == -1\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst25_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 0)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tand $a0, $s0, $s1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 0\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst26_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tand $a0, $s1, $s1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 1\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst27_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tand $a0, $s1, $s2\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 1\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst28_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 5)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tand $a0, $s2, $s3\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 5\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst29_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 0)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tandi $a0, $s1, 0\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 0\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst30_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tandi $a0, $s1, 1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 1\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst31_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 1)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tandi $a0, $s1, 5\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 1\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst32_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[4] == 5)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tandi $a0, $s3, 5\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[4] == 5\n\n* Variables:\n\tafter_mem(REGS.A0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[4]);
                $finish;
            end
        end
        
        if (inst33_pipe_stage == `STAGE_BEFORE_PIPE) begin
            future_33_pc_before = U_MIPS_R2000.U_PCU.PC;
        end
        
        if (inst33_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_PCU.PC == future_33_pc_before + 4*3)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbeq $s0, $s0, beq_success\n\n* Condition:\n\tU_MIPS_R2000.U_PCU.PC == future_33_pc_before + 4*3\n\n* Variables:\n\tbefore(REGS.PC) = 0x%8X\n\tafter_mem(REGS.PC) = 0x%8X\n", future_33_pc_before, U_MIPS_R2000.U_PCU.PC);
                $finish;
            end
        end
        
        if (inst35_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(0 /* always false */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbeq_unsuccess: and $a0, $s0, $s1\n\n* Condition:\n\t0 /* always false */");
                $finish;
            end
        end
        
        if (inst36_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(1 /* always true */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbeq_success: and $a0, $s0, $s1\n\n* Condition:\n\t1 /* always true */");
                $finish;
            end
        end
        
        if (inst37_pipe_stage == `STAGE_BEFORE_PIPE) begin
            future_37_pc_before = U_MIPS_R2000.U_PCU.PC;
        end
        
        if (inst37_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_PCU.PC == future_37_pc_before + 4*3)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbne $s0, $s1, bne_success\n\n* Condition:\n\tU_MIPS_R2000.U_PCU.PC == future_37_pc_before + 4*3\n\n* Variables:\n\tbefore(REGS.PC) = 0x%8X\n\tafter_mem(REGS.PC) = 0x%8X\n", future_37_pc_before, U_MIPS_R2000.U_PCU.PC);
                $finish;
            end
        end
        
        if (inst39_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(0 /* always false */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbne_unsuccess: and $a0, $s0, $s1\n\n* Condition:\n\t0 /* always false */");
                $finish;
            end
        end
        
        if (inst40_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(1 /* always true */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbne_success: and $a0, $s1, $s1\n\n* Condition:\n\t1 /* always true */");
                $finish;
            end
        end
        
        if (inst41_pipe_stage == `STAGE_BEFORE_PIPE) begin
            future_41_pc_before = U_MIPS_R2000.U_PCU.PC;
        end
        
        if (inst41_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_PCU.PC == future_41_pc_before + 4*4)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbeq $s0, $s1, nbeq_success\n\n* Condition:\n\tU_MIPS_R2000.U_PCU.PC == future_41_pc_before + 4*4\n\n* Variables:\n\tbefore(REGS.PC) = 0x%8X\n\tafter_mem(REGS.PC) = 0x%8X\n", future_41_pc_before, U_MIPS_R2000.U_PCU.PC);
                $finish;
            end
        end
        
        if (inst43_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(1 /* always true */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tnbeq_unsuccess: and $a0, $s0, $s1\n\n* Condition:\n\t1 /* always true */");
                $finish;
            end
        end
        
        if (inst44_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(1 /* always true */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tnbeq_success: and $a0, $s0, $s1\n\n* Condition:\n\t1 /* always true */");
                $finish;
            end
        end
        
        if (inst45_pipe_stage == `STAGE_BEFORE_PIPE) begin
            future_45_pc_before = U_MIPS_R2000.U_PCU.PC;
        end
        
        if (inst45_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_PCU.PC == future_45_pc_before + 4*4)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbne $s0, $s0, nbne_success\n\n* Condition:\n\tU_MIPS_R2000.U_PCU.PC == future_45_pc_before + 4*4\n\n* Variables:\n\tbefore(REGS.PC) = 0x%8X\n\tafter_mem(REGS.PC) = 0x%8X\n", future_45_pc_before, U_MIPS_R2000.U_PCU.PC);
                $finish;
            end
        end
        
        if (inst47_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(1 /* always true */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tnbne_unsuccess: and $a0, $s0, $s1\n\n* Condition:\n\t1 /* always true */");
                $finish;
            end
        end
        
        if (inst48_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(1 /* always true */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tnbne_success: and $a0, $s1, $s1\n\n* Condition:\n\t1 /* always true */");
                $finish;
            end
        end
        
        if (inst49_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(1 /* always true */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a0, $s0, $s1\n\n* Condition:\n\t1 /* always true */");
                $finish;
            end
        end
        
        if (inst50_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[5] == 2)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a1, $a0, $a0\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[5] == 2\n\n* Variables:\n\tafter_mem(REGS.A1) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[5]);
                $finish;
            end
        end
        
        if (inst51_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[6] == 3)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a2, $a0, $a1\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[6] == 3\n\n* Variables:\n\tafter_mem(REGS.A2) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[6]);
                $finish;
            end
        end
        
        if (inst52_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[7] == 4)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $a3, $a0, $a2\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[7] == 4\n\n* Variables:\n\tafter_mem(REGS.A3) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[7]);
                $finish;
            end
        end
        
        if (inst53_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[8] == 5)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tadd $t0, $a0, $a3\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[8] == 5\n\n* Variables:\n\tafter_mem(REGS.T0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[8]);
                $finish;
            end
        end
        
        if (inst54_pipe_stage == `STAGE_BEFORE_PIPE) begin
            future_54_pc_before = U_MIPS_R2000.U_PCU.PC;
        end
        
        if (inst54_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_PCU.PC == future_54_pc_before + 4*3)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbeq $s0, $s0, hazard_beq_success\n\n* Condition:\n\tU_MIPS_R2000.U_PCU.PC == future_54_pc_before + 4*3\n\n* Variables:\n\tbefore(REGS.PC) = 0x%8X\n\tafter_mem(REGS.PC) = 0x%8X\n", future_54_pc_before, U_MIPS_R2000.U_PCU.PC);
                $finish;
            end
        end
        
        if (inst56_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(0 /* always false */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\thazard_beq_unsuccess: addiu $k0, 100\n\n* Condition:\n\t0 /* always false */");
                $finish;
            end
        end
        
        if (inst57_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[26] == 0)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\thazard_beq_success: addiu $k1, 300\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[26] == 0\n\n* Variables:\n\tafter_mem(REGS.K0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[26]);
                $finish;
            end
        end
        
        if (inst57_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[27] == 300)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\thazard_beq_success: addiu $k1, 300\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[27] == 300\n\n* Variables:\n\tafter_mem(REGS.K1) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[27]);
                $finish;
            end
        end
        
    end
endmodule
