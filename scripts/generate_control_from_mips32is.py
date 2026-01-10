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
    
    if not cmd:
        continue
    
    opcode, fmt, ft, funct = (int(str(x), 16) if x else x for x in next_row[1:5])
    jump, reg_dst, branch, mem_read, mem_write, reg_write, alu_src, ext_op, alu_op, special_op = next_row[5:15]

    pairs = zip((opcode, fmt, ft, funct), instructions_parts, instructions_parts_bytes)
    logic_statments = ["{} == {}'h{}".format(key, nbyte, hex(value)[2:]) for (value, key, nbyte) in pairs if value is not None]
    logic_statment = " && ".join(logic_statments)
    DATA_BLOCK += f"""if ({logic_statment}) begin
            // {cmd} case:
            Jump      <= {jump       or "1'b0"};
            RegDst    <= {reg_dst    or "1'b0"};
            Branch    <= {branch     or "1'b0"};
            MemRead   <= {mem_read   or "1'b0"};
            MemWrite  <= {mem_write  or "1'b0"};
            RegWrite  <= {reg_write  or "1'b0"};
            ALUSrc    <= {alu_src    or "1'b0"};
            ExtOp     <= {ext_op     or "1'b0"};
            ALUOp     <= {alu_op     or "5'b0"};
            SpecialOP <= {special_op or "4'b0"};
        end else """

template = f"""// AUTO-GENERATED - DO NOT CHNAGE!
`timescale 1ns / 1ps

`include "signal_def.v"

module Control(
    input wire clk,
    input wire rst,
    input wire [5:0] OpCode,
    input wire [5:0] Funct,
    output reg Jump,
    output reg RegDst,
    output reg Branch,
    output reg MemRead,
    output reg MemWrite,
    output reg RegWrite,
    output reg ALUSrc,
    output reg ExtOp,
    output reg [4:0] ALUOp,
    output reg [3:0] SpecialOP,
    output wire nBranch
);
    assign nBranch = ~Branch;

    initial begin
        Jump      <= 1'b0;
        RegDst    <= 1'b0;
        Branch    <= 1'b0;
        MemRead   <= 1'b0;
        MemWrite  <= 1'b0;
        RegWrite  <= 1'b0;
        ALUSrc    <= 1'b0;
        ExtOp     <= 1'b0;
        ALUOp     <= 5'b0;
        SpecialOP <= 4'b0;
    end

    always @(negedge clk, posedge rst) begin
        if (rst) begin
            Jump      <= 1'b0;
            RegDst    <= 1'b0;
            Branch    <= 1'b0;
            MemRead   <= 1'b0;
            MemWrite  <= 1'b0;
            RegWrite  <= 1'b0;
            ALUSrc    <= 1'b0;
            ExtOp     <= 1'b0;
            ALUOp     <= 5'b0;
            SpecialOP <= 4'b0;
        end else {DATA_BLOCK} begin
            // default case:
            Jump      <= 1'b0;
            RegDst    <= 1'b0;
            Branch    <= 1'b0;
            MemRead   <= 1'b0;
            MemWrite  <= 1'b0;
            RegWrite  <= 1'b0;
            ALUSrc    <= 1'b0;
            ExtOp     <= 1'b0;
            ALUOp     <= 5'b0;
            SpecialOP <= 4'b0;
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
