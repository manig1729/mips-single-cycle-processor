/*
    Primary ALU. The output of this alu is connected to a MUX, alongwith the output
    of the floating point module, to obtain the final alu result
*/

module alu(n1, n2, aluControlSignal, aluOut, aluZero);

    input [31:0] n1, n2;
    input [3:0] aluControlSignal;
    output reg aluZero;
    output reg [31:0] aluOut;

    always @(*) begin
        case(aluControlSignal) 
            4'b0000 : aluOut = n1 & n2;
            4'b0001 : aluOut = n1 | n2;
            4'b0010 : aluOut = n1 + n2;
            4'b0110 : aluOut = n1 - n2;
            4'b0111 : aluOut = (n1 < n2)?(32'd1):(32'd0);
        endcase

        if (aluOut == 0)
            aluZero = 1;
        else
            aluZero = 0;
    end

endmodule