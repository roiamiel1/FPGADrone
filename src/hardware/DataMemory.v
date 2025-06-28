`include "signal_def.v"

`define P_UART_CHAR  32'd1000
`define P_UART_START 32'd1001
`define P_UART_DONE  32'd1002
`define P_UART_BUSY  32'd1003

// states of SDReader state machine
`define RESET               3'b001
`define IDLE                3'b010
`define START_READ_SECTOR   3'b011
`define READ_SECTOR         3'b100
`define STOP_READ_SECTOR    3'b101

`define SECTORS_TO_READ 2'd1

module DataMemory(
    input wire clk,
    input wire rst,
    input wire uartClk,
    input wire [31:0] address,
    input wire [31:0] data_in, 
    input wire write_enable,
    input wire [1:0] mode,
    output wire uart_tx_out,
    output reg [31:0] data_out,
    output sdclk,
    inout sdcmd,
    input sddat0
);
    reg [31:0] memory [0:600];
    
    reg UART_Start = 0;
    reg [7:0] UART_In = 8'b0;
    wire UART_Done;
    wire UART_Busy;

    reg [2:0] state = `RESET;
    reg [2:0] SD_ReadedSectors;
    reg SD_Rstart;
    reg [31:0] SD_RSector;
    wire SD_RBusy;
    wire SD_RDone;
    wire SD_Outen;
    wire [8:0] SD_OutAddr;
    wire [7:0] SD_OutByte;

    initial begin
        state   <= `RESET;
        SD_ReadedSectors <= 2'b0;
        SD_Rstart <= 1'b0;
        SD_RSector <= 32'b0;
    end

    SDRreader U_SD_READER(
        .rstn(!rst),
        .clk(clk),
        .sdclk(sdclk),
        .sdcmd(sdcmd),
        .sddat0(sddat0),
        .card_stat(),
        .card_type(),
        // user read sector command interface (sync with clk)
        .rstart(SD_Rstart),
        .rsector(SD_RSector),
        .rbusy(SD_RBusy),
        .rdone(SD_RDone),
        // sector data output interface (sync with clk)
        .outen(SD_Outen),
        .outaddr(SD_OutAddr),
        .outbyte(SD_OutByte)
    );

    Uart8Transmitter U_Uart(
        .clk(uartClk),
        .en(1'b1),
        .start(UART_Start),
        .in(UART_In),
        .out(uart_tx_out),
        .done(UART_Done),
        .busy(UART_Busy)
    );

    always @(negedge clk) begin
        if (!write_enable) begin
            case (address)
                `P_UART_DONE: data_out <= {30'b0, UART_Done};
                `P_UART_BUSY: data_out <= {30'b0, UART_Busy};
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
        end
    end

    always @(posedge clk) begin
        case (state)
            default: begin
                state <= `IDLE;
            end
            
            `RESET: begin
                state   <= `IDLE;
                SD_Rstart <= 1'b0;
                SD_RSector <= 32'b0;
            end

            `IDLE: begin
                if (SD_ReadedSectors < `SECTORS_TO_READ) begin
                    state <= `START_READ_SECTOR;
                end
            end

            `START_READ_SECTOR: begin
                state <= `READ_SECTOR;
                SD_RSector <= {29'b0, SD_ReadedSectors};
                SD_Rstart <= 1'b1;
            end

            `READ_SECTOR: begin
                if (SD_Outen) begin
                    memory[(SD_ReadedSectors * 128) + (SD_OutAddr >> 2)] <= (
                        memory[(SD_ReadedSectors * 128) + (SD_OutAddr >> 2)] | (
                            ((SD_OutAddr & 2'b11) == 2'b00 ? {SD_OutByte, 24'b0} :
                            ((SD_OutAddr & 2'b11) == 2'b01 ? {8'b0, SD_OutByte, 16'b0} :
                            ((SD_OutAddr & 2'b11) == 2'b10 ? {16'b0, SD_OutByte, 8'b0} :
                            {24'b0, SD_OutByte})))
                        )
                    );

                    if (SD_OutAddr == 9'd511) begin
                        SD_Rstart <= 1'b0;
                        state <= `STOP_READ_SECTOR;
                    end
                end
            end

            `STOP_READ_SECTOR: begin
                state <= `IDLE;
                SD_ReadedSectors <= SD_ReadedSectors + 1'b1;
            end
        endcase
    end
endmodule
