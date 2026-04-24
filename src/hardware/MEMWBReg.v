`timescale 1ns / 1ps

module MEMWBReg (
    input clk,
    input rst,

    // Debugging instruction
    input  [31:0] Instr_in,
    output [31:0] Instr_out,

    // WB signal
    input RegWrite_in,
    input MemRead_in,
    // data (integer)
    input [31:0] Mem_in,
    input [31:0] ALU_in,
    input [4:0] WriteBackRegAddr_in,

    // FPU signals
    input FPUWrite_in,
    input [63:0] FPU_in,
    input IsDouble_in,
    input [4:0] FPRWriteAddr_in,
    input CC_in,
    input CCWrite_in,

    // WB signal
    output RegWrite_out,
    output MemRead_out,
    // data (integer)
    output [31:0] Mem_out,
    output [31:0] ALU_out,
    output [4:0] WriteBackRegAddr_out,

    // FPU signals
    output FPUWrite_out,
    output [63:0] FPU_out,
    output IsDouble_out,
    output [4:0] FPRWriteAddr_out,
    output CC_out,
    output CCWrite_out
);
    // 103 (original) + 1 (FPUWrite) + 64 (FPU) + 1 (IsDouble) + 5 (FPRWriteAddr) + 1 (CC) + 1 (CCWrite) = 176 bits
    reg [175:0] StageReg;

    assign {
        Instr_out[31:0],
        RegWrite_out,
        MemRead_out,
        Mem_out[31:0],
        ALU_out[31:0],
        WriteBackRegAddr_out[4:0],
        FPUWrite_out,
        FPU_out[63:0],
        IsDouble_out,
        FPRWriteAddr_out[4:0],
        CC_out,
        CCWrite_out
    } = StageReg;

    initial begin
        StageReg <= 176'b0;
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            StageReg <= 176'b0;
        else begin
            StageReg <= {
                Instr_in[31:0],
                RegWrite_in,
                MemRead_in,
                Mem_in[31:0],
                ALU_in[31:0],
                WriteBackRegAddr_in[4:0],
                FPUWrite_in,
                FPU_in[63:0],
                IsDouble_in,
                FPRWriteAddr_in[4:0],
                CC_in,
                CCWrite_in
            };
        end
    end

endmodule
