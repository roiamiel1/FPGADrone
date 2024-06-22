module MEM(
    input wire rst,
    input wire clk,
    input wire mem_ctl_branch,
    input wire mem_ctl_mem_read,
    input wire mem_ctl_mem_to_reg,
    input wire mem_ctl_mem_write,
    input wire mem_ctl_reg_write,
    input wire [31:0] mem_mem_write_data,
    input wire [31:0] mem_alu_result,
    input wire mem_zero,
    input wire [25:0] mem_pc,
    input wire [4:0] mem_reg_dst,
    output wire pc_src,
    output wire [25:0] next_pc,
    output reg wb_ctl_reg_write,
    output reg wb_ctl_mem_to_reg,
    output reg [31:0] wb_ram_read_data,
    output reg [31:0] wb_alu_result,
    output reg [4:0] wb_reg_dst
); 
    wire [31:0] internal_ram_read_data;

    assign pc_src = mem_zero & mem_ctl_branch;
    assign next_pc = mem_pc;

    RAM32 ram(
        .rst(rst),
        .clk(clk),
        .address(mem_alu_result),
        .read_data(internal_ram_read_data),
        .write_data(mem_mem_write_data),
        .read(mem_ctl_mem_read),
        .write(mem_ctl_mem_write)
    );
    
    always @(negedge clk, posedge rst) begin
        if (rst == 1) begin
            wb_ctl_reg_write = 0;
            wb_ctl_mem_to_reg = 0;
            wb_ram_read_data = 0;
            wb_alu_result = 0;
            wb_reg_dst = 0;
        end else begin
            wb_ctl_reg_write <= mem_ctl_reg_write;
            wb_ctl_mem_to_reg <= mem_ctl_mem_to_reg;
            wb_ram_read_data <= internal_ram_read_data;
            wb_alu_result <= mem_alu_result;
            wb_reg_dst <= mem_reg_dst;
        end
    end

endmodule