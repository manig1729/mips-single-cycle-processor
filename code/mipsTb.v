/* 
    Testbench for mips.v

    Author - Manikandan Gunaseelan

    Only clk and rst are external signals to the processor.
    Hence, to view the separate internal waveforms, expand on 
    the uut section in the simulation window and choose the 
    waveforms needed

    You can see how this can be done on ModelSim and GTKWave
    on page 3 of the report

    The instructions loaded by default are the ones used in the 
    report for beq instruction demonstration. Many other sample 
    programs are also given in the instructionMemory.v file
*/

`timescale 1ns / 1ns
`include "mips.v"

module mipsTb;

    reg clk;
    reg rst;

    mips uut(clk, rst);

    always #5 clk = ~clk;

    initial begin
      $dumpfile("mips_output.vcd");     // These are for GTKWave simulation and you can 
      $dumpvars(0, mipsTb);             // remove them if simulating on ModelSim
      clk=0; rst=1;
		  #4  rst=0;
		  #100 $finish;                 // Not needed in ModelSim
    end

endmodule