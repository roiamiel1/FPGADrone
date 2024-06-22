
module GPR (
    input clk,
    input rst,
    input RegWrite,
    input [4:0] ReadRegister1,
    input [4:0] ReadRegister2,
    input [4:0] WriteRegister,
    input [31:0] WriteData,
    output [31:0] DataOut1,
    output [31:0] DataOut2
);
    integer i;
    reg [31:0] gprRegisters [31:0];

    assign DataOut1 = gprRegisters[ReadRegister1];
    assign DataOut2 = gprRegisters[ReadRegister2];

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            gprRegisters[i] <= 0;
        end
    end

    always @(negedge clk, posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                gprRegisters[i] <= 0;
            end
        end else begin
            if(RegWrite) begin
                gprRegisters[WriteRegister] <= (WriteRegister)?WriteData:32'b0;
            end
        end
    end

endmodule
