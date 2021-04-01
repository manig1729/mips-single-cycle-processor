/*
    Main control unit - takes the opcode of the instruction (bits 31-26) and generates all
    of the control signals required. Apart from the figure in the Patterson and Hennessy
    book, a floating point instruction has also been implemented with opcode 110011
*/

module controlUnit (opcode, RegDst, Branch, MemRead, MemtoReg, 
                    ALUOp, MemWrite, ALUSrc, RegWrite, jump, floating);

    input [5:0] opcode;
    output reg RegDst, Branch, MemRead, MemtoReg;
    output reg [1:0] ALUOp;
    output reg MemWrite, ALUSrc, RegWrite, jump, floating;

    always @(*) begin
      
        case(opcode)
            6'b000000: begin        // R-type instructions
              RegDst    = 1;
              ALUSrc    = 0;
              MemtoReg  = 0;
              RegWrite  = 1;
              MemRead   = 0;
              MemWrite  = 0;
              Branch    = 0;
              ALUOp     = 2'b10;
              jump      = 0;
              floating  = 0;
            end

            6'b110011: begin        // Arbitrarily chosen opcode for Floating point arithmetic
              RegDst    = 1;
              ALUSrc    = 0;
              MemtoReg  = 0;
              RegWrite  = 1;
              MemRead   = 0;
              MemWrite  = 0;
              Branch    = 0;
              ALUOp     = 2'b10;
              jump      = 0;
              floating  = 1;
            end

            6'b001000: begin        // addi instruction
              RegDst    = 0;
              ALUSrc    = 1;
              MemtoReg  = 0;
              RegWrite  = 1;
              MemRead   = 0;
              MemWrite  = 0;
              Branch    = 0;
              ALUOp     = 2'b00;
              jump      = 0;
              floating  = 0;
            end

            6'b100011: begin        // lw instruction
              RegDst    = 0;
              ALUSrc    = 1;
              MemtoReg  = 1;
              RegWrite  = 1;
              MemRead   = 1;
              MemWrite  = 0;
              Branch    = 0;
              ALUOp     = 2'b00;
              jump      = 0;
              floating  = 0;
            end

            6'b101011: begin        // sw instruction
              RegDst    = 0;
              ALUSrc    = 1;
              MemtoReg  = 1;
              RegWrite  = 0;
              MemRead   = 0;
              MemWrite  = 1;
              Branch    = 0;
              ALUOp     = 2'b00;
              jump      = 0;
              floating  = 0;
            end

            6'b000100: begin        // beq instruction
              RegDst    = 0;
              ALUSrc    = 0;
              MemtoReg  = 1;
              RegWrite  = 0;
              MemRead   = 0;
              MemWrite  = 0;
              Branch    = 1;
              ALUOp     = 2'b01;
              jump      = 0;
              floating  = 0;
            end

            6'b000010: begin        // jump instruction
              RegDst    = 0;
              ALUSrc    = 0;
              MemtoReg  = 1;
              RegWrite  = 0;
              MemRead   = 0;
              MemWrite  = 0;
              Branch    = 1;
              ALUOp     = 2'b01;
              jump      = 1;
              floating  = 0;
            end

        endcase
    end

endmodule