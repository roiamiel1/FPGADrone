import os
from .mips_testbanch_builder import TestbanchBuilder, MipsInstruction, MipsTestCondition


FALSE_CONDITION = "0 /* always false */"
TRUE_CONDITION = "1 /* always true */"


class TestBuilder():
    def __init__(self) -> None:
        self._builder = TestbanchBuilder()
        self._pc = 0
    
    def attach_instructions(self, insts):
        for inst in insts:
            self._builder.attach_inst(
                MipsInstruction(self._pc, inst[0]), 
                map(MipsTestCondition, inst[1:])
            )
            self._pc += 1

        return self

    def write(self, output_path_tb, output_path_asm):
        with open(output_path_tb, "w") as f:
            f.write(self._builder.build_tb())

        with open(output_path_asm, "w") as f:
            f.write(self._builder.build_asm())
        
        return self
