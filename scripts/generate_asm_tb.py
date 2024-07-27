from mips_test_lib.mips_test_lib import build_test
from mips_test_lib.mips_objects import REGS

instructions = [
    # Test `addiu``:
    ("addiu $s0, 0", REGS.S0 == 0),
    ("addiu $s1, 1", REGS.S1 == 1),
    ("addiu $s2, 5", REGS.S2 == 5),
    ("addiu $s3, -1", REGS.S3 == -1),
    ("addiu $s4, -2", REGS.S4 == -2),

    # Test `add`:
    ("add $a0, $s0, $s1", REGS.A0 == 1),
    ("add $a0, $s1, $s1", REGS.A0 == 2),
    ("add $a0, $s1, $s2", REGS.A0 == 6),
    ("add $a0, $s3, $s4", REGS.A0 == -3),
    ("add $a0, $s3, $s1", REGS.A0 == 0),
    ("add $a0, $s3, $s2", REGS.A0 == 4),
    ("add $a0, $s1, $s4", REGS.A0 == -1),

    # Test `addi`:
    ("addi $a0, $s0, 5", REGS.A0 == 5),
    ("addi $a0, $s1, 10000", REGS.A0 == 10001),
    ("addi $a0, $s3, 10000", REGS.A0 == 9999),
    ("addi $a0, $s0, -1", REGS.A0 == -1),
    ("addi $a0, $s0, -2", REGS.A0 == -2),
    ("addi $a0, $s0, -10000", REGS.A0 == -10000),

    # Test `addu`:
    ("addu $a0, $s0, $s1", REGS.A0 == 1),
    ("addu $a0, $s1, $s1", REGS.A0 == 2),
    ("addu $a0, $s1, $s2", REGS.A0 == 6),
    ("addu $a0, $s3, $s4", REGS.A0 == -3),
    ("addu $a0, $s3, $s1", REGS.A0 == 0),
    ("addu $a0, $s3, $s2", REGS.A0 == 4),
    ("addu $a0, $s1, $s4", REGS.A0 == -1),

    # Test `and`:
    ("and $a0, $s0, $s1", REGS.A0 == 0),
    ("and $a0, $s1, $s1", REGS.A0 == 1),
    ("and $a0, $s1, $s2", REGS.A0 == 1),
    ("and $a0, $s2, $s3", REGS.A0 == 5),

    # Test `andi`:
    ("andi $a0, $s1, 0", REGS.A0 == 0),
    ("andi $a0, $s1, 1", REGS.A0 == 1),
    ("andi $a0, $s1, 5", REGS.A0 == 1),
    ("andi $a0, $s3, 5", REGS.A0 == 5),

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