`define CLOCK_RATE      27_000_000 // board internal clock (27Mhz)

`ifndef DEBUG
`define UART_BAUD_RATE  115_200
`else
`define UART_BAUD_RATE (`CLOCK_RATE / 2) // for debugging purposes
`endif

`define MEM_TOP_ADDRESS     32'h0000_3FF0

`define OP(instr)           instr[31:26]
`define RS(instr)           instr[25:21]
`define RT(instr)           instr[20:16]
`define RD(instr)           instr[15:11]
`define SHAMT(instr)        instr[10:6]
`define FUNCT(instr)        instr[5:0]
`define IMMEDIATE(instr)    instr[15:0]
`define JUMP_ADDRESS(instr) instr[25:0]

// Forward MUX Options
`define FOWARD_MUX_NO_FORWARD    2'b00
`define FOWARD_MUX_EXMEM_FORWARD 2'b01
`define FOWARD_MUX_MEMWB_FORWARD 2'b10

// Mux Macro, sel is either `ALUDataIn1Mux_out` or `ALUDataIn2Mux_out`
`define ForwardingMux(sel, i0, i1, i2) (sel == `FOWARD_MUX_NO_FORWARD ? i0 : ((sel == `FOWARD_MUX_EXMEM_FORWARD) ? i1 : i2))

// Special Operations Options
`define SpecialOP_NONE      4'b0000
`define SpecialOP_JAL       4'b0001
`define SpecialOP_JR        4'b0010
`define SpecialOP_DM_BYTE   4'b0011
`define SpecialOP_DM_HW     4'b0100
`define SpecialOP_BEQ       4'b0101
`define SpecialOP_BNE       4'b0110
`define SpecialOP_BGTZ      4'b0111
`define SpecialOP_BLEZ      4'b1000
`define SpecialOP_BGEZAL    4'b1001

// ALU Source
`define ALU_SRC_REG 1'b0
`define ALU_SRC_EXT 1'b1

// Register
`define REG_RT  2'b00
`define REG_RD  2'b01
`define REG_RS  2'b10
`define REG_MUX(register, rt, rd, rs) (register == `REG_RT ? rt : ((register == `REG_RD) ? rd : rs))
`define INSTR_REG_MUX(register, inst) (register == `REG_RT ? `RT(inst) : ((register == `REG_RD) ? `RD(inst) : `RS(inst)))

// Extender
`define EXT_ZERO    1'b0
`define EXT_SIGNED  1'b1

// ALU Arithmetic and Logic Operations
`define ALUOp_ADD   5'b00000    // ALURes = A + B;
`define ALUOp_SUB   5'b00001    // ALURes = A - B;
`define ALUOp_MULT  5'b00010    // ALURes = A * B;
`define ALUOp_DIV   5'b00011    // ALURes = A / B;
`define ALUOp_SLL   5'b00100    // ALURes = A << 1;
`define ALUOp_SRL   5'b00101    // ALURes = A >> 1;
`define ALUOp_AND   5'b00110    // ALURes = A and B;
`define ALUOp_OR    5'b00111    // ALURes = A or B;
`define ALUOp_XOR   5'b01000    // ALURes = A xor B;
`define ALUOp_NOR   5'b01001    // ALURes = A nor B;
`define ALUOp_NAND  5'b01010    // ALURes = A nand B;
`define ALUOp_XNOR  5'b01011    // ALURes = A xnor B;
`define ALUOp_SLT   5'b01100    // ALURes = 1 if A<B else 0;
`define ALUOp_LUI   5'b01101    // ALURes = 1 if A<B else 0;
`define ALUOp_IN1   5'b01110    // ALURes = A;
`define ALUOp_SRA   5'b01111    // ALURes = A >> 1 (with sign extension)
`define ALUOp_MFHI  5'b10000    // ALURes = HI;
`define ALUOp_MFLO  5'b10001    // ALURes = LO;
`define ALUOp_MULTU 5'b10010    // ALURes = A * B (but unsigned);

// DataMemoryMode
`define DataMemoryMode_WORD     2'b00
`define DataMemoryMode_HALFWORD 2'b01
`define DataMemoryMode_BYTE     2'b10

// Registers
`define REG_RA 5'd31

// Instruction Types
`define INST_TYPE_R    2'b00
`define INST_TYPE_I    2'b01
`define INST_TYPE_J    2'b10