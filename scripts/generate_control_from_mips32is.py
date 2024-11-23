from openpyxl import load_workbook

wb = load_workbook("scripts/mips32_r2000_instruction_set.xlsx")
ws = wb.active

instructions_parts = ("OpCode", "FMT", "FT", "Funct")
instructions_parts_bytes = (6, 5, 5, 6)

DATA_BLOCK = ""

row_reader = ws.rows
_, _ = next(row_reader), next(row_reader) # Ignore two first header rows.
while True:
    next_row = list(map(lambda x: x.value if x.value != "x" else None, next(row_reader)))
    
    cmd = next_row[0]
    
    if not cmd:
        # Reach end of table.
        break
    
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
`include "instruction_def.v"
`include "signal_def.v"

module Control(
    input wire clk,
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

    always @(negedge clk) begin
        {DATA_BLOCK}begin
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
        end
    end
endmodule
"""

with open("./src/hardware/Control.v", "w") as f:
    f.write(template)
