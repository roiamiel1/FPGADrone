VERILOG_TEST_FORMAT = """
`include "signal_def.v"

module TESTBENCH (
    input clk,
    input rst
);
    reg clk_debug;
    reg rst_debug;
    reg [31:0] cycles;
    
    MIPS_R2000 U_MIPS_R2000(
        .clk(clk_debug),
        .rst(rst_debug)
    );

    initial begin
        $dumpfile("MIPS_R2000_tb.vcd");
        $dumpvars;
        $readmemh("../../tests/hardware/asm/MIPS_R2000_tb.hex", U_MIPS_R2000.U_InstructionMemory.IMem);

        U_MIPS_R2000.U_IFIDReg.StageReg = 0;
        U_MIPS_R2000.U_IDEXReg.StageReg = 0;
        U_MIPS_R2000.U_EXMEMReg.StageReg = 0;
        U_MIPS_R2000.U_MEMWBReg.StageReg = 0;

        clk_debug = 1;
        rst_debug = 0;
        cycles = 0;

        rst_debug = 1;
        #2 rst_debug = 0;
    end
    
    always begin
        #10 clk_debug = ~clk_debug;
    end

    always @ (posedge rst_debug) begin
        cycles = 0;
    end

    always@(posedge clk_debug) begin
        cycles = cycles + 1;
{VALIDATIONS}
    end

endmodule
"""

def build_test(verilog_testfile_path, asm_testfile_path, instructions_and_validations):
    instructions = []
    validations = []

    for inst, *inst_validations in instructions_and_validations:
        instructions.append(inst)
        for validation in inst_validations:
            if not validation:
                continue
            
            validations.append(validation(inst, len(instructions) - 1))
    
    validations.append(f"""
if (cycles >= {len(instructions) - 1 + 5})
    $finish;
""")

    validations = [v.strip() for v in validations]
    validations = ["\n".join([f"\t\t{x}" for x in v.split("\n")]) for v in validations]

    with open(asm_testfile_path, "w") as f:
        f.write("\n".join(instructions))

    with open(verilog_testfile_path, "w") as f:
        f.write(VERILOG_TEST_FORMAT.format(VALIDATIONS="\n\n".join(validations)))
