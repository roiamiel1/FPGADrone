import os
from .mips_testbanch_builder import TestbanchBuilder, MipsInstruction, MipsTestCondition


FALSE_CONDITION = "0 /* always false */"
TRUE_CONDITION = "1 /* always true */"


class TestBuilder():
    _BRANCH_OPCODES = ["bne", "beq", "j", "jal"]

    def __init__(self) -> None:
        self._builder = TestbanchBuilder()
        self._pc = 0
    
    def attach_instructions(self, insts):
        for inst in insts:
            self._builder.attach_inst(
                MipsInstruction(self._pc, inst[0]), 
                map(MipsTestCondition, inst[1:])
            )

            # This is a patch, the builtin GNU assembler add a NOP after branch opcodes.
            # The nop is needed beacuse of the branch pipeline.
            # TODO: in the future, use our own assembler to be able to control it. 
            if self._is_branch_inst(inst[0]):
                self._pc += 1    

            self._pc += 1

        return self

    def _inst_to_opcode(self, inst):
        """
        This is a supid function that get a given assembly line and return the opcode,
        i.e.
        "label: mov eax, ebx" -> mov
        "mov eax, ebx" -> mov
        "label: mov eax, ebx # this is a comment :" -> mov
        """
        _COMMENT_SIGN = "#"
        _LABEL_SIGN = ":"

        inst = inst.lower()

        # Remove comment
        if _COMMENT_SIGN in inst:
            inst = inst.split(_COMMENT_SIGN)[0].strip()
        
        # Remove label
        assert inst.count(_LABEL_SIGN) <= 1, f"Too many labels in {inst}"
        if _LABEL_SIGN in inst:
            inst = inst.split(_LABEL_SIGN)[1].strip()

        inst_parts = list(filter(None, inst.split()))
        assert len(inst_parts) >= 1, f"There is no opcode in {inst}"

        return inst_parts[0]

    def _is_branch_inst(self, inst):
        opcode = self._inst_to_opcode(inst)
        for branch_opcode in TestBuilder._BRANCH_OPCODES:
            if opcode == branch_opcode:
                return True
        return False
    
    def write(self, output_path_tb, output_path_asm):
        os.makedirs(os.path.dirname(output_path_tb), exist_ok=True)
        with open(output_path_tb, "w") as f:
            f.write(self._builder.build_tb())
        
        os.makedirs(os.path.dirname(output_path_asm), exist_ok=True)
        with open(output_path_asm, "w") as f:
            f.write(self._builder.build_asm())
        
        return self
