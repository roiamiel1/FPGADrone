[
    # Test `addiu``:
    ("addiu $s1, 1",  "{after_mem(REGS.S1)} == 1"),
    ("addiu $s2, 5",  "{after_mem(REGS.S2)} == 5"),
    ("addiu $s0, 0",  "{after_mem(REGS.S0)} == 0"),
    ("addiu $v0, -1", "{after_mem(REGS.V0)} == -1"),
    ("addiu $v0, $zero, 0", "{after_mem(REGS.V0)} == 0"),
    ("addiu $v0, $v0, -1", "{after_mem(REGS.V0)} == {before(REGS.V0)} - 1"),

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
    ("beq_unsuccess: and $a0, $s0, $s1", FALSE),
    ("beq_success: and $a0, $s0, $s1", TRUE),

    # Test `bne` - branching:
    ("bne $s0, $s1, bne_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("bne_unsuccess: and $a0, $s0, $s1", FALSE),
    ("bne_success: and $a0, $s1, $s1", TRUE),

    # Test `beq` - not branching:
    ("beq $s0, $s1, nbeq_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*4"),
    ("nbeq_unsuccess: and $a0, $s0, $s1", TRUE),
    ("nbeq_success: and $a0, $s0, $s1", TRUE),

    # Test `bne` - not branching:
    ("bne $s0, $s0, nbne_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*4"),
    ("nbne_unsuccess: and $a0, $s0, $s1", TRUE),
    ("nbne_success: and $a0, $s1, $s1", TRUE),

    # Test forwarding.
    ("add $a0, $s0, $s1", TRUE),
    ("add $a1, $a0, $a0", "{after_mem(REGS.A1)} == 2"),
    ("add $a2, $a0, $a1", "{after_mem(REGS.A2)} == 3"),
    ("add $a3, $a0, $a2", "{after_mem(REGS.A3)} == 4"),
    ("add $t0, $a0, $a3", "{after_mem(REGS.T0)} == 5"),

    # Test branch hazard.
    ("beq $s0, $s0, hazard_beq_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("hazard_beq_unsuccess: addiu $k0, 100", FALSE),
    ("hazard_beq_success: addiu $k1, 300", "{after_mem(REGS.K0)} == 0", "{after_mem(REGS.K1)} == 300"),

    # Test `j` - branching:
    ("j j_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j_unsuccess: addiu $k0, 100", FALSE),
    ("j_success: addiu $k1, $zero, 523", "{after_mem(REGS.K0)} == 0", "{after_mem(REGS.K1)} == 523"),

    # Test `j` - complex branching:
    ("j0: j j4", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j1: j j3", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j2: j j5", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j3: j j2", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j4: j j1", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("j5: addiu $gp, $zero, 10432", "{after_mem(REGS.GP)} == 10432"),

    # Test `jal` - branching:
    ("jal jal_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} - 4*4"),
    ("nop", FALSE),
    ("jal_unsuccess: addiu $k0, 100", FALSE),
    ("nop", FALSE),
    ("jal_success: addi $k1, $zero, -12312", 
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == -12312", 
        "{after_mem(REGS.RA)} == {before(REGS.PC)} - 3*4"
    ),
    
    # Test `jr` - branching:
    # Note! this test should come after `jal` test. 
    # because after `jal` test, $RA register contains the current PC. 
    # We use this data to calculate where to jump to.
    ("addiu $t0, $ra, 36", TRUE), # We have 6 opcodes after jal to jr_success (8 * 4 + 4 = 36).
    ("jr $t0", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("jr_unsuccess: addiu $k0, 100", FALSE),
    ("jr_success: addiu $k1, $zero, 123", "{after_mem(REGS.K0)} == 0", "{after_mem(REGS.K1)} == 123"),

    # Test addiu big int
    # Immidiate is a signd 16 bits number, 2**16/2 = 32768. so 32767 is the biggest possitive number.
    ("addi $fp, $zero, 32767", "{after_mem(REGS.FP)} == 32767"),
    ("addi $fp, $zero, 32768", "{after_mem(REGS.FP)} != 32768"),
    ("addiu $fp, $zero, 32767", "{after_mem(REGS.FP)} == 32767"),
    ("addiu $fp, $zero, 32768", "{after_mem(REGS.FP)} == -32768"),

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
    ("sb $a0, 3($zero)", "{after(MEM.BYTE(3))} == 211"),

    # Test `sb` - with 2 byte value (will cut it to one byte)
    ("addi $a0, $zero, 355",  "{after_mem(REGS.A0)} == 355"),
    ("sb $a0, 4($zero)", "{after_mem(MEM.BYTE(4))} == 99"),

    # Test `sh` - with 2 byte value
    ("addi $a0, $zero, 355",  "{after_mem(REGS.A0)} == 355"),
    ("sh $a0, 6($zero)", "{after_mem(MEM.HALFWORD(6))} == 355"),

    # Test `sh` - with 3 byte value
    ("addiu $a0, $zero, 65535",  "{after_mem(REGS.A0)} == -1"),
    ("addiu $a0, $a0, 123",  "{after_mem(REGS.A0)} == 122"),
    ("sh $a0, 6($zero)", "{after_mem(MEM.HALFWORD(6))} == 122"),

    #  Test over load store commands
    ("addi $a0, $zero, -1",  "{after_mem(REGS.A0)} == -1"),
    ("sw $a0, 33($zero)", "{after_mem(MEM.WORD(33))} == -1"),
    ("addi $a0, $zero, 0",  "{after_mem(REGS.A0)} == 0"),
    ("sb $a0, 33($zero)", "{after_mem(MEM.WORD(33))} == 16777215"),
    ("nop",),
    ("sh $a0, 33($zero)", "{after_mem(MEM.WORD(33))} == 65535"),

    # Test `lw`
    ("addi $a0, $zero, 145",  "{after_mem(REGS.A0)} == 145"),
    ("sw $a0, 34($zero)", "{after_mem(MEM.WORD(34))} == 145"),
    ("nop",),
    ("lw $a1, 34($zero)", "{after_mem(REGS.A1)} == 145"),

    # Test `lbu`
    ("addi $a0, $zero, 146",  "{after_mem(REGS.A0)} == 146"),
    ("sb $a0, 35($zero)", "{after_mem(MEM.BYTE(35))} == 146"),
    ("nop",),
    ("lbu $a1, 35($zero)", "{after_mem(REGS.A1)} == 146"),
    
    # Test `lb`
    ("addi $a0, $zero, -123",  "{after_mem(REGS.A0)} == -123"),
    ("sw $a0, 39($zero)", "{after_mem(MEM.WORD(39))} == -123"),
    ("nop",),
    ("lw $a1, 39($zero)", "{after_mem(REGS.A1)} == -123"),

    # Test `lb` with forwarding
    ("addi $a2, $zero, 12",  "{after_mem(REGS.A2)} == 12"),
    ("sw $a2, 34($zero)", "{after_mem(MEM.WORD(34))} == 12"),
    ("nop",),
    ("lw $v0, 34($zero)", "{after_mem(REGS.V0)} == 12"),
    ("addi $a1, $v0, 6",  "{after_mem(REGS.A1)} == 18"),

    # Test `lhu`
    ("addi $a1, $zero, 147",  "{after_mem(REGS.A1)} == 147"),
    ("sh $a1, 36($zero)", "{after_mem(MEM.HALFWORD(36))} == 147"),
    ("nop",),
    ("lhu $a2, 36($zero)", "{after_mem(REGS.A2)} == 147"),

    # Test load opcodes bytes size cutting
    ("addi $a0, $zero, -1",  "{after_mem(REGS.A0)} == -1"),
    ("sw $a0, 37($zero)", "{after_mem(MEM.WORD(37))} == -1"),
    ("nop",),
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
    ("addi $t0, $zero, 3",  "{after_mem(REGS.T0)} == 3"),

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

    # Test `sll` and `sllv`
    ("sll $a0, $s0, 0",  "{after_mem(REGS.A0)} == 123"),
    ("sll $a0, $s0, 3",  "{after_mem(REGS.A0)} == 984"),
    ("sllv $a0, $s0, $t0",  "{before(REGS.T0)} == 3", "{before(REGS.S0)} == 123", "{after_mem(REGS.A0)} == 984"),

    # Test `srl` and `srlv`
    ("srl $a0, $s0, 2", "{before(REGS.S0)} == 123", "{after_mem(REGS.A0)} == 30"),
    ("srlv $a0, $s0, $t0",  "{before(REGS.T0)} == 3", "{before(REGS.S0)} == 123", "{after_mem(REGS.A0)} == 15"),

    # Test `sra` and `srav`
    ("sra $a0, $s4, 2", "{before(REGS.S4)} == -322", "{after_mem(REGS.A0)} == -81"),
    ("srav $a0, $s4, $t0",  "{before(REGS.T0)} == 3", "{before(REGS.S4)} == -322", "{after_mem(REGS.A0)} == -41"),

    # Test `sub`
    ("sub $a0, $s0, $s1",  "{after_mem(REGS.A0)} == -198"),
    ("sub $a0, $s1, $s0",  "{after_mem(REGS.A0)} == 198"),

    # Test `subu`
    ("subu $a0, $s0, $s1",  "{after_mem(REGS.A0)} == -198"),
    ("subu $a0, $s1, $s0",  "{after_mem(REGS.A0)} == 198"),

    # Test byte write and read to align and non align address
    # Align 1
    ("addi $a0, $zero, 149",  "{after_mem(REGS.A0)} == 149"),
    ("sb $a0, 8($zero)", "{after(MEM.BYTE(8))} == 149"),
    ("nop",),
    ("lb $a1, 8($zero)", "{after_mem(REGS.A1)} == 149"),
    # Align 2
    ("addi $a0, $zero, 150",  "{after_mem(REGS.A0)} == 150"),
    ("sb $a0, 9($zero)", "{after(MEM.BYTE(9))} == 150"),
    ("nop",),
    ("lb $a1, 9($zero)", "{after_mem(REGS.A1)} == 150"),
    # Align 3
    ("addi $a0, $zero, 151",  "{after_mem(REGS.A0)} == 151"),
    ("sb $a0, 10($zero)", "{after(MEM.BYTE(10))} == 151"),
    ("nop",),
    ("lb $a1, 10($zero)", "{after_mem(REGS.A1)} == 151"),
    # Align 0
    ("addi $a0, $zero, 152",  "{after_mem(REGS.A0)} == 152"),
    ("sb $a0, 11($zero)", "{after(MEM.BYTE(11))} == 152"),
    ("nop",),
    ("lb $a1, 11($zero)", "{after_mem(REGS.A1)} == 152"),

    # Test half word write and read to align and non align address
    # Align 1
    ("addi $a0, $zero, 1149",  "{after_mem(REGS.A0)} == 1149"),
    ("sh $a0, 8($zero)", "{after(MEM.HALFWORD(8))} == 1149"),
    ("nop",),
    ("lhu $a1, 8($zero)", "{after_mem(REGS.A1)} == 1149"),
    # Align 2
    ("addi $a0, $zero, 1150",  "{after_mem(REGS.A0)} == 1150"),
    ("sh $a0, 9($zero)", "{after(MEM.HALFWORD(9))} == 1150"),
    ("nop",),
    ("lhu $a1, 9($zero)", "{after_mem(REGS.A1)} == 1150"),
    # Align 3
    ("addi $a0, $zero, 1151",  "{after_mem(REGS.A0)} == 1151"),
    ("sh $a0, 10($zero)", "{after(MEM.HALFWORD(10))} == 1151"),
    ("nop",),
    ("lhu $a1, 10($zero)", "{after_mem(REGS.A1)} == 1151"),
    # Align 0
    ("addi $a0, $zero, 1152",  "{after_mem(REGS.A0)} == 1152"),
    ("sh $a0, 11($zero)", "{after(MEM.HALFWORD(11))} == 1152"),
    ("nop",),
    ("lhu $a1, 11($zero)", "{after_mem(REGS.A1)} == 1152"),

    # Test word write and read to align and non align address
    # Align 1
    ("addi $a0, $zero, 1149",  "{after_mem(REGS.A0)} == 1149"),
    ("sw $a0, 8($zero)", "{after(MEM.WORD(8))} == 1149"),
    ("nop",),
    ("lw $a1, 8($zero)", "{after_mem(REGS.A1)} == 1149"),
    # Align 2
    ("addi $a0, $zero, 1150",  "{after_mem(REGS.A0)} == 1150"),
    ("sw $a0, 9($zero)", "{after(MEM.WORD(9))} == 1150"),
    ("nop",),
    ("lw $a1, 9($zero)", "{after_mem(REGS.A1)} == 1150"),
    # Align 3
    ("addi $a0, $zero, 1151",  "{after_mem(REGS.A0)} == 1151"),
    ("sw $a0, 10($zero)", "{after(MEM.WORD(10))} == 1151"),
    ("nop",),
    ("lw $a1, 10($zero)", "{after_mem(REGS.A1)} == 1151"),
    # Align 0
    ("addi $a0, $zero, 1152",  "{after_mem(REGS.A0)} == 1152"),
    ("sw $a0, 11($zero)", "{after(MEM.WORD(11))} == 1152"),
    ("nop",),
    ("lw $a1, 11($zero)", "{after_mem(REGS.A1)} == 1152"),

    # Blez test when negative
    ("addi $a0, $zero, -1", "{after_mem(REGS.A0)} == -1"),
    ("blez $a0, blez_neg_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("blez_neg_unsuccess: addiu $k0, $zero, 100", FALSE),
    ("blez_neg_success: addiu $k1, $zero, 555", "{after_mem(REGS.K0)} == 0", "{after_mem(REGS.K1)} == 555"),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # Blez test when zero
    ("addi $a0, $zero, 0", "{after_mem(REGS.A0)} == 0"),
    ("blez $a0, blez_zero_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*4"),
    ("blez_zero_unsuccess: addiu $k0, $zero, 100", FALSE),
    ("blez_zero_success: addiu $k1, $zero, 556", "{after_mem(REGS.K0)} == 0", "{after_mem(REGS.K1)} == 556"),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # Blez test when positive
    ("addi $a0, $zero, 1",  "{after_mem(REGS.A0)} == 1"),
    ("blez $a0, blez_pos_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*4"),
    ("blez_pos_unsuccess: addiu $k0, $zero, 100", TRUE),
    ("blez_pos_success: addiu $k1, $zero, 557", "{after_mem(REGS.K0)} == 100", "{after_mem(REGS.K1)} == 557"),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # Bgtz test when negative
    ("addi $a0, $zero, -1", "{after_mem(REGS.A0)} == -1"),
    ("bgtz $a0, bgtz_neg_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*4"),
    ("bgtz_neg_unsuccess: addiu $k0, $zero, 100", TRUE),
    ("bgtz_neg_success: addiu $k1, $zero, 558", "{after_mem(REGS.K0)} == 100", "{after_mem(REGS.K1)} == 558"),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # Bgtz test when zero
    ("addi $a0, $zero, 0",  "{after_mem(REGS.A0)} == 0"),
    ("bgtz $a0, bgtz_zero_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*4"),
    ("bgtz_zero_unsuccess: addiu $k0, $zero, 100", TRUE),
    ("bgtz_zero_success: addiu $k1, $zero, 559", "{after_mem(REGS.K0)} == 100", "{after_mem(REGS.K1)} == 559"),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # Bgtz test when positive
    ("addi $a0, $zero, 1",  "{after_mem(REGS.A0)} == 1"),
    ("bgtz $a0, bgtz_pos_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("bgtz_pos_unsuccess: addiu $k0, $zero, 100", FALSE),
    ("bgtz_pos_success: addiu $k1, $zero, 560", "{after_mem(REGS.K0)} == 0", "{after_mem(REGS.K1)} == 560"),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # Bgezal test when branch taken (grater than zero)
    ("addiu $ra, $zero, 0",  "{after_mem(REGS.RA)} == 0"),
    ("addiu $a0, $zero, 123", "{after_mem(REGS.A0)} == 123"),
    ("bgezal $a0, bgezal_success", "{after_mem(REGS.PC)} == {before(REGS.PC)} - 4*4"),
    ("nop", FALSE),
    ("bgezal_unsuccess: addiu $k0, 100", FALSE),
    ("nop", FALSE),
    ("bgezal_success: addi $k1, $zero, -12312", 
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == -12312", 
        "{after_mem(REGS.RA)} == {before(REGS.PC)} - 3*4"
    ),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # Bgezal test when branch taken (equal zero)
    ("addiu $ra, $zero, 0", "{after_mem(REGS.RA)} == 0"),
    ("addiu $a0, $zero, 0", "{after_mem(REGS.A0)} == 0"),
    ("bgezal $a0, bgezal_success_1", "{after_mem(REGS.PC)} == {before(REGS.PC)} - 4*4"),
    ("nop", FALSE),
    ("bgezal_unsuccess_1: addiu $k0, 100", FALSE),
    ("nop", FALSE),
    ("bgezal_success_1: addi $k1, $zero, -12312", 
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == -12312", 
        "{after_mem(REGS.RA)} == {before(REGS.PC)} - 3*4"
    ),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # Bgezal test when branch not taken (negative)
    ("addiu $ra, $zero, 0", "{after_mem(REGS.RA)} == 0"),
    ("addiu $a0, $zero, -1", "{after_mem(REGS.A0)} == -1"),
    ("bgezal $a0, bgezal_success_2", "{after_mem(REGS.PC)} - 4*4 == {before(REGS.PC)}"),
    ("nop", TRUE),
    ("bgezal_unsuccess_2: addiu $k0, 100", "{after_mem(REGS.K0)} == 100",),
    ("nop", TRUE),
    ("bgezal_success_2: addi $k1, $zero, -12312", 
        "{after_mem(REGS.K0)} == 100",
        "{after_mem(REGS.K1)} == -12312", 
        "{after_mem(REGS.RA)} == 0"
    ),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # Xor tests
    ("addi $a0, $zero, 170", "{after_mem(REGS.A0)} == 170"),
    ("addi $a1, $zero, 204", "{after_mem(REGS.A1)} == 204"),
    ("xor $a2, $a0, $a1", "{after_mem(REGS.A2)} == 102"),
    ("xori $a3, $a0, 240", "{after_mem(REGS.A3)} == 90"),

    # Test mult, multu, mfhi, mflo
    ("addi $a0, $zero, 20", "{after_mem(REGS.A0)} == 20"),
    ("addi $a1, $zero, 30", "{after_mem(REGS.A1)} == 30"),
    ("mult $a0, $a1", TRUE),
    ("mflo $v0", "{after_mem(REGS.V0)} == 600"),
    ("mfhi $v1", "{after_mem(REGS.V1)} == 0"),
    ("addi $a0, $zero, -20", "{after_mem(REGS.A0)} == -20"),
    ("addi $a1, $zero, 30", "{after_mem(REGS.A1)} == 30"),
    # Unsigned multiplication
    ("multu $a0, $a1", TRUE),
    ("mflo $v0", "{after_mem(REGS.V0)} == 4294966696"),
    ("mfhi $v1", "{after_mem(REGS.V1)} == 29"),
    # Signed multiplication
    ("mult $a0, $a1", TRUE),
    ("mflo $v0", "{after_mem(REGS.V0)} == -600"),
    ("mfhi $v1", "{after_mem(REGS.V1)} == 4294967295"),

    # =========================================================
    # FPU: single-precision (float) tests
    # IEEE 754 bit patterns:
    #   1.0f = 0x3F800000 = 1065353216
    #   2.0f = 0x40000000 = 1073741824
    #   3.0f = 0x40400000 = 1077936128
    #   4.0f = 0x40800000 = 1082130432
    #  -1.0f = 0xBF800000 = -1082130432 (signed)
    #  -2.0f = 0xC0000000 = -1073741824 (signed)
    # Note: on -mips1/-march=r2000 the assembler auto-inserts 1 NOP after
    # mtc1/mfc1 and 2 NOPs after c.xx compares when the slot is empty.
    # We always place a manual nop in those slots to prevent the assembler
    # from shifting PCs, which would break the test framework's PC tracking.
    # =========================================================

    # mtc1 / mfc1 round-trip
    ("lui $at, 0x3f80", TRUE),                                          # $at = 0x3F800000 (1.0f)
    ("mtc1 $at, $f0", "{after_mem(REGS.F0)} == 1065353216"),            # f0 = 1.0f
    ("nop",),                                                            # fill mtc1 delay slot
    ("lui $at, 0x4000", TRUE),                                          # $at = 0x40000000 (2.0f)
    ("mtc1 $at, $f2", "{after_mem(REGS.F2)} == 1073741824"),            # f2 = 2.0f
    ("nop",),
    ("nop",),
    ("mfc1 $v0, $f0", "{after_mem(REGS.V0)} == 1065353216"),            # mfc1: f0 -> $v0
    ("nop",),                                                            # fill mfc1 delay slot

    # add.s: f4 = f0 + f2 = 1.0f + 2.0f = 3.0f
    ("add.s $f4, $f0, $f2", "{after_mem(REGS.F4)} == 1077936128"),
    ("nop",),
    ("nop",),
    ("mfc1 $v0, $f4", "{after_mem(REGS.V0)} == 1077936128"),
    ("nop",),                                                            # fill mfc1 delay slot

    # sub.s: f6 = f4 - f2 = 3.0f - 2.0f = 1.0f
    ("sub.s $f6, $f4, $f2", "{after_mem(REGS.F6)} == 1065353216"),
    ("nop",),
    ("nop",),

    # mul.s: f8 = f0 * f2 = 1.0f * 2.0f = 2.0f
    ("mul.s $f8, $f0, $f2", "{after_mem(REGS.F8)} == 1073741824"),
    ("nop",),
    ("nop",),

    # div.s: f10 = 4.0f / 2.0f = 2.0f
    ("lui $at, 0x4080", TRUE),                                          # 4.0f
    ("mtc1 $at, $f0", TRUE),
    ("nop",),
    ("nop",),
    ("div.s $f10, $f0, $f2", "{after_mem(REGS.F10)} == 1073741824"),    # 2.0f
    ("nop",),
    ("nop",),
    ("lui $at, 0x3f80", TRUE),                                          # restore f0 = 1.0f
    ("mtc1 $at, $f0", TRUE),
    ("nop",),
    ("nop",),

    # neg.s: f12 = -f0 = -1.0f = 0xBF800000
    ("neg.s $f12, $f0", "{after_mem(REGS.F12)} == -1082130432"),
    ("nop",),
    ("nop",),

    # abs.s: f14 = abs(-2.0f) = 2.0f
    ("lui $at, 0xc000", TRUE),                                          # -2.0f
    ("mtc1 $at, $f12", TRUE),
    ("nop",),
    ("nop",),
    ("abs.s $f14, $f12", "{after_mem(REGS.F14)} == 1073741824"),        # 2.0f
    ("nop",),
    ("nop",),

    # cvt.s.w: integer 3 -> 3.0f
    ("addiu $at, $zero, 3", TRUE),
    ("mtc1 $at, $f16", TRUE),
    ("nop",),
    ("nop",),
    ("cvt.s.w $f16, $f16", "{after_mem(REGS.F16)} == 1077936128"),      # 3.0f
    ("nop",),
    ("nop",),

    # swc1 / lwc1: store f0 (1.0f) to mem[40], load back to f18
    ("lui $at, 0x3f80", TRUE),
    ("mtc1 $at, $f0", TRUE),
    ("nop",),
    ("nop",),
    ("swc1 $f0, 40($zero)", "{after_mem(MEM.WORD(40))} == 1065353216"),
    ("nop",),
    ("lwc1 $f18, 40($zero)", "{after_mem(REGS.F18)} == 1065353216"),
    ("nop",),
    ("nop",),
    ("mfc1 $v0, $f18", "{after_mem(REGS.V0)} == 1065353216"),
    ("nop",),                                                            # fill mfc1 delay slot

    # c.eq.s + bc1t: f0 == f0 -> CC=1 -> bc1t taken
    # 2 NOPs needed: hardware needs 1, assembler needs 2 (fills both slots for c.xx)
    ("c.eq.s $f0, $f0", TRUE),
    ("nop",),
    ("nop",),
    ("bc1t fpu_bc1t_s", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("fpu_bc1t_f: addiu $k0, $zero, 1", FALSE),
    ("fpu_bc1t_s: addiu $k1, $zero, 10",
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == 10"),

    # c.eq.s + bc1f: f0 != f2 -> CC=0 -> bc1f taken
    ("c.eq.s $f0, $f2", TRUE),                                          # 1.0f != 2.0f -> CC=0
    ("nop",),
    ("nop",),
    ("bc1f fpu_bc1f_s", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("fpu_bc1f_f: addiu $k0, $zero, 1", FALSE),
    ("fpu_bc1f_s: addiu $k1, $zero, 11",
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == 11"),

    # c.lt.s + bc1t: f0 < f2 -> 1.0f < 2.0f -> CC=1 -> bc1t taken
    ("c.lt.s $f0, $f2", TRUE),
    ("nop",),
    ("nop",),
    ("bc1t fpu_clt_s", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("fpu_clt_f: addiu $k0, $zero, 1", FALSE),
    ("fpu_clt_s: addiu $k1, $zero, 12",
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == 12"),

    # c.lt.s + bc1t NOT taken: f2 < f0 -> 2.0f < 1.0f -> CC=0 -> bc1t not taken
    ("c.lt.s $f2, $f0", TRUE),
    ("nop",),
    ("nop",),
    ("bc1t fpu_cltn_s", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*4"),
    ("fpu_cltn_f: addiu $k0, $zero, 1", TRUE),
    ("fpu_cltn_s: addiu $k1, $zero, 13",
        "{after_mem(REGS.K0)} == 1",
        "{after_mem(REGS.K1)} == 13"),
    ("addiu $k0, $zero, 0", "{after_mem(REGS.K0)} == 0"),

    # c.le.s + bc1t: f0 <= f0 -> 1.0f <= 1.0f -> CC=1 -> bc1t taken
    ("c.le.s $f0, $f0", TRUE),
    ("nop",),
    ("nop",),
    ("bc1t fpu_cle_s", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("fpu_cle_f: addiu $k0, $zero, 1", FALSE),
    ("fpu_cle_s: addiu $k1, $zero, 14",
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == 14"),

    # =========================================================
    # FPU: double-precision tests
    # 1.0d: f0(low)=0x00000000=0, f1(high)=0x3FF00000=1072693248
    # 2.0d: f2(low)=0x00000000=0, f3(high)=0x40000000=1073741824
    # 3.0d: f4(low)=0x00000000=0, f5(high)=0x40080000=1074266112
    # =========================================================

    # Load 1.0d into f0/f1
    ("lui $at, 0x3ff0", TRUE),                                          # high word of 1.0d
    ("mtc1 $at, $f1", "{after_mem(REGS.F1)} == 1072693248"),            # f1 = 0x3FF00000
    ("nop",),                                                            # fill mtc1 delay slot
    ("mtc1 $zero, $f0", "{after_mem(REGS.F0)} == 0"),                   # f0 = 0
    ("nop",),
    ("nop",),

    # Load 2.0d into f2/f3
    ("lui $at, 0x4000", TRUE),                                          # high word of 2.0d
    ("mtc1 $at, $f3", "{after_mem(REGS.F3)} == 1073741824"),            # f3 = 0x40000000
    ("nop",),                                                            # fill mtc1 delay slot
    ("mtc1 $zero, $f2", "{after_mem(REGS.F2)} == 0"),                   # f2 = 0
    ("nop",),
    ("nop",),

    # add.d: f4 = f0 + f2 = 1.0d + 2.0d = 3.0d
    ("add.d $f4, $f0, $f2",
        "{after_mem(REGS.F4)} == 0",
        "{after_mem(REGS.F5)} == 1074266112"),
    ("nop",),
    ("nop",),

    # sub.d: f6 = f4 - f2 = 3.0d - 2.0d = 1.0d
    ("sub.d $f6, $f4, $f2",
        "{after_mem(REGS.F6)} == 0",
        "{after_mem(REGS.F7)} == 1072693248"),
    ("nop",),
    ("nop",),

    # c.lt.d + bc1t: 1.0d < 2.0d -> CC=1 -> bc1t taken
    ("c.lt.d $f0, $f2", TRUE),
    ("nop",),
    ("nop",),
    ("bc1t fpu_cltd_s", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("fpu_cltd_f: addiu $k0, $zero, 1", FALSE),
    ("fpu_cltd_s: addiu $k1, $zero, 15",
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == 15"),

    # c.eq.d + bc1f: 1.0d != 2.0d -> CC=0 -> bc1f taken
    ("c.eq.d $f0, $f2", TRUE),
    ("nop",),
    ("nop",),
    ("bc1f fpu_ceqd_s", "{after_mem(REGS.PC)} == {before(REGS.PC)} + 4*3"),
    ("fpu_ceqd_f: addiu $k0, $zero, 1", FALSE),
    ("fpu_ceqd_s: addiu $k1, $zero, 16",
        "{after_mem(REGS.K0)} == 0",
        "{after_mem(REGS.K1)} == 16"),
]