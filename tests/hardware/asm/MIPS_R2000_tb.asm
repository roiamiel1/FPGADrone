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