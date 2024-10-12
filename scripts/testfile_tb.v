`include "signal_def.v"

################### Consts ###################
`define STAGE_NOT_IN_PIPE = -1;
`define STAGE_BEFORE_PIPE = 5;
`define STAGE_AFTER_IF = 4;
`define STAGE_AFTER_ID = 3;
`define STAGE_AFTER_EX = 2;
`define STAGE_AFTER_MEM = 1;
`define STAGE_AFTER_PIPE = 0;


module TESTBENCH (
    input clk,
    input rst
);
    reg clk_debug;
    reg rst_debug;
    reg [31:0] cycles;
    
    ################# Initialize #################
    integer inst0_pipe_stage = STAGE_NOT_IN_PIPE;
    integer inst4_pipe_stage = STAGE_NOT_IN_PIPE;
    
    ############### Condition Vars ###############
    reg [31:0] future_4_a1_before = 32'd0;
    reg [31:0] future_4_a1_after_if = 32'd0;
    
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
        
        ########### Update Pipe Stage Vars ###########
        if (inst0_pipe_stage > STAGE_NOT_IN_PIPE) begin
            inst0_pipe_stage -= 1;
        end
        
        if (inst4_pipe_stage > STAGE_NOT_IN_PIPE) begin
            inst4_pipe_stage -= 1;
        end
        
        ################# PC Trigger #################
        if (U_MIPS_R2000.U_PCU.PC == 0) begin
            if (inst0_pipe_stage != STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst0_pipe_stage = STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 4) begin
            if (inst4_pipe_stage != STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst4_pipe_stage = STAGE_BEFORE_PIPE;
        end
        
        ################# Conditions #################
        if (inst0_pipe_stage == STAGE_AFTER_PIPE) begin
            if (U_MIPS_R2000.U_GPR.gprRegisters[4] == 5) begin
                $display("Error");
                $finish;
            end
        end
        
        if (inst4_pipe_stage == STAGE_AFTER_PIPE) begin
            if (U_MIPS_R2000.U_GPR.gprRegisters[4] == 5) begin
                $display("Error");
                $finish;
            end
        end
        
        if (inst4_pipe_stage == STAGE_BEFORE_PIPE) begin
            future_4_a1_before = U_MIPS_R2000.U_GPR.gprRegisters[5];
        end
        
        if (inst4_pipe_stage == STAGE_AFTER_IF) begin
            future_4_a1_after_if = U_MIPS_R2000.U_GPR.gprRegisters[5];
        end
        
        if (inst4_pipe_stage == STAGE_AFTER_PIPE) begin
            if (future_4_a1_before == (U_MIPS_R2000.U_GPR.gprRegisters[5] + future_4_a1_after_if)) begin
                $display("Error");
                $finish;
            end
        end
        
    end
endmodule
