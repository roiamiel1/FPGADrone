`define P_UART_CHAR  32'd1000
`define P_UART_START 32'd1001
`define P_UART_DONE  32'd1002
`define P_UART_BUSY  32'd1003

// states of SDReader state machine
`define S_SD_RESET               3'b001
`define S_SD_IDLE                3'b010
`define S_SD_START_READ_SECTOR   3'b011
`define S_SD_READ_SECTOR         3'b100
`define S_SD_STOP_READ_SECTOR    3'b101
`define S_SD_DONE                3'b110

`define SD_LAST_SECTOR 32'd511

`define SECTORS_TO_READ 4'd10

module DataMemoryInterface(
    input wire clk,
    input wire rst,

    // Data memory interface
    input wire write_enable,
    input wire [1:0] mode,
    input wire [31:0] address,
    input wire [31:0] data_in, 
    output wire [31:0] data_out,
    output reg ready,

    // Instruction memory interface
    input wire [31:0] IMAdress,
    output wire [31:0] IR,

    // UART interface
    input wire uart_clk,
    output wire uart_tx_out,

    // SD card interface
    output sdclk,
    inout sdcmd,
    input sddat0
);
    // Data memory interface
    wire IsSpacialAddress;
    wire DataMemoryWriteEnable;
    wire [31:0] DataMemoryIn;
    wire [31:0] MemoryDataOut;
    wire [13:0] DataMemoryAddress;
    wire [1:0] DataMemoryMode;

    // UART Interface
    reg UART_Start = 0;
    reg [7:0] UART_In = 8'b0;
    wire UART_Done;
    wire UART_Busy;

    // SD Interface
    reg [2:0] SD_State = `S_SD_RESET;
    reg [5:0] SD_ReadSectorIndex;
    reg SD_Start;
    wire SD_Busy;
    wire SD_Done;
    wire SD_OutEn;
    wire [8:0] SD_OutAddr;
    wire [7:0] SD_OutByte;

    // Read SD and write to memory registers
    reg IsInitiateWordPending;
    reg [31:0] InitiateWordBuffer;
    reg [13:0] InitiateWordAddr;

    initial begin
        UART_Start <= 1'b0;
        UART_In <= 8'b0;

        SD_State <= `S_SD_RESET;
        SD_ReadSectorIndex <= 2'b0;
        SD_Start <= 1'b0;

        IsInitiateWordPending <= 1'b0;
        InitiateWordBuffer <= 32'b0;
        InitiateWordAddr <= 14'b0;

        ready <= 1'b0;
    end 

    // Assigns
    assign IsSpacialAddress = (
        (address == `P_UART_CHAR) ||
        (address == `P_UART_START) ||
        (address == `P_UART_DONE) ||
        (address == `P_UART_BUSY)
    );
    assign data_out = !IsSpacialAddress ? MemoryDataOut : (
        (address == `P_UART_DONE) ? {30'b0, UART_Done} :
        (address == `P_UART_BUSY) ? {30'b0, UART_Busy} :
        (31'b0)
    );

    assign DataMemoryWriteEnable = (write_enable && !IsSpacialAddress) || IsInitiateWordPending;
    assign DataMemoryAddress = IsInitiateWordPending ? InitiateWordAddr : address[13:0];
    assign DataMemoryIn = IsInitiateWordPending ? InitiateWordBuffer : data_in;
    assign DataMemoryMode = IsInitiateWordPending ? `DataMemoryMode_WORD : mode;

    Uart8Transmitter U_Uart(
        .clk(uart_clk),
        .rst(rst),
        .en(ready),
        .start(UART_Start),
        .in(UART_In),
        .out(uart_tx_out),
        .done(UART_Done),
        .busy(UART_Busy)
    );

    // Data memory interface
    DataMemory U_DataMemory(
        .clk(clk),
        .rst(rst),
        // Read Write Main Interface
        .write_enable_a(DataMemoryWriteEnable),
        .mode_a(DataMemoryMode),
        .address_a(DataMemoryAddress),
        .data_in_a(DataMemoryIn),
        .data_out_a(MemoryDataOut),
        // Read Instruction Memory Interface
        .write_enable_b(1'b0),
        .mode_b(`DataMemoryMode_WORD),
        .address_b(IMAdress[13:0]),
        .data_in_b(32'b0),
        .data_out_b(IR)
    );

    // SD card interface
    SDRreader U_SD_READER(
        .rstn(!rst),
        .clk(clk),
        .sdclk(sdclk),
        .sdcmd(sdcmd),
        .sddat0(sddat0),
        .card_stat(/* ignore */),
        .card_type(/* ignore */),
        // Read sector command input (sync with clk)
        .rstart(SD_Start),
        .rsector({29'b0, SD_ReadSectorIndex}),
        .rbusy(SD_Busy),
        .rdone(SD_Done),
        // Read sector command output (sync with clk)
        .outen(SD_OutEn),
        .outaddr(SD_OutAddr),
        .outbyte(SD_OutByte)
    );

    always @(posedge clk) begin
        if (write_enable) begin
            case (address)
                `P_UART_CHAR: UART_In <= data_in[7:0];
                `P_UART_START: UART_Start <= data_in[0];
            endcase
        end
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            SD_State <= `S_SD_RESET;
            SD_Start <= 1'b0;
            SD_ReadSectorIndex <= 32'b0;

            IsInitiateWordPending <= 1'b0;
            InitiateWordBuffer <= 32'b0;
            InitiateWordAddr <= 14'b0;

            ready <= 1'b0;
        end else begin
            case (SD_State)
                `S_SD_RESET: begin
                    SD_State <= `S_SD_IDLE;
                    SD_Start <= 1'b0;
                    SD_ReadSectorIndex <= 32'b0;
                    ready <= 1'b0;
                end
                `S_SD_IDLE: begin
                    if (SD_ReadSectorIndex < `SECTORS_TO_READ) begin
                        // In case there are more sectors to read, read next sector
                        SD_State <= `S_SD_START_READ_SECTOR;
                    end else begin
                        ready <= 1'b1;
                    end
                end
                `S_SD_START_READ_SECTOR: begin
                    SD_State <= `S_SD_READ_SECTOR;
                    SD_Start <= 1'b1;
                end
                `S_SD_READ_SECTOR: begin
                    IsInitiateWordPending = 1'b0;
                    if (SD_OutEn) begin
                        case (SD_OutAddr & 2'b11)
                            2'b00: InitiateWordBuffer[31:24] <= SD_OutByte;
                            2'b01: InitiateWordBuffer[23:16] <= SD_OutByte;
                            2'b10: InitiateWordBuffer[15:8] <= SD_OutByte;
                            2'b11: begin
                                InitiateWordBuffer[7:0] <= SD_OutByte;
                                InitiateWordAddr <= 14'b0 | ((SD_ReadSectorIndex * 128) + (SD_OutAddr >> 2));
                                IsInitiateWordPending <= 1'b1;
                            end
                        endcase

                        if (SD_OutAddr == `SD_LAST_SECTOR) begin
                            SD_Start <= 1'b0;
                            SD_State <= `S_SD_STOP_READ_SECTOR;
                        end
                    end
                end
                `S_SD_STOP_READ_SECTOR: begin
                    SD_State <= `S_SD_IDLE;
                    SD_ReadSectorIndex <= SD_ReadSectorIndex + 1'b1;
                    IsInitiateWordPending <= 1'b0;
                end
                default: begin
                    SD_State <= `S_SD_IDLE;
                end
            endcase
        end
    end
endmodule