module Main(
    input rst,
    input clk,
    output wire out
);
    /******** IF ********/
    // Inputs
    wire [25:0] mem_next_pc;

    // Outputs
    wire [25:0] id_pc;
    wire [31:0] id_instruction;

    // Internal
    wire [25:0] if_pc;
    wire [31:0] if_instruction;
    wire [25:0] current_pc;
    wire [25:0] next_pc;
    wire pc_overflow;

    IF ifModule(
        .rst(rst),
        .clk(clk),
        .if_pc(if_pc),
        .if_instruction(if_instruction),
        .id_pc(id_pc),
        .id_instruction(id_instruction)
    );

    ROM32 romModule(
        .address(if_pc),
        .data(if_instruction)
    );
    
    PC26 pcModule(
        .rst(rst),
        .clk(clk),
        .pc(current_pc),
        .next_pc(next_pc)
	);

    assign next_pc = pc_src ? mem_next_pc : if_pc;
    assign {pc_overflow, if_pc} = current_pc + 4;

    /********************/

    /******** ID ********/
    // Inputs
    wire reg_write;
    wire [31:0] reg_write_data;
    wire [4:0] reg_write_address;

    // Outputs
    wire [25:0] ex_pc;
    wire [31:0] ex_read_data1;
    wire [31:0] ex_read_data2;
    wire [31:0] ex_instruction;
    wire ex_ctl_reg_dst;
    wire ex_ctl_branch;
    wire ex_ctl_mem_read;
    wire ex_ctl_mem_to_reg;
    wire ex_ctl_alu_op;
    wire ex_ctl_mem_write;
    wire ex_ctl_alu_src;
    wire ex_ctl_reg_write;

    // Internal
    wire id_ctl_reg_dst;
    wire id_ctl_branch;
    wire id_ctl_mem_read;
    wire id_ctl_mem_to_reg;
    wire id_ctl_alu_op;
    wire id_ctl_mem_write;
    wire id_ctl_alu_src;
    wire id_ctl_reg_write;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    ID idModule(
        .rst(rst),
        .clk(clk),
        .id_pc(id_pc),
        .id_read_data1(read_data1),
        .id_read_data2(read_data2),
        .id_instruction(id_instruction),
        .id_ctl_reg_dst(id_ctl_reg_dst),
        .id_ctl_branch(id_ctl_branch),
        .id_ctl_mem_read(id_ctl_mem_read),
        .id_ctl_mem_to_reg(id_ctl_mem_to_reg),
        .id_ctl_alu_op(id_ctl_alu_op),
        .id_ctl_mem_write(id_ctl_mem_write),
        .id_ctl_alu_src(id_ctl_alu_src),
        .id_ctl_reg_write(id_ctl_reg_write),
        .ex_pc(ex_pc),
        .ex_read_data1(ex_read_data1),
        .ex_read_data2(ex_read_data2),
        .ex_instruction(ex_instruction),
        .ex_ctl_reg_dst(ex_ctl_reg_dst),
        .ex_ctl_branch(ex_ctl_branch),
        .ex_ctl_mem_read(ex_ctl_mem_read),
        .ex_ctl_mem_to_reg(ex_ctl_mem_to_reg),
        .ex_ctl_alu_op(ex_ctl_alu_op),
        .ex_ctl_mem_write(ex_ctl_mem_write),
        .ex_ctl_alu_src(ex_ctl_alu_src),
        .ex_ctl_reg_write(ex_ctl_reg_write)
    );

    Control controlModule(
        .opcode(id_instruction[4:0]),
        .funct(id_instruction[30:26]),
        .control_reg_dst(id_ctl_reg_dst),
        .control_branch(id_ctl_branch),
        .control_mem_read(id_ctl_mem_read),
        .control_mem_to_reg(id_ctl_mem_to_reg),
        .control_alu_op(id_ctl_alu_op),
        .control_mem_write(id_ctl_mem_write),
        .control_alu_src(id_ctl_alu_src),
        .control_reg_write(id_ctl_reg_write)
    );

    REG32 regModule(
        .rst(rst),
        .clk(clk),
        .write_enable(reg_write),
        .read_address1(id_instruction[10:6]),
        .read_address2(id_instruction[15:11]),
        .write_address(reg_write_address),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .write_data(reg_write_data)
    );

    /********************/

    /******** EX ********/
    // Outputs
    wire mem_ctl_branch;
    wire mem_ctl_mem_read;
    wire mem_ctl_mem_to_reg;
    wire mem_ctl_mem_write;
    wire mem_ctl_reg_write;
    wire [31:0] mem_mem_write_data;
    wire [31:0] mem_alu_result;
    wire mem_zero;
    wire [25:0] mem_pc;
    wire [4:0] mem_reg_dst;

    EX exModule(
        .rst(rst),
        .clk(clk),
        .pc(ex_pc),
        .read_data1(ex_read_data1),
        .read_data2(ex_read_data2),
        .instruction(ex_instruction),
        .ex_ctl_reg_dst(ex_ctl_reg_dst),
        .ex_ctl_branch(ex_ctl_branch),
        .ex_ctl_mem_read(ex_ctl_mem_read),
        .ex_ctl_mem_to_reg(ex_ctl_mem_to_reg),
        .ex_ctl_alu_op(ex_ctl_alu_op),
        .ex_ctl_mem_write(ex_ctl_mem_write),
        .ex_ctl_alu_src(ex_ctl_alu_src),
        .ex_ctl_reg_write(ex_ctl_reg_write),
        .mem_ctl_branch(mem_ctl_branch),
        .mem_ctl_mem_read(mem_ctl_mem_read),
        .mem_ctl_mem_to_reg(mem_ctl_mem_to_reg),
        .mem_ctl_mem_write(mem_ctl_mem_write),
        .mem_ctl_reg_write(mem_ctl_reg_write),
        .mem_alu_result(mem_alu_result),
        .mem_zero(mem_zero),
        .mem_pc(mem_pc),
        .mem_reg_dst(mem_reg_dst),
        .mem_mem_write_data(mem_mem_write_data)
    );

    /********************/

    /******** MEM ********/
    // Outputs
    wire wb_ctl_reg_write;
    wire wb_ctl_mem_to_reg;
    wire [31:0] wb_ram_read_data;
    wire [31:0] wb_alu_result;
    wire [4:0] wb_reg_dst;

    MEM memModule(
        .rst(rst),
        .clk(clk),
        .mem_ctl_branch(mem_ctl_branch),
        .mem_ctl_mem_read(mem_ctl_mem_read),
        .mem_ctl_mem_to_reg(mem_ctl_mem_to_reg),
        .mem_ctl_mem_write(mem_ctl_mem_write),
        .mem_ctl_reg_write(mem_ctl_reg_write),
        .mem_mem_write_data(mem_mem_write_data),
        .mem_alu_result(mem_alu_result),
        .mem_zero(mem_zero),
        .mem_reg_dst(mem_reg_dst),
        .mem_pc(mem_pc),
        .pc_src(pc_src),
        .next_pc(mem_next_pc),
        .wb_ctl_reg_write(wb_ctl_reg_write),
        .wb_ctl_mem_to_reg(wb_ctl_mem_to_reg),
        .wb_ram_read_data(wb_ram_read_data),
        .wb_alu_result(wb_alu_result),
        .wb_reg_dst(wb_reg_dst) 
    );

    /********************/

    /******** WB ********/

    assign reg_write = wb_ctl_reg_write;
    assign reg_write_data = wb_ctl_mem_to_reg ? wb_ram_read_data : wb_alu_result;
    assign reg_write_address = wb_reg_dst;

    /********************/
    
    assign out = wb_reg_dst[0] & wb_ram_read_data[1];

endmodule