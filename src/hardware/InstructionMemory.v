
// AUTO-GENERATED - DO NOT CHNAGE!
module InstructionMemory (
    input [31:0] IMAdress,
    output reg [31:0] IR
);

always @(IMAdress) begin
    IR = (IMAdress == 32'h00000000) ? 32'h27bdffe0 :
         (IMAdress == 32'h00000001) ? 32'hafbe001c :
         (IMAdress == 32'h00000002) ? 32'h03a0f025 :
         (IMAdress == 32'h00000003) ? 32'h24020005 :
         (IMAdress == 32'h00000004) ? 32'hafc20010 :
         (IMAdress == 32'h00000005) ? 32'h3c020040 :
         (IMAdress == 32'h00000006) ? 32'hc44001f0 :
         (IMAdress == 32'h00000007) ? 32'h00000000 :
         (IMAdress == 32'h00000008) ? 32'he7c00008 :
         (IMAdress == 32'h00000009) ? 32'h8fc20010 :
         (IMAdress == 32'h0000000a) ? 32'h00000000 :
         (IMAdress == 32'h0000000b) ? 32'h44820000 :
         (IMAdress == 32'h0000000c) ? 32'h00000000 :
         (IMAdress == 32'h0000000d) ? 32'h46800020 :
         (IMAdress == 32'h0000000e) ? 32'hc7c20008 :
         (IMAdress == 32'h0000000f) ? 32'h00000000 :
         (IMAdress == 32'h00000010) ? 32'h46001000 :
         (IMAdress == 32'h00000011) ? 32'he7c00008 :
         (IMAdress == 32'h00000012) ? 32'hafc0000c :
         (IMAdress == 32'h00000013) ? 32'h1000000e :
         (IMAdress == 32'h00000014) ? 32'h00000000 :
         (IMAdress == 32'h00000015) ? 32'h8fc20010 :
         (IMAdress == 32'h00000016) ? 32'h00000000 :
         (IMAdress == 32'h00000017) ? 32'h44820000 :
         (IMAdress == 32'h00000018) ? 32'h00000000 :
         (IMAdress == 32'h00000019) ? 32'h46800020 :
         (IMAdress == 32'h0000001a) ? 32'hc7c20008 :
         (IMAdress == 32'h0000001b) ? 32'h00000000 :
         (IMAdress == 32'h0000001c) ? 32'h46001000 :
         (IMAdress == 32'h0000001d) ? 32'he7c00008 :
         (IMAdress == 32'h0000001e) ? 32'h8fc2000c :
         (IMAdress == 32'h0000001f) ? 32'h00000000 :
         (IMAdress == 32'h00000020) ? 32'h24420001 :
         (IMAdress == 32'h00000021) ? 32'hafc2000c :
         (IMAdress == 32'h00000022) ? 32'h8fc2000c :
         (IMAdress == 32'h00000023) ? 32'h00000000 :
         (IMAdress == 32'h00000024) ? 32'h2842000a :
         (IMAdress == 32'h00000025) ? 32'h1440ffef :
         (IMAdress == 32'h00000026) ? 32'h00000000 :
         (IMAdress == 32'h00000027) ? 32'h00001025 :
         (IMAdress == 32'h00000028) ? 32'h03c0e825 :
         (IMAdress == 32'h00000029) ? 32'h8fbe001c :
         (IMAdress == 32'h0000002a) ? 32'h27bd0020 :
         (IMAdress == 32'h0000002b) ? 32'h03e00008 :
         (IMAdress == 32'h0000002c) ? 32'h00000000 :
         (IMAdress == 32'h0000002d) ? 32'h00000000 :
         (IMAdress == 32'h0000002e) ? 32'h00000000 :
         (IMAdress == 32'h0000002f) ? 32'h00000000 :

         32'h00000000;
    end
endmodule
