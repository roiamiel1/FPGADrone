function integer rlog2ceil;
    input real x;
    begin
        rlog2ceil = $ceil($ln(x)/$ln(2));
    end
endfunction

localparam CLOCK_FREQ = 27_000_000;  // 27MHz clock assumed

module I2C_Master(
    // Device default wires.
	input wire clk,
	input wire rst,

	input wire [6:0] i2c_device_addr,       // Address of the target device.
    input wire [7:0] i2c_register_addr,     // Address of the register in the target device.
    input wire i2c_rw,                      // 1 - Read, 0 - Write.

    input wire [7:0] i2c_data_write,        // Data to write.
    output reg [7:0] i2c_data_read,         // Read data to this.

    // TODO: implement
	wire enable,  
	output wire ready,

    // I2C clock and data line.
    output scl,
    inout sda
);
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

    // Constants.
    /*
    localparam I2C_FREQ = 400_000;                                  // 400kHz I2C frequency
    localparam I2C_CYCLE_TICKS = (CLOCK_FREQ / I2C_FREQ);           // == 67.5 clock ticks per I2C tick
    localparam I2C_CYCLE_TICKS_BITS = 7;                            // CEIL(LOG2(67.5)) == 7
    */
    localparam I2C_FREQ = 1_000;                                  // 400kHz I2C frequency
    localparam I2C_CYCLE_TICKS = (CLOCK_FREQ / I2C_FREQ);           // == 270 clock ticks per I2C tick
    localparam I2C_CYCLE_TICKS_BITS = 30;                            // CEIL(LOG2(270)) == 9

    localparam I2C_CYCLE_TICKS_1_2 = I2C_CYCLE_TICKS / 2;
    localparam I2C_CYCLE_TICKS_1_3 = I2C_CYCLE_TICKS / 3;
    localparam I2C_CYCLE_TICKS_2_3 = I2C_CYCLE_TICKS_1_3 * 2;

    // ************* State *************
    // I2C Protocol State Machine
    reg[3:0] i2c_state = I2C_STATE_IDLE;    // Holds the current state of the I2C communication.
    reg[2:0] i2c_counter = 0;               // Counter for states that has multiple internal states (for reading/writing multiple bits).

    // Datalines state
    reg sda_enable = 0;
    reg scl_enable = 0;
    reg sda_out = 1;

    // ************* I2C Clock *************
    reg i2c_clk = 1;
    reg [I2C_CYCLE_TICKS_BITS - 1:0] clk_counter = 0;

    // Initialize signals
    assign sda = sda_enable ? sda_out : 1'bz;
    assign scl = scl_enable ? (clk_counter >= I2C_CYCLE_TICKS_1_3 & clk_counter < I2C_CYCLE_TICKS_2_3) : 1;

    // **************************************

    always @(posedge clk, posedge rst) begin
        if (rst == 1 | clk_counter == I2C_CYCLE_TICKS - 1) begin
            clk_counter <= 0;
            i2c_clk <= 0;
        end else begin
            clk_counter <= clk_counter + 1;
            i2c_clk <= clk_counter >= I2C_CYCLE_TICKS_1_2;
        end
    end
    // **************************************	

    // ************* I2C Protocol Logic *************
    // Pre state logic
    always @(posedge clk, posedge rst) begin
        if (rst == 1) begin
            sda_enable <= 0;
            scl_enable <= 0;
        end else if (clk_counter == I2C_CYCLE_TICKS - 4) begin
            case (i2c_state)
                I2C_STATE_IDLE: begin
                    sda_enable <= 1;
                    scl_enable <= 0;
                end

                I2C_STATE_START: begin
                    sda_enable <= 1;
                    scl_enable <= 0;
                end

                I2C_STATE_SEND_ADDRESS: begin
                    sda_enable <= 1;
                    scl_enable <= 1;
                end

                I2C_STATE_SEND_RW: begin
                    sda_enable <= 1;
                    scl_enable <= 1;
                end

                I2C_STATE_WAIT_ADDRESS_ACK: begin
                    sda_enable <= 0;
                end

                I2C_STATE_WAIT_REGISTER_ACK: begin
                    sda_enable <= 0;
                end

                I2C_STATE_SEND_REGISTER: begin
                    sda_enable <= 1;
                end

                I2C_STATE_DATA: begin
                    sda_enable <= ~i2c_rw;
                end

                I2C_STATE_DATA_ACK: begin
                    sda_enable <= i2c_rw;
                end

                I2C_STATE_STOP: begin
                    sda_enable <= 0;
                    scl_enable <= 0;
                end
            endcase
        end
    end

    always @(negedge i2c_clk, posedge rst) begin
        if (rst == 1) begin
            i2c_state <= I2C_STATE_START;
            i2c_counter <= 0;
            sda_out <= 1;
        end else begin
            case (i2c_state)
                I2C_STATE_IDLE: begin
                    if (enable) begin
                        i2c_state <= I2C_STATE_START;
                        sda_out <= 1;
                    end
                end
                I2C_STATE_START: begin
                    sda_out <= 0;
                    i2c_counter <= 0;
                    i2c_state <= I2C_STATE_SEND_ADDRESS;
                end
                I2C_STATE_SEND_ADDRESS: begin
                    sda_out <= i2c_device_addr[6 - i2c_counter];
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
                    sda_out <= i2c_register_addr[7 - i2c_counter];
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
                        i2c_data_read[7 - i2c_counter] <= sda;
                    else
                        sda_out <= i2c_data_write[7 - i2c_counter];

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
                    sda_out <= 1;

                    i2c_state <= I2C_STATE_IDLE;
                    i2c_counter <= 0;
                end
            endcase
        end
    end

endmodule

module ArduinoPrint(
    input wire rst,
    input wire clk,
    wire enable,

	inout i2c_sda,
	wire i2c_scl,
    
    input wire [7:0] byte1,
    input wire [7:0] byte2
);
	// Inputs
	reg [6:0] device_addr = 7'b1101000;
	
	reg rw = 0; // 1 - read, 0 - write

	// Outputs
	wire [7:0] data_read;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	I2C_Master master (
        .clk(clk),
        .rst(rst),
        .i2c_device_addr(device_addr),
        .i2c_register_addr(byte1),
        .i2c_data_write(byte2),
        .i2c_rw(rw),
        .i2c_data_read(data_read),
        .enable(enable),
        .ready(ready),
        .scl(i2c_scl),
        .sda(i2c_sda)
	);
endmodule

/*
module Main(
    wire clk,
	inout i2c_sda,
	wire i2c_scl
);
	// Inputs
	reg rst = 0;
	reg [6:0] device_addr = 7'b1101000;
    reg [7:0] register_addr = 8'b10101010;
	reg [7:0] data_write = 8'b10111010;
	reg enable = 1;
	reg rw = 0; // 1 - read, 0 - write

	// Outputs
	wire [7:0] data_read;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	I2C_Master master (
        .clk(clk),
        .rst(rst),
        .i2c_device_addr(device_addr),
        .i2c_register_addr(register_addr),
        .i2c_rw(rw),
        .i2c_data_write(data_write),
        .i2c_data_read(data_read),
        .enable(enable),
        .ready(ready),
        .scl(i2c_scl),
        .sda(i2c_sda)
	);
	
	initial begin
        $display("-------------- THE SIMULATION STARTED ------------");  
		// Initialize Inputs
        rst = 1;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        rst = 0;		
        device_addr = 7'h68;
        register_addr = 8'b10101010;
        data_write = 8'b10111010;
        rw = 0;	
        enable = 1;
        #10;
        enable = 0;
                
        #500;
		$finish;	
        $display("-------------- THE SIMULATION FINISHED ------------");  
	end      
endmodule
*/

module Main(
    wire clk,
	inout i2c_sda,
	wire i2c_scl
);
	// Inputs
	reg rst = 0;
	reg [6:0] device_addr = 7'b1101000;
    reg [7:0] register_addr = 8'b10101010;
	reg [7:0] data_write = 8'b10111010;
	reg enable = 1;
	reg rw = 0; // 1 - read, 0 - write

	reg [7:0] byte1;
    reg [7:0] byte2;

	// Instantiate the Unit Under Test (UUT)
	ArduinoPrint print (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .i2c_scl(i2c_scl),
        .i2c_sda(i2c_sda),
        .byte1(byte1),
        .byte2(byte2)
	);

/*
    initial begin
        rst <= 0;	
        byte1 <= 72;
        byte2 <= 69;
        enable <= 1;
        #10;
        enable <= 0;
        #10;
        rst <= 0;	
        byte1 <= 76;
        byte2 <= 76;
        enable <= 1;
        #10;
        enable <= 0;
        #10;
        rst <= 0;	
        byte1 <= 79;
        byte2 <= 10;
        enable <= 1;
        #10;
        enable <= 0;
        #10;
    end   
*/  
endmodule
