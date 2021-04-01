/*
    The instruction memory

    To run programs, type your instructions here.
    Do make sure you start storing them from instructionMem[1]

    All the sample programs shown in the report are also given here as comments.

    The program uncommented is the one I used for beq demonstration.
*/

module instructionMemory(readAddress, instruction);

    //input clk;
    input [31:0] readAddress;
    output reg [31:0] instruction;

    reg [31:0] instructionMem [0:127];

    integer i = 0;

    // TODO - Add instructions here!
    initial begin
        for(i = 0; i < 128; i = i + 1) begin    // Make all memory locations 0
            instructionMem[i] = 0;
        end

        /*      Instructions for basic Register arithmetic                  
        instructionMem[1] = {6'd8, 5'd0, 5'd8, 16'd29};                 // addi $t0, $zero, 29
        instructionMem[2] = {6'd8, 5'd0, 5'd9, 16'd31};                 // addi $t1, $zero, 31
        instructionMem[3] = {6'd0, 5'd9, 5'd8, 5'd11, 5'd0, 6'd32};         // add $t3, $t1, $t0
        instructionMem[4] = {6'd0, 5'd11, 5'd9, 5'd12, 5'd0, 6'd34};        // sub $t4, $t3, $t1
        */

        /*      Instructions for lw and sw demonstration        
        instructionMem[1] = {6'd8, 5'd0, 5'd8, 16'd29};                 // addi $t0, $zero, 29
        instructionMem[2] = {6'd8, 5'd0, 5'd9, 16'd20};                 // addi $t1, $zero, 20
        instructionMem[3] = {6'd43, 5'd9, 5'd8, 16'd4};                    // sw $t0, 4($t1)
        instructionMem[4] = {6'd35, 5'd9, 5'd10, 16'd4};                     // lw $t2, 4($t1)       
        */

        /*      Instructions for beq demonstration    */  
        instructionMem[1] = {6'd8, 5'd0, 5'd8, 16'd12};                 // addi $t0, $zero, 12
        instructionMem[2] = {6'd8, 5'd0, 5'd9, 16'd5};                 // addi $t1, $zero, 5
        instructionMem[3] = {6'd8, 5'd0, 5'd10, 16'd7};                 // addi $t2, $zero, 7
        instructionMem[4] = {6'd0, 5'd8, 5'd9, 5'd11, 5'd0, 6'd32};     // add $t3, $t0, $t1
        instructionMem[5] = {6'd4, 5'd11, 5'd8, 16'd3};                 // beq $t3, $t0, +3
        instructionMem[6] = {6'd0, 5'd9, 5'd10, 5'd11, 5'd0, 6'd32};     // add $t3, $t1, $t2
        instructionMem[7] = {6'd4, 5'd11, 5'd8, 16'd1};                  // beq $t3, $t0, +1
        instructionMem[8] = {6'd0, 5'd8, 5'd11, 5'd8, 5'd0, 6'd34};     // sub $t0, $t3, $t0
        instructionMem[9] = {6'd0, 5'd9, 5'd8, 5'd12, 5'd0, 6'd32};     // add $t4, $t1, $t0
        

        /*      Instructions for jump demonstration           
        instructionMem[1] = {6'd8, 5'd0, 5'd8, 16'd12};                      // addi $t0, $zero, 12
        instructionMem[2] = {6'd8, 5'd0, 5'd9, 16'd5};                      // addi $t1, $zero, 5
        instructionMem[3] = {6'd0, 5'd9, 5'd8, 5'd10, 5'd0, 6'd32};         //  add $t2, $t1, $t0
        instructionMem[4] = {6'd2, 26'd50};                                  //  j 50
        instructionMem[5] = {6'd0, 5'd11, 5'd10, 5'd12, 5'd0, 6'd34};        // sub $t4, $t3, $t2     
        instructionMem[6] = {6'd0, 5'd9, 5'd8, 5'd12, 5'd0, 6'd32};          // add $t4, $t1, $t0
        instructionMem[50] = {6'd0, 5'd8, 5'd10, 5'd11, 5'd0, 6'd32};        // add $t3, $t0, $t2
        */

        /*      Instructions for floating point arithmetic demonstration              
        instructionMem[1] = {6'b110011, 5'd17, 5'd16, 5'd18, 5'd0, 6'd0};         //  fpa $s2, $s1, $s0
        */

    end

    always @(*) begin
      instruction = instructionMem[readAddress[31:2]];
    end

endmodule