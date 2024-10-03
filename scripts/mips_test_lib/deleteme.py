STAGE_NOT_IN_PIPE = -1
STAGE_BEFORE_PIPE = 5
STAGE_AFTER_PIPE = 0

################# Check Patameters ################# 
inst000_pc_before = -1

################# Initialize ################# 
inst000_pipe_stage = STAGE_NOT_IN_PIPE


################# Update Pipe Stage Vars ################# 
if (inst000_pipe_stage > STAGE_NOT_IN_PIPE):
    inst000_pipe_stage -= 1

################# PC Triggers ################# 
if (pc == x):
    assert inst000_pipe_stage == STAGE_NOT_IN_PIPE, ""
    inst000_pipe_stage = STAGE_BEFORE_PIPE

################# Checks ################# 
if (inst000_pipe_stage == STAGE_BEFORE_PIPE):
    # DO before stuff
    inst000_pc_before = pc

if (inst000_pipe_stage == STAGE_AFTER_PIPE):
    # DO after stuff
    pass
