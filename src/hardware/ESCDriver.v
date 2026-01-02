`timescale 1ns / 1ps

`include "signal_def.v"

module ESCDriver(
    input wire clk,
    input wire rst, 
    input wire [9:0] speed, // 0 - 1000
    output reg pwm_out
);
    // ESC constants
    localparam integer ESC_FREQ = 50;          // 50 Hz ESC PWM
    localparam integer PULSE_MIN_US = 1_000;    // 1 ms
    localparam integer PULSE_MAX_US = 5_000;    // 2 ms

    // Compute PWM period and pulse widths in FPGA clock cycles
    localparam integer PWM_PERIOD   = (`CLOCK_RATE / ESC_FREQ);                  // full period cycles
    localparam integer PULSE_MIN    = (`CLOCK_RATE / 1_000_000 ) * PULSE_MIN_US; // 1ms pulse width cycles
    localparam integer PULSE_MAX    = (`CLOCK_RATE / 1_000_000 ) * PULSE_MAX_US; // 2ms pulse width cycles
    localparam integer PULSE_RANGE  = PULSE_MAX - PULSE_MIN;

    reg  [31:0] counter = 0;
    wire [31:0] pulse_width;

    // Compute pulse width based on speed input (0-1000)
    assign pulse_width = PULSE_MIN + (PULSE_RANGE * speed) / 1000;

    initial begin
        pwm_out <= 1'b0;
        counter <= 32'b0;
    end

    // PWM generation
    always @(posedge clk) begin
        if (counter < PWM_PERIOD - 1) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end

        pwm_out <= (counter < pulse_width) ? 1'b1 : 1'b0;
    end

endmodule
