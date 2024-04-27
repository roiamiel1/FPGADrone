parameter CLOCK_FREQ = 27_000_000;  // 27MHz clock assumed
parameter I2C_FREQ = 300_000;       // 400kHz I2C frequency
parameter I2C_CYCLE_TICKS = CLOCK_FREQ / I2C_FREQ; // == 67.5 clock ticks per I2C tick

module I2C_Master(
    input clk,
    output scl,
    inout sda
);

/*
// I2C parameters
parameter SCL_HIGH_TIME = 10; // Adjust this according to your clock frequency
parameter SCL_LOW_TIME = 10;  // Adjust this according to your clock frequency
parameter START_CONDITION = 1'b1;
parameter STOP_CONDITION = 1'b0;
parameter DATA_BIT_WIDTH = 8;  // 8-bit data width
*/

/*
// I2C state machine
reg [2:0] state;
reg [7:0] data_reg;
reg ack;

// Counter for generating clock pulses
reg [7:0] count;
*/

// I2C States
parameter I2C_STATE_IDLE = 0;
parameter I2C_STATE_START = 1;
parameter I2C_STATE_SEND_ADDRESS = 2;
parameter I2C_STATE_SEND_RW = 3;
parameter I2C_STATE_WAIT_ADDRESS_ACK = 4;
parameter I2C_STATE_SEND_DATA = 5;
parameter I2C_STATE_WAIT_DATA_ACK = 6;
parameter I2C_STATE_STOP = 7;

// I2C State Machine
reg[2:0] i2c_state = I2C_STATE_IDLE;
reg[2:0] i2c_counter = 0;
reg[6:0] i2c_address = 8'b110_1000; // 0x68 MPU 6050 Address
reg i2c_rw = 0;
reg[7:0] i2c_data = 0;

reg sda_enable = 0;
reg scl_enable = 0;
reg sda_out = 1;
reg[17:0] clock_ticks = 0;

// Initialize signals
assign sda = sda_out | (~sda_enable);
assign scl = (clock_ticks >= ((I2C_CYCLE_TICKS / 2) + (I2C_CYCLE_TICKS / 6))) | (~scl_enable);

// State machine logic
always @(posedge clk)
begin
    clock_ticks <= clock_ticks + 1;
    if (clock_ticks == I2C_CYCLE_TICKS)
        clock_ticks <= 0;

    if (clock_ticks == (I2C_CYCLE_TICKS / 4)) begin
        case (i2c_state)
            I2C_STATE_IDLE: begin
                i2c_state <= I2C_STATE_START;
                i2c_counter <= 0;
            end
            I2C_STATE_START: begin
                sda_out <= 0;

                sda_enable <= 1;
                scl_enable <= 0;

                i2c_state <= I2C_STATE_SEND_ADDRESS;
                i2c_counter <= 0;
            end
            I2C_STATE_SEND_ADDRESS: begin
                scl_enable <= 1;

                sda_out <= i2c_address[6 - i2c_counter];
                i2c_counter <= i2c_counter + 1;
                
                if (i2c_counter == 6) begin
                    i2c_state <= I2C_STATE_SEND_RW;
                    i2c_counter <= 0;
                end
            end
            I2C_STATE_SEND_RW: begin
                sda_out <= i2c_rw;

                i2c_state <= I2C_STATE_WAIT_ADDRESS_ACK;
                i2c_counter <= 0;
            end
            I2C_STATE_WAIT_ADDRESS_ACK: begin
                sda_out <= 1;

                if (~sda) begin
                    i2c_state <= I2C_STATE_SEND_DATA;
                    i2c_counter <= 0;
                end
            end
            I2C_STATE_SEND_DATA: begin
                // Temp burn time.
                sda_enable <= 0;
                scl_enable <= 0;

                sda_out <= 1;
                i2c_counter <= i2c_counter + 1;

                if (i2c_counter == 7) begin
                    i2c_state <= I2C_STATE_IDLE;
                    i2c_counter <= 0;
                end
            end
            I2C_STATE_STOP: begin
                i2c_state <= I2C_STATE_STOP;
                i2c_counter <= 0;
            end
        endcase
    end

    /*
    if (!§) begin
        state <= IDLE;
        count <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                // Wait for start condition
                if (sda == 0 && scl == 1) begin
                    state <= START;
                    count <= 0;
                end
            end
            START: begin
                // Generate start condition
                scl <= 0;
                count <= count + 1;
                if (count == SCL_LOW_TIME) begin
                    scl <= 1;
                    count <= 0;
                    state <= SEND_ADDRESS;
                end
            end
            SEND_ADDRESS: begin
                // Send device address
                // Code to send device address (7-bit address + read/write bit) goes here
                state <= SEND_DATA;
            end
            SEND_DATA: begin
                // Send data
                // Code to send data goes here
                state <= ACK;
            end
            ACK: begin
                // Receive ACK
                // Code to receive ACK goes here
                state <= READ_DATA;
            end
            READ_DATA: begin
                // Read data
                // Code to read data goes here
                state <= IDLE;
            end
        endcase
    end
    */
end

endmodule
