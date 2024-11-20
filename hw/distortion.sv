// This is the top level entity for the distortion module for the guitar pedal.

module distortion
#(
    parameter WIDTH
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
logic[WIDTH-1:0] comparator_in;
logic[WIDTH-1:0] gained_signal;
logic[WIDTH-1:0] gained_signal_registered;
logic[WIDTH-1:0] mux_out;
logic[WIDTH-1:0] rectifier_in;
logic[WIDTH-1:0] rectifier_out;
logic[WIDTH-1:0] threshold_signal_input;


register #(.WIDTH(WIDTH)) multiplier_register (input(gained_signal), output(gained_signal_registered), .#);
rectifier #(.WIDTH(WIDTH)) signal_rectifier (input(rectifier_in), output(rectifier_out));
register #(.WIDTH(WIDTH)) rectifier_register (input(rectifier_out), output(comparator_in), .#);
comparator #(.WIDTH(WIDTH)) threshold_comparator (in0(comparator_in), in1(threshold), out(comparator_out));
register #(.WIDTH(WIDTH)) threshold_mux_in_register (input(gained_signal_registered), output(threshold_signal_input), .#);
multiplexer #(.WIDTH(WIDTH)) threshold_mux (.in0(threshold_signal_input), .in1(threshold), sel(comparator_out), .out(mux_out));

endmodule