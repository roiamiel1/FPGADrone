# Registers:
class REGISTERS:
    REG_ZERO = "$zero"
    REG_AT   = "$at"
    REG_V0   = "$v0"
    REG_V1   = "$v1"
    REG_A0   = "$a0"
    REG_A1   = "$a1"
    REG_A2   = "$a2"
    REG_A3   = "$a3"
    REG_T0   = "$t0"
    REG_T1   = "$t1"
    REG_T2   = "$t2"
    REG_T3   = "$t3"
    REG_T4   = "$t4"
    REG_T5   = "$t5"
    REG_T6   = "$t6"
    REG_T7   = "$t7"
    REG_S0   = "$s0"
    REG_S1   = "$s1"
    REG_S2   = "$s2"
    REG_S3   = "$s3"
    REG_S4   = "$s4"
    REG_S5   = "$s5"
    REG_S6   = "$s6"
    REG_S7   = "$s7"
    REG_T8   = "$t8"
    REG_T9   = "$t9"
    REG_K0   = "$k0"
    REG_K1   = "$k1"
    REG_GP   = "$gp"
    REG_SP   = "$sp"
    REG_FP   = "$fp"
    REG_RA   = "$ra"

REGISTER_TO_INDEX = {
    REGISTERS.REG_ZERO: 0,
    REGISTERS.REG_AT: 1,
    REGISTERS.REG_V0: 2,
    REGISTERS.REG_V1: 3,
    REGISTERS.REG_A0: 4,
    REGISTERS.REG_A1: 5,
    REGISTERS.REG_A2: 6,
    REGISTERS.REG_A3: 7,
    REGISTERS.REG_T0: 8,
    REGISTERS.REG_T1: 9,
    REGISTERS.REG_T2: 10,
    REGISTERS.REG_T3: 11,
    REGISTERS.REG_T4: 12,
    REGISTERS.REG_T5: 13,
    REGISTERS.REG_T6: 14,
    REGISTERS.REG_T7: 15,
    REGISTERS.REG_S0: 16,
    REGISTERS.REG_S1: 17,
    REGISTERS.REG_S2: 18,
    REGISTERS.REG_S3: 19,
    REGISTERS.REG_S4: 20,
    REGISTERS.REG_S5: 21,
    REGISTERS.REG_S6: 22,
    REGISTERS.REG_S7: 23,
    REGISTERS.REG_T8: 24,
    REGISTERS.REG_T9: 25,
    REGISTERS.REG_K0: 26,
    REGISTERS.REG_K1: 27,
    REGISTERS.REG_GP: 28,
    REGISTERS.REG_SP: 29,
    REGISTERS.REG_FP: 30,
    REGISTERS.REG_RA: 31
}

ALL_REGISTERS = REGISTER_TO_INDEX.keys()