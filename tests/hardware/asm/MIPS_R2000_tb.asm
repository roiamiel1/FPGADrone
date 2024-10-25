addiu $s0, 0
addiu $s1, 1
addiu $s2, 5
addiu $s3, -1
addiu $s4, -2
add $a0, $s0, $s1
add $a0, $s1, $s1
add $a0, $s1, $s2
add $a0, $s3, $s4
add $a0, $s3, $s1
add $a0, $s3, $s2
add $a0, $s1, $s4
addi $a0, $s0, 5
addi $a0, $s1, 10000
addi $a0, $s3, 10000
addi $a0, $s0, -1
addi $a0, $s0, -2
addi $a0, $s0, -10000
addu $a0, $s0, $s1
addu $a0, $s1, $s1
addu $a0, $s1, $s2
addu $a0, $s3, $s4
addu $a0, $s3, $s1
addu $a0, $s3, $s2
addu $a0, $s1, $s4
and $a0, $s0, $s1
and $a0, $s1, $s1
and $a0, $s1, $s2
and $a0, $s2, $s3
andi $a0, $s1, 0
andi $a0, $s1, 1
andi $a0, $s1, 5
andi $a0, $s3, 5
beq $s0, $s0, beq_success
beq_unsuccess: and $a0, $s0, $s1
beq_success: and $a0, $s0, $s1
bne $s0, $s1, bne_success
bne_unsuccess: and $a0, $s0, $s1
bne_success: and $a0, $s1, $s1
beq $s0, $s1, nbeq_success
nbeq_unsuccess: and $a0, $s0, $s1
nbeq_success: and $a0, $s0, $s1
bne $s0, $s0, nbne_success
nbne_unsuccess: and $a0, $s0, $s1
nbne_success: and $a0, $s1, $s1
add $a0, $s0, $s1
add $a1, $a0, $a0
add $a2, $a0, $a1
add $a3, $a0, $a2
add $t0, $a0, $a3
beq $s0, $s0, hazard_beq_success
hazard_beq_unsuccess: addiu $k0, 100
hazard_beq_success: addiu $k1, 300

