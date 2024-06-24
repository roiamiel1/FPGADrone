# Initiate registers values:
        li $a0, 0
        li $a1, 1
        li $a2, 2
        li $a3, -1

# Test add command:
        add $v0, $v1, $a1
        add $a0, $t8, $t8
        add $a1, $v0, $v0
        add $k1, $k0, $t8
        add $v0, $v0, $v0

# Test addi command
        addi $v1, $zero, 5


        addi $a2, $v0, 5        # $a2 = $v0 + 5 ($a2 = 1 + 5 = 6)
        nop                     
        addi $a0, $a2, -3       # $a0 = $v0 + (-3) ($a0 = 6 + (-3) = 3)
        nop
        nop
        nop
        nop
        
