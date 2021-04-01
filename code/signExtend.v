/*
	The sign extend module is used to extend the sign
	for the bits 16-0 of the 32 bit instruction and, in 
	this processor, used for addi, lw and sw instructions
*/

module signExtend(signExtend_in, signExtend_out);

    input [15:0] signExtend_in;
    output reg [31:0] signExtend_out;

    always @(*) begin
        signExtend_out = {{16{signExtend_in[15]}}, signExtend_in};
    end

endmodule