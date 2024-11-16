
`define DEBUG 1

`define OP(instr) \
    (instr[31:26])
`define RS(instr) \
    (instr[25:21])
`define RT(instr) \
    (instr[20:16])
`define RD(instr) \
    (instr[15:11])
`define SHAMT(instr) \
    (instr[10:6])
`define FUNCT(instr) \
    (instr[5:0])
`define IMMEDIATE(instr) \
    (instr[15:0])
`define JUMP_ADDRESS(instr) \
    (instr[25:0])

// Forward MUX Options
`define FOWARD_MUX_NO_FORWARD 2'b00
`define FOWARD_MUX_EXMEM_FORWARD 2'b01
`define FOWARD_MUX_MEMWB_FORWARD 2'b10

// Mux Macro, sel is either `ALUDataIn1Mux_out` or `ALUDataIn2Mux_out`
`define ForwardingMux(sel, i0, i1, i2) \
    (sel == `FOWARD_MUX_NO_FORWARD ? i0 : ((sel == `FOWARD_MUX_EXMEM_FORWARD) ? i1 : i2))

// Special Operations Options
`define SpecialOP_NONE      4'b0000
`define SpecialOP_JAL       4'b0001
`define SpecialOP_JR        4'b0010
`define SpecialOP_DM_BYTE   4'b0011
`define SpecialOP_DM_HW     4'b0100

// ALU Source
`define ALU_SRC_REG 1'b0
`define ALU_SRC_EXT 1'b1

// Register
`define REG_DST_RT  1'b0
`define REG_DST_RD  1'b1

// Extender
`define EXT_ZERO    1'b0
`define EXT_SIGNED  1'b1

// ALU Arithmetic and Logic Operations
`define ALUOp_ADD   5'b00000    // ALURes = A + B;
`define ALUOp_SUB   5'b00001    // ALURes = A - B;
`define ALUOp_MUL   5'b00010    // ALURes = A * B;
`define ALUOp_DIV   5'b00011    // ALURes = A / B;
`define ALUOp_SLL   5'b00100    // ALURes = A << 1;
`define ALUOp_SRL   5'b00101    // ALURes = A >> 1;
`define ALUOp_SLR   5'b00110    // ALURes = A rotated left by B;
`define ALUOp_SRR   5'b00111    // ALURes = A rotated right by B;
`define ALUOp_AND   5'b01000    // ALURes = A and B;
`define ALUOp_OR    5'b01001    // ALURes = A or B;
`define ALUOp_XOR   5'b01010    // ALURes = A xor B;
`define ALUOp_NOR   5'b01011    // ALURes = A nor B;
`define ALUOp_NAND  5'b01100    // ALURes = A nand B;
`define ALUOp_XNOR  5'b01101    // ALURes = A xnor B;
`define ALUOp_BNE   5'b01110    // Zero = 1 if A!=B else 0;
`define ALUOp_SLT   5'b01111    // ALURes = 1 if A<B else 0;
`define ALUOp_LUI   5'b10001    // ALURes = 1 if A<B else 0;
`define ALUOp_IN1   5'b10010    // ALURes = A;
