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
    integer inst2_pipe_stage;
    integer inst4_pipe_stage;
    
    // ############### Condition Vars ###############
    reg [31:0] future_0_pc_before = 32'd0;
    
    MIPS_R2000 U_MIPS_R2000(
        .clk(clk_debug),
        .rst(rst_debug)
    );
    
    initial begin
        // ################# Initialize #################
        inst0_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst2_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst4_pipe_stage = `STAGE_NOT_IN_PIPE;
        
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
        if(U_MIPS_R2000.U_PCU.PC > 84) begin
            $finish;
        end
        
        // ########### Update Pipe Stage Vars ###########
        if (inst0_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst0_pipe_stage -= 1;
        end
        
        if (inst2_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst2_pipe_stage -= 1;
        end
        
        if (inst4_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst4_pipe_stage -= 1;
        end
        
        // ################# PC Trigger #################
        if (U_MIPS_R2000.U_PCU.PC == 0) begin
            if (inst0_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst0_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 8) begin
            if (inst2_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst2_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        if (U_MIPS_R2000.U_PCU.PC == 16) begin
            if (inst4_pipe_stage != `STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            inst4_pipe_stage = `STAGE_BEFORE_PIPE;
        end
        
        // ################# Conditions #################
        if (inst0_pipe_stage == `STAGE_BEFORE_PIPE) begin
            future_0_pc_before = U_MIPS_R2000.U_PCU.PC;
        end
        
        if (inst0_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(U_MIPS_R2000.U_PCU.PC == future_0_pc_before + 20)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbeq $s0, $s0, beq_success\n\n* Condition:\n\tU_MIPS_R2000.U_PCU.PC == future_0_pc_before + 20\n\n* Variables:\n\tbefore(REGS.PC) = 0x%8X\n\tafter(REGS.PC) = 0x%8X\n", future_0_pc_before, U_MIPS_R2000.U_PCU.PC);
                $finish;
            end
        end
        
        if (inst2_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(0 /* always false */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbeq_unsuccess: and $a0, $s0, $s1\n\n* Condition:\n\t0 /* always false */");
                $finish;
            end
        end
        
        if (inst4_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(1 /* always true */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbeq_success: and $a0, $s0, $s1\n\n* Condition:\n\t1 /* always true */");
                $finish;
            end
        end
        
    end
endmodule
