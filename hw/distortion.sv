// This is the top level entity for the distortion module for the guitar pedal.

module distortion
#(
    parameter int WIDTH = 24
)
(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [WIDTH-1:0] in,
    input logic [WIDTH-1:0] gain,
    input logic [WIDTH-1:0] threshold,
    input logic [WIDTH-1:0] volume,
    output logic [WIDTH-1:0] out

);
logic comparator_out;
logic[2*WIDTH-1:0] data_register_out_fixed_point;
logic[2*WIDTH-1:0] gain_register_out_fixed_point;
logic[WIDTH-1:0] data_register_out;
logic[WIDTH-1:0] gain_register_out;
logic[WIDTH-1:0] threshold_register_out; 
logic[WIDTH-1:0] comparator_in;
logic[4*WIDTH-1:0] gained_signal;
logic[WIDTH-1:0] gained_signal_registered;
logic[WIDTH-1:0] clipped_signal;
logic[WIDTH-1:0] rectifier_out;
logic[WIDTH-1:0] gained_signal_delayed;

//This is a register that stores the threshold value.
register #(.WIDTH(WIDTH)) threshold_in (.in(threshold), .out(threshold_register_out), .#);
//This is a signed 24bit integer. It has 24 full bits and 0 fractional bits.
register #(.WIDTH(WIDTH)) data_in (.in(in), .out(data_register_out), .#);
//This is a 24bit fixed point signed number. It will be representing values between 0 and 8.
//The first 4 bits are for whole numbers and the remaining 20 are for fractional bits.
register #(.WIDTH(WIDTH)) gain_knob_in (.in(gain), .out(gain_register_out), .#);

//This converts the data from 24 bit signed to be 48 bits where the fixed-point decimal is in the middle.
assign data_register_out_fixed_point = {data_register_out, '0};
//This converts the gain_knob data to have its fixed-point decimal point in the middle to match the location of the data.
assign gain_register_out_fixed_point = {20'b00000000000000000000, gain_register_out, 4'b0000};

//This multiplier multiplies the gain with the data.
multiplier #(.WIDTH(WIDTH*2)) gain_multiplier (.a(data_register_out_fixed_point), .b(gain_register_out_fixed_point), .product(gained_signal));

//Stores multiplier output in register. Cuts off the upper 48 bits of multiplication and the last 24 bits since they are fractional bits.
register #(.WIDTH(WIDTH)) multiplier_register (.in.(gained_signal[2*WIDTH-1:WIDTH]), .out(gained_signal_registered), .#);

//This rectifier gets the output of the multiplier and turns it positive if it is negative. 
//This step is necessary since the comparison for the threshold is done against a positive number.
rectifier #(.WIDTH(WIDTH)) signal_rectifier (.in(gained_signal_registered), .out(rectifier_out));
register #(.WIDTH(WIDTH)) rectifier_register (.in(rectifier_out), .out(comparator_in), .#);

//This comparator compares if the data is larger than the threshold. If it is larger, it outputs True.
comparator #(.WIDTH(WIDTH)) threshold_comparator (.in0(comparator_in), .in1(threshold_register_out), .out(comparator_out));

//This register delays the gained_signal by 1 cycle to match the delay caused by the rectifier.
register #(.WIDTH(WIDTH)) threshold_mux_in_register (.in(gained_signal_registered), .out(gained_signal_delayed), .#);
//This mux does the audio clipping. If the data is larger than the threshold, it passes the data through. If not it passes the threshold through.
multiplexer #(.WIDTH(WIDTH)) threshold_mux (.in0(gained_signal_delayed), .in1(threshold_register_out), .sel(comparator_out), .out(clipped_signal));
register #(.WIDTH(WIDTH)) output_register (.in(clipped_signal), .#);
endmodule