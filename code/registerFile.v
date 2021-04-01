/*
    The Register file. 32 registers each of 32 bits.

    Only point to note here is that 
    $s0 and $s1 are pre-loaded with IEEE754 floating 
    point representation values for the demonstration
    of floating point arithmetic instructions

    Registers can be written into or read from, based on the 
    regWrite control signal.
*/

module registerFile (clk, regWrite, readReg1, readReg2, writeReg, writeData, readData1, readData2);

    input clk, regWrite;
    input [4:0] readReg1, readReg2;
    input [4:0] writeReg;
    input [31:0] writeData;

    output reg [31:0] readData1, readData2;

    reg [31:0] registerMem [0:31];               // 32 registers of 32 bits each

    integer i = 0;
    
    initial begin                                   // Make all 32 registers 0
        for(i = 0; i < 32; i = i + 1) begin
            registerMem[i] = 0;
        end

        registerMem[0] = 32'd0;                 // $zero register

        // $s0 and $s1 are pre-loaded with IEEE754 floating values for floating point arithmetic demonstration //

        registerMem[16] = 32'b01000001110000010000000000000000;			// 24.125 loaded in $s0 register
        registerMem[17] = 32'b01000100011011001011000000000000;			// 946.75 loaded in $s1 register
    end

    always @(*) begin                                   // For reading data

        if ((readReg1 == 0) && (readReg2 != 0)) begin
            readData1 = 0;
            readData2 = registerMem[readReg2];
        end
        
        else if ((readReg2 == 0) && (readReg1 != 0)) begin
            readData2 = 0;
            readData1 = registerMem[readReg1];
        end
        else begin
            readData1 = registerMem[readReg1];     
            readData2 = registerMem[readReg2];
        end
    end

    always @(posedge clk) begin                     // For writing data
        if (regWrite == 1) begin
          registerMem[writeReg] = writeData;
        end
    end

endmodule