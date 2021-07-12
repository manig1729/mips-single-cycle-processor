/*
    32 bit adder
	Used for adding the branch offset to PC + 4
*/

module adder (n1, n2, adder_out);

    input [31:0] n1;
    input [31:0] n2;
    output reg [31:0] adder_out;

    always @(*) begin
        adder_out = n1 + n2;
    end

endmodule