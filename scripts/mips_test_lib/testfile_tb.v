################### Consts ###################
`define STAGE_NOT_IN_PIPE = 6;
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
future_4_A_0 = 0;
future_4_C_1 = 0;

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
    if (REGISTERS[0] == 5) begin
        $display("Error");
        $finish;
    end
end

if (inst4_pipe_stage == STAGE_BEFORE_PIPE) begin
    future_4_A_0 = REGISTERS[0]
end

if (inst4_pipe_stage == STAGE_AFTER_IF) begin
    future_4_C_1 = REGISTERS[0]
end

if (inst4_pipe_stage == STAGE_AFTER_IF) begin
    if (future_4_A_0 == (REGISTERS[0] + future_4_C_1)) begin
        $display("Error");
        $finish;
    end
end


