import math
from itertools import batched

BYTES_PER_OPCODE = 4

ADDRESS_BITS = 32
MEM_CELL_BITS = 32

opcode_template_ident = "         "
opcode_template = "(IMAdress == {ADDRESS}) ? {DATA} :\n"

with open("bin/main.shellcode", "rb") as f:
    shellcode = f.read()

assert(len(shellcode) % BYTES_PER_OPCODE == 0, "Invalid shellcode")

opcodes_iterator = batched(shellcode, BYTES_PER_OPCODE)

DATA_BLOCK = ""

for address, opcode in enumerate(opcodes_iterator):
    address_code = f"{str(ADDRESS_BITS)}'h" + hex(address)[2:].zfill(math.ceil(math.log(2**ADDRESS_BITS-1, 16)))
    data_code = f"{MEM_CELL_BITS}'h" + "".join(hex(b)[2:].zfill(2) for b in opcode)

    if (address > 0):
        DATA_BLOCK += opcode_template_ident  
    DATA_BLOCK += opcode_template.format(ADDRESS=address_code, DATA=data_code)

template = f"""
// AUTO-GENERATED - DO NOT CHNAGE!
module InstructionMemory (
    input [{ADDRESS_BITS - 1}:0] IMAdress,
    output reg [{MEM_CELL_BITS - 1}:0] IR
);

always @(IMAdress) begin
    IR = {DATA_BLOCK}
         {MEM_CELL_BITS}'h00000000;
    end
endmodule
"""

with open("new_cpu/InstructionMemory.v", "w") as f:
    f.write(template)
