from mips_objects import MipsObjects
from mips_testbanch_builder import TestbanchBuilder, MipsInstruction, MipsTestCondition, OpcodeExecutionStage

builder = TestbanchBuilder()

cond1 = MipsTestCondition("{A} == 5", {"A": (MipsObjects.REG_A0, OpcodeExecutionStage.AFTER)})
cond2 = MipsTestCondition("{A} == ({B} + {C})", {
    "A": (MipsObjects.REG_A1, OpcodeExecutionStage.BEFORE),
    "B": (MipsObjects.REG_A1, OpcodeExecutionStage.AFTER),
    "C": (MipsObjects.REG_A1, OpcodeExecutionStage.AFTER_IF)
})

builder.attach_inst(MipsInstruction(pc=4*0, opcode="addi $a0, $s0, 5"), [cond1])
builder.attach_inst(MipsInstruction(pc=4*1, opcode="addi $a0, $s0, 5"), [cond1, cond2])

test_str = builder.build()
with open("testfile_tb.v", "w") as f:
    f.write(test_str)
