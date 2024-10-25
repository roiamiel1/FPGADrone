from mips_test_lib.test_builder import TestBuilder, FALSE_CONDITION, TRUE_CONDITION


instructions = [
    # Test `addiu``:
    ("addiu $s0, 0",  "{after_mem(REGS.S0)} == 0"),
    ("addiu $s1, 1",  "{after_mem(REGS.S1)} == 1"),
    ("addiu $s2, 5",  "{after_mem(REGS.S2)} == 5"),
    ("addiu $s3, -1", "{after_mem(REGS.S3)} == -1"),
    ("addiu $s4, -2", "{after_mem(REGS.S4)} == -2"),

    # Test `add`:
    ("add $a0, $s0, $s1", "{after_mem(REGS.A0)} == 1"),
    ("add $a0, $s1, $s1", "{after_mem(REGS.A0)} == 2"),
    ("add $a0, $s1, $s2", "{after_mem(REGS.A0)} == 6"),
    ("add $a0, $s3, $s4", "{after_mem(REGS.A0)} == -3"),
    ("add $a0, $s3, $s1", "{after_mem(REGS.A0)} == 0"),
    ("add $a0, $s3, $s2", "{after_mem(REGS.A0)} == 4"),
    ("add $a0, $s1, $s4", "{after_mem(REGS.A0)} == -1"),

    # Test `addi`:
    ("addi $a0, $s0, 5",      "{after_mem(REGS.A0)} == 5"),
    ("addi $a0, $s1, 10000",  "{after_mem(REGS.A0)} == 10001"),
    ("addi $a0, $s3, 10000",  "{after_mem(REGS.A0)} == 9999"),
    ("addi $a0, $s0, -1",     "{after_mem(REGS.A0)} == -1"),
    ("addi $a0, $s0, -2",     "{after_mem(REGS.A0)} == -2"),
    ("addi $a0, $s0, -10000", "{after_mem(REGS.A0)} == -10000"),

    # Test `addu`:
    ("addu $a0, $s0, $s1", "{after_mem(REGS.A0)} == 1"),
    ("addu $a0, $s1, $s1", "{after_mem(REGS.A0)} == 2"),
    ("addu $a0, $s1, $s2", "{after_mem(REGS.A0)} == 6"),
    ("addu $a0, $s3, $s4", "{after_mem(REGS.A0)} == -3"),
    ("addu $a0, $s3, $s1", "{after_mem(REGS.A0)} == 0"),
    ("addu $a0, $s3, $s2", "{after_mem(REGS.A0)} == 4"),
    ("addu $a0, $s1, $s4", "{after_mem(REGS.A0)} == -1"),

    # Test `and`:
    ("and $a0, $s0, $s1", "{after_mem(REGS.A0)} == 0"),
    ("and $a0, $s1, $s1", "{after_mem(REGS.A0)} == 1"),
    ("and $a0, $s1, $s2", "{after_mem(REGS.A0)} == 1"),
    ("and $a0, $s2, $s3", "{after_mem(REGS.A0)} == 5"),

    # Test `andi`:
    ("andi $a0, $s1, 0", "{after_mem(REGS.A0)} == 0"),
    ("andi $a0, $s1, 1", "{after_mem(REGS.A0)} == 1"),
    ("andi $a0, $s1, 5", "{after_mem(REGS.A0)} == 1"),
    ("andi $a0, $s3, 5", "{after_mem(REGS.A0)} == 5"),

    # Test `beq`:
    ("beq $s0, $s0, beq_success", "{after_ex(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("beq_unsuccess: and $a0, $s0, $s1", FALSE_CONDITION),
    ("beq_success: and $a0, $s0, $s1", TRUE_CONDITION),

    # Test `bne`:
    ("bne $s0, $s1, bne_success", "{after_ex(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("bne_unsuccess: and $a0, $s0, $s1", FALSE_CONDITION),
    ("bne_success: and $a0, $s1, $s1", TRUE_CONDITION),
]

test_instructions = [
]

TestBuilder().attach_instructions(test_instructions or instructions).write(
    output_path_tb="tests/hardware/MIPS_R2000_tb.v",
    output_path_asm="tests/hardware/asm/MIPS_R2000_tb.asm"
)
