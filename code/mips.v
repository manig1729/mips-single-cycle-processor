/*
    Main MIPS module for the processor

    Author : Manikandan Gunaseelan, 2018AAPS0246G

    This module defines all the circuit connections of the processor.
    For the circuit diagram and brief overviews of each of the modules,
    do go through the report.

    Most of the connections are self-explanatory and comments have been
    provided wherever necessary.

    To simulate this, please run the mipsTb module.
*/

// The following include statements are only needed for GTKWave + iverilog simulation
// You may remove these for simulation on ModelSim

`include "pc.v"
`include "instructionMemory.v"
`include "controlUnit.v"
`include "MUX.v"
`include "registerFile.v"
`include "signExtend.v"
`include "aluControl.v"
`include "alu.v"
`include "dataMemory.v"
`include "shiftLeft2.v"
`include "adder.v"
`include "floatingPointAdder.v"

module mips (clk, rst);

    input clk;
    input rst;

    // PC module
    wire [31:0] pc_out;
    wire [31:0] pc_in_temp;
    wire [31:0] pc_in;

    pc_register pc_register_module (clk, rst, pc_in_temp, pc_in);
    pc_adder pc_adder_module (pc_in, pc_out);

    // Instruction Memory
    wire [31:0] instruction;
    instructionMemory im_module (pc_in, instruction);

    // Control unit
    wire [5:0] opcode;
    assign opcode = instruction[31:26];
    wire RegDst, Branch, MemRead, MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite, ALUSrc, RegWrite, jump, floating;
    controlUnit cu_module (opcode, RegDst, Branch, MemRead, MemtoReg, 
                            ALUOp, MemWrite, ALUSrc, RegWrite, jump, floating);

    // MUX for register file
    wire [4:0] writeReg;
    MUX_5bit MUX1 (instruction[20:16], instruction[15:11], RegDst, writeReg);

    // Register file module
    wire [31:0] writeData, readData1, readData2;  
    registerFile rf_module (clk, RegWrite, instruction[25:21], instruction[20:16],
                            writeReg, writeData, readData1, readData2);

    // Sign extension module
    wire [31:0] signExtend_out;
    signExtend se_module (instruction[15:0], signExtend_out);
    
    // ALU control signal
    wire [3:0] aluControlSignal;
    aluControl ac_module (instruction[5:0], ALUOp, aluControlSignal);

    // MUX for ALU
    wire [31:0] ALUin2;
    MUX_32bit MUX2 (readData2, signExtend_out, ALUSrc, ALUin2);

    // Primary ALU
    wire [31:0] aluOut;
    wire aluZero;
    alu ALU_module (readData1, ALUin2, aluControlSignal, aluOut, aluZero);

    // Floating point module
    // Same inputs as normal ALU
    wire [31:0] fpa_out;
    floatingPointAdder fpa_module (readData1, ALUin2, fpa_out);

    // MUX to choose between floating point output and normal ALU_output
    wire [31:0] alu_result;
    MUX_32bit MUX6 (aluOut, fpa_out, floating, alu_result);

    // Data memory
    wire [31:0] ReadData;
    dataMemory dm_module (clk, alu_result[6:0], readData2, MemRead, MemWrite, ReadData);

    // MUX after data memory
    MUX_32bit MUX3 (alu_result, ReadData, MemtoReg, writeData);

    // Top left shift-left-2
    wire [27:0] jump_temp;
    shiftLeft2_26bit SL2_1 (instruction[25:0], jump_temp);

    wire [31:0] jumpAddress;
    assign jumpAddress = {pc_out[31:28], jump_temp};        // Node for connection of jump address - explained in the last page of the report

    // shift-left-2 for PC vs branch
    wire [31:0] SLT_2_temp;
    shiftLeft2_32bit SL2_2 (signExtend_out, SLT_2_temp);

    // Adder
    wire [31:0] adder_out;
    adder Add_module (pc_out, SLT_2_temp, adder_out);

    // MUX after adder
    wire adder_mux_select;
    assign adder_mux_select = Branch & aluZero;     // And gate for the MUX select signal for branching - explained in the final page of the report
    wire [31:0] adder_mux_out;
    MUX_32bit MUX4 (pc_out, adder_out, adder_mux_select, adder_mux_out);

    // MUX for jump
    MUX_32bit MUX5 (adder_mux_out, jumpAddress, jump, pc_in_temp);

endmodule