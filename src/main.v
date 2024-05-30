function integer rlog2ceil;
    input real x;
    begin
        rlog2ceil = $ceil($ln(x)/$ln(2));
    end
endfunction

localparam CLOCK_FREQ = 27_000_000;  // 27MHz clock assumed
localparam I2C_FREQ = 400_000;       // 400kHz I2C frequency

localparam I2C_CYCLE_TICKS = (CLOCK_FREQ / I2C_FREQ) * 4; // == 67.5 clock ticks per I2C tick // TODO remove * 4
localparam I2C_CYCLE_TICKS_BITS = 7;

module I2C_Master(
    input clk,
    output scl,
    inout sda
);
    // ************* I2C Clock *************
    reg i2c_clk = 1;
    reg [I2C_CYCLE_TICKS_BITS - 1:0] clk_counter = 0;

    always @(posedge clk) begin
        if (clk_counter == I2C_CYCLE_TICKS - 1) begin
            i2c_clk <= ~i2c_clk;
            clk_counter <= 0;
        end
        else clk_counter <= clk_counter + 1;
    end
    // **************************************

/*
 * I2C States
 * Each I2C State has a pre-state and a state positions.
 * Pre state comes before that state.
 * Each state is represented by a number.
 */
parameter I2C_STATE_IDLE                = 0;
parameter I2C_STATE_START               = 1;
parameter I2C_STATE_SEND_ADDRESS        = 2;
parameter I2C_STATE_SEND_RW             = 3;
parameter I2C_STATE_WAIT_ADDRESS_ACK    = 4;
parameter I2C_STATE_SEND_REGISTER       = 5;
parameter I2C_STATE_WAIT_REGISTER_ACK   = 6;
parameter I2C_STATE_DATA                = 7;
parameter I2C_STATE_DATA_ACK            = 8;
parameter I2C_STATE_STOP                = 9;

// I2C State Machine
reg[3:0] i2c_state = I2C_STATE_IDLE;
reg[2:0] i2c_counter = 0;
reg[6:0] i2c_address = 7'b110_1000;     // 0x68 MPU 6050 Address.
reg i2c_rw = 1;                         // 1 - Read, 0 - Write.
reg[7:0] i2c_register = 8'b0011_1100;   // ACCEL_XOUT_L - 60
reg[7:0] i2c_data = 8'b0;

reg sda_enable = 0;
reg scl_enable = 0;
reg sda_out = 1;
reg[24:0] clock_ticks = 0; // TODO: what is the right size?

// Initialize signals
assign sda = sda_enable ? sda_out : 1'bz;
assign scl = (clock_ticks >= ((I2C_CYCLE_TICKS / 2) + (I2C_CYCLE_TICKS / 6))) | (~scl_enable);

// State machine logic
always @(posedge clk)
begin
    clock_ticks <= clock_ticks + 1;
    if (clock_ticks == I2C_CYCLE_TICKS)
        clock_ticks <= 0;
    
    if (clock_ticks == ((I2C_CYCLE_TICKS / 4) - 4)) begin
        // Pre-state code.
        case (i2c_state)
            I2C_STATE_START: begin
            end
            I2C_STATE_SEND_ADDRESS: begin
            end
            I2C_STATE_WAIT_ADDRESS_ACK: begin
                sda_enable <= 0;
            end
            I2C_STATE_SEND_REGISTER: begin
                sda_enable <= 1;
            end
            I2C_STATE_WAIT_REGISTER_ACK: begin
                sda_enable <= 0;
            end
            I2C_STATE_DATA: begin
                sda_enable <= ~i2c_rw;
            end
            I2C_STATE_DATA_ACK: begin
                sda_enable <= i2c_rw;
            end
        endcase
    end
    else if (clock_ticks == (I2C_CYCLE_TICKS / 4)) begin
        // State code.
        case (i2c_state)
            I2C_STATE_IDLE: begin
                i2c_state <= I2C_STATE_START;
            end
            I2C_STATE_START: begin
                sda_enable <= 1;
                sda_out <= 0;

                scl_enable <= 0;

                i2c_counter <= 0;
                i2c_state <= I2C_STATE_SEND_ADDRESS;
            end
            I2C_STATE_SEND_ADDRESS: begin
                scl_enable <= 1;

                sda_out <= i2c_address[6 - i2c_counter];
                i2c_counter <= i2c_counter + 1;
                
                if (i2c_counter == 6)
                    i2c_state <= I2C_STATE_SEND_RW;
            end
            I2C_STATE_SEND_RW: begin
                sda_out <= i2c_rw;
                i2c_state <= I2C_STATE_WAIT_ADDRESS_ACK;
            end
            I2C_STATE_WAIT_ADDRESS_ACK: begin
                i2c_counter <= 0;

                if (~sda | sda)
                    i2c_state <= I2C_STATE_SEND_REGISTER;
            end
            I2C_STATE_SEND_REGISTER: begin
                sda_out <= i2c_register[7 - i2c_counter];
                i2c_counter <= i2c_counter + 1;
                
                if (i2c_counter == 7)
                    i2c_state <= I2C_STATE_WAIT_REGISTER_ACK;
            end
            I2C_STATE_WAIT_REGISTER_ACK: begin
                i2c_counter <= 0;

                if (~sda | sda)
                    i2c_state <= I2C_STATE_DATA;
            end
            I2C_STATE_DATA: begin
                if (i2c_rw)
                    i2c_data[7 - i2c_counter] <= sda;
                else
                    sda_out <= i2c_data[7 - i2c_counter];

                i2c_counter <= i2c_counter + 1;

                if (i2c_counter == 7) begin
                    i2c_state <= I2C_STATE_DATA_ACK;
                    i2c_counter <= 0;
                end
            end
            I2C_STATE_DATA_ACK: begin
                if (i2c_rw)
                    sda_out <= 0;
                
                if (~sda | sda) begin
                    i2c_state <= I2C_STATE_STOP;
                    i2c_counter <= 0;
                end
            end
            I2C_STATE_STOP: begin
                sda_enable <= 0;
                scl_enable <= 0;
                sda_out <= 1;

                i2c_state <= I2C_STATE_IDLE;
                i2c_counter <= 0;
            end
        endcase
    end
end

endmodule

module Main(
    input clk,
    output i2c_clockline,
    inout i2c_dataline
)


	// Inputs
	reg clk;
	reg rst;
	reg [6:0] addr;
	reg [7:0] data_in;
	reg enable;
	reg rw;

	// Outputs
	wire [7:0] data_out;
	wire ready;

	// Bidirs
	wire i2c_sda;
	wire i2c_scl;

	// Instantiate the Unit Under Test (UUT)
	i2c_controller master (
		.clk(clk), 
		.rst(rst), 
		.addr(addr), 
		.data_in(data_in), 
		.enable(enable), 
		.rw(rw), 
		.data_out(data_out), 
		.ready(ready), 
		.i2c_sda(i2c_sda), 
		.i2c_scl(i2c_scl)
	);
	
		
	i2c_slave_controller slave (
    .sda(i2c_sda), 
    .scl(i2c_scl)
    );
	
	initial begin
		clk = 0;
		forever begin
			clk = #1 ~clk;
		end		
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;		
		addr = 7'b0101010;
		data_in = 8'b10101010;
		rw = 0;	
		enable = 1;
		#10;
		enable = 0;
				
		#500
		$finish;
		
	end      

endmodule