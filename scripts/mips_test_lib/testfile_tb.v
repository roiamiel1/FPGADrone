################### Consts ###################
`define STAGE_NOT_IN_PIPE = -1;
`define STAGE_BEFORE_PIPE = 5;
`define STAGE_AFTER_IF = 4;
`define STAGE_AFTER_ID = 3;
`define STAGE_AFTER_EX = 2;
`define STAGE_AFTER_MEM = 1;
`define STAGE_AFTER_PIPE = 0;

################# Initialize #################
inst0_pipe_stage = STAGE_NOT_IN_PIPE;
inst4_pipe_stage = STAGE_NOT_IN_PIPE;

############### Condition Vars ###############
reg[31:0] future_4_A_BEFORE = 32'd0;
reg[31:0] future_4_C_AFTER_IF = 32'd0;

########### Update Pipe Stage Vars ###########
if (inst0_pipe_stage > STAGE_NOT_IN_PIPE) begin
    inst0_pipe_stage -= 1;
end

if (inst4_pipe_stage > STAGE_NOT_IN_PIPE) begin
    inst4_pipe_stage -= 1;
end

################# PC Trigger #################
if (pc == 0) begin
    if (inst0_pipe_stage != STAGE_NOT_IN_PIPE) begin
        $display("Instruction already in pipeline");
        $finish;
    end
    
    inst0_pipe_stage = STAGE_BEFORE_PIPE;
end

if (pc == 4) begin
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
    future_4_A_BEFORE = U_MIPS_R2000.U_GPR.gprRegisters[5];
end

if (inst4_pipe_stage == STAGE_AFTER_IF) begin
    future_4_C_AFTER_IF = U_MIPS_R2000.U_GPR.gprRegisters[5];
end

if (inst4_pipe_stage == STAGE_AFTER_PIPE) begin
    if (future_4_A_BEFORE == (U_MIPS_R2000.U_GPR.gprRegisters[5] + future_4_C_AFTER_IF)) begin
        $display("Error");
        $finish;
    end
end


