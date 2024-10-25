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
    integer inst3_pipe_stage;
    integer inst4_pipe_stage;
    
    // ############### Condition Vars ###############
    reg [31:0] future_1_pc_before = 32'd0;
    
    MIPS_R2000 U_MIPS_R2000(
        .clk(clk_debug),
        .rst(rst_debug)
    );
    
    initial begin
        // ################# Initialize #################
        inst0_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst1_pipe_stage = `STAGE_NOT_IN_PIPE;
        inst3_pipe_stage = `STAGE_NOT_IN_PIPE;
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
        
        if (inst3_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst3_pipe_stage -= 1;
        end
        
        if (inst4_pipe_stage > `STAGE_NOT_IN_PIPE) begin
            inst4_pipe_stage -= 1;
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
        
        // ########### Reset Pipe Stage Vars On Hazard ###########
        if (U_MIPS_R2000.U_HazardUnit.Hazard) begin
            // Drop IFID/IDEX/EXMEM instructions.
            if (`STAGE_AFTER_EX <= inst0_pipe_stage && inst0_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst0_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst1_pipe_stage && inst1_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst1_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst3_pipe_stage && inst3_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst3_pipe_stage = `STAGE_NOT_IN_PIPE;
            if (`STAGE_AFTER_EX <= inst4_pipe_stage && inst4_pipe_stage <= `STAGE_BEFORE_PIPE)
                inst4_pipe_stage = `STAGE_NOT_IN_PIPE;
        end
        
        // ################# Conditions #################
        if (inst0_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[16] == 0)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\taddiu $s0, 0\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[16] == 0\n\n* Variables:\n\tafter_mem(REGS.S0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[16]);
                $finish;
            end
        end
        
        if (inst1_pipe_stage == `STAGE_BEFORE_PIPE) begin
            future_1_pc_before = U_MIPS_R2000.U_PCU.PC;
        end
        
        if (inst1_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_PCU.PC == future_1_pc_before + 4*3)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\tbeq $s0, $s0, hazard_beq_success\n\n* Condition:\n\tU_MIPS_R2000.U_PCU.PC == future_1_pc_before + 4*3\n\n* Variables:\n\tbefore(REGS.PC) = 0x%8X\n\tafter_mem(REGS.PC) = 0x%8X\n", future_1_pc_before, U_MIPS_R2000.U_PCU.PC);
                $finish;
            end
        end
        
        if (inst3_pipe_stage == `STAGE_AFTER_PIPE) begin
            if (!(0 /* always false */)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\thazard_beq_unsuccess: addiu $k0, 100\n\n* Condition:\n\t0 /* always false */");
                $finish;
            end
        end
        
        if (inst4_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[26] == 0)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\thazard_beq_success: addiu $k1, 300\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[26] == 0\n\n* Variables:\n\tafter_mem(REGS.K0) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[26]);
                $finish;
            end
        end
        
        if (inst4_pipe_stage == `STAGE_AFTER_MEM) begin
            if (!(U_MIPS_R2000.U_GPR.gprRegisters[27] == 300)) begin
                $display("\n***************  Error  ***************\n\n* Opcode:\n\thazard_beq_success: addiu $k1, 300\n\n* Condition:\n\tU_MIPS_R2000.U_GPR.gprRegisters[27] == 300\n\n* Variables:\n\tafter_mem(REGS.K1) = 0x%8X\n", U_MIPS_R2000.U_GPR.gprRegisters[27]);
                $finish;
            end
        end
        
    end
endmodule
