from mips_test_lib import REGS, build_test

instructions = [
    ("li $a0, 0", REGS.A0 == 0),
    ("li $a1, 5", REGS.A1 == 5),
    ("li $a1, -1", REGS.A2 == 0xFFFFFFFF),
    ("li $a1, -1", REGS.A2 == 0x1FFFFFFF),
]

build_test(
    r"tests/hardware/MIPS_R2000_tb.v", 
    r"tests/hardware/asm/MIPS_R2000_tb.asm", 
    instructions
)