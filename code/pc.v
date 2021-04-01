/*
    The pc_register module initialises the PC to zero after reset
    and the pc_adder adds 4 to it to create the pc_out signal.

    More information about this has been given in page 12 of the report
*/

module pc_register (clk, rst, reg_d, reg_q);
    input clk, rst;
    input [31:0] reg_d;
    output reg [31:0] reg_q;

  always @(posedge clk or posedge rst) begin
    if(rst == 1)
      reg_q = 0;
    else
      reg_q = reg_d;
  end
endmodule

module pc_adder (pc_in, pc_out);

    input [31:0] pc_in;
    output reg [31:0] pc_out;

    always @(*) begin
      pc_out = pc_in + 4;
    end
endmodule