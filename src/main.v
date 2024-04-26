module PWMController(
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    input [31:0] pwm_width_us,
    output reg pwm_out
);

// ESC is a PWM with a frequency of 50Hz, i.e 50 Cycles in 1sec.
// The sys_clk is 27MHz.
// Therefore each 20 board clock cycles are 1 PWM cycle.
`define CLOCK_CYCLES_IN_ESC_CYCLE 540000
`define CLOCK_CYCLES_IN_US 27

reg [31:0] cycles_counter = 0;
reg [31:0] phase_cycles_counter = 0;
reg [31:0] phase_us_counter = 0;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cycles_counter <= 0;
        phase_cycles_counter <= 0;
        phase_us_counter <= 0;
        pwm_out <= 0;
    end
    else begin
        cycles_counter <= cycles_counter + 1;
        phase_cycles_counter <= phase_cycles_counter + 1;

        if (cycles_counter == `CLOCK_CYCLES_IN_ESC_CYCLE) begin
            cycles_counter <= 0;
            phase_us_counter <= 0;
            phase_cycles_counter <= 0;
        end

        if (phase_cycles_counter == `CLOCK_CYCLES_IN_US) begin
            phase_cycles_counter <= 0;
            phase_us_counter <= phase_us_counter + 1;
        end

        if (phase_us_counter < pwm_width_us)
            pwm_out <= 1;
        else
            pwm_out <= 0;
    end
end

endmodule

module main(
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    output wire pwm_out
);

PWMController pwm_controller (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .pwm_width_us(1800),
    .pwm_out(pwm_out)
);

endmodule
