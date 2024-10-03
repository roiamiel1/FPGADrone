from mips_objects import TestbanchBuilder, MipsInstruction, MipsTestCondition, OpcodeExecutionStage, MipsObjects

builder = TestbanchBuilder()

cond1 = MipsTestCondition("{A} == 5", {"A": (MipsObjects.EAX, OpcodeExecutionStage.AFTER)})
cond2 = MipsTestCondition("{A} == ({B} + {C})", {
    "A": (MipsObjects.EAX, OpcodeExecutionStage.BEFORE),
    "B": (MipsObjects.EAX, OpcodeExecutionStage.AFTER),
    "C": (MipsObjects.EAX, OpcodeExecutionStage.AFTER_IF)
})

builder.attach_inst(MipsInstruction(pc=4*0, opcode="addi $a0, $s0, 5"), [cond1])
builder.attach_inst(MipsInstruction(pc=4*1, opcode="addi $a0, $s0, 5"), [cond2])

test_str = builder.build()
with open("testfile_tb.v", "w") as f:
    f.write(test_str)
