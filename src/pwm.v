parameter US_IN_SEC = 1000000;
parameter CLOCK_FREQ = 27_000_000;  // 27MHz clock assumed
parameter PWM_FREQ = 50;            // 50Hz PWM frequency
parameter PWM_CYCLE_TICKS = CLOCK_FREQ / PWM_FREQ;
parameter PWM_US_CLOCK_TICKS = CLOCK_FREQ / US_IN_SEC;

parameter PWM_WIDTH_US = 1400;

module PWM_Generator_Verilog(clk, pwm_out);
    input clk;
    output pwm_out;

    reg[24:0] clock_ticks = 0;
    reg[24:0] pulse_width_clock_ticks = PWM_WIDTH_US * PWM_US_CLOCK_TICKS;

    assign pwm_out = clock_ticks < pulse_width_clock_ticks;

    always @(posedge clk)
    begin
        clock_ticks <= clock_ticks + 1;
        if (clock_ticks >= PWM_CYCLE_TICKS)
            clock_ticks <= 0;
    end
endmodule