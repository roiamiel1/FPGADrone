// AUTO-GENERATED - DO NOT CHNAGE!
module ROM32 (
    input [25:0] address,
    output reg [31:0] data
);

always @(*) begin
    data = (address == 26'h0000000) ? 32'h27bdffe0 :
           (address == 26'h0000001) ? 32'hafbe001c :
           (address == 26'h0000002) ? 32'h03a0f025 :
           (address == 26'h0000003) ? 32'h24020005 :
           (address == 26'h0000004) ? 32'hafc20010 :
           (address == 26'h0000005) ? 32'h3c020040 :
           (address == 26'h0000006) ? 32'hc44001f0 :
           (address == 26'h0000007) ? 32'h00000000 :
           (address == 26'h0000008) ? 32'he7c00008 :
           (address == 26'h0000009) ? 32'h8fc20010 :
           (address == 26'h000000a) ? 32'h00000000 :
           (address == 26'h000000b) ? 32'h44820000 :
           (address == 26'h000000c) ? 32'h00000000 :
           (address == 26'h000000d) ? 32'h46800020 :
           (address == 26'h000000e) ? 32'hc7c20008 :
           (address == 26'h000000f) ? 32'h00000000 :
           (address == 26'h0000010) ? 32'h46001000 :
           (address == 26'h0000011) ? 32'he7c00008 :
           (address == 26'h0000012) ? 32'hafc0000c :
           (address == 26'h0000013) ? 32'h1000000e :
           (address == 26'h0000014) ? 32'h00000000 :
           (address == 26'h0000015) ? 32'h8fc20010 :
           (address == 26'h0000016) ? 32'h00000000 :
           (address == 26'h0000017) ? 32'h44820000 :
           (address == 26'h0000018) ? 32'h00000000 :
           (address == 26'h0000019) ? 32'h46800020 :
           (address == 26'h000001a) ? 32'hc7c20008 :
           (address == 26'h000001b) ? 32'h00000000 :
           (address == 26'h000001c) ? 32'h46001000 :
           (address == 26'h000001d) ? 32'he7c00008 :
           (address == 26'h000001e) ? 32'h8fc2000c :
           (address == 26'h000001f) ? 32'h00000000 :
           (address == 26'h0000020) ? 32'h24420001 :
           (address == 26'h0000021) ? 32'hafc2000c :
           (address == 26'h0000022) ? 32'h8fc2000c :
           (address == 26'h0000023) ? 32'h00000000 :
           (address == 26'h0000024) ? 32'h2842000a :
           (address == 26'h0000025) ? 32'h1440ffef :
           (address == 26'h0000026) ? 32'h00000000 :
           (address == 26'h0000027) ? 32'h00001025 :
           (address == 26'h0000028) ? 32'h03c0e825 :
           (address == 26'h0000029) ? 32'h8fbe001c :
           (address == 26'h000002a) ? 32'h27bd0020 :
           (address == 26'h000002b) ? 32'h03e00008 :
           (address == 26'h000002c) ? 32'h00000000 :
           (address == 26'h000002d) ? 32'h00000000 :
           (address == 26'h000002e) ? 32'h00000000 :
           (address == 26'h000002f) ? 32'h00000000 :
           32'h00000000;
    end
endmodule
