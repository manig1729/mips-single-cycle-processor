/*
    Data memory - 128 memory locations of 32 bits each, all are initialised to be zero
*/

module dataMemory (clk, address, writeData, MemRead, MemWrite, ReadData);

    input clk, MemRead, MemWrite;
    input [6:0] address;                        // 7 bit address for addressing 128 locations
    input [31:0] writeData;
    output reg [31:0] ReadData;

    reg [31:0] dataMem [0:127];               // 128 memory locations of 32 bits each

    integer i = 0;
    
    initial begin                                   // Make all memory locations 0
        for(i = 0; i < 128; i = i + 1) begin
            dataMem[i] = 0;
        end

        // dataMem[0] = 32'd5;
        // dataMem[1] = 32'd6;
        // dataMem[2] = 32'd7;

        // For lw and sw demonstration
        // dataMem[6] = 32'd33;

    end

    always @(*) begin                               // For reading data
      if (MemRead === 1)
        ReadData = dataMem[address[6:2]];
    end

    always @(posedge clk) begin                     // For writing data 
      if (MemWrite == 1)
        dataMem[address[6:2]] = writeData;
    end

endmodule