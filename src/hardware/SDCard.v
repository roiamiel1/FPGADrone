//--------------------------------------------------------------------------------------------------------
// Module  : sdcmd_ctrl
// Type    : synthesizable, IP's sub module
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: sdcmd signal control,
//           instantiated by SDRreader
//--------------------------------------------------------------------------------------------------------

module sdcmd_ctrl (
    input  wire         rstn,
    input  wire         clk,
    // SDcard signals (sdclk and sdcmd)
    output reg          sdclk,
    inout               sdcmd,
    // config clk freq
    input  wire  [15:0] clkdiv,
    // user input signal
    input  wire         start,
    input  wire  [15:0] precnt,
    input  wire  [ 5:0] cmd,
    input  wire  [31:0] arg,
    // user output signal
    output reg          busy,
    output reg          done,
    output reg          timeout,
    output reg          syntaxe,
    output wire  [31:0] resparg
);


initial {busy, done, timeout, syntaxe} = 0;
initial sdclk = 1'b0;

localparam [7:0] TIMEOUT = 8'd250;

reg sdcmdoe  = 1'b0;
reg sdcmdout = 1'b1;

// sdcmd tri-state driver
assign sdcmd = sdcmdoe ? sdcmdout : 1'bz;
wire sdcmdin = sdcmdoe ? 1'b1 : sdcmd;

function  [6:0] CalcCrc7;
    input [6:0] crc;
    input [0:0] inbit;
//function automatic logic [6:0] CalcCrc7(input logic [6:0] crc, input logic inbit);
begin
    CalcCrc7 = ( {crc[5:0],crc[6]^inbit} ^ {3'b0,crc[6]^inbit,3'b0} );
end
endfunction

reg  [ 5:0] req_cmd = 6'd0;    // request[45:40]
reg  [31:0] req_arg = 0;       // request[39: 8]
reg  [ 6:0] req_crc = 7'd0;    // request[ 7: 1]
wire [51:0] request = {6'b111101, req_cmd, req_arg, req_crc, 1'b1};

//struct packed {
reg         resp_st;
reg  [ 5:0] resp_cmd;
reg  [31:0] resp_arg;
//} response = 0;

assign resparg = resp_arg;

reg  [17:0] clkdivr = 18'h3FFFF;
reg  [17:0] clkcnt  = 0;
reg  [15:0] cnt1 = 0;
reg  [ 5:0] cnt2 = 6'h3F;
reg  [ 7:0] cnt3 = 0;
reg  [ 7:0] cnt4 = 8'hFF;


always @ (posedge clk or negedge rstn)
    if(~rstn) begin
        {busy, done, timeout, syntaxe} <= 0;
        sdclk <= 1'b0;
        {sdcmdoe, sdcmdout} <= 2'b01;
        {req_cmd, req_arg, req_crc} <= 0;
        {resp_st, resp_cmd, resp_arg} <= 0;
        clkdivr <= 18'h3FFFF;
        clkcnt  <= 0;
        cnt1 <= 0;
        cnt2 <= 6'h3F;
        cnt3 <= 0;
        cnt4 <= 8'hFF;
    end else begin
        {done, timeout, syntaxe} <= 0;
        
        clkcnt <= ( clkcnt < {clkdivr[16:0],1'b1} ) ? (clkcnt+18'd1) : 18'd0;
        
        if     (clkcnt == 18'd0)
            clkdivr <= {2'h0, clkdiv} + 18'd1;
        
        if (clkcnt == clkdivr)
            sdclk <= 1'b0;
        else if (clkcnt == {clkdivr[16:0],1'b1} )
            sdclk <= 1'b1;
        
        if(~busy) begin
            if(start) busy <= 1'b1;
            req_cmd <= cmd;
            req_arg <= arg;
            req_crc <= 0;
            cnt1 <= precnt;
            cnt2 <= 6'd51;
            cnt3 <= TIMEOUT;
            cnt4 <= 8'd134;
        end else if(done) begin
            busy <= 1'b0;
        end else if( clkcnt == clkdivr) begin
            {sdcmdoe, sdcmdout} <= 2'b01;
            if     (cnt1 != 16'd0) begin
                cnt1 <= cnt1 - 16'd1;
            end else if(cnt2 != 6'h3F) begin
                cnt2 <= cnt2 - 6'd1;
                {sdcmdoe, sdcmdout} <= {1'b1, request[cnt2]};
                if(cnt2>=8 && cnt2<48) req_crc <= CalcCrc7(req_crc, request[cnt2]);
            end
        end else if( clkcnt == {clkdivr[16:0],1'b1} && cnt1==16'd0 && cnt2==6'h3F ) begin
            if(cnt3 != 8'd0) begin
                cnt3 <= cnt3 - 8'd1;
                if(~sdcmdin)
                    cnt3 <= 8'd0;
                else if(cnt3 == 8'd1)
                    {done, timeout, syntaxe} <= 3'b110;
            end else if(cnt4 != 8'hFF) begin
                cnt4 <= cnt4 - 8'd1;
                if(cnt4 >= 8'd96)
                    {resp_st, resp_cmd, resp_arg} <= {resp_cmd, resp_arg, sdcmdin};
                if(cnt4 == 8'd0) begin
                    {done, timeout} <= 2'b10;
                    syntaxe <= resp_st || ((resp_cmd!=req_cmd) && (resp_cmd!=6'h3F) && (resp_cmd!=6'd0));
                end
            end
        end
    end

endmodule


//--------------------------------------------------------------------------------------------------------
// Module  : SDRreader
// Type    : synthesizable, IP's top
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: A SD-host to initialize SD-card and read sector
//           Support CardType   : SDv1.1 , SDv2  or SDHCv2
//--------------------------------------------------------------------------------------------------------

module SDRreader # (
    parameter [2:0] CLK_DIV = 3'd2,     // when clk =   0~ 25MHz , set CLK_DIV = 3'd1,
                                        // when clk =  25~ 50MHz , set CLK_DIV = 3'd2,
                                        // when clk =  50~100MHz , set CLK_DIV = 3'd3,
                                        // when clk = 100~200MHz , set CLK_DIV = 3'd4,
                                        // ......
    parameter       SIMULATE = 0
) (
    // rstn active-low, 1:working, 0:reset
    input  wire         rstn,
    // clock
    input  wire         clk,
    // SDcard signals (connect to SDcard), this design do not use sddat1~sddat3.
    output wire         sdclk,
    inout               sdcmd,
    input  wire         sddat0,            // FPGA only read SDDAT signal but never drive it
    // show card status
    output wire [ 3:0]  card_stat,         // show the sdcard initialize status
    output reg  [ 1:0]  card_type,         // 0=UNKNOWN    , 1=SDv1    , 2=SDv2  , 3=SDHCv2
    // user read sector command interface (sync with clk)
    input  wire         rstart, 
    input  wire [31:0]  rsector,
    output wire         rbusy,
    output wire         rdone,
    // sector data output interface (sync with clk)
    output reg          outen,             // when outen=1, a byte of sector content is read out from outbyte
    output reg  [ 8:0]  outaddr,           // outaddr from 0 to 511, because the sector size is 512
    output reg  [ 7:0]  outbyte            // a byte of sector content
);


initial {outen, outaddr, outbyte} = 0;

localparam [1:0] UNKNOWN = 2'd0,      // SD card type
                 SDv1    = 2'd1,
                 SDv2    = 2'd2,
                 SDHCv2  = 2'd3;

localparam [15:0] FASTCLKDIV = (16'd1 << CLK_DIV) ;
localparam [15:0] SLOWCLKDIV = FASTCLKDIV * (SIMULATE ? 16'd5 : 16'd48);

reg        start  = 1'b0;
reg [15:0] precnt = 0;
reg [ 5:0] cmd    = 0;
reg [31:0] arg    = 0;
reg [15:0] clkdiv = SLOWCLKDIV;
reg [31:0] rsectoraddr = 0;

wire       busy, done, timeout, syntaxe;
wire[31:0] resparg;

reg        sdv1_maybe = 1'b0;
reg [ 2:0] cmd8_cnt   = 0;
reg [15:0] rca = 0;

localparam [3:0] CMD0      = 4'd0,
                 CMD8      = 4'd1,
                 CMD55_41  = 4'd2,
                 ACMD41    = 4'd3,
                 CMD2      = 4'd4,
                 CMD3      = 4'd5,
                 CMD7      = 4'd6,
                 CMD16     = 4'd7,
                 CMD17     = 4'd8,
                 READING   = 4'd9,
                 READING2  = 4'd10;

reg [3:0] sdcmd_stat = CMD0;
//enum logic [3:0] {CMD0, CMD8, CMD55_41, ACMD41, CMD2, CMD3, CMD7, CMD16, CMD17, READING, READING2} sdcmd_stat = CMD0;

reg        sdclkl = 1'b0;

localparam [2:0] RWAIT    = 3'd0,
                 RDURING  = 3'd1,
                 RTAIL    = 3'd2,
                 RDONE    = 3'd3,
                 RTIMEOUT = 3'd4;

reg [2:0] sddat_stat = RWAIT;

//enum logic [2:0] {RWAIT, RDURING, RTAIL, RDONE, RTIMEOUT} sddat_stat = RWAIT;

reg [31:0] ridx   = 0;

assign     rbusy  = (sdcmd_stat != CMD17) ;
assign     rdone  = (sdcmd_stat == READING2) && (sddat_stat==RDONE);

assign card_stat = sdcmd_stat;


sdcmd_ctrl u_sdcmd_ctrl (
    .rstn        ( rstn         ),
    .clk         ( clk          ),
    .sdclk       ( sdclk        ),
    .sdcmd       ( sdcmd        ),
    .clkdiv      ( clkdiv       ),
    .start       ( start        ),
    .precnt      ( precnt       ),
    .cmd         ( cmd          ),
    .arg         ( arg          ),
    .busy        ( busy         ),
    .done        ( done         ),
    .timeout     ( timeout      ),
    .syntaxe     ( syntaxe      ),
    .resparg     ( resparg      )
);


task set_cmd;
    input [ 0:0] _start;
    input [15:0] _precnt;
    input [ 5:0] _cmd;
    input [31:0] _arg;
//task automatic set_cmd(input _start, input[15:0] _precnt='0, input[5:0] _cmd='0, input[31:0] _arg='0 );
begin
    start  <= _start;
    precnt <= _precnt;
    cmd    <= _cmd;
    arg    <= _arg;
end
endtask




always @ (posedge clk or negedge rstn)
    if(~rstn) begin
        set_cmd(0,0,0,0);
        clkdiv      <= SLOWCLKDIV;
        rsectoraddr <= 0;
        rca         <= 0;
        sdv1_maybe  <= 1'b0;
        card_type   <= UNKNOWN;
        sdcmd_stat  <= CMD0;
        cmd8_cnt    <= 0;
    end else begin
        set_cmd(0,0,0,0);
        if(sdcmd_stat == READING2) begin
            if(sddat_stat==RTIMEOUT) begin
                set_cmd(1, 96, 17, rsectoraddr);
                sdcmd_stat <= READING;
            end else if(sddat_stat==RDONE)
                sdcmd_stat <= CMD17;
        end else if(~busy) begin
            case(sdcmd_stat)
                CMD0    :   set_cmd(1, (SIMULATE?512:64000),  0,  'h00000000);
                CMD8    :   set_cmd(1,                 512 ,  8,  'h000001aa);
                CMD55_41:   set_cmd(1,                 512 , 55,  'h00000000);
                ACMD41  :   set_cmd(1,                 256 , 41,  'h40100000);
                CMD2    :   set_cmd(1,                 256 ,  2,  'h00000000);
                CMD3    :   set_cmd(1,                 256 ,  3,  'h00000000);
                CMD7    :   set_cmd(1,                 256 ,  7, {rca,16'h0});
                CMD16   :   set_cmd(1, (SIMULATE?512:64000), 16,  'h00000200);
                CMD17   :   if(rstart) begin 
                                set_cmd(1, 96, 17, (card_type==SDHCv2) ? rsector : (rsector<<9) );
                                rsectoraddr <= (card_type==SDHCv2) ? rsector : (rsector<<9);
                                sdcmd_stat <= READING;
                            end
            endcase
        end else if(done) begin
            case(sdcmd_stat)
                CMD0    :   sdcmd_stat <= CMD8;
                CMD8    :   if(~timeout && ~syntaxe && resparg[7:0]==8'haa) begin
                                sdcmd_stat <= CMD55_41;
                            end else if(timeout) begin
                                cmd8_cnt <= cmd8_cnt + 3'd1;
                                if (cmd8_cnt == 3'b111) begin
                                    sdv1_maybe <= 1'b1;
                                    sdcmd_stat <= CMD55_41;
                                end
                            end
                CMD55_41:   if(~timeout && ~syntaxe)
                                sdcmd_stat <= ACMD41;
                ACMD41  :   if(~timeout && ~syntaxe && resparg[31]) begin
                                card_type <= sdv1_maybe ? SDv1 : (resparg[30] ? SDHCv2 : SDv2);
                                sdcmd_stat <= CMD2;
                            end else begin
                                sdcmd_stat <= CMD55_41;
                            end
                CMD2    :   if(~timeout && ~syntaxe)
                                sdcmd_stat <= CMD3;
                CMD3    :   if(~timeout && ~syntaxe) begin
                                rca <= resparg[31:16];
                                sdcmd_stat <= CMD7;
                            end
                CMD7    :   if(~timeout && ~syntaxe) begin
                                clkdiv  <= FASTCLKDIV;
                                sdcmd_stat <= CMD16;
                            end
                CMD16   :   if(~timeout && ~syntaxe)
                                sdcmd_stat <= CMD17;
                default : //READING :   
                            if(~timeout && ~syntaxe)
                                sdcmd_stat <= READING2;
                            else
                                set_cmd(1, 128, 17, rsectoraddr);
            endcase
        end
    end


always @ (posedge clk or negedge rstn)
    if(~rstn) begin
        outen   <= 1'b0;
        outaddr <= 0;
        outbyte <= 0;
        sdclkl  <= 1'b0;
        sddat_stat <= RWAIT;
        ridx    <= 0;
    end else begin
        outen   <= 1'b0;
        outaddr <= 0;
        sdclkl  <= sdclk;
        if(sdcmd_stat!=READING && sdcmd_stat!=READING2) begin
            sddat_stat <= RWAIT;
            ridx   <= 0;
        end else if(~sdclkl & sdclk) begin
            case(sddat_stat)
                RWAIT   : begin
                    if(~sddat0) begin
                        sddat_stat <= RDURING;
                        ridx   <= 0;
                    end else begin
                        if(ridx > 1000000)      // according to SD datasheet, 1ms is enough to wait for DAT result, here, we set timeout to 1000000 clock cycles = 80ms (when SDCLK=12.5MHz)
                            sddat_stat <= RTIMEOUT;
                        ridx   <= ridx + 1;
                    end
                end
                RDURING : begin
                    outbyte[3'd7 - ridx[2:0]] <= sddat0;
                    if(ridx[2:0] == 3'd7) begin
                        outen  <= 1'b1;
                        outaddr<= ridx[11:3];
                    end
                    if(ridx >= 512*8-1) begin
                        sddat_stat <= RTAIL;
                        ridx   <= 0; 
                    end else begin
                        ridx   <= ridx + 1;
                    end
                end
                RTAIL   : begin
                    if (ridx >= 8*8-1)
                        sddat_stat <= RDONE;
                    ridx   <= ridx + 1;
                end
            endcase
        end
    end


endmodule
