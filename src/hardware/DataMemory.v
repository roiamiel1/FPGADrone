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
            case (address)
                `P_UART_DONE: begin end // Write unallowd.
                `P_UART_BUSY: begin end // Write unallowd.
                `P_UART_CHAR: UART_In <= data_in[7:0];
                `P_UART_START: UART_Start <= data_in[0];
                default: begin
                    case (mode)
                        `DataMemoryMode_WORD: memory[address] <= data_in;
                        `DataMemoryMode_HALFWORD: memory[address] <= {memory[address][31:16], data_in[15:0]};
                        `DataMemoryMode_BYTE: memory[address] <= {memory[address][31:8], data_in[7:0]};
                    endcase
                end
            endcase
        end else begin  // Read
            case (address)
                `P_UART_DONE: data_out <= {31'b0, UART_Done};
                `P_UART_BUSY: data_out <= {31'b0, UART_Busy};
                `P_UART_CHAR: data_out <= 31'b0;  // Read unallowd.
                `P_UART_START: data_out <= 31'b0; // Read unallowd.
                default: begin
                    case (mode)
                        `DataMemoryMode_WORD: data_out <= memory[address];
                        `DataMemoryMode_HALFWORD: data_out <= {16'b0, memory[address][15:0]};
                        `DataMemoryMode_BYTE: data_out <= {24'b0, memory[address][7:0]};
                    endcase
                end
            endcase
        end
    end
endmodule
