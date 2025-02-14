// This file contains multiple modules that will have to be used a lot, such as a register, multiplexer, multiplier, adder, comparator, rectifier.

module register
#(
    parameter int WIDTH = 24
)
(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);

always_ff @(posedge clk or posedge reset) begin
    //If reset is 1, set output to 0
    if(reset)
        out <= '0;
    //If enable is 1, set output to input
    else if (enable)
        out <= in;

end

endmodule

module delay 
#(
    parameter int WIDTH = 24,
    parameter int CYCLES = 2
)
(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);
logic [WIDTH-1:0] regs [CYCLES+1];

for(genvar i = 0; i < CYCLES; i++) begin : reg_array
    register #(.WIDTH(WIDTH))
    reg_array (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .in(regs[i]),
        .out(regs[i+1])
    );
end 
assign regs[0] = in;
assign out = regs[CYCLES];
endmodule



module multiplexer
#(
    parameter int WIDTH = 24
    
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
    parameter int WIDTH = 24
)
(
    input logic[WIDTH-1:0] a,
    input logic[WIDTH-1:0] b,
    output logic[2*WIDTH-1:0] product
);

assign product = signed'(a) * signed'(b); 

endmodule

module adder
#(
    parameter int WIDTH = 24
)
(
    input logic [WIDTH-1:0] in0, in1,
    input logic carry_in,
    output logic [WIDTH-1:0] sum,
    output logic carry_out
);

assign {carry_out, sum} = in0 + in1 + carry_in;

endmodule

module comparator
#(
    parameter int WIDTH = 24
)
(
    input logic [WIDTH-1:0] in0, in1,
    output logic out
);

    assign out = (in0 >= in1);

endmodule

module rectifier
#(
    parameter int WIDTH = 24
)
(
    input logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);
// Checks if last bit is 1, flips input sign if true.
    assign out = in[WIDTH-1] ? ~in + 1 : in;

endmodule