`include "signal_def.v"
`include "instruction_def.v"

`define CLOCK_RATE      100000 // board internal clock (def == 100KHz)
`define UART_BAUD_RATE  9600

module MIPS_R2000 (
    input clk,
    input rst,
    output uart_tx_out
);
    parameter UART_MAX_RATE_TX = `CLOCK_RATE / (2 * `UART_BAUD_RATE);
    parameter UART_TX_CNT_WIDTH = $clog2(UART_MAX_RATE_TX);

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
    wire U_MEMWBReg_RegWrite_out;
    wire U_MEMWBReg_MemRead_out;
    wire [31:0] U_MEMWBReg_Mem_out;
    wire [31:0] U_MEMWBReg_ALU_out;
    wire [4:0] U_MEMWBReg_WriteBackRegAddr_out;

    // U_EXMEMReg connections.
    wire U_EXMEMReg_Branch_out;
    wire U_EXMEMReg_Jump_out;
    wire [31:0] U_EXMEMReg_BranchAddress_out;
    wire U_EXMEMReg_MemRead_out;
    wire U_EXMEMReg_MemWrite_out;
    wire [31:0] U_EXMEMReg_Reg2_out;
    wire [3:0] U_EXMEMReg_SpecialOP_out;
    wire U_EXMEMReg_RegWrite_out;
    wire U_EXMEMReg_Zero_out;
    wire [31:0] U_EXMEMReg_ALU_in;
    wire [31:0] U_EXMEMReg_ALU_out;
    wire [4:0] U_EXMEMReg_WriteBackRegAddr_out;
    wire [4:0] U_EXMEMReg_WriteBackRegAddr_in;

    // U_IDEXReg connections.
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
    wire [31:0] U_IDEXReg_Reg1_in;
    wire [4:0] U_IDEXReg_Rd_in;

    // U_GPR connections.
    wire [31:0] U_MEMWBReg_WriteBackValue;
    wire [31:0] U_GPR_DataOut1;
    wire [31:0] U_GPR_DataOut2;

    // U_IFIDReg connections.
    wire [31:0] U_IFIDReg_PC_out;
    wire [31:0] U_IFIDReg_Instr_out;

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

    // U_DataMemory connections.
    wire [31:0] U_DataMemory_DataOut;

    // U_ForwardingUnit connections.
    wire [2:0] ALUDataIn1Mux;
    wire [2:0] ALUDataIn2Mux;
    wire [31:0] ALURegInput1;
    wire [31:0] ALURegInput2;

    // U_HazardUnit connections.
    wire HazardFlushRegs;

    // BranchAddress connections.
    wire [31:0] BranchAddress;

    // Sign Extender connections.
    wire [15:0] ExtenderDataIn;

    // Uart connections.
    reg uartTxClk;
    reg [UART_TX_CNT_WIDTH - 1:0] uartTxCounter = 0;

    initial begin
        uartTxClk = 1'b0;
    end

    // Sign Extender assigns.
    assign ExtenderDataIn = `IMMEDIATE(U_IFIDReg_Instr_out);
    assign U_OpcodeImmExtender_Out = {U_Ctrl_ExtOp ? {16{ExtenderDataIn[15]}} : 16'b0, ExtenderDataIn[15:0]};

    // Connections assigns.
    assign U_EXMEMReg_WriteBackRegAddr_in = (U_IDEXReg_RegDst_out == `REG_DST_RD) ? U_IDEXReg_Rd_out : U_IDEXReg_Rt_out;
    assign U_MEMWBReg_WriteBackValue = U_MEMWBReg_MemRead_out ? U_MEMWBReg_Mem_out : U_MEMWBReg_ALU_out;

    // Branch and Jump assigns.
    assign U_PCU_PCSrc = (U_EXMEMReg_Branch_out && U_EXMEMReg_Zero_out) || U_EXMEMReg_Jump_out;
    assign HazardFlushRegs = U_PCU_PCSrc == 1'b1; // U_PCU_PCSrc == 1'b1 -> Jump or Branch.

    assign BranchAddress = (U_IDEXReg_SpecialOP_out == `SpecialOP_JR ? U_EXMEMReg_ALU_in : 
        (U_IDEXReg_Branch_out ? (U_IDEXReg_NextPC_out + (U_IDEXReg_ExtImm_out << 2)) :
        // According to the DOC https://www.eecis.udel.edu/~davis/cpeg222/AssemblyTutorial/Chapter-17/ass17_5.html
        (U_IDEXReg_Jump_out ? {U_IDEXReg_NextPC_out[31:28], U_IDEXReg_JumpAddress_out, 2'b0} : 32'b0))
    );

    // IDEXReg assigns.
    // In case the SpecialOP is JAL -> R[31] = $RA = PC + 8;
    assign U_IDEXReg_Reg1_in = ((U_Ctrl_SpecialOP == `SpecialOP_JAL) ? (U_IFIDReg_PC_out + 8) : U_GPR_DataOut1);
    assign U_IDEXReg_Rd_in = ((U_Ctrl_SpecialOP == `SpecialOP_JAL) ? 31 : (`RD(U_IFIDReg_Instr_out)));

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
    
    // Modules section.
    PCU U_PCU(
        .clk(clk),
        .rst(rst),
        .PCSrc(U_PCU_PCSrc),
        .BranchAddress(U_EXMEMReg_BranchAddress_out),
        .PC(U_PCU_PC),
        .NextPC(U_PCU_NextPC)
    );

    // TODO: read from data memory.
    InstructionMemory U_InstructionMemory(
        .clk(clk),
        // The `>> 2` is a hack cause InstructionMemory works with regualr indexes, 
        // i.e. 0, 1, 2, 3, etc... and not 4 multiplies.
        // In the future we will read the instructions from the data memory, till then let's keep it that way.
        .IMAdress(U_PCU_PC >> 2),
        .IR(U_InstructionMemory_IR)
    );

    IFIDReg U_IFIDReg(
        .clk(clk),
        .rst(rst),
        .HazardFlush(HazardFlushRegs),
        .PC_in(U_PCU_NextPC),
        .Instr_in(U_InstructionMemory_IR),
        .PC_out(U_IFIDReg_PC_out),
        .Instr_out(U_IFIDReg_Instr_out)
    );

    GPR U_GPR(
        .clk(clk),
        .rst(rst),
        .WriteData(U_MEMWBReg_WriteBackValue),
        .RegWrite(U_MEMWBReg_RegWrite_out),
        .WriteRegister(U_MEMWBReg_WriteBackRegAddr_out),
        .ReadRegister1(`RS(U_IFIDReg_Instr_out)),
        .ReadRegister2(`RT(U_IFIDReg_Instr_out)),
        .DataOut1(U_GPR_DataOut1),
        .DataOut2(U_GPR_DataOut2)
    );

    IDEXReg U_IDEXReg(
        .clk(clk),
        .rst(rst),
        .HazardFlush(HazardFlushRegs),
        .RegDst_in(U_Ctrl_RegDst),
        .ALUOp_in(U_Ctrl_ALUOp),
        .ALUSrc_in(U_Ctrl_ALUSrc),
        .SpecialOP_in(U_Ctrl_SpecialOP),
        .Branch_in(U_Ctrl_Branch),
        .Jump_in(U_Ctrl_Jump),
        .JumpAddress_in(`JUMP_ADDRESS(U_IFIDReg_Instr_out)),
        .NextPC_in(U_IFIDReg_PC_out),
        .MemRead_in(U_Ctrl_MemRead),
        .MemWrite_in(U_Ctrl_MemWrite),
        .RegWrite_in(U_Ctrl_RegWrite),
        .Reg1_in(U_IDEXReg_Reg1_in),
        .Reg2_in(U_GPR_DataOut2),
        .ExtImm_in(U_OpcodeImmExtender_Out),
        .Rs_in(`RS(U_IFIDReg_Instr_out)),
        .Rt_in(`RT(U_IFIDReg_Instr_out)),
        .Rd_in(U_IDEXReg_Rd_in),
        .shamt_in(`SHAMT(U_IFIDReg_Instr_out)),
        .RegDst_out(U_IDEXReg_RegDst_out),
        .ALUOp_out(U_IDEXReg_ALUOp_out),
        .ALUSrc_out(U_IDEXReg_ALUSrc_out),
        .SpecialOP_out(U_IDEXReg_SpecialOP_out),
        .Branch_out(U_IDEXReg_Branch_out),
        .Jump_out(U_IDEXReg_Jump_out),
        .JumpAddress_out(U_IDEXReg_JumpAddress_out),
        .NextPC_out(U_IDEXReg_NextPC_out),
        .MemRead_out(U_IDEXReg_MemRead_out),
        .MemWrite_out(U_IDEXReg_MemWrite_out),
        .RegWrite_out(U_IDEXReg_RegWrite_out),
        .Reg1_out(U_IDEXReg_Reg1_out),
        .Reg2_out(U_IDEXReg_Reg2_out),
        .ExtImm_out(U_IDEXReg_ExtImm_out),
        .Rs_out(U_IDEXReg_Rs_out),
        .Rt_out(U_IDEXReg_Rt_out),
        .Rd_out(U_IDEXReg_Rd_out),
        .shamt_out(U_IDEXReg_shamt_out)
    );

    ForwardingUnit U_ForwardingUnit(
        .ALUDataIn1RegAddr_in(U_IDEXReg_Rs_out),
        .ALUDataIn2RegAddr_in(U_IDEXReg_Rt_out),
        .EXMEM_WriteBackReg(U_EXMEMReg_RegWrite_out),
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
        .Zero(U_ALU_Zero)
    );

    EXMEMReg U_EXMEMReg (
        .clk(clk),
        .rst(rst),
        .HazardFlush(HazardFlushRegs),
        .Branch_in(U_IDEXReg_Branch_out),
        .Jump_in(U_IDEXReg_Jump_out),
        .BranchAddress_in(BranchAddress),
        .MemRead_in(U_IDEXReg_MemRead_out),
        .MemWrite_in(U_IDEXReg_MemWrite_out),
        .Reg2_in(ALURegInput2),
        .SpecialOP_in(U_IDEXReg_SpecialOP_out),
        .RegWrite_in(U_IDEXReg_RegWrite_out),
        .Zero_in(U_ALU_Zero),
        .WriteBackRegAddr_in(U_EXMEMReg_WriteBackRegAddr_in),
        .Branch_out(U_EXMEMReg_Branch_out),
        .Jump_out(U_EXMEMReg_Jump_out),
        .BranchAddress_out(U_EXMEMReg_BranchAddress_out),
        .MemRead_out(U_EXMEMReg_MemRead_out),
        .MemWrite_out(U_EXMEMReg_MemWrite_out),
        .Reg2_out(U_EXMEMReg_Reg2_out),
        .SpecialOP_out(U_EXMEMReg_SpecialOP_out),
        .RegWrite_out(U_EXMEMReg_RegWrite_out),
        .Zero_out(U_EXMEMReg_Zero_out),
        .ALU_in(U_EXMEMReg_ALU_in),
        .ALU_out(U_EXMEMReg_ALU_out),
        .WriteBackRegAddr_out(U_EXMEMReg_WriteBackRegAddr_out)
    );

    DataMemory U_DataMemory(
        .clk(clk),
        .uartClk(uartTxClk),
        .data_out(U_DataMemory_DataOut),
        .data_in(U_EXMEMReg_Reg2_out),
        .write_enable(U_EXMEMReg_MemWrite_out),
        .address(U_EXMEMReg_ALU_out),
        .mode(U_EXMEMReg_SpecialOP_out == `SpecialOP_DM_BYTE ? `DataMemoryMode_BYTE : (
            U_EXMEMReg_SpecialOP_out == `SpecialOP_DM_HW ? `DataMemoryMode_HALFWORD :
            `DataMemoryMode_WORD
        )),
        .uart_tx_out(uart_tx_out)
    );

    MEMWBReg U_MEMWBReg (
        .clk(clk),
        .rst(rst),
        .RegWrite_in(U_EXMEMReg_RegWrite_out),
        .MemRead_in(U_EXMEMReg_MemRead_out),
        .Mem_in(U_DataMemory_DataOut),
        .ALU_in(U_EXMEMReg_ALU_out),
        .WriteBackRegAddr_in(U_EXMEMReg_WriteBackRegAddr_out),
        .RegWrite_out(U_MEMWBReg_RegWrite_out),
        .MemRead_out(U_MEMWBReg_MemRead_out),
        .Mem_out(U_MEMWBReg_Mem_out),
        .ALU_out(U_MEMWBReg_ALU_out),
        .WriteBackRegAddr_out(U_MEMWBReg_WriteBackRegAddr_out)
    );

    Control U_Ctrl(
        .clk(clk),
        .OpCode(`OP(U_IFIDReg_Instr_out)),
        .Funct(`FUNCT(U_IFIDReg_Instr_out)),
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

    always @(posedge clk) begin
        if (uartTxCounter == UART_MAX_RATE_TX) begin
            uartTxCounter <= 0;
            uartTxClk <= ~uartTxClk;
        end else begin
            uartTxCounter <= uartTxCounter + 1'b1;
        end
    end

endmodule
