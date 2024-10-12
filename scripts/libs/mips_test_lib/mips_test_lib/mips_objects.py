from enum import Enum, IntEnum, EnumMeta
from typing import NamedTuple, Any, Dict
from functools import partial
from utils import extract_format_fields


class MipsObject(object):
    """
    This is class represent a mips arch internal object.
    May be register, ALU-flag, Memory address, etc...
    Value is the code that access the spesific object, for example:
    EAX -> MIPSU.REGISTERS[0] 
    PC -> MIPSU.PC
    for each object you should state the bits count of this object.
    etc....
    """
    def __init__(self, name: str, value: str, bits_count: int) -> None:
        super().__init__()
        self._name = name
        self._value = value
        self._bits_count = bits_count

    @property
    def name(self) -> str:
        return self._name

    @property
    def value(self) -> str:
        return self._value
    
    @property
    def bits_count(self) -> int:
        return self._bits_count


class OpcodeExecutionStage(IntEnum):
    """
    This enum represent a timing for an mips object relative to opode execution.
    """
    ANY         = -1    # this is ignored execution stage.
    BEFORE      = 0     # before the execution start.
    AFTER_IF    = 1     # after instruction fetch.
    AFTER_ID    = 2     # after instruction decode.
    AFTER_EX    = 3     # after instruction execution.
    AFTER_MEM   = 4     # after instruction write to mem.
    AFTER       = 5     # after the execution ends.
    # NOTE! values must be sorted by stage order. 


class TimedMipsObject(object):
    def __init__(self, obj: MipsObject, exec_stage: OpcodeExecutionStage) -> None:
        super().__init__()
        self._obj = obj
        self._exec_stage = exec_stage

    @property
    def obj(self) -> MipsObject:
        return self._obj

    @property
    def exec_stage(self) -> OpcodeExecutionStage:
        return self._exec_stage


class MipsTestCondition(object):
    def __init__(self, condition: str) -> None:
        """
        TODO: fix docs:
        1. `condition` - Logical condition containing Mips operands such as registers (`EAX`, `PC` etc...).
        2. `operands` - should contains all the operands in (`value`, `OpcodeExecutionStage`).

        for example:
        `condition`: "{PC_Before} + 4 == {PC_After}"
        `operands`: {
            'PC_Before': (MipsInternalRegisters.PC, OpcodeExecutionStage.BEFORE),
            'PC_After': (MipsInternalRegisters.PC, OpcodeExecutionStage.AFTER)
        }
        """
        super().__init__()
        self._condition = condition
        self._operands = {
            op: MipsTestCondition._eval_operand(op) for op in extract_format_fields(condition)
        }

    @property
    def condition(self) -> str:
        return self._condition

    @property
    def operands(self) -> Dict[str, TimedMipsObject]:
        return self._operands
    
    @classmethod
    def _eval_operand_globals(cls) -> Dict[str, Any]:
        return {}

    @classmethod
    def _eval_operand_locals(cls) -> Dict[str, Any]:
        local = {
            "REGS": MipsObjects.Regs
        }

        for exec_stage in OpcodeExecutionStage:
            local[exec_stage.name.lower()] = partial(TimedMipsObject, exec_stage=exec_stage)
        
        return local
    
    @classmethod
    def _eval_operand(cls, operand: str) -> TimedMipsObject:
        result = eval(
            operand, MipsTestCondition._eval_operand_globals(), MipsTestCondition._eval_operand_locals()
        )

        assert isinstance(result, TimedMipsObject), f"Result of eval of `{operand}` must be `TimedMipsObject`"

        return result
    

class MipsInstruction(NamedTuple):
    """
    This class represent one instruction.
    Each instruction has:
    1. `pc` index of the instruction/opcode in the program.
    2. `opcode` a string that store the assembly opcode, i.e. `addi $a0, $s0, 5`.
    """
    pc: int
    opcode: str


class DirectValueMeta(EnumMeta):
    "Metaclass that allows for directly getting an enum attribute"
    def __getattribute__(cls, name):
        value = super().__getattribute__(name)
        if isinstance(value, cls):
            value = value.value
        return value


class MipsObjects(Enum, metaclass=DirectValueMeta):
    class Regs(Enum, metaclass=DirectValueMeta):
        PC = MipsObject("PC", "U_MIPS_R2000.U_PCU.PC", 32)
        ZERO = MipsObject("ZERO", "U_MIPS_R2000.U_GPR.gprRegisters[0]", 32)
        AT = MipsObject("AT", "U_MIPS_R2000.U_GPR.gprRegisters[1]", 32)
        V0 = MipsObject("V0", "U_MIPS_R2000.U_GPR.gprRegisters[2]", 32)
        V1 = MipsObject("V1", "U_MIPS_R2000.U_GPR.gprRegisters[3]", 32)
        A0 = MipsObject("A0", "U_MIPS_R2000.U_GPR.gprRegisters[4]", 32)
        A1 = MipsObject("A1", "U_MIPS_R2000.U_GPR.gprRegisters[5]", 32)
        A2 = MipsObject("A2", "U_MIPS_R2000.U_GPR.gprRegisters[6]", 32)
        A3 = MipsObject("A3", "U_MIPS_R2000.U_GPR.gprRegisters[7]", 32)
        T0 = MipsObject("T0", "U_MIPS_R2000.U_GPR.gprRegisters[8]", 32)
        T1 = MipsObject("T1", "U_MIPS_R2000.U_GPR.gprRegisters[9]", 32)
        T2 = MipsObject("T2", "U_MIPS_R2000.U_GPR.gprRegisters[10]", 32)
        T3 = MipsObject("T3", "U_MIPS_R2000.U_GPR.gprRegisters[11]", 32)
        T4 = MipsObject("T4", "U_MIPS_R2000.U_GPR.gprRegisters[12]", 32)
        T5 = MipsObject("T5", "U_MIPS_R2000.U_GPR.gprRegisters[13]", 32)
        T6 = MipsObject("T6", "U_MIPS_R2000.U_GPR.gprRegisters[14]", 32)
        T7 = MipsObject("T7", "U_MIPS_R2000.U_GPR.gprRegisters[15]", 32)
        S0 = MipsObject("S0", "U_MIPS_R2000.U_GPR.gprRegisters[16]", 32)
        S1 = MipsObject("S1", "U_MIPS_R2000.U_GPR.gprRegisters[17]", 32)
        S2 = MipsObject("S2", "U_MIPS_R2000.U_GPR.gprRegisters[18]", 32)
        S3 = MipsObject("S3", "U_MIPS_R2000.U_GPR.gprRegisters[19]", 32)
        S4 = MipsObject("S4", "U_MIPS_R2000.U_GPR.gprRegisters[20]", 32)
        S5 = MipsObject("S5", "U_MIPS_R2000.U_GPR.gprRegisters[21]", 32)
        S6 = MipsObject("S6", "U_MIPS_R2000.U_GPR.gprRegisters[22]", 32)
        S7 = MipsObject("S7", "U_MIPS_R2000.U_GPR.gprRegisters[23]", 32)
        T8 = MipsObject("T8", "U_MIPS_R2000.U_GPR.gprRegisters[24]", 32)
        T9 = MipsObject("T9", "U_MIPS_R2000.U_GPR.gprRegisters[25]", 32)
        K0 = MipsObject("K0", "U_MIPS_R2000.U_GPR.gprRegisters[26]", 32)
        K1 = MipsObject("K1", "U_MIPS_R2000.U_GPR.gprRegisters[27]", 32)
        GP = MipsObject("GP", "U_MIPS_R2000.U_GPR.gprRegisters[28]", 32)
        SP = MipsObject("SP", "U_MIPS_R2000.U_GPR.gprRegisters[29]", 32)
        FP = MipsObject("FP", "U_MIPS_R2000.U_GPR.gprRegisters[30]", 32)
        RA = MipsObject("RA", "U_MIPS_R2000.U_GPR.gprRegisters[31]", 32)
