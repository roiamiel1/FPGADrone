`timescale 1ns / 1ps

`include "signal_def.v"

`define I2C_STATE_IDLE              4'h0
`define I2C_STATE_START             4'h1
`define I2C_STATE_SEND_ADDRESS      4'h2
`define I2C_STATE_SEND_RW           4'h3
`define I2C_STATE_WAIT_ADDRESS_ACK  4'h4
`define I2C_STATE_SEND_REGISTER     4'h5
`define I2C_STATE_WAIT_REGISTER_ACK 4'h6
`define I2C_STATE_DATA              4'h7
`define I2C_STATE_DATA_ACK          4'h8
`define I2C_STATE_STOP              4'h9

module I2C_Master(
    // Device default wires.
	input wire clk,
	input wire rst,

	input wire [6:0] i2c_device_addr,       // Address of the target device.
    input wire [7:0] i2c_register_addr,     // Address of the register in the target device.
    input wire       i2c_rw,                // 1 - Read, 0 - Write.

    input wire [7:0] i2c_data_write,        // Data to write.
    output reg [7:0] i2c_data_read,         // Read data to this.

    // Module control lines
	input  wire start,  
	output reg  done,

    // I2C clock and data line.
    output scl,
    inout  sda
);

    // Constants
    parameter I2C_CYCLE_TICKS = `CLOCK_RATE / `I2C_BAUD_RATE;
    parameter I2C_CYCLE_TICKS_BITS = $clog2(I2C_CYCLE_TICKS);

    localparam I2C_CYCLE_TICKS_1_2 = I2C_CYCLE_TICKS / 2;
    localparam I2C_CYCLE_TICKS_1_3 = I2C_CYCLE_TICKS / 3;
    localparam I2C_CYCLE_TICKS_2_3 = I2C_CYCLE_TICKS_1_3 * 2;

    // ************* State *************
    // I2C Protocol State Machine
    reg[3:0] i2c_state = `I2C_STATE_IDLE;    // Holds the current state of the I2C communication.
    reg[2:0] i2c_counter = 3'b0;             // Counter for states that has multiple internal states (for reading/writing multiple bits).

    // Datalines state
    reg sda_enable = 0;
    reg scl_enable = 0;
    reg sda_out = 1;

    // ************* I2C Clock *************
    reg i2c_clk = 1'b0;
    reg [I2C_CYCLE_TICKS_BITS - 1:0] clk_counter = 0;

    // Initialize signals
    assign sda = sda_enable ? sda_out : 1'bz;
    assign scl = scl_enable ? (clk_counter >= I2C_CYCLE_TICKS_1_3 & clk_counter < I2C_CYCLE_TICKS_2_3) : 1;

    // **************************************

    always @(posedge clk, posedge rst) begin
        if (rst == 1 | clk_counter == I2C_CYCLE_TICKS - 1) begin
            clk_counter <= 0;
            i2c_clk <= 1'b0;
        end else begin
            clk_counter = clk_counter + 1'b1;
            i2c_clk = clk_counter >= I2C_CYCLE_TICKS_1_2;
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
                `I2C_STATE_IDLE: begin
                    sda_enable <= 1;
                    scl_enable <= 0;
                end

                `I2C_STATE_START: begin
                    sda_enable <= 1;
                    scl_enable <= 0;
                end

                `I2C_STATE_SEND_ADDRESS: begin
                    sda_enable <= 1;
                    scl_enable <= 1;
                end

                `I2C_STATE_SEND_RW: begin
                    sda_enable <= 1;
                    scl_enable <= 1;
                end

                `I2C_STATE_WAIT_ADDRESS_ACK: begin
                    sda_enable <= 0;
                end

                `I2C_STATE_WAIT_REGISTER_ACK: begin
                    sda_enable <= 0;
                end

                `I2C_STATE_SEND_REGISTER: begin
                    sda_enable <= 1;
                end

                `I2C_STATE_DATA: begin
                    sda_enable <= ~i2c_rw;
                end

                `I2C_STATE_DATA_ACK: begin
                    sda_enable <= i2c_rw;
                end

                `I2C_STATE_STOP: begin
                    sda_enable <= 0;
                    scl_enable <= 0;
                end
            endcase
        end
    end

    always @(negedge i2c_clk, posedge rst) begin
        if (rst == 1) begin
            i2c_state   <= `I2C_STATE_IDLE;
            i2c_counter <= 3'b0;
            sda_out     <= 1;
            done        <= 1'b0;
        end else begin
            case (i2c_state)
                `I2C_STATE_IDLE: begin
                    if (start) begin
                        i2c_state <= `I2C_STATE_START;
                        sda_out   <= 1;
                        done      <= 1'b0;
                    end
                end
                `I2C_STATE_START: begin
                    i2c_state <= `I2C_STATE_SEND_ADDRESS;
                    i2c_counter <= 3'b0;
                    sda_out <= 0;
                end
                `I2C_STATE_SEND_ADDRESS: begin
                    sda_out <= i2c_device_addr[3'h6 - i2c_counter];
                    // Check BEFORE incrementing so addr[0] is sent before transitioning
                    if (i2c_counter == 3'h6) begin
                        i2c_state   = `I2C_STATE_SEND_RW;
                        i2c_counter = 3'b0;
                    end else begin
                        i2c_counter = i2c_counter + 1'b1;
                    end
                end
                `I2C_STATE_SEND_RW: begin
                    sda_out <= i2c_rw;
                    i2c_state <= `I2C_STATE_WAIT_ADDRESS_ACK;
                end
                `I2C_STATE_WAIT_ADDRESS_ACK: begin
                    i2c_counter <= 3'b0;

                    if (~sda | sda)
                        i2c_state <= `I2C_STATE_SEND_REGISTER;
                end
                `I2C_STATE_SEND_REGISTER: begin
                    sda_out <= i2c_register_addr[3'h7 - i2c_counter];
                    // Check BEFORE incrementing so reg[0] is sent before transitioning
                    if (i2c_counter == 3'h7) begin
                        i2c_state   <= `I2C_STATE_WAIT_REGISTER_ACK;
                        i2c_counter = 3'b0;
                    end else begin
                        i2c_counter = i2c_counter + 1'b1;
                    end
                end
                `I2C_STATE_WAIT_REGISTER_ACK: begin
                    i2c_counter <= 3'b0;

                    if (~sda | sda)
                        i2c_state <= `I2C_STATE_DATA;
                end
                `I2C_STATE_DATA: begin
                    if (i2c_rw) begin
                        i2c_data_read[3'h7 - i2c_counter] <= sda;
                    end else begin
                        sda_out <= i2c_data_write[3'h7 - i2c_counter];
                    end
                    // Check BEFORE incrementing so bit[0] is processed before transitioning
                    if (i2c_counter == 3'h7) begin
                        i2c_state   = `I2C_STATE_DATA_ACK;
                        i2c_counter = 0;
                    end else begin
                        i2c_counter = i2c_counter + 1'b1;
                    end
                end
                `I2C_STATE_DATA_ACK: begin
                    if (i2c_rw)
                        sda_out <= 0;
                    
                    if (~sda | sda) begin
                        i2c_state <= `I2C_STATE_STOP;
                        i2c_counter <= 3'b0;
                    end
                end
                `I2C_STATE_STOP: begin
                    i2c_state   <= `I2C_STATE_IDLE;
                    i2c_counter <= 3'b0;
                    sda_out     <= 1;
                    done        <= 1'b1;
                end
            endcase
        end
    end

endmodule
