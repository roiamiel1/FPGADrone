
module Extender(
    input [15:0] DataIn,
    input ExtOp,
    output [31:0] ExtOut
);

    assign ExtOut = {ExtOp ? {16{DataIn[15]}} : 16'b0, DataIn[15:0]};

endmodule
