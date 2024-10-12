from mips_test_lib.mips_testbanch_builder import TestbanchBuilder, MipsInstruction, MipsTestCondition

builder = TestbanchBuilder()

cond1 = MipsTestCondition("{after(REGS.A0)} == 5")
cond2 = MipsTestCondition("{before(REGS.A1)} == ({after(REGS.A1)} + {after_if(REGS.A1)})")

builder.attach_inst(MipsInstruction(pc=4*0, opcode="addi $a0, $s0, 5"), [cond1])
builder.attach_inst(MipsInstruction(pc=4*1, opcode="addi $a0, $s0, 5"), [cond1, cond2])

tb_str = builder.build_tb()
with open("testfile_tb.v", "w") as f:
    f.write(tb_str)

asm_str = builder.build_asm()
with open("testfile.asm", "w") as f:
    f.write(asm_str)