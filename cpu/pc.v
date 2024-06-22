module PC26(
    input wire rst,
    input wire clk,
    wire [0:25] next_pc,
    output reg [0:25] pc
);
    always @(negedge clk, posedge rst) begin
        if (rst == 1)
            pc <= 0;
        else
            pc <= next_pc;
    end
endmodule
