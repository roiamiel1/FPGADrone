module PWMController(
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    input [31:0] pwm_width_ns,
    output reg pwm_out
);

// ESC is a PWM with a frequency of 50Hz, i.e 50 Cycles in 1sec.
// The FPGA board clock is (27MHz).
// Therefore each 540,000 board clock cycles are 1 PWM cycle.
`define CLOCK_CYCLES_IN_ESC_CYCLE 540000
`define CLOCK_CYCLES_IN_NS 37

reg [31:0] cycles_counter = 0; 
reg [31:0] phase_cycles_counter = 0;
reg [31:0] phase_ns_counter = 0;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cycles_counter <= 0;
        phase_cycles_counter <= 0;
        phase_ns_counter <= 0;
    end
    else begin
        cycles_counter <= cycles_counter + 1;
        phase_cycles_counter <= phase_cycles_counter + 1;

        if (cycles_counter == `CLOCK_CYCLES_IN_ESC_CYCLE) begin
            cycles_counter <= 0;
            phase_ns_counter <= 0;
            phase_cycles_counter <= 0;
        end

        if (phase_cycles_counter == `CLOCK_CYCLES_IN_NS) begin
            phase_cycles_counter <= 0;
            phase_ns_counter <= phase_ns_counter + 1;
        end
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        pwm_out <= 0;
    else if (phase_ns_counter < pwm_width_ns)
        pwm_out <= 1;
    else
        pwm_out <= 0;
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
    .pwm_width_ns(1000),
    .pwm_out(pwm_out)
);

endmodule
