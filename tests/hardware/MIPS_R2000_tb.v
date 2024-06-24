`include "signal_def.v"

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal(%8X) != value(%8X)", signal, value); \
            $finish; \
        end

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

        if (cycles == 8) begin
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[4], 32'h0)
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[5], 32'h1)
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[6], 32'h2)
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[7], 32'hFFFFFFFF)
        end

        if (cycles == 11)
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[2], 32'd3)

        if (cycles == 12)
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[4], 32'd10)

        if (cycles == 13)
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[5], 32'd6)

        if (cycles == 14)
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[27], 32'd4)

        if (cycles == 15)
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[2], 32'd6)

        if (cycles == 16)
            `assert(U_MIPS_R2000.U_GPR.gprRegisters[3], 32'd5)

        if (cycles >= 30)
            $finish;
    end

endmodule

/*
module TESTBENCH (
    `ifndef DEBUG
    input clk,
    input rstn,
    input [15:0] sw_i, 
    output[7:0] tubeSelect,
    output[7:0] tubeChar,
    `endif
);

    reg CLK_DEBUG;
    reg RST_DEBUG;
    wire CLK_CPU;
    wire RST_CPU;
    `ifdef DEBUG
    assign RST_CPU = RST_DEBUG;
    assign CLK_CPU = CLK_DEBUG;
    reg [31:0] cycles;
    wire[15:0] sw_i = 15'b0;
    integer i;
    `else 
    wire CLK_TB = clk;
    assign RST_CPU = ~rstn;
    `endif


    `ifdef DEBUG
    initial begin
        $dumpfile("MIPS_R2000_tb.vcd");
        $dumpvars;
        $readmemh("../../tests/hardware/asm/MIPS_R2000_tb.hex", U_MIPS_R2000.U_InstructionMemory.IMem);
        U_MIPS_R2000.U_IFIDReg.StageReg = 0;
        U_MIPS_R2000.U_IDEXReg.StageReg = 0;
        U_MIPS_R2000.U_EXMEMReg.StageReg = 0;
        U_MIPS_R2000.U_MEMWBReg.StageReg = 0;
        cycles = 0;
        CLK_DEBUG = 1;
        RST_DEBUG = 0;
        #2 RST_DEBUG = ~RST_DEBUG;
        #2 RST_DEBUG = ~RST_DEBUG;
    end
    
    always begin
        #10 CLK_DEBUG = ~CLK_DEBUG;
    end
    
    always @ (posedge RST_CPU) begin
        cycles = 0;
    end
    
    always@(posedge CLK_CPU) begin
        cycles = cycles+1;
        if(cycles[9]) begin
            $finish;
        end
    end

    always@(negedge CLK_CPU) begin
        $display("=====================================");
        for(i=0;i<8;i=i+1) begin
            $display("R[%2d-%2d]  %8X  %8X  %8X  %8X",i*4,i*4+3, 
                U_MIPS_R2000.U_GPR.gprRegisters[i*4+0], 
                U_MIPS_R2000.U_GPR.gprRegisters[i*4+1], 
                U_MIPS_R2000.U_GPR.gprRegisters[i*4+2], 
                U_MIPS_R2000.U_GPR.gprRegisters[i*4+3]
            );
        end
        $display("");
        for(i=0;i<8;i=i+1) begin
            $display("M[%2d-%2d]  %8X  %8X  %8X  %8X",i*4,i*4+3,
                U_MIPS_R2000.U_DataMemory.memory[i*4+0],
                U_MIPS_R2000.U_DataMemory.memory[i*4+1],
                U_MIPS_R2000.U_DataMemory.memory[i*4+2],
                U_MIPS_R2000.U_DataMemory.memory[i*4+3]
            );
        end
        $display("");
        $display("Clock     %8X", cycles);
        $display("PC        %8X", U_MIPS_R2000.U_PCU.PC);
        $display("IR        %8X", U_MIPS_R2000.U_InstructionMemory.IR);
        $display("Tube      %8X", displayData);
        if(U_MIPS_R2000.U_GPR.RegWrite) begin
            $display("R[ %4d]  %8X", 
                U_MIPS_R2000.U_GPR.WriteRegister,
                U_MIPS_R2000.U_GPR.WriteData
            );
        end

        if(U_MIPS_R2000.U_DataMemory.write_enable) begin
            $display("M[ %4d]  %8X",
                U_MIPS_R2000.U_DataMemory.address,
                U_MIPS_R2000.U_DataMemory.data_in
            );
        end

        $display("=====================================\n\n");
    end
    `endif



    MIPS_R2000 U_MIPS_R2000(
        .clk(CLK_CPU),
        .rst(RST_CPU)
    );


    //          LED Display            
    -------------------------------------
    | RegWrite | MemWrite | Display     |
    -------------------------------------
    |   1      |    0     | gprDataIn   |
    |   0      |    1     | gprDataOut2 |
    |   0      |    0     | pcOut       |
    //  Switch Definition
    |   15      | 14                       | 13                             |
    | clk Speed | CPU Data Display Disable | Register Data Display Disable  |
    |  12:5     | 4:0                      |                                |
    | unused    | Display Address          |                              
    wire [31:0] cpuData = (U_MIPS_R2000.U_Ctrl.RegWrite)?
        U_MIPS_R2000.U_GPR.WriteData:(
            (U_MIPS_R2000.U_Ctrl.MemWrite)?
                U_MIPS_R2000.U_GPR.DataOut2:
                    U_MIPS_R2000.U_PCU.PC
        );
    wire [31:0] memData = U_MIPS_R2000.U_DataMemory.memory[sw_i[4:0]];
    wire [31:0] regData = U_MIPS_R2000.U_GPR.gprRegisters[sw_i[4:0]];
    wire [31:0] displayData = sw_i[14]?(sw_i[13]?memData:regData):cpuData;
    `ifndef DEBUG
    seg7x16 U_seg7x16(.clk(CLK_TB),
        .rst(RST_CPU),
        .inputData(displayData),
        .tubeChar(tubeChar),
        .tubeSelect(tubeSelect));
    clk_div U_ClockDivider(.CLK_CPU(CLK_CPU),
        .clk(CLK_TB),
        .rst(RST_CPU),
        .SW15(sw_i[15]));
    `endif


endmodule
*/