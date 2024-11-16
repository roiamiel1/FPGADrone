`include "signal_def.v"

module DataMemory(
    input clk,
    output [31:0] data_out,
    input [31:0] address,
    input [31:0] data_in, 
    input write_enable,
    input [1:0] mode
);
    reg [31:0] memory [0:500];

    always @(posedge clk) begin
        if (write_enable) begin
            case (mode)
                `DataMemoryMode_WORD: begin
                    memory[address] <= data_in;
                end

                `DataMemoryMode_HALFWORD: begin
                    memory[address] <= {memory[address][31:15], data_in[15:0]};
                end

                `DataMemoryMode_BYTE: begin
                    memory[address] <= {memory[address][31:7], data_in[7:0]};
                end
            endcase
        end
    end

    assign data_out = mode == `DataMemoryMode_BYTE ? {24'b0, memory[address][7:0]} : (
        mode == `DataMemoryMode_HALFWORD ? {16'b0, memory[address][15:0]} : memory[address]
    );
     
endmodule
