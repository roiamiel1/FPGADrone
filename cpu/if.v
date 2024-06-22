module IF(
    input wire rst,
    input wire clk,
    input wire [0:25] if_pc,
    input wire [31:0] if_instruction,
    output reg [0:25] id_pc,
    output reg [31:0] id_instruction
);
    always @(negedge clk, posedge rst) begin
        if (rst == 1) begin
            id_pc <= 0;
            id_instruction <= 0;
        end else begin
            id_pc <= if_pc;
            id_instruction <= if_instruction;
        end
    end
endmodule
