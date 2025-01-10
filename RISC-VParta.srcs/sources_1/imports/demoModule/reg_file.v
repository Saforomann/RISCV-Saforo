`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 08:29:23 AM
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module reg_file(
  input clk, wren,
  input [4:0] rr1, rr2, wr,
  input [31:0] wd,
  input JLFlg,                // New input to indicate jal
  input [31:0] PC_plus,       // PC + 4, the return address for jal
  output [31:0] rd1, rd2
);
  reg [31:0] file [31:0]; // 32 registers, 32 bits wide
  integer i;

  // Initialize the register file
  initial begin
    file[0] = 32'h0; // x0 is hardwired to 0
    for (i = 1; i < 32; i = i + 1)
      file[i] = 32'h0;
  end

  // Combinational read logic
  assign rd1 = file[rr1];
  assign rd2 = file[rr2];

  // Sequential write logic
  always @(posedge clk) begin
    if (wren) begin
      file[wr] <= (JLFlg) ? PC_plus : wd; // Write PC+4 for jal
    end
  end
endmodule


