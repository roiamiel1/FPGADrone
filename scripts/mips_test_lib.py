from functools import partial
from typing import Any, Callable
from mips_consts import REGISTERS, REGISTER_TO_INDEX, ALL_REGISTERS

VERILOG_TEST_FORMAT = """
`include "signal_def.v"

module TESTBENCH (
    input clk,
    input rst
);
    reg clk_debug;
    reg rst_debug;
    reg [31:0] cycles;
    
    MIPS_R2000 U_MIPS_R2000(
        .clk(clk_debug),
        .rst(rst_debug)
    );

    initial begin
        $dumpfile("MIPS_R2000_tb.vcd");
        $dumpvars;
        $readmemh("../../tests/hardware/asm/MIPS_R2000_tb.hex", U_MIPS_R2000.U_InstructionMemory.IMem);

        U_MIPS_R2000.U_IFIDReg.StageReg = 0;
        U_MIPS_R2000.U_IDEXReg.StageReg = 0;
        U_MIPS_R2000.U_EXMEMReg.StageReg = 0;
        U_MIPS_R2000.U_MEMWBReg.StageReg = 0;

        clk_debug = 1;
        rst_debug = 0;
        cycles = 0;

        rst_debug = 1;
        #2 rst_debug = 0;
    end
    
    always begin
        #10 clk_debug = ~clk_debug;
    end

    always @ (posedge rst_debug) begin
        cycles = 0;
    end

    always@(posedge clk_debug) begin
{VALIDATIONS}
    end

endmodule
"""

def build_test(verilog_testfile_path, asm_testfile_path, instructions_and_validations):
    instructions = []
    validations = []

    for inst, *inst_validations in instructions_and_validations:
        instructions.append(inst)
        for validation in inst_validations:
            validations.append(validation(inst, len(instructions) - 1))
    
    validations.append(f"""
if (cycles >= {len(instructions) - 1 + 5})
    $finish;
""")

    validations = [v.strip() for v in validations]
    validations = ["\n".join([f"\t\t{x}" for x in v.split("\n")]) for v in validations]

    with open(asm_testfile_path, "w") as f:
        f.write("\n".join(instructions))

    with open(verilog_testfile_path, "w") as f:
        f.write(VERILOG_TEST_FORMAT.format(VALIDATIONS="\n\n".join(validations)))


class MipsRule(object):
    def __init__(self, generate_function: Callable[[int], str]) -> None:
        super().__init__()
        self._generate_function = generate_function

    def __call__(self, *args: Any, **kwds: Any) -> Any:
        return self._generate_function(*args, **kwds)


class MipsRuleAssert(MipsRule):
    def __init__(self, actual_expression, logical_operator, expected_expression) -> None:
        def __inner_function__(inst: str, instruction_index: int):
            return f"""
if (cycles == {instruction_index + 4} && !({actual_expression} {logical_operator} {expected_expression})) begin
    $display("ASSERTION FAILED `{inst}`: signal(%8X) != value(%8X)", {actual_expression}, {expected_expression});
    $finish;
end
            """
        super().__init__(__inner_function__)


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
            other_expression = f"32'd{other}"
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
