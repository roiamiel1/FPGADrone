`timescale 1ns / 1ps

module ForwardingUnit (
    input wire [4:0] ALUDataIn1RegAddr_in,  // Address of the register being insterted as first input to the ALU?
    input wire [4:0] ALUDataIn2RegAddr_in,  // Address of the register being insterted as second input to the ALU?
    
    input wire EXMEM_WriteBackReg,          // Is EXMEM planning to write back to register?
    input wire MEMWB_WriteBackReg,          // Is MEMWB planning to write back to register?

    input wire [4:0] EXMEM_WriteBackRegAddr,  // Which register address EXMEM planning to write to.
    input wire [4:0] MEMWB_WriteBackRegAddr,  // Which register address MEMWB planning to write to.

    output wire [2:0] ALUDataIn1Mux_out,  // First MUX output.
    output wire [2:0] ALUDataIn2Mux_out   // Second MUX output.
);
    assign ALUDataIn1Mux_out = 
        ((ALUDataIn1RegAddr_in != 0 && ALUDataIn1RegAddr_in == EXMEM_WriteBackRegAddr) && EXMEM_WriteBackReg) ? `FOWARD_MUX_EXMEM_FORWARD :
        (((ALUDataIn1RegAddr_in != 0 && ALUDataIn1RegAddr_in == MEMWB_WriteBackRegAddr) && MEMWB_WriteBackReg) ? `FOWARD_MUX_MEMWB_FORWARD : `FOWARD_MUX_NO_FORWARD);

    assign ALUDataIn2Mux_out = 
        ((ALUDataIn2RegAddr_in != 0 && ALUDataIn2RegAddr_in == EXMEM_WriteBackRegAddr) && EXMEM_WriteBackReg) ? `FOWARD_MUX_EXMEM_FORWARD :
        (((ALUDataIn2RegAddr_in != 0 && ALUDataIn2RegAddr_in == MEMWB_WriteBackRegAddr) && MEMWB_WriteBackReg) ? `FOWARD_MUX_MEMWB_FORWARD : `FOWARD_MUX_NO_FORWARD);

endmodule
