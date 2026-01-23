`timescale 1ns / 1ps

`include "signal_def.v"

module Timer(
    input wire clk,
    input wire rst,
    output reg [31:0] uptime_ms
);

    parameter TIMER_MS_DIV = `CLOCK_RATE / `MS_IN_SEC;
    parameter TIMER_MS_CNT_W = $clog2(TIMER_MS_DIV);

    reg [TIMER_MS_CNT_W-1:0] counter;

    initial begin
        uptime_ms <= 32'b0;
        counter <= 0;
    end

    always@(posedge clk, posedge rst) begin
        if (rst) begin
            uptime_ms <= 32'b0;
            counter   <= 0;
        end else if (counter == TIMER_MS_DIV - 1) begin
            uptime_ms <= uptime_ms + 32'b1;
            counter   <= 0;
        end else begin
            counter <= counter + 1'b1;
        end
    end

endmodule