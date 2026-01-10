`timescale 1ns / 1ps

`include "signal_def.v"

module MIPS_R2000 (
    input clk,
    input rst,
    output uart_tx_out,
    output pwm_esc1_out,
    output sdclk,
    inout sdcmd,
    input sddat0
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
    wire [3:0] U_Ctrl_SpecialOP;
    wire U_Ctrl_nBranch;
    wire U_Ctrl_ExtOp;

    // U_MEMWBReg connections.
    wire [31:0] MEMWB_Instr;
    wire U_MEMWBReg_RegWrite_out;
    wire U_MEMWBReg_MemRead_out;
    wire [31:0] U_MEMWBReg_Mem_out;
    wire [31:0] U_MEMWBReg_ALU_out;
    wire [4:0] U_MEMWBReg_WriteBackRegAddr_out;

    // U_EXMEMReg connections.
    wire [31:0] EXMEM_Instr;
    wire U_EXMEMReg_Branch_out;
    wire U_EXMEMReg_Jump_out;
    wire [31:0] U_EXMEMReg_BranchAddress_out;
    wire U_EXMEMReg_MemRead_out;
    wire U_EXMEMReg_MemWrite_out;
    wire [31:0] U_EXMEMReg_Reg2_out;
    wire [3:0] U_EXMEMReg_SpecialOP_out;
    wire U_EXMEMReg_RegWrite_out;
    wire U_EXMEMReg_ShouldRegWrite_out;
    wire U_EXMEMReg_Zero_out;
    wire U_EXMEMReg_Sign_out;
    wire [31:0] U_EXMEMReg_ALU_in;
    wire [31:0] U_EXMEMReg_ALU_out;
    wire [4:0] U_EXMEMReg_WriteBackRegAddr_out;
    wire [4:0] U_EXMEMReg_WriteBackRegAddr_in;
    wire [31:0] U_EXMEMReg_NextPC_out;

    // U_IDEXReg connections.
    wire [31:0] IDEX_Instr;
    wire U_IDEXReg_RegDst_out;
    wire [4:0] U_IDEXReg_ALUOp_out;
    wire U_IDEXReg_ALUSrc_out;
    wire [3:0] U_IDEXReg_SpecialOP_out;
    wire U_IDEXReg_Branch_out;
    wire U_IDEXReg_Jump_out;
    wire [25:0] U_IDEXReg_JumpAddress_out;
    wire [31:0] U_IDEXReg_NextPC_out;
    wire U_IDEXReg_MemRead_out;
    wire U_IDEXReg_MemWrite_out;
    wire U_IDEXReg_RegWrite_out;
    wire [31:0] U_IDEXReg_Reg1_out;
    wire [31:0] U_IDEXReg_Reg2_out;
    wire [31:0] U_IDEXReg_ExtImm_out;
    wire [4:0] U_IDEXReg_Rs_out;
    wire [4:0] U_IDEXReg_Rt_out;
    wire [4:0] U_IDEXReg_Rd_out;
    wire [4:0] U_IDEXReg_shamt_out;
    wire U_EXMEM_IsAndLinkOp;

    // U_GPR connections.
    wire [31:0] U_MEMWBReg_WriteBackValue;
    wire [31:0] U_GPR_DataOut1;
    wire [31:0] U_GPR_DataOut2;

    // U_IFIDReg connections.
    wire [31:0] U_IFIDReg_NextPC_out;
    wire [31:0] IFID_Instr;

    // U_PCU connections.
    wire [31:0] U_PCU_PC;
    wire [31:0] U_PCU_NextPC;
    wire U_PCU_PCSrc;

    // U_InstructionMemory connections.
    wire [31:0] U_InstructionMemory_IR;

    // U_OpcodeImmExtender connections.
    wire [31:0] U_OpcodeImmExtender_Out;

    // U_ALU connections.
    wire U_ALU_Zero;
    wire U_ALU_Sign;

    // U_DataMemory connections.
    wire [31:0] U_DataMemory_DataOut;
    wire MemoryReady;

    // U_ForwardingUnit connections.
    wire [2:0] ALUDataIn1Mux;
    wire [2:0] ALUDataIn2Mux;
    wire [31:0] ALURegInput1;
    wire [31:0] ALURegInput2;

    // U_HazardUnit connections.
    wire HazardFlushRegs;

    // BranchAddress connections.
    wire [31:0] U_EXMEMReg_BranchAddress_in;
    wire U_EXMEMReg_ShouldJumpOrBranch;

    // Sign Extender connections.
    wire [15:0] ExtenderDataIn;
    
    // Sign Extender assigns.
    assign ExtenderDataIn = `IMMEDIATE(IFID_Instr);
    assign U_OpcodeImmExtender_Out = {U_Ctrl_ExtOp ? {16{ExtenderDataIn[15]}} : 16'b0, ExtenderDataIn[15:0]};

    // Connections assigns.
    assign U_EXMEMReg_WriteBackRegAddr_in = (U_IDEXReg_RegDst_out == `REG_DST_RD) ? U_IDEXReg_Rd_out : U_IDEXReg_Rt_out;
    assign U_MEMWBReg_WriteBackValue = U_MEMWBReg_MemRead_out ? U_MEMWBReg_Mem_out : U_MEMWBReg_ALU_out;

    // Branch and Jump assigns.
    assign U_PCU_PCSrc = U_EXMEMReg_Jump_out || (U_EXMEMReg_Branch_out && (
        (U_EXMEMReg_SpecialOP_out == `SpecialOP_BEQ    &&   U_EXMEMReg_Zero_out                          ) ||
        (U_EXMEMReg_SpecialOP_out == `SpecialOP_BNE    &&  !U_EXMEMReg_Zero_out                          ) ||
        (U_EXMEMReg_SpecialOP_out == `SpecialOP_BGTZ   && (!U_EXMEMReg_Zero_out && !U_EXMEMReg_Sign_out )) ||
        (U_EXMEMReg_SpecialOP_out == `SpecialOP_BLEZ   &&  (U_EXMEMReg_Zero_out ||  U_EXMEMReg_Sign_out )) ||
        (U_EXMEMReg_SpecialOP_out == `SpecialOP_BGEZAL &&  (U_EXMEMReg_Zero_out || !U_EXMEMReg_Sign_out ))
    ));
    assign U_EXMEMReg_ShouldJumpOrBranch = U_PCU_PCSrc;
    assign HazardFlushRegs = U_PCU_PCSrc;

    // In case the op is BGEZAL, we need to check if the branch is taken to write to the register.
    assign U_EXMEMReg_ShouldRegWrite_out = U_EXMEMReg_RegWrite_out && (
        U_EXMEMReg_SpecialOP_out == `SpecialOP_BGEZAL ? U_EXMEMReg_ShouldJumpOrBranch : 1'b1
    );

    assign U_EXMEMReg_BranchAddress_in = (U_IDEXReg_SpecialOP_out == `SpecialOP_JR ? U_EXMEMReg_ALU_in : 
        (U_IDEXReg_Branch_out ? (U_IDEXReg_NextPC_out + (U_IDEXReg_ExtImm_out << 2)) :
        // According to the DOC https://www.eecis.udel.edu/~davis/cpeg222/AssemblyTutorial/Chapter-17/ass17_5.html
        (U_IDEXReg_Jump_out ? {U_IDEXReg_NextPC_out[31:28], U_IDEXReg_JumpAddress_out, 2'b0} : 32'b0))
    );

    // In case the SpecialOP is JAL -> R[31] = $RA = $PC + 4 (Note that U_IFIDReg_NextPC_out = $PC + 4);
    assign U_EXMEM_IsAndLinkOp = U_EXMEMReg_ShouldJumpOrBranch &&
        (U_EXMEMReg_SpecialOP_out == `SpecialOP_JAL || U_EXMEMReg_SpecialOP_out == `SpecialOP_BGEZAL);

    // Assigns Forwaring Mux's
    assign ALURegInput1 = `ForwardingMux(
        ALUDataIn1Mux,              // Selector
        U_IDEXReg_Reg1_out,         // No forwarding
        U_EXMEMReg_ALU_out,         // Forward from EX/MEM
        U_MEMWBReg_WriteBackValue   // Forward from MEM/WB
    );
    assign ALURegInput2 = `ForwardingMux(
        ALUDataIn2Mux,              // Selector
        U_IDEXReg_Reg2_out,         // No forwarding
        U_EXMEMReg_ALU_out,         // Forward from EX/MEM
        U_MEMWBReg_WriteBackValue   // Forward from MEM/WB
    );

    PCU U_PCU(
        .clk(clk),
        .rst(rst),
        .en(MemoryReady),
        .PCSrc(U_PCU_PCSrc),
        .BranchAddress(U_EXMEMReg_BranchAddress_out),
        .PC(U_PCU_PC),
        .NextPC(U_PCU_NextPC)
    );

    IFIDReg U_IFIDReg(
        .clk(clk),
        .rst(rst),
        .HazardFlush(HazardFlushRegs),
        .NextPC_in(U_PCU_NextPC),
        .Instr_in(MemoryReady ? U_InstructionMemory_IR : 32'b0),
        .NextPC_out(U_IFIDReg_NextPC_out),
        .Instr_out(IFID_Instr)
    );

    GPR U_GPR(
        .clk(clk),
        .rst(rst),
        .WriteData(U_MEMWBReg_WriteBackValue),
        .RegWrite(U_MEMWBReg_RegWrite_out),
        .WriteRegister(U_MEMWBReg_WriteBackRegAddr_out),
        .ReadRegister1(`RS(IFID_Instr)),
        .ReadRegister2(`RT(IFID_Instr)),
        .DataOut1(U_GPR_DataOut1),
        .DataOut2(U_GPR_DataOut2)
    );

    IDEXReg U_IDEXReg(
        .clk(clk),
        .rst(rst),
        .HazardFlush(HazardFlushRegs),
        .Instr_in(IFID_Instr),
        .Instr_out(IDEX_Instr),
        .RegDst_in(U_Ctrl_RegDst),
        .RegDst_out(U_IDEXReg_RegDst_out),
        .ALUOp_in(U_Ctrl_ALUOp),
        .ALUOp_out(U_IDEXReg_ALUOp_out),
        .ALUSrc_in(U_Ctrl_ALUSrc),
        .ALUSrc_out(U_IDEXReg_ALUSrc_out),
        .SpecialOP_in(U_Ctrl_SpecialOP),
        .SpecialOP_out(U_IDEXReg_SpecialOP_out),
        .Branch_in(U_Ctrl_Branch),
        .Branch_out(U_IDEXReg_Branch_out),
        .Jump_in(U_Ctrl_Jump),
        .Jump_out(U_IDEXReg_Jump_out),
        .JumpAddress_in(`JUMP_ADDRESS(IFID_Instr)),
        .JumpAddress_out(U_IDEXReg_JumpAddress_out),
        .NextPC_in(U_IFIDReg_NextPC_out),
        .NextPC_out(U_IDEXReg_NextPC_out),
        .MemRead_in(U_Ctrl_MemRead),
        .MemRead_out(U_IDEXReg_MemRead_out),
        .MemWrite_in(U_Ctrl_MemWrite),
        .MemWrite_out(U_IDEXReg_MemWrite_out),
        .RegWrite_in(U_Ctrl_RegWrite),
        .RegWrite_out(U_IDEXReg_RegWrite_out),
        .Reg1_in(U_GPR_DataOut1),
        .Reg1_out(U_IDEXReg_Reg1_out),
        .Reg2_in(U_GPR_DataOut2),
        .Reg2_out(U_IDEXReg_Reg2_out),
        .ExtImm_in(U_OpcodeImmExtender_Out),
        .ExtImm_out(U_IDEXReg_ExtImm_out),
        .Rs_in(`RS(IFID_Instr)),
        .Rs_out(U_IDEXReg_Rs_out),
        .Rt_in(`RT(IFID_Instr)),
        .Rt_out(U_IDEXReg_Rt_out),
        .Rd_in(`RD(IFID_Instr)),
        .Rd_out(U_IDEXReg_Rd_out),
        .shamt_in(`SHAMT(IFID_Instr)),
        .shamt_out(U_IDEXReg_shamt_out)
    );

    ForwardingUnit U_ForwardingUnit(
        .ALUDataIn1RegAddr_in(U_IDEXReg_Rs_out),
        .ALUDataIn2RegAddr_in(U_IDEXReg_Rt_out),
        .EXMEM_WriteBackReg(U_EXMEMReg_ShouldRegWrite_out),
        .MEMWB_WriteBackReg(U_MEMWBReg_RegWrite_out),
        .EXMEM_WriteBackRegAddr(U_EXMEMReg_WriteBackRegAddr_out),
        .MEMWB_WriteBackRegAddr(U_MEMWBReg_WriteBackRegAddr_out),
        .ALUDataIn1Mux_out(ALUDataIn1Mux),
        .ALUDataIn2Mux_out(ALUDataIn2Mux)
    );

    ALU U_ALU(
        .clk(clk),
        .DataIn1(ALURegInput1),
        .DataIn2(U_IDEXReg_ALUSrc_out ? U_IDEXReg_ExtImm_out : ALURegInput2),
        .ALUOp(U_IDEXReg_ALUOp_out),
        .shamt(U_IDEXReg_shamt_out),
        .ALURes(U_EXMEMReg_ALU_in),
        .Zero(U_ALU_Zero),
        .Sign(U_ALU_Sign)
    );

    EXMEMReg U_EXMEMReg (
        .clk(clk),
        .rst(rst),
        .Instr_in(IDEX_Instr),
        .Instr_out(EXMEM_Instr),
        .HazardFlush(HazardFlushRegs),
        .Branch_in(U_IDEXReg_Branch_out),
        .Jump_in(U_IDEXReg_Jump_out),
        .BranchAddress_in(U_EXMEMReg_BranchAddress_in),
        .MemRead_in(U_IDEXReg_MemRead_out),
        .MemWrite_in(U_IDEXReg_MemWrite_out),
        .Reg2_in(ALURegInput2),
        .SpecialOP_in(U_IDEXReg_SpecialOP_out),
        .RegWrite_in(U_IDEXReg_RegWrite_out),
        .Zero_in(U_ALU_Zero),
        .Sign_in(U_ALU_Sign),
        .WriteBackRegAddr_in(U_EXMEMReg_WriteBackRegAddr_in),
        .NextPC_in(U_IDEXReg_NextPC_out),
        .Branch_out(U_EXMEMReg_Branch_out),
        .Jump_out(U_EXMEMReg_Jump_out),
        .BranchAddress_out(U_EXMEMReg_BranchAddress_out),
        .MemRead_out(U_EXMEMReg_MemRead_out),
        .MemWrite_out(U_EXMEMReg_MemWrite_out),
        .Reg2_out(U_EXMEMReg_Reg2_out),
        .SpecialOP_out(U_EXMEMReg_SpecialOP_out),
        .RegWrite_out(U_EXMEMReg_RegWrite_out),
        .Zero_out(U_EXMEMReg_Zero_out),
        .Sign_out(U_EXMEMReg_Sign_out),
        .ALU_in(U_EXMEMReg_ALU_in),
        .ALU_out(U_EXMEMReg_ALU_out),
        .WriteBackRegAddr_out(U_EXMEMReg_WriteBackRegAddr_out),
        .NextPC_out(U_EXMEMReg_NextPC_out)
    );

    DataMemoryInterface U_DataMemory(
        .clk(clk),
        .rst(rst),

        // Data memory interface
        .write_enable(U_EXMEMReg_MemWrite_out),
        .mode(U_EXMEMReg_SpecialOP_out == `SpecialOP_DM_BYTE ? `DataMemoryMode_BYTE : (
            U_EXMEMReg_SpecialOP_out == `SpecialOP_DM_HW ? `DataMemoryMode_HALFWORD :
            `DataMemoryMode_WORD
        )),
        .address(U_EXMEMReg_ALU_out),
        .data_in(U_EXMEMReg_Reg2_out),
        .data_out(U_DataMemory_DataOut),
        .ready(MemoryReady),
        
        .IMAdress(U_PCU_PC),
        .IR(U_InstructionMemory_IR),

        // UART interface
        .uart_tx_out(uart_tx_out),

        // ESC interface
        .pwm_esc1_out(pwm_esc1_out),

        // SD card interface
        .sdclk(sdclk),
        .sdcmd(sdcmd),
        .sddat0(sddat0)
    );

    MEMWBReg U_MEMWBReg (
        .clk(clk),
        .rst(rst),
        .Instr_in(EXMEM_Instr),
        .Instr_out(MEMWB_Instr),
        .RegWrite_in(U_EXMEMReg_ShouldRegWrite_out),
        .MemRead_in(U_EXMEMReg_MemRead_out),
        .Mem_in(U_DataMemory_DataOut),
        .ALU_in(U_EXMEM_IsAndLinkOp ? U_EXMEMReg_NextPC_out : U_EXMEMReg_ALU_out),
        .WriteBackRegAddr_in(U_EXMEM_IsAndLinkOp ? `REG_RA : U_EXMEMReg_WriteBackRegAddr_out),
        .RegWrite_out(U_MEMWBReg_RegWrite_out),
        .MemRead_out(U_MEMWBReg_MemRead_out),
        .Mem_out(U_MEMWBReg_Mem_out),
        .ALU_out(U_MEMWBReg_ALU_out),
        .WriteBackRegAddr_out(U_MEMWBReg_WriteBackRegAddr_out)
    );

    Control U_Ctrl(
        .clk(clk),
        .rst(rst),
        .OpCode(`OP(IFID_Instr)),
        .Funct(`FUNCT(IFID_Instr)),
        .RegDst(U_Ctrl_RegDst),
        .ALUOp(U_Ctrl_ALUOp),
        .ALUSrc(U_Ctrl_ALUSrc),
        .Branch(U_Ctrl_Branch),
        .MemRead(U_Ctrl_MemRead),
        .MemWrite(U_Ctrl_MemWrite),
        .RegWrite(U_Ctrl_RegWrite),
        .Jump(U_Ctrl_Jump),
        .SpecialOP(U_Ctrl_SpecialOP),
        .nBranch(U_Ctrl_nBranch),
        .ExtOp(U_Ctrl_ExtOp)
    );

endmodule
