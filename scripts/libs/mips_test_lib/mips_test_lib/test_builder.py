import os
from .mips_testbanch_builder import TestbanchBuilder, MipsInstruction, MipsTestCondition

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

    def write(self, output_path, output_filename):
        with open(os.path.join(output_path, f"{output_filename}.v"), "w") as f:
            f.write(self._builder.build_tb())

        with open(os.path.join(output_path, f"{output_filename}.asm"), "w") as f:
            f.write(self._builder.build_asm())
        
        return self
