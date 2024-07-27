from typing import Any
from .utils import twos_complement
from .mips_rules import MipsRuleAssert
from .mips_consts import REGISTERS, REGISTER_TO_INDEX, ALL_REGISTERS

class MipsObject(object):
    def __init__(self, value_expression) -> None:
        self._value_expression = value_expression
    
    def __lt__(self, other):
        return self._generic_comperator(other, "<")

    def __le__(self, other):
        return self._generic_comperator(other, "<=")

    def __eq__(self, other):
        return self._generic_comperator(other, "==")

    def __ne__(self, other):
        return self._generic_comperator(other, "!=")

    def __ge__(self, other):
        return self._generic_comperator(other, ">=")

    def __gt__(self, other):
        return self._generic_comperator(other, ">")
    
    def _generic_comperator(self, other, logical_operator):
        other_expression = None
        if (isinstance(other, int)):
            other_expression = f"32'd{twos_complement(abs(other), 32) if other < 0 else other}"
        elif (isinstance(other, MipsObject)):
            other_expression = other._value_expression
        else:
            raise Exception(f"Unsupported type {type(other)}")

        return MipsRuleAssert(self._value_expression, logical_operator, other_expression)

    @property
    def value(self):
        return self()

    def __call__(self, *args: Any, **kwds: Any) -> Any:
        return self._value_expression

class Register(MipsObject):
    _MIPS_REGISTERS_ARRAY = "U_MIPS_R2000.U_GPR.gprRegisters"

    def __init__(self, reg: str) -> None:
        lower_reg = reg.lower()
        assert lower_reg in ALL_REGISTERS, f"Unknown expression {reg}"
        super().__init__(f"{Register._MIPS_REGISTERS_ARRAY}[{REGISTER_TO_INDEX[lower_reg]}]")

class PC(MipsObject):
    def __init__(self) -> None:
        super().__init__("U_MIPS_R2000.U_PCU.PC")

class REGS():
    ZERO = Register(REGISTERS.REG_ZERO)
    AT = Register(REGISTERS.REG_AT)
    V0 = Register(REGISTERS.REG_V0)
    V1 = Register(REGISTERS.REG_V1)
    A0 = Register(REGISTERS.REG_A0)
    A1 = Register(REGISTERS.REG_A1)
    A2 = Register(REGISTERS.REG_A2)
    A3 = Register(REGISTERS.REG_A3)
    T0 = Register(REGISTERS.REG_T0)
    T1 = Register(REGISTERS.REG_T1)
    T2 = Register(REGISTERS.REG_T2)
    T3 = Register(REGISTERS.REG_T3)
    T4 = Register(REGISTERS.REG_T4)
    T5 = Register(REGISTERS.REG_T5)
    T6 = Register(REGISTERS.REG_T6)
    T7 = Register(REGISTERS.REG_T7)
    S0 = Register(REGISTERS.REG_S0)
    S1 = Register(REGISTERS.REG_S1)
    S2 = Register(REGISTERS.REG_S2)
    S3 = Register(REGISTERS.REG_S3)
    S4 = Register(REGISTERS.REG_S4)
    S5 = Register(REGISTERS.REG_S5)
    S6 = Register(REGISTERS.REG_S6)
    S7 = Register(REGISTERS.REG_S7)
    T8 = Register(REGISTERS.REG_T8)
    T9 = Register(REGISTERS.REG_T9)
    K0 = Register(REGISTERS.REG_K0)
    K1 = Register(REGISTERS.REG_K1)
    GP = Register(REGISTERS.REG_GP)
    SP = Register(REGISTERS.REG_SP)
    FP = Register(REGISTERS.REG_FP)
    RA = Register(REGISTERS.REG_RA)
