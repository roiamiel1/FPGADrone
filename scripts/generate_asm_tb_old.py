from mips_test_lib.mips_test_lib import build_test
from scripts.mips_test_lib.mips_testbanch_builder import REGS

instructions = [
    # Test `beq`:
    # ("bne $a0, $s3, beq_success", PC == before(PC) + 4),
    # ("nop", None),
    # ("nop", None),

]

build_test(
    r"tests/hardware/MIPS_R2000_tb.v", 
    r"tests/hardware/asm/MIPS_R2000_tb.asm", 
    instructions
)