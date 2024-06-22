module ID(
    input wire rst,
    input wire clk,
    input wire [25:0] id_pc,
    input wire [31:0] id_read_data1,
    input wire [31:0] id_read_data2,
    input wire [31:0] id_instruction,
    input wire id_ctl_reg_dst,
    input wire id_ctl_branch,
    input wire id_ctl_mem_read,
    input wire id_ctl_mem_to_reg,
    input wire id_ctl_alu_op,
    input wire id_ctl_mem_write,
    input wire id_ctl_alu_src,
    input wire id_ctl_reg_write,
    output reg [25:0] ex_pc,
    output reg [31:0] ex_read_data1,
    output reg [31:0] ex_read_data2,
    output reg [31:0] ex_instruction,
    output reg ex_ctl_reg_dst,
    output reg ex_ctl_branch,
    output reg ex_ctl_mem_read,
    output reg ex_ctl_mem_to_reg,
    output reg ex_ctl_alu_op,
    output reg ex_ctl_mem_write,
    output reg ex_ctl_alu_src,
    output reg ex_ctl_reg_write
);
    always @(negedge clk, posedge rst) begin
        if (rst == 1) begin
            ex_pc <= 0;
            ex_read_data1 <= 0;
            ex_read_data2 <= 0;
            ex_instruction <= 0;
            ex_ctl_reg_dst <= 0;
            ex_ctl_branch <= 0;
            ex_ctl_mem_read <= 0;
            ex_ctl_mem_to_reg <= 0;
            ex_ctl_alu_op <= 0;
            ex_ctl_mem_write <= 0;
            ex_ctl_alu_src <= 0;
            ex_ctl_reg_write <= 0;
        end else begin
            ex_pc <= id_pc;
            ex_read_data1 <= id_read_data1;
            ex_read_data2 <= id_read_data2;
            ex_instruction <= id_instruction;
            ex_ctl_reg_dst <= id_ctl_reg_dst;
            ex_ctl_branch <= id_ctl_branch;
            ex_ctl_mem_read <= id_ctl_mem_read;
            ex_ctl_mem_to_reg <= id_ctl_mem_to_reg;
            ex_ctl_alu_op <= id_ctl_alu_op;
            ex_ctl_mem_write <= id_ctl_mem_write;
            ex_ctl_alu_src <= id_ctl_alu_src;
            ex_ctl_reg_write <= id_ctl_reg_write;
        end
    end
endmodule