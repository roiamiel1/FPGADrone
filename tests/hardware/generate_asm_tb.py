from mips_test_lib.test_builder import TestBuilder, FALSE_CONDITION, TRUE_CONDITION


instructions = [
    # Test `addiu``:
    ("addiu $s0, 0",  "{after_mem(REGS.S0)} == 0"),
    ("addiu $s1, 1",  "{after_mem(REGS.S1)} == 1"),
    ("addiu $s2, 5",  "{after_mem(REGS.S2)} == 5"),

    # Just add numbers for the test.
    ("addi $s3, -1", "{after_mem(REGS.S3)} == -1"),
    ("addi $s4, -2", "{after_mem(REGS.S4)} == -2"),

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

    # Test `beq` - branching:
    ("beq $s0, $s0, beq_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("beq_unsuccess: and $a0, $s0, $s1", FALSE_CONDITION),
    ("beq_success: and $a0, $s0, $s1", TRUE_CONDITION),

    # Test `bne` - branching:
    ("bne $s0, $s1, bne_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("bne_unsuccess: and $a0, $s0, $s1", FALSE_CONDITION),
    ("bne_success: and $a0, $s1, $s1", TRUE_CONDITION),

    # Test `beq` - not branching:
    ("beq $s0, $s1, nbeq_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*4"),
    ("nbeq_unsuccess: and $a0, $s0, $s1", TRUE_CONDITION),
    ("nbeq_success: and $a0, $s0, $s1", TRUE_CONDITION),

    # Test `bne` - not branching:
    ("bne $s0, $s0, nbne_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*4"),
    ("nbne_unsuccess: and $a0, $s0, $s1", TRUE_CONDITION),
    ("nbne_success: and $a0, $s1, $s1", TRUE_CONDITION),

    # Test forwarding.
    ("add $a0, $s0, $s1", TRUE_CONDITION),
    ("add $a1, $a0, $a0", "{after_mem(REGS.A1)} == 2"),
    ("add $a2, $a0, $a1", "{after_mem(REGS.A2)} == 3"),
    ("add $a3, $a0, $a2", "{after_mem(REGS.A3)} == 4"),
    ("add $t0, $a0, $a3", "{after_mem(REGS.T0)} == 5"),

    # Test branch hazard.
    ("beq $s0, $s0, hazard_beq_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("hazard_beq_unsuccess: addiu $k0, 100", FALSE_CONDITION),
    ("hazard_beq_success: addiu $k1, 300", "{after_mem(REGS.K0)} == 0", "{after_mem(REGS.K1)} == 300"),

    # Test `j` - branching:
    ("j j_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j_unsuccess: addiu $k0, 100", FALSE_CONDITION),
    ("j_success: addiu $k1, $zero, 523", "{after_mem(REGS.K0)} == 0", "{after_mem(REGS.K1)} == 523"),

    # Test `j` - complex branching:
    ("j0: j j4", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j1: j j3", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j2: j j5", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j3: j j2", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j4: j j1", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j5: addiu $gp, $zero, 10432", "{after_mem(REGS.GP)} == 10432"),

    # Test `jal` - branching:
    ("jal jal_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("jal_unsuccess: addiu $k0, 100", FALSE_CONDITION),
    ("jal_success: addi $k1, $zero, -12312", 
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == -12312", 
        "{after_mem(REGS.RA)} == {before(REGS.PC)} - 8 + 4*2"
    ),
    
    # Test `jr` - branching:
    # Note! this test should come after `jal` test. 
    # because after `jal` test, $RA register contains the current PC. 
    # We use this data to calculate where to jump to.
    ("addiu $t0, $ra, 20", TRUE_CONDITION), # We have 6 opcodes after jal to jr_success.
    ("jr $t0", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("jr_unsuccess: addiu $k0, 100", FALSE_CONDITION),
    ("jr_success: addiu $k1, $zero, 123", "{after_mem(REGS.K0)} == 0", "{after_mem(REGS.K1)} == 123"),

    # Test addiu big int
    # Immidiate is a signd 16 bits number, 2**16/2 = 32768. so 32767 is the biggest possitive number.
    ("addi $fp, $zero, 32767", "{after_mem(REGS.FP)} == 32767"),
    ("addi $fp, $zero, 32768", "{after_mem(REGS.FP)} != 32768"),
    ("addiu $fp, $zero, 32767", "{after_mem(REGS.FP)} == 32767"),
    ("addiu $fp, $zero, 32768", "{after_mem(REGS.FP)} == 32768"),

    # Test `sw` - with 1 step write value forward
    ("addiu $a0, $zero, 5",  "{after_mem(REGS.A0)} == 5"),
    ("sw $a0, 12($zero)", "{after_mem(MEM.WORD(12))} == 5"),

    # Test `sw` - with 2 step write value forward
    ("addiu $a0, $zero, 6",  "{after_mem(REGS.A0)} == 6"),
    ("nop",),
    ("sw $a0, 12($zero)", "{after_mem(MEM.WORD(12))} == 6"),

    # Test `sw` - with 3 step write value forward
    ("addiu $a0, $zero, 7",  "{after_mem(REGS.A0)} == 7"),
    ("nop",),
    ("nop",),
    ("sw $a0, 12($zero)", "{after_mem(MEM.WORD(12))} == 7"),

    # Test `sw` - with 4 step write value forward
    ("addiu $a0, $zero, 8",  "{after_mem(REGS.A0)} == 8"),
    ("nop",),
    ("nop",),
    ("nop",),
    ("sw $a0, 12($zero)", "{after_mem(MEM.WORD(12))} == 8"),

    # Test `sw` - with address forward
    ("addiu $a0, $zero, 11",  "{after_mem(REGS.A0)} == 11"),
    ("addiu $a1, $zero, 10",  "{after_mem(REGS.A1)} == 10"),
    ("sw $a0, 10($a1)", "{after_mem(MEM.WORD(20))} == 11"),

    # Test `sw` - with address and value forward
    ("addiu $a2, $zero, 20",  "{after_mem(REGS.A2)} == 20"),
    ("sw $a2, 10($a2)", "{after_mem(MEM.WORD(30))} == 20"),

    # Test `sw` - with negative address offset
    ("addiu $a2, $zero, 30",  "{after_mem(REGS.A2)} == 30"),
    ("sw $a2, -10($a2)", "{after_mem(MEM.WORD(20))} == 30"),

    # Test `sw` - with full word value
    ("addi $a0, $zero, -2",  "{after_mem(REGS.A0)} == -2"),
    ("sw $a0, 12($zero)", "{after_mem(MEM.WORD(12))} == -2"),

        # Test `sb` - with 1 byte value
    ("addi $a0, $zero, 211",  "{after_mem(REGS.A0)} == 211"),
    ("sb $a0, 3($zero)", "{after_mem(MEM.WORD(3))} == 211"),

    # Test `sb` - with 2 byte value (will cut it to one byte)
    ("addi $a0, $zero, 355",  "{after_mem(REGS.A0)} == 355"),
    ("sb $a0, 4($zero)", "{after_mem(MEM.WORD(4))} == 99"),

    # Test `sh` - with 2 byte value
    ("addi $a0, $zero, 355",  "{after_mem(REGS.A0)} == 355"),
    ("sh $a0, 6($zero)", "{after_mem(MEM.WORD(6))} == 355"),

    # Test `sh` - with 3 byte value
    ("addiu $a0, $zero, 65535",  "{after_mem(REGS.A0)} == 65535"),
    ("addiu $a0, $a0, 123",  "{after_mem(REGS.A0)} == 65658"),
    ("sh $a0, 6($zero)", "{after_mem(MEM.WORD(6))} == 122"),

    #  Test over load store commands
    ("addi $a0, $zero, -1",  "{after_mem(REGS.A0)} == -1"),
    ("sw $a0, 33($zero)", "{after_mem(MEM.WORD(33))} == -1"),
    ("addi $a0, $zero, 0",  "{after_mem(REGS.A0)} == 0"),
    ("sb $a0, 33($zero)", "{after_mem(MEM.WORD(33))} == 4294967040"),
    ("sh $a0, 33($zero)", "{after_mem(MEM.WORD(33))} == 4294901760"),

    # Test `lw`
    ("addi $a0, $zero, 145",  "{after_mem(REGS.A0)} == 145"),
    ("sw $a0, 34($zero)", "{after_mem(MEM.WORD(34))} == 145"),
    ("lw $a1, 34($zero)", "{after_mem(REGS.A1)} == 145"),

    # Test `lbu`
    ("addi $a0, $zero, 146",  "{after_mem(REGS.A0)} == 146"),
    ("sw $a0, 35($zero)", "{after_mem(MEM.WORD(35))} == 146"),
    ("lbu $a1, 35($zero)", "{after_mem(REGS.A1)} == 146"),

    # Test `lhu`
    ("addi $a1, $zero, 147",  "{after_mem(REGS.A1)} == 147"),
    ("sw $a1, 36($zero)", "{after_mem(MEM.WORD(36))} == 147"),
    ("lhu $a2, 36($zero)", "{after_mem(REGS.A2)} == 147"),

    # Test load opcodes bytes size cutting
    ("addi $a0, $zero, -1",  "{after_mem(REGS.A0)} == -1"),
    ("sw $a0, 37($zero)", "{after_mem(MEM.WORD(37))} == -1"),
    ("lw $a1, 37($zero)", "{after_mem(REGS.A1)} == -1"),
    ("lbu $a1, 37($zero)", "{after_mem(REGS.A1)} == 255"),
    ("lhu $a1, 37($zero)", "{after_mem(REGS.A1)} == 65535"),

    # Test `lui`
    ("lui $a0, 100",  "{after_mem(REGS.A0)} == 6553600"),

        # initial state
    ("addi $s0, $zero, 123",  "{after_mem(REGS.S0)} == 123"),
    ("addi $s1, $zero, 321",  "{after_mem(REGS.S1)} == 321"),
    ("addi $s2, $zero, 534",  "{after_mem(REGS.S2)} == 534"),
    ("addi $s3, $zero, 534",  "{after_mem(REGS.S3)} == 534"),
    ("addi $s4, $zero, -322",  "{after_mem(REGS.S4)} == -322"),

    # Test `nor`
    ("nor $a0, $s0, $s1",  "{after_mem(REGS.A0)} == -380"),

    # Test `or`
    ("or $a0, $s0, $s1",  "{after_mem(REGS.A0)} == 379"),

    # Test `ori`
    ("ori $a0, $s0, 12345",  "{after_mem(REGS.A0)} == 12411"),

    # Test `slt`
    ("slt $a0, $s0, $s1",  "{after_mem(REGS.A0)} == 1"),
    ("slt $a0, $s1, $s0",  "{after_mem(REGS.A0)} == 0"),
    ("slt $a0, $s2, $s3",  "{after_mem(REGS.A0)} == 0"),

    # Test `slti`
    ("slti $a0, $s0, 123",  "{after_mem(REGS.A0)} == 0"),
    ("slti $a0, $s0, 122",  "{after_mem(REGS.A0)} == 0"),
    ("slti $a0, $s0, 124",  "{after_mem(REGS.A0)} == 1"),
    
    # Test `sltiu`
    ("sltiu $a0, $s0, 123",  "{after_mem(REGS.A0)} == 0"),
    ("sltiu $a0, $s0, 122",  "{after_mem(REGS.A0)} == 0"),
    ("sltiu $a0, $s0, 124",  "{after_mem(REGS.A0)} == 1"),

    # Test `sltu`
    ("sltu $a0, $s0, $s1",  "{after_mem(REGS.A0)} == 1"),
    ("sltu $a0, $s1, $s0",  "{after_mem(REGS.A0)} == 0"),
    ("sltu $a0, $s2, $s3",  "{after_mem(REGS.A0)} == 0"),

    # Test `sll`
    ("sll $a0, $s0, 3",  "{after_mem(REGS.A0)} == 984"),

    # Test `srl`
    ("srl $a0, $s0, 2",  "{after_mem(REGS.A0)} == 30"),

    # Test `sub`
    ("sub $a0, $s0, $s1",  "{after_mem(REGS.A0)} == -198"),
    ("sub $a0, $s1, $s0",  "{after_mem(REGS.A0)} == 198"),

    # Test `subu`
    ("subu $a0, $s0, $s1",  "{after_mem(REGS.A0)} == -198"),
    ("subu $a0, $s1, $s0",  "{after_mem(REGS.A0)} == 198"),
]

test_instructions = [
]

TestBuilder().attach_instructions(test_instructions or instructions).write(
    output_path_tb="tests/hardware/MIPS_R2000_tb.v",
    output_path_asm="tests/hardware/asm/MIPS_R2000_tb.asm"
)
