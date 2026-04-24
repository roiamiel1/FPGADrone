import csv

instructions_parts = ("OpCode", "FMT", "FT", "Funct")
instructions_parts_bytes = (6, 5, 5, 6)

DATA_BLOCK = ""

with open('scripts/mips32_r2000_instruction_set.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.reader(csvfile)
    data_iter = iter(list(reader))

row_reader = next(data_iter) # Skip header row.
while True:
    line = next(data_iter, None)
    if line is None:
        break

    next_row = list(map(lambda x: x.strip() if x.strip() != "x" else None, line))

    cmd = next_row[0]

    if not cmd or cmd.startswith('//'):
        continue

    opcode, fmt, ft, funct = (int(str(x), 16) if x else x for x in next_row[1:5])
    inst_type, jump, read_reg1, read_reg2, reg_dst, branch, mem_read, mem_write, reg_write, alu_src, ext_op, alu_op, special_op = next_row[5:18]
    fpu_op  = next_row[18] if len(next_row) > 18 else None
    fpu_write = next_row[19] if len(next_row) > 19 else None

    pairs = zip((opcode, fmt, ft, funct), instructions_parts, instructions_parts_bytes)
    logic_statments = ["{} == {}'h{}".format(key, nbyte, hex(value)[2:]) for (value, key, nbyte) in pairs if value is not None]
    logic_statment = " && ".join(logic_statments)
    DATA_BLOCK += f"""if ({logic_statment}) begin
            // {cmd} case:
            InstType  <= {inst_type or  "2'b00"};
            Jump      <= {jump       or "1'b0"};
            ReadReg1  <= {read_reg1  or "2'b00"};
            ReadReg2  <= {read_reg2  or "2'b00"};
            RegDst    <= {reg_dst    or "2'b00"};
            Branch    <= {branch     or "1'b0"};
            MemRead   <= {mem_read   or "1'b0"};
            MemWrite  <= {mem_write  or "1'b0"};
            RegWrite  <= {reg_write  or "1'b0"};
            ALUSrc    <= {alu_src    or "1'b0"};
            ExtOp     <= {ext_op     or "1'b0"};
            ALUOp     <= {alu_op     or "5'b0"};
            SpecialOP <= {special_op or "4'b0"};
            FPUOp     <= {fpu_op     or "6'b0"};
            FPUWrite  <= {fpu_write  or "1'b0"};
        end else """

template = f"""// AUTO-GENERATED - DO NOT CHNAGE!
`timescale 1ns / 1ps

`include "signal_def.v"

module Control(
    input wire clk,
    input wire rst,
    input wire [5:0] OpCode,
    input wire [4:0] FMT,
    input wire [4:0] FT,
    input wire [5:0] Funct,
    output reg [1:0] InstType,
    output reg Jump,
    output reg [1:0] ReadReg1,
    output reg [1:0] ReadReg2,
    output reg [1:0] RegDst,
    output reg Branch,
    output reg MemRead,
    output reg MemWrite,
    output reg RegWrite,
    output reg ALUSrc,
    output reg ExtOp,
    output reg [4:0] ALUOp,
    output reg [3:0] SpecialOP,
    output reg [5:0] FPUOp,
    output reg FPUWrite,
    output wire nBranch
);
    assign nBranch = ~Branch;

    initial begin
        InstType  <= 2'b00;
        Jump      <= 1'b0;
        ReadReg1  <= 2'b00;
        ReadReg2  <= 2'b00;
        RegDst    <= 2'b00;
        Branch    <= 1'b0;
        MemRead   <= 1'b0;
        MemWrite  <= 1'b0;
        RegWrite  <= 1'b0;
        ALUSrc    <= 1'b0;
        ExtOp     <= 1'b0;
        ALUOp     <= 5'b0;
        SpecialOP <= 4'b0;
        FPUOp     <= 6'b0;
        FPUWrite  <= 1'b0;
    end

    always @(negedge clk, posedge rst) begin
        if (rst) begin
            InstType  <= 2'b00;
            Jump      <= 1'b0;
            ReadReg1  <= 2'b00;
            ReadReg2 <= 2'b00;
            RegDst    <= 2'b00;
            Branch    <= 1'b0;
            MemRead   <= 1'b0;
            MemWrite  <= 1'b0;
            RegWrite  <= 1'b0;
            ALUSrc    <= 1'b0;
            ExtOp     <= 1'b0;
            ALUOp     <= 5'b0;
            SpecialOP <= 4'b0;
            FPUOp     <= 6'b0;
            FPUWrite  <= 1'b0;
        end else {DATA_BLOCK} begin
            // default case:
            InstType  <= 2'b00;
            Jump      <= 1'b0;
            ReadReg1  <= 2'b00;
            ReadReg2  <= 2'b00;
            RegDst    <= 2'b00;
            Branch    <= 1'b0;
            MemRead   <= 1'b0;
            MemWrite  <= 1'b0;
            RegWrite  <= 1'b0;
            ALUSrc    <= 1'b0;
            ExtOp     <= 1'b0;
            ALUOp     <= 5'b0;
            SpecialOP <= 4'b0;
            FPUOp     <= 6'b0;
            FPUWrite  <= 1'b0;
            `ifdef DEBUG
            if (OpCode !== 6'bx && Funct !== 6'bx) begin
                $display("\\n*************** Warning ***************");
                $display(   "  Unsupported instruction encountered  ");
                $display("Time: %t", $time);
                $display("OpCode: 0x%h", OpCode);
                $display("Funct: 0x%h", Funct);
                $display("Inst: 0x%h", TESTBENCH.U_MIPS_R2000.IFID_Instr);
                $display("PCU: 0x%h", TESTBENCH.U_MIPS_R2000.U_PCU_PC);
                $display("***************************************\\n");
            end
            `endif
        end
    end
endmodule
"""

with open("./src/hardware/Control.v", "w") as f:
    f.write(template)
