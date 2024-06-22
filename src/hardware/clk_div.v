//`timescale 1ns / 1ps
module clk_div (
    input clk,
    input rst,
    input SW15,
    output CLK_CPU
);

// Clock divider

    reg[31:0]clkdiv;

    always @ (posedge clk or posedge rst)
        begin
            if (rst)
                clkdiv <= 0;
            else
                clkdiv <= clkdiv + 1'b1;
        end

    // SW=1 => T=5.36s
    // SW=1 => T=0.02s
    assign CLK_CPU=(SW15)?clkdiv[21]:clkdiv[29];

endmodule
