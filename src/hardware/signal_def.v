`define CLOCK_RATE      27_000_000 // board internal clock (27Mhz)

`ifndef DEBUG
`define UART_BAUD_RATE  115_200
`else
`define UART_BAUD_RATE (`CLOCK_RATE / 2) // for debugging purposes
`endif

`define I2C_BAUD_RATE 400_000 // 400kHz

`define MS_IN_SEC (1000) // There is 1000ms in one second

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
`define SpecialOP_BC1T      4'b1010  // branch if FP condition code = 1
`define SpecialOP_BC1F      4'b1011  // branch if FP condition code = 0
`define SpecialOP_SWC1      4'b1100  // store word from FPR (data_in comes from FPR)

// ALU Source
`define ALU_SRC_REG 1'b0
`define ALU_SRC_EXT 1'b1

// Register
`define REG_RT  2'b00
`define REG_RD  2'b01
`define REG_RS  2'b10
`define REG_FD  2'b11  // FP fd field: instr[10:6] (SHAMT position)
`define REG_MUX(register, rt, rd, rs, fd) (register == `REG_RT ? rt : (register == `REG_RD ? rd : (register == `REG_FD ? fd : rs)))
`define INSTR_REG_MUX(register, inst) (register == `REG_RT ? `RT(inst) : (register == `REG_RD ? `RD(inst) : (register == `REG_FD ? `SHAMT(inst) : `RS(inst))))

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
`define ALUOp_LUI   5'b01101    // ALURes = {DataIn2[15:0], 16'b0};
`define ALUOp_IN1   5'b01110    // ALURes = A;
`define ALUOp_SRA   5'b01111    // ALURes = A >> 1 (with sign extension)
`define ALUOp_MFHI  5'b10000    // ALURes = HI;
`define ALUOp_MFLO  5'b10001    // ALURes = LO;
`define ALUOp_MULTU 5'b10010    // ALURes = A * B (but unsigned);
`define ALUOp_SLTU  5'b10011    // ALURes = 1 if A<B else 0 (unsigned);

// FPU Operations (6-bit)
`define FPUOp_NONE    6'h00
`define FPUOp_ADD_S   6'h01  // add.s
`define FPUOp_SUB_S   6'h02  // sub.s
`define FPUOp_MUL_S   6'h03  // mul.s
`define FPUOp_DIV_S   6'h04  // div.s
`define FPUOp_ABS_S   6'h05  // abs.s
`define FPUOp_NEG_S   6'h06  // neg.s
`define FPUOp_MOV_S   6'h07  // mov.s
`define FPUOp_CVT_D_S 6'h08  // cvt.d.s (single->double)
`define FPUOp_CVT_W_S 6'h09  // cvt.w.s (single->int)
`define FPUOp_C_EQ_S  6'h0a  // c.eq.s
`define FPUOp_C_LT_S  6'h0b  // c.lt.s
`define FPUOp_C_LE_S  6'h0c  // c.le.s
`define FPUOp_ADD_D   6'h0d  // add.d
`define FPUOp_SUB_D   6'h0e  // sub.d
`define FPUOp_MUL_D   6'h0f  // mul.d
`define FPUOp_DIV_D   6'h10  // div.d
`define FPUOp_ABS_D   6'h11  // abs.d
`define FPUOp_NEG_D   6'h12  // neg.d
`define FPUOp_MOV_D   6'h13  // mov.d
`define FPUOp_CVT_S_D 6'h14  // cvt.s.d (double->single)
`define FPUOp_CVT_W_D 6'h15  // cvt.w.d (double->int)
`define FPUOp_C_EQ_D  6'h16  // c.eq.d
`define FPUOp_C_LT_D  6'h17  // c.lt.d
`define FPUOp_C_LE_D  6'h18  // c.le.d
`define FPUOp_MFC1    6'h19  // mfc1 (FPR->GPR)
`define FPUOp_MTC1    6'h1a  // mtc1 (GPR->FPR)
`define FPUOp_CVT_S_W 6'h1b  // cvt.s.w (int->single)
`define FPUOp_CVT_D_W 6'h1c  // cvt.d.w (int->double)
`define FPUOp_LWC1    6'h1d  // lwc1
`define FPUOp_SWC1    6'h1e  // swc1
`define FPUOp_BC1T    6'h1f  // bc1t (branch if CC=1)
`define FPUOp_BC1F    6'h20  // bc1f (branch if CC=0)

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