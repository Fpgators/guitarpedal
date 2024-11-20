// This file contains multiple modules that will have to be used a lot, such as a register, multiplexer, multiplier, adder, comparator, rectifier.

module register
#(
    parameter WIDTH
)
(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);

always_ff @(posedge clk or posedge rst) begin
    //If reset is 1, set output to 0
    if(reset)
        out <= '0;
    //If enable is 1, set output to input
    else if (enable)
        out <= in;

end

endmodule

module multiplexer
#(
    parameter WIDTH
    
)
(
    input logic [WIDTH-1:0] in0,
    input logic [WIDTH-1:0] in1,
    input logic sel,
    output logic [WIDTH-1:0]out
);

//If select is 1 bring in1 to otput, otherwise bring in0
assign out = sel == 1'b1 ? in1 : in0;

endmodule

module multiplier
#(
    parameter WIDTH
)
(
    input logic[WIDTH-1:0] a,
    input logic[WIDTH-1:0] b,
    input logic[2*WIDTH-1:0] product
);

assign product = signed'a * signed'b; 

endmodule

module adder
#(
    parameter WIDTH
)
(
    input logic [WIDTH-1:0] in0, in1,
    input logic carry_in,
    output logic [WIDTH-1:0] sum,
    output logic carry_out,
);

assign {carry_out, sum} = in0 + in1 + carry_in;

endmodule

module comparator
#(
    parameter WIDTH
)
(
    input logic [WIDTH-1:0] in0, in1,
    output logic out,
);

    assign out = (in0 >= in1);

endmodule

module rectifier
#(
    parameter WIDTH
)
(
    input logic [WIDTH-1:0] input,
    output logic [WIDTH-1:0] output,
);
// Checks if last bit is 1, flips input sign if true.
    assign output = input[WIDTH-1] ? ~input + 1 : input;

endmodule