`timescale 1ns / 1ps

`include "signal_def.v"

// states of state machine
`define RESET       3'b001
`define IDLE        3'b010
`define START_BIT   3'b011 // transmitter only
`define DATA_BITS   3'b100
`define STOP_BIT    3'b101

/*
 * 8-bit UART Transmitter.
 * Able to transmit 8 bits of serial data, one start bit, one stop bit.
 * When transmit is complete {done} is driven high for one clock cycle.
 * When transmit is in progress {busy} is driven high.
 * Clock should be decreased to baud rate.
 */
module Uart8Transmitter(
    input wire clk,
    input wire rst,
    input wire en,
    input wire start, // start of transaction
    input wire [7:0] in,    // data to transmit
    output reg out,   // tx
    output reg done,  // end on transaction
    output reg busy   // transaction is in process
);
    parameter UART_DIV = `CLOCK_RATE / `UART_BAUD_RATE;
    parameter UART_CNT_W = $clog2(UART_DIV);

    reg [2:0] state;
    reg [7:0] data;
    reg [2:0] bitIdx;

    reg [UART_CNT_W-1:0] uartTxCounter;
    reg uartTxTick;

    initial begin
        state <= `RESET;
        out <= 1'b1; // idle level
        done <= 1'b0;
        busy <= 1'b0;
        bitIdx <= 3'b0;
        data <= 8'b0;
        uartTxCounter <= 1'b0;
        uartTxTick <= 1'b0;
    end

    always @(posedge clk) begin
        if (rst) begin
            uartTxCounter <= 1'b0;
            uartTxTick    <= 1'b0;
        end else if (uartTxCounter == UART_DIV-1) begin
            uartTxCounter <= 1'b0;
            uartTxTick    <= 1'b1;
        end else begin
            uartTxCounter <= uartTxCounter + 1'b1;
            uartTxTick    <= 1'b0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= `RESET;
            out     <= 1'b1; // idle level
            done    <= 1'b0;
            busy    <= 1'b0;
            bitIdx  <= 3'b0;
            data    <= 8'b0;
        end else if (uartTxTick) begin
            case (state)                        
                `RESET: begin
                    state   <= `IDLE;
                    out     <= 1'b1;
                    done    <= 1'b0;
                    busy    <= 1'b0;
                    bitIdx  <= 3'b0;
                    data    <= 8'b0;
                end
                `IDLE: begin
                    out     <= 1'b1;
                    busy    <= 1'b0;
                    done    <= 1'b0;
                    bitIdx  <= 3'b0;

                    if (start && en) begin
                        data  <= in;
                        busy  <= 1'b1;
                        state <= `START_BIT;
                    end
                end
                `START_BIT: begin
                    out   <= 1'b0;     // start bit
                    busy  <= 1'b1;    
                    state <= `DATA_BITS;
                end
                `DATA_BITS: begin
                    out <= data[bitIdx];

                    if (bitIdx == 3'd7) begin
                        bitIdx <= 3'b0;
                        state  <= `STOP_BIT;
                    end else begin
                        bitIdx <= bitIdx + 1'b1;
                    end
                end
                `STOP_BIT: begin
                    out   <= 1'b1;
                    done  <= 1'b1;
                    if (!start) begin
                        state <= `IDLE;
                    end
                end
                default: begin
                    state <= `RESET;
                end
            endcase
        end
    end
endmodule
