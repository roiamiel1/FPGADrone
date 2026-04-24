`timescale 1ns / 1ps

`include "signal_def.v"

// Floating-Point Register File: 32 x 32-bit registers ($f0-$f31).
// Double-precision values occupy consecutive even/odd pairs:
//   even reg = bits[31:0], odd reg = bits[63:32].
// CC flag is set by FP compare instructions and read by bc1t/bc1f.
module FPR (
    input  wire        clk,
    input  wire        rst,
    // Read ports (async, addressed via instruction fields)
    input  wire [4:0]  ReadRegister1,   // fs = instr[15:11]
    input  wire [4:0]  ReadRegister2,   // ft = instr[20:16]
    output wire [63:0] DataOut1,        // {FPR[fs|1], FPR[fs&~1]}
    output wire [63:0] DataOut2,        // {FPR[ft|1], FPR[ft&~1]}
    // Write port (sync, negedge)
    input  wire        RegWrite,
    input  wire [4:0]  WriteRegister,
    input  wire [63:0] WriteData,
    input  wire        WriteDouble,     // 1 = write 64-bit pair (fd and fd+1)
    // Condition-code flag (for c.xx instructions / bc1t / bc1f)
    input  wire        CCWrite,
    input  wire        CCIn,
    output wire        CC
);
    integer i;
    reg [31:0] fprRegisters [0:31];
    reg        ccFlag;

    // Even register = lower 32 bits of double; odd = upper 32 bits.
    wire [4:0] reg1_lo = {ReadRegister1[4:1], 1'b0};
    wire [4:0] reg1_hi = {ReadRegister1[4:1], 1'b1};
    wire [4:0] reg2_lo = {ReadRegister2[4:1], 1'b0};
    wire [4:0] reg2_hi = {ReadRegister2[4:1], 1'b1};

    assign DataOut1 = {fprRegisters[reg1_hi], fprRegisters[reg1_lo]};
    assign DataOut2 = {fprRegisters[reg2_hi], fprRegisters[reg2_lo]};
    assign CC       = ccFlag;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            fprRegisters[i] = 32'b0;
        ccFlag = 1'b0;
    end

    always @(negedge clk, posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                fprRegisters[i] <= 32'b0;
            ccFlag <= 1'b0;
        end else begin
            if (RegWrite) begin
                fprRegisters[WriteRegister]         <= WriteData[31:0];
                if (WriteDouble)
                    fprRegisters[WriteRegister | 5'd1] <= WriteData[63:32];
            end
            if (CCWrite)
                ccFlag <= CCIn;
        end
    end

endmodule
