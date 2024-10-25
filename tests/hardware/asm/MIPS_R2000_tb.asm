addiu $s0, 0
beq $s0, $s0, hazard_beq_success
hazard_beq_unsuccess: addiu $k0, 100
hazard_beq_success: addiu $k1, 300

