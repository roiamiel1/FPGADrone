`include "signal_def.v"

`define P_UART_CHAR  32'd1000
`define P_UART_START 32'd1001
`define P_UART_DONE  32'd1002
`define P_UART_BUSY  32'd1003

module DataMemory(
    input wire clk,
    input wire uartClk,
    input wire [31:0] address,
    input wire [31:0] data_in, 
    input wire write_enable,
    input wire [1:0] mode,
    output wire uart_tx_out,
    output reg [31:0] data_out
);
    reg [31:0] memory [0:1000];

    reg UART_Start = 0;
    reg [7:0] UART_In = 8'b0;
    wire UART_Done;
    wire UART_Busy;

    Uart8Transmitter U_Uart(
        .clk(uartClk),
        .en(1'b1),
        .start(UART_Start),
        .in(UART_In),
        .out(uart_tx_out),
        .done(UART_Done),
        .busy(UART_Busy)
    );

    always @(posedge clk) begin
        if (write_enable) begin
            case (mode)
                `DataMemoryMode_WORD: begin
                    memory[address] <= data_in;
                end

                `DataMemoryMode_HALFWORD: begin
                    memory[address] <= {memory[address][31:16], data_in[15:0]};
                end

                `DataMemoryMode_BYTE: begin
                    case (address)
                        `P_UART_CHAR: UART_In <= data_in[7:0];
                        `P_UART_START: UART_Start <= data_in[0];
                        default: memory[address] <= {memory[address][31:8], data_in[7:0]};
                    endcase
                end
            endcase
        end else begin  // Read
            case (mode)
                `DataMemoryMode_WORD: begin
                    data_out <= memory[address];
                end

                `DataMemoryMode_HALFWORD: begin
                    data_out <= {16'b0, memory[address][15:0]};
                end

                `DataMemoryMode_BYTE: begin
                    case (address)
                        `P_UART_DONE: data_out <= UART_Done;
                        `P_UART_BUSY: data_out <= UART_Busy;
                        default: data_out <= {24'b0, memory[address][7:0]};
                    endcase
                end
            endcase
        end
    end
     
endmodule
