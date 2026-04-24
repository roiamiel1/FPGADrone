`timescale 1ns / 1ps

`include "signal_def.v"

// Floating-Point Unit.
// Single-precision: uses manual IEEE 754 f32<->f64 bit conversion so that
// only $bitstoreal/$realtobits (supported by Icarus Verilog 12) are needed.
// Synthesis targeting FPGA requires replacing the real-type operations with
// IEEE 754 IP cores (e.g., Gowin FP IP or a hand-rolled implementation).
//
// DataIn1/DataIn2 carry 64-bit values from FPR:
//   single ops use [31:0]; double ops use the full 64 bits.
// IntDataIn carries a 32-bit integer from GPR (used by mtc1 and cvt.x.w).
// FPURes[63:0]: lower 32 bits = single result; full 64 = double result.
// IsDouble: 1 when result occupies both the even and odd FPR pair.
// CCWrite/CCOut: written to FPR.ccFlag for compare instructions.
module FPU (
    input  wire        clk,
    input  wire        rst,
    input  wire [63:0] DataIn1,     // FPR[fs] (64-bit for double)
    input  wire [63:0] DataIn2,     // FPR[ft]
    input  wire [31:0] IntDataIn,   // GPR source (for mtc1, cvt.x.w)
    input  wire [5:0]  FPUOp,
    output reg  [63:0] FPURes,
    output reg         IsDouble,    // result is a 64-bit double pair
    output reg         CCOut,
    output reg         CCWrite
);
    // ----------------------------------------------------------------
    // IEEE 754 single (32-bit) <-> double (64-bit) bit conversion.
    // Handles: normal, zero, inf, nan.  Subnormals flush to zero.
    // ----------------------------------------------------------------
    function [63:0] f32_to_f64;
        input [31:0] f;
        reg        s;
        reg [7:0]  e8;
        reg [22:0] m;
        reg [10:0] e11;
        begin
            s  = f[31];
            e8 = f[30:23];
            m  = f[22:0];
            if (e8 == 8'hFF)
                e11 = 11'h7FF;                   // inf / nan
            else if (e8 == 8'h00)
                e11 = 11'h000;                   // zero / subnormal -> zero
            else
                e11 = {3'b000, e8} - 11'd127 + 11'd1023;
            f32_to_f64 = {s, e11, m, 29'b0};
        end
    endfunction

    function [31:0] f64_to_f32;
        input [63:0] f;
        reg        s;
        reg [10:0] e11, e_adj;
        reg [51:0] m52;
        reg [7:0]  e8;
        begin
            s   = f[63];
            e11 = f[62:52];
            m52 = f[51:0];
            if (e11 == 11'h7FF)
                e8 = 8'hFF;                      // inf / nan
            else if (e11 == 11'h000)
                e8 = 8'h00;                      // zero
            else begin
                e_adj = e11 - 11'd1023 + 11'd127;
                e8    = e_adj[7:0];
            end
            f64_to_f32 = {s, e8, m52[51:29]};
        end
    endfunction

    initial begin
        FPURes   = 64'b0;
        IsDouble = 1'b0;
        CCOut    = 1'b0;
        CCWrite  = 1'b0;
    end

    always @(negedge clk, posedge rst) begin
        if (rst) begin
            FPURes   <= 64'b0;
            IsDouble <= 1'b0;
            CCOut    <= 1'b0;
            CCWrite  <= 1'b0;
        end else begin
            CCWrite  <= 1'b0;
            IsDouble <= 1'b0;

            case (FPUOp)
                // ---- Single precision arithmetic ----
                `FPUOp_ADD_S: begin
                    FPURes[31:0] <= f64_to_f32($realtobits(
                        $bitstoreal(f32_to_f64(DataIn1[31:0])) +
                        $bitstoreal(f32_to_f64(DataIn2[31:0]))));
                end
                `FPUOp_SUB_S: begin
                    FPURes[31:0] <= f64_to_f32($realtobits(
                        $bitstoreal(f32_to_f64(DataIn1[31:0])) -
                        $bitstoreal(f32_to_f64(DataIn2[31:0]))));
                end
                `FPUOp_MUL_S: begin
                    FPURes[31:0] <= f64_to_f32($realtobits(
                        $bitstoreal(f32_to_f64(DataIn1[31:0])) *
                        $bitstoreal(f32_to_f64(DataIn2[31:0]))));
                end
                `FPUOp_DIV_S: begin
                    FPURes[31:0] <= f64_to_f32($realtobits(
                        $bitstoreal(f32_to_f64(DataIn1[31:0])) /
                        $bitstoreal(f32_to_f64(DataIn2[31:0]))));
                end
                `FPUOp_ABS_S: begin
                    FPURes[31:0] <= {1'b0, DataIn1[30:0]};
                end
                `FPUOp_NEG_S: begin
                    FPURes[31:0] <= {~DataIn1[31], DataIn1[30:0]};
                end
                `FPUOp_MOV_S: begin
                    FPURes[31:0] <= DataIn1[31:0];
                end

                // ---- Single precision converts ----
                `FPUOp_CVT_D_S: begin
                    // single -> double: direct bit-field expansion
                    FPURes   <= f32_to_f64(DataIn1[31:0]);
                    IsDouble <= 1'b1;
                end
                `FPUOp_CVT_W_S: begin
                    // single -> int (truncate toward zero)
                    FPURes[31:0] <= $rtoi($bitstoreal(f32_to_f64(DataIn1[31:0])));
                end

                // ---- Single precision compares (set CC flag) ----
                `FPUOp_C_EQ_S: begin
                    CCOut   <= ($bitstoreal(f32_to_f64(DataIn1[31:0])) ==
                                $bitstoreal(f32_to_f64(DataIn2[31:0])));
                    CCWrite <= 1'b1;
                end
                `FPUOp_C_LT_S: begin
                    CCOut   <= ($bitstoreal(f32_to_f64(DataIn1[31:0])) <
                                $bitstoreal(f32_to_f64(DataIn2[31:0])));
                    CCWrite <= 1'b1;
                end
                `FPUOp_C_LE_S: begin
                    CCOut   <= ($bitstoreal(f32_to_f64(DataIn1[31:0])) <=
                                $bitstoreal(f32_to_f64(DataIn2[31:0])));
                    CCWrite <= 1'b1;
                end

                // ---- Double precision arithmetic ----
                `FPUOp_ADD_D: begin
                    FPURes   <= $realtobits($bitstoreal(DataIn1) + $bitstoreal(DataIn2));
                    IsDouble <= 1'b1;
                end
                `FPUOp_SUB_D: begin
                    FPURes   <= $realtobits($bitstoreal(DataIn1) - $bitstoreal(DataIn2));
                    IsDouble <= 1'b1;
                end
                `FPUOp_MUL_D: begin
                    FPURes   <= $realtobits($bitstoreal(DataIn1) * $bitstoreal(DataIn2));
                    IsDouble <= 1'b1;
                end
                `FPUOp_DIV_D: begin
                    FPURes   <= $realtobits($bitstoreal(DataIn1) / $bitstoreal(DataIn2));
                    IsDouble <= 1'b1;
                end
                `FPUOp_ABS_D: begin
                    FPURes   <= {1'b0, DataIn1[62:0]};
                    IsDouble <= 1'b1;
                end
                `FPUOp_NEG_D: begin
                    FPURes   <= {~DataIn1[63], DataIn1[62:0]};
                    IsDouble <= 1'b1;
                end
                `FPUOp_MOV_D: begin
                    FPURes   <= DataIn1;
                    IsDouble <= 1'b1;
                end

                // ---- Double precision converts ----
                `FPUOp_CVT_S_D: begin
                    // double -> single: direct bit-field compression
                    FPURes[31:0] <= f64_to_f32(DataIn1);
                end
                `FPUOp_CVT_W_D: begin
                    // double -> int
                    FPURes[31:0] <= $rtoi($bitstoreal(DataIn1));
                end

                // ---- Double precision compares ----
                `FPUOp_C_EQ_D: begin
                    CCOut   <= ($bitstoreal(DataIn1) == $bitstoreal(DataIn2));
                    CCWrite <= 1'b1;
                end
                `FPUOp_C_LT_D: begin
                    CCOut   <= ($bitstoreal(DataIn1) < $bitstoreal(DataIn2));
                    CCWrite <= 1'b1;
                end
                `FPUOp_C_LE_D: begin
                    CCOut   <= ($bitstoreal(DataIn1) <= $bitstoreal(DataIn2));
                    CCWrite <= 1'b1;
                end

                // ---- Integer <-> FP converts (source is DataIn1 from FPR) ----
                `FPUOp_CVT_S_W: begin
                    // int word in FPR[fs] -> single
                    FPURes[31:0] <= f64_to_f32($realtobits($itor($signed(DataIn1[31:0]))));
                end
                `FPUOp_CVT_D_W: begin
                    // int word in FPR[fs] -> double
                    FPURes   <= $realtobits($itor($signed(DataIn1[31:0])));
                    IsDouble <= 1'b1;
                end

                // ---- Register moves ----
                `FPUOp_MFC1: begin
                    // FPR[fs] -> GPR: output fs value, pipeline routes it to GPR
                    FPURes[31:0] <= DataIn1[31:0];
                end
                `FPUOp_MTC1: begin
                    // GPR[rt] -> FPR[fs]: IntDataIn holds GPR value
                    FPURes[31:0] <= IntDataIn;
                end

                // ---- Branches (no computation, pipeline reads CC from FPR directly) ----
                `FPUOp_BC1T: ; // handled by branch logic in MIPS_R2000
                `FPUOp_BC1F: ; // handled by branch logic in MIPS_R2000

                // ---- Loads/stores: FPU is idle; data path handled by memory interface ----
                `FPUOp_LWC1: ;
                `FPUOp_SWC1: ;

                default: begin
                    FPURes   <= 64'b0;
                    IsDouble <= 1'b0;
                end
            endcase
        end
    end

endmodule
