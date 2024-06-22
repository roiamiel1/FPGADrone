module Control(
    input [4:0] opcode,
    input [4:0] funct,
    output reg control_reg_dst,
    output reg control_branch,
    output reg control_mem_read,
    output reg control_mem_to_reg,
    output reg control_alu_op,
    output reg control_mem_write,
    output reg control_alu_src,
    output reg control_reg_write
);
    always @(opcode or funct) begin
        control_reg_dst <= opcode[0];
        control_branch <= opcode[1];
        control_mem_read <= opcode[2];
        control_mem_to_reg <= opcode[3];
        control_alu_op <= opcode[4];
        control_mem_write <= funct[0];
        control_alu_src <= funct[1];
        control_reg_write <= funct[2];
    end
endmodule