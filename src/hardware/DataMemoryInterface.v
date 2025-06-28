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
`define DONE                3'b110

`define SECTORS_TO_READ 2'd1

module DataMemoryInterface(
    input wire clk,
    input wire rst,
    input wire write_enable,
    input wire [1:0] mode,
    input wire [31:0] address,
    input wire [31:0] data_in, 
    output wire [31:0] data_out,

    // UART interface
    input wire uartClk,
    output wire uart_tx_out,

    // SD card interface
    output sdclk,
    inout sdcmd,
    input sddat0
);
    // Data memory interface
    wire IsSpacialAddress;
    wire DataMemoryWriteEnable;
    wire [31:0] MemoryDataOut;

    // UART interface
    reg UART_Start = 0;
    reg [7:0] UART_In = 8'b0;
    wire UART_Done;
    wire UART_Busy;

    // Assigns
    assign IsSpacialAddress = (
        (address == `P_UART_CHAR) ||
        (address == `P_UART_START) ||
        (address == `P_UART_DONE) ||
        (address == `P_UART_BUSY)
    );
    assign DataMemoryWriteEnable = write_enable && !IsSpacialAddress;
    assign data_out = !IsSpacialAddress ? MemoryDataOut : (
        (address == `P_UART_DONE) ? {30'b0, UART_Done} :
        (address == `P_UART_BUSY) ? {30'b0, UART_Busy} :
        (31'b0)
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

    // Data memory interface
    DataMemory U_DataMemory(
        .clk(clk),
        .rst(rst),
        .write_enable(DataMemoryWriteEnable),
        .mode(mode),
        .address(address[11:0]),
        .data_in(data_in),
        .data_out(MemoryDataOut)
    );

    always @(posedge clk) begin
        if (write_enable) begin
            case (address)
                `P_UART_CHAR: UART_In <= data_in[7:0];
                `P_UART_START: UART_Start <= data_in[0];
            endcase
        end
    end

    // SD card interface
    /*
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
        state <= `RESET;
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
    */
endmodule