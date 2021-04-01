/*
    Two different shift left 2 blocks

    The shiftLeft2_26bit module is used in jump address calculation
    The shiftLeft2_32bit module is used for branch offset calculation
*/

module shiftLeft2_26bit (signExtend_out, shiftLeft2_out);

    input [25:0] signExtend_out;
    output reg [27:0] shiftLeft2_out;

    always @(*) begin
        shiftLeft2_out = {signExtend_out, 2'b00};
    end

endmodule

module shiftLeft2_32bit (signExtend_out, shiftLeft2_out);

    input [31:0] signExtend_out;
    output reg [31:0] shiftLeft2_out;

    always @(*) begin
        shiftLeft2_out = signExtend_out << 2;
    end

endmodule