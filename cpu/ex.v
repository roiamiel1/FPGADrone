module EX(
    input rst,
    input clk,
    input [25:0] pc,
    input [31:0] read_data1,
    input [31:0] read_data2,
    input [31:0] instruction,
    input ex_ctl_reg_dst,
    input ex_ctl_branch,
    input ex_ctl_mem_read,
    input ex_ctl_mem_to_reg,
    input ex_ctl_alu_op,
    input ex_ctl_mem_write,
    input ex_ctl_alu_src,
    input ex_ctl_reg_write,
    output reg mem_ctl_branch,
    output reg mem_ctl_mem_read,
    output reg mem_ctl_mem_to_reg,
    output reg mem_ctl_mem_write,
    output reg mem_ctl_reg_write,
    output reg [31:0] mem_alu_result,
    output reg mem_zero,
    output reg [25:0] mem_pc,
    output reg [4:0] mem_reg_dst,
    output reg [31:0] mem_mem_write_data
);
    // Internal
    wire [31:0] immediate;
    wire [31:0] internal_mem_alu_result;
    wire internal_mem_zero;
    reg [5:0] pc_immediate_overflow;

    assign immediate = $signed(instruction[30:16]);

    ALU32 aluModule(
        .rst(rst),
        .clk(clk),
        .op(ex_ctl_alu_op),
        .arg1(read_data1),
        .arg2(ex_ctl_alu_src ? immediate : read_data2),
        .result(internal_mem_alu_result),
        .zero(internal_mem_zero)    
    );

    always @(negedge clk, posedge rst) begin
        if (rst == 1) begin
            mem_ctl_branch = 0;
            mem_ctl_mem_read = 0;
            mem_ctl_mem_to_reg = 0;
            mem_ctl_mem_write = 0;
            mem_ctl_reg_write = 0;
            mem_mem_write_data = 0;
        end else begin
            mem_ctl_branch <= ex_ctl_branch;
            mem_ctl_mem_read <= ex_ctl_mem_read;
            mem_ctl_mem_to_reg <= ex_ctl_mem_to_reg;
            mem_ctl_mem_write <= ex_ctl_mem_write;
            mem_ctl_reg_write <= ex_ctl_reg_write;
            {pc_immediate_overflow, mem_pc} <= pc + (immediate << 2);
            mem_reg_dst <= ex_ctl_reg_dst ? instruction[19:16] : instruction[14:11];
            mem_alu_result <= internal_mem_alu_result;
            mem_zero <= internal_mem_zero;
            mem_mem_write_data <= read_data2;
        end
    end

endmodule