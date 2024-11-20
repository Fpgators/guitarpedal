// This is the top level entity for the distortion module for the guitar pedal.

module distortion
#(
    parameter WIDTH
)
(
    input logic clk,
    input logic reset,
    input logic [WIDTH-1:0] in,
    input logic [WIDTH-1:0] gain,
    input logic [WIDTH-1:0] threshold,
    output logic [WIDTH-1:0] out

);

endmodule