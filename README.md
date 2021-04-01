# MIPS Single Cycle Processor Implementation in Verilog
This is a verilog implementation of a MIPS Single Cycle Processor based on the design in Patterson and Hennessy's "Computer Organization and Design" book.

For a detailed explanation, I would highly recommend you to go through the report in the assets folder.

The instructions implemented on the processor are - 

R-type instructions - add, sub, AND, OR, slt  
addi instruction  
sw instruction  
lw instruction  
beq instruction  
jump instruction  
floating point arithmetic 

The floating point arithmetic module is implemented using my repository [floating-point-adder](https://github.com/manig1729/floating-point-adder "floating-point-adder").

In the instruction file comments, you can see sample programs for the demonstration of these instructions, the outputs of these sample programs are discussed in the report.

The circuit diagram of the processor is as shown here

<img src="/assets/mips_single_cycle.png" alt="drawing" width="500"/> <br>

With the only exception that a floating point module has also been added, which is connected in parallel to the main ALU, as shown here 

<img src="/assets/float_modification.png" alt="drawing" width="500"/> <br>
