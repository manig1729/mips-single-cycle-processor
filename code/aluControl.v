/*
    To generate the control signal for the primary ALU.
*/

module aluControl (instruction, ALUOp, aluControlSignal);

    input [5:0] instruction;
    input [1:0] ALUOp;
    output reg [3:0] aluControlSignal;

    always @(*) begin
      
        // This is obtained from the coding table for the ALU control in the book
        if (ALUOp == 2'b00)                     // LW or SW instruction or addi
            aluControlSignal = 4'b0010;           // These use Add

        else if (ALUOp == 2'b01)                // beq instruction
            aluControlSignal = 4'b0110;           // beq uses subtract

        else                                    // R type instruction
        begin
            case(instruction)
                6'b100000 : aluControlSignal = 4'b0010;       // add
                6'b100010 : aluControlSignal = 4'b0110;       // sub
                6'b100100 : aluControlSignal = 4'b0000;       // AND
                6'b100101 : aluControlSignal = 4'b0001;       // OR
                6'b101010 : aluControlSignal = 4'b0111;       // slt
            endcase
        end
    end

endmodule