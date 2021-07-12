/*
	5 bit and 32 bit MUX modules
*/

module MUX_5bit (a, b, Sel, mux_out);

    input [4:0] a, b;
    input Sel;
    output [4:0] mux_out;

	assign mux_out = Sel?b:a;

endmodule

module MUX_32bit (a, b, Sel, mux_out);

    input [31:0] a, b;
    input Sel;
    output [31:0] mux_out;

	assign mux_out = Sel?b:a;

endmodule