
// AUTO-GENERATED - DO NOT CHNAGE!
`ifndef DEBUG
module InstructionMemory (
    input wire clk,
    input wire [31:0] IMAdress,
    output reg [31:0] IR
);

    always @(negedge clk) begin
        IR <= (IMAdress == 32'h00000000) ? 32'h27bdfff8 :
         (IMAdress == 32'h00000001) ? 32'hafbe0004 :
         (IMAdress == 32'h00000002) ? 32'h03a0f025 :
         (IMAdress == 32'h00000003) ? 32'h00000000 :
         (IMAdress == 32'h00000004) ? 32'h240203eb :
         (IMAdress == 32'h00000005) ? 32'h80420000 :
         (IMAdress == 32'h00000006) ? 32'h00000000 :
         (IMAdress == 32'h00000007) ? 32'h1440fffc :
         (IMAdress == 32'h00000008) ? 32'h00000000 :
         (IMAdress == 32'h00000009) ? 32'h00001825 :
         (IMAdress == 32'h0000000a) ? 32'h240203e8 :
         (IMAdress == 32'h0000000b) ? 32'h80630000 :
         (IMAdress == 32'h0000000c) ? 32'h00000000 :
         (IMAdress == 32'h0000000d) ? 32'ha0430000 :
         (IMAdress == 32'h0000000e) ? 32'h240203e9 :
         (IMAdress == 32'h0000000f) ? 32'h24030001 :
         (IMAdress == 32'h00000010) ? 32'ha0430000 :
         (IMAdress == 32'h00000011) ? 32'h240203ea :
         (IMAdress == 32'h00000012) ? 32'h80420000 :
         (IMAdress == 32'h00000013) ? 32'h00000000 :
         (IMAdress == 32'h00000014) ? 32'h1040fffc :
         (IMAdress == 32'h00000015) ? 32'h00000000 :
         (IMAdress == 32'h00000016) ? 32'h240203e9 :
         (IMAdress == 32'h00000017) ? 32'ha0400000 :
         (IMAdress == 32'h00000018) ? 32'h240203eb :
         (IMAdress == 32'h00000019) ? 32'h80420000 :
         (IMAdress == 32'h0000001a) ? 32'h00000000 :
         (IMAdress == 32'h0000001b) ? 32'h1440fffc :
         (IMAdress == 32'h0000001c) ? 32'h00000000 :
         (IMAdress == 32'h0000001d) ? 32'h24030001 :
         (IMAdress == 32'h0000001e) ? 32'h240203e8 :
         (IMAdress == 32'h0000001f) ? 32'h80630000 :
         (IMAdress == 32'h00000020) ? 32'h00000000 :
         (IMAdress == 32'h00000021) ? 32'ha0430000 :
         (IMAdress == 32'h00000022) ? 32'h240203e9 :
         (IMAdress == 32'h00000023) ? 32'h24030001 :
         (IMAdress == 32'h00000024) ? 32'ha0430000 :
         (IMAdress == 32'h00000025) ? 32'h240203ea :
         (IMAdress == 32'h00000026) ? 32'h80420000 :
         (IMAdress == 32'h00000027) ? 32'h00000000 :
         (IMAdress == 32'h00000028) ? 32'h1040fffc :
         (IMAdress == 32'h00000029) ? 32'h00000000 :
         (IMAdress == 32'h0000002a) ? 32'h240203e9 :
         (IMAdress == 32'h0000002b) ? 32'ha0400000 :
         (IMAdress == 32'h0000002c) ? 32'h240203eb :
         (IMAdress == 32'h0000002d) ? 32'h80420000 :
         (IMAdress == 32'h0000002e) ? 32'h00000000 :
         (IMAdress == 32'h0000002f) ? 32'h1440fffc :
         (IMAdress == 32'h00000030) ? 32'h00000000 :
         (IMAdress == 32'h00000031) ? 32'h24030002 :
         (IMAdress == 32'h00000032) ? 32'h240203e8 :
         (IMAdress == 32'h00000033) ? 32'h80630000 :
         (IMAdress == 32'h00000034) ? 32'h00000000 :
         (IMAdress == 32'h00000035) ? 32'ha0430000 :
         (IMAdress == 32'h00000036) ? 32'h240203e9 :
         (IMAdress == 32'h00000037) ? 32'h24030001 :
         (IMAdress == 32'h00000038) ? 32'ha0430000 :
         (IMAdress == 32'h00000039) ? 32'h240203ea :
         (IMAdress == 32'h0000003a) ? 32'h80420000 :
         (IMAdress == 32'h0000003b) ? 32'h00000000 :
         (IMAdress == 32'h0000003c) ? 32'h1040fffc :
         (IMAdress == 32'h0000003d) ? 32'h00000000 :
         (IMAdress == 32'h0000003e) ? 32'h240203e9 :
         (IMAdress == 32'h0000003f) ? 32'ha0400000 :
         (IMAdress == 32'h00000040) ? 32'h240203eb :
         (IMAdress == 32'h00000041) ? 32'h80420000 :
         (IMAdress == 32'h00000042) ? 32'h00000000 :
         (IMAdress == 32'h00000043) ? 32'h1440fffc :
         (IMAdress == 32'h00000044) ? 32'h00000000 :
         (IMAdress == 32'h00000045) ? 32'h24030003 :
         (IMAdress == 32'h00000046) ? 32'h240203e8 :
         (IMAdress == 32'h00000047) ? 32'h80630000 :
         (IMAdress == 32'h00000048) ? 32'h00000000 :
         (IMAdress == 32'h00000049) ? 32'ha0430000 :
         (IMAdress == 32'h0000004a) ? 32'h240203e9 :
         (IMAdress == 32'h0000004b) ? 32'h24030001 :
         (IMAdress == 32'h0000004c) ? 32'ha0430000 :
         (IMAdress == 32'h0000004d) ? 32'h240203ea :
         (IMAdress == 32'h0000004e) ? 32'h80420000 :
         (IMAdress == 32'h0000004f) ? 32'h00000000 :
         (IMAdress == 32'h00000050) ? 32'h1040fffc :
         (IMAdress == 32'h00000051) ? 32'h00000000 :
         (IMAdress == 32'h00000052) ? 32'h240203e9 :
         (IMAdress == 32'h00000053) ? 32'ha0400000 :
         (IMAdress == 32'h00000054) ? 32'h1000ffaf :
         (IMAdress == 32'h00000055) ? 32'h00000000 :
         (IMAdress == 32'h00000056) ? 32'h00000000 :
         (IMAdress == 32'h00000057) ? 32'h00000000 :
         32'h00000000;
    end

endmodule
`else
module InstructionMemory(
    input wire clk,
    input wire [31:0] IMAdress,
    output reg [31:0] IR
);
    reg [31:0] IMem [1023:0];

    always @(negedge clk) begin
        IR <= IMem[IMAdress];
    end
    
endmodule
`endif
