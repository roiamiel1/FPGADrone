`include "signal_def.v"
`include "instruction_def.v"

module MIPS_R2000 (
    input clk,
    input rst,

    // Debug probes
    output reg [31:0] debug_pc,
    output reg debug_alu_zero
);
    // U_Ctrl connections.
    wire U_Ctrl_RegDst;
    wire [4:0] U_Ctrl_ALUOp;
    wire U_Ctrl_ALUSrc;
    wire U_Ctrl_Branch;
    wire U_Ctrl_MemRead;
    wire U_Ctrl_MemWrite;
    wire U_Ctrl_RegWrite;
    wire U_Ctrl_Jump;
    wire U_Ctrl_nBranch;
    wire U_Ctrl_ExtOp;

    // U_MEMWBReg connections.
    wire U_MEMWBReg_RegWrite_out;
    wire U_MEMWBReg_MemRead_out;
    wire [31:0] U_MEMWBReg_Mem_out;
    wire [31:0] U_MEMWBReg_ALU_out;
    wire [4:0] U_MEMWBReg_Rd_out;

    // U_EXMEMReg connections.
    wire U_EXMEMReg_Branch_out;
    wire U_EXMEMReg_MemRead_out;
    wire U_EXMEMReg_MemWrite_out;
    wire [31:0] U_EXMEMReg_Reg2_out;
    wire U_EXMEMReg_RegWrite_out;
    wire U_EXMEMReg_Zero_out;
    wire [31:0] U_EXMEMReg_ALU_in;
    wire [31:0] U_EXMEMReg_ALU_out;
    wire [4:0] U_EXMEMReg_Rd_out;
    wire [4:0] U_EXMEMReg_Rd_in;

    // U_IDEXReg connections.
    wire U_IDEXReg_RegDst_out;
    wire [4:0] U_IDEXReg_ALUOp_out;
    wire U_IDEXReg_ALUSrc_out;
    wire U_IDEXReg_Branch_out;
    wire U_IDEXReg_MemRead_out;
    wire U_IDEXReg_MemWrite_out;
    wire U_IDEXReg_RegWrite_out;
    wire [31:0] U_IDEXReg_Reg1_out;
    wire [31:0] U_IDEXReg_Reg2_out;
    wire [31:0] U_IDEXReg_Ext_out;
    wire [4:0] U_IDEXReg_Rs_out;
    wire [4:0] U_IDEXReg_Rt_out;
    wire [4:0] U_IDEXReg_Rd_out;
    wire [4:0] U_IDEXReg_shamt_out;

    // U_GPR connections.
    wire [31:0] U_GPR_WriteData;
    wire [31:0] U_GPR_DataOut1;
    wire [31:0] U_GPR_DataOut2;

    // U_IFIDReg connections.
    wire [31:0] U_IFIDReg_PC_out;
    wire [31:0] U_IFIDReg_Instr_out;

    // U_PCU connections.
    wire [31:0] U_PCU_PC;
    wire U_PCU_PCSrc;

    // U_InstructionMemory connections.
    wire [31:0] U_InstructionMemory_IR;

    // U_Extender connections.
    wire [31:0] U_Extender_ExtOut;

    // U_ALU connections.
    wire U_ALU_Zero;

    // U_DataMemory connections.
    wire [31:0] U_DataMemory_DataOut;

    // Connections assigns.
    assign U_EXMEMReg_Rd_in = U_IDEXReg_RegDst_out ? U_IDEXReg_Rd_out : U_IDEXReg_Rt_out;
    assign U_GPR_WriteData = U_MEMWBReg_MemRead_out ? U_MEMWBReg_Mem_out : U_MEMWBReg_ALU_out;
    
    // Debug assign
    always @(clk) begin
        debug_pc = U_PCU_PC;
        debug_alu_zero = U_ALU_Zero;
    end

    // Modules section.
    PCU U_PCU (
        .clk(clk),
        .rst(rst),
        .PCSrc(U_PCU_PCSrc),
        .Jump(U_Ctrl_Jump),
        .BranchAddr(U_IFIDReg_PC_out + {{14{U_IFIDReg_Instr_out[15]}}, `IMMEDIATE(U_IFIDReg_Instr_out), 2'b00}),
        .JmpAddr({U_IFIDReg_PC_out[31:28], U_IFIDReg_Instr_out[25:0], 2'b0}),
        .PC(U_PCU_PC)
    );

    InstructionMemory U_InstructionMemory(
        .IMAdress(U_PCU_PC >> 2),
        .IR(U_InstructionMemory_IR)
    );

    IFIDReg U_IFIDReg (
        .clk(clk),
        .rst(rst),
        .PC_in(U_PCU_PC + 4),
        .Instr_in(U_InstructionMemory_IR),
        .PC_out(U_IFIDReg_PC_out),
        .Instr_out(U_IFIDReg_Instr_out)
    );

    GPR U_GPR(
        .clk(clk),
        .rst(rst),
        .WriteData(U_GPR_WriteData),
        .RegWrite(U_MEMWBReg_RegWrite_out),
        .WriteRegister(U_MEMWBReg_Rd_out),
        .ReadRegister1(U_IFIDReg_Instr_out[25:21]),
        .ReadRegister2(U_IFIDReg_Instr_out[20:16]),
        .DataOut1(U_GPR_DataOut1),
        .DataOut2(U_GPR_DataOut2)
    );

    Extender U_Extender(
        .DataIn(U_IFIDReg_Instr_out[15:0]),
        .ExtOp(U_Ctrl_ExtOp),
        .ExtOut(U_Extender_ExtOut)
    );

    IDEXReg U_IDEXReg (
        .clk(clk),
        .rst(rst),
        .RegDst_in(U_Ctrl_RegDst),
        .ALUOp_in(U_Ctrl_ALUOp),
        .ALUSrc_in(U_Ctrl_ALUSrc),
        .Branch_in(U_Ctrl_Branch),
        .MemRead_in(U_Ctrl_MemRead),
        .MemWrite_in(U_Ctrl_MemWrite),
        .RegWrite_in(U_Ctrl_RegWrite),
        .Reg1_in(U_GPR_DataOut1),
        .Reg2_in(U_GPR_DataOut2),
        .Ext_in(U_Extender_ExtOut),
        .Rs_in(U_IFIDReg_Instr_out[25:21]),
        .Rt_in(U_IFIDReg_Instr_out[20:16]),
        .Rd_in(U_IFIDReg_Instr_out[15:11]),
        .shamt_in(U_IFIDReg_Instr_out[10:6]),
        .RegDst_out(U_IDEXReg_RegDst_out),
        .ALUOp_out(U_IDEXReg_ALUOp_out),
        .ALUSrc_out(U_IDEXReg_ALUSrc_out),
        .Branch_out(U_IDEXReg_Branch_out),
        .MemRead_out(U_IDEXReg_MemRead_out),
        .MemWrite_out(U_IDEXReg_MemWrite_out),
        .RegWrite_out(U_IDEXReg_RegWrite_out),
        .Reg1_out(U_IDEXReg_Reg1_out),
        .Reg2_out(U_IDEXReg_Reg2_out),
        .Ext_out(U_IDEXReg_Ext_out),
        .Rs_out(U_IDEXReg_Rs_out),
        .Rt_out(U_IDEXReg_Rt_out),
        .Rd_out(U_IDEXReg_Rd_out),
        .shamt_out(U_IDEXReg_shamt_out)
    );

    ALU U_ALU(
        .DataIn1(U_IDEXReg_Reg1_out),
        .DataIn2(U_Ctrl_ALUSrc ? U_IDEXReg_Ext_out : U_IDEXReg_Reg2_out),
        .ALUOp(U_IDEXReg_ALUOp_out),
        .shamt(U_IDEXReg_shamt_out),
        .ALURes(U_EXMEMReg_ALU_in),
        .Zero(U_ALU_Zero)
    );

    EXMEMReg U_EXMEMReg (
        .clk(clk),
        .rst(rst),
        .Branch_in(U_IDEXReg_Branch_out),
        .MemRead_in(U_IDEXReg_MemRead_out),
        .MemWrite_in(U_IDEXReg_MemWrite_out),
        .Reg2_in(U_IDEXReg_Reg2_out),
        .RegWrite_in(U_IDEXReg_RegWrite_out),
        .Zero_in(U_ALU_Zero),
        .Rd_in(U_EXMEMReg_Rd_in),
        .Branch_out(U_EXMEMReg_Branch_out),
        .MemRead_out(U_EXMEMReg_MemRead_out),
        .MemWrite_out(U_EXMEMReg_MemWrite_out),
        .Reg2_out(U_EXMEMReg_Reg2_out),
        .RegWrite_out(U_EXMEMReg_RegWrite_out),
        .Zero_out(U_EXMEMReg_Zero_out),
        .ALU_in(U_EXMEMReg_ALU_in),
        .ALU_out(U_EXMEMReg_ALU_out),
        .Rd_out(U_EXMEMReg_Rd_out)
    );

    DataMemory U_DataMemory(
        .clk(clk),
        .data_out(U_DataMemory_DataOut),
        .data_in(U_EXMEMReg_Reg2_out),
        .write_enable(U_EXMEMReg_MemWrite_out),
        .address(U_EXMEMReg_ALU_out)
    );

    MEMWBReg U_MEMWBReg (
        .clk(clk),
        .rst(rst),
        .RegWrite_in(U_EXMEMReg_RegWrite_out),
        .MemRead_in(U_EXMEMReg_MemRead_out),
        .Mem_in(U_DataMemory_DataOut),
        .ALU_in(U_EXMEMReg_ALU_out),
        .Rd_in(U_EXMEMReg_Rd_out),
        .RegWrite_out(U_MEMWBReg_RegWrite_out),
        .MemRead_out(U_MEMWBReg_MemRead_out),
        .Mem_out(U_MEMWBReg_Mem_out),
        .ALU_out(U_MEMWBReg_ALU_out),
        .Rd_out(U_MEMWBReg_Rd_out)
    );

    Control U_Ctrl(
        .OpCode(U_IFIDReg_Instr_out[31:26]),
        .Funct(U_IFIDReg_Instr_out[5:0]),
        .RegDst(U_Ctrl_RegDst),
        .ALUOp(U_Ctrl_ALUOp),
        .ALUSrc(U_Ctrl_ALUSrc),
        .Branch(U_Ctrl_Branch),
        .MemRead(U_Ctrl_MemRead),
        .MemWrite(U_Ctrl_MemWrite),
        .RegWrite(U_Ctrl_RegWrite),
        .Jump(U_Ctrl_Jump),
        .nBranch(U_Ctrl_nBranch),
        .ExtOp(U_Ctrl_ExtOp)
    );

endmodule
