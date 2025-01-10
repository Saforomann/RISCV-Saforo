`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 08:29:23 AM
// Design Name: 
// Module Name: tb_reg_file
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

module tb_reg_file_rd2;
  reg clk, wren;
  reg [4:0] rr1, rr2, wr;
  reg [31:0] wd;
  wire [31:0] rd1, rd2;

  // Instantiate the reg_file module
  reg_file TEST (
      .clk(clk),
      .wren(wren),
      .wd(wd),
      .rr1(rr1),
      .rr2(rr2),
      .wr(wr),
      .rd1(rd1),
      .rd2(rd2)
  );

  // Clock generation
  initial begin
    clk = 1;
  end
  always #0.50 clk = ~clk;

  // Monitor output for debugging
  always @(posedge clk) begin
    $display("Time=%0t | wren=%b | wr=%h | wd=%h | rr1=%h | rr2=%h | rd1=%h | rd2=%h",
             $time, wren, wr, wd, rr1, rr2, rd1, rd2);
  end

  // Test sequence for consistent `rd2`
  initial begin
    $display("Testbench for consistent rd2");
    #0 wren = 1; wr = 5'h0; wd = 32'h0; rr1 = 5'h0; rr2 = 5'h0; #1;
    #1 wren = 1; wr = 5'h1; wd = 32'h1; rr1 = 5'h0; rr2 = 5'h1; #1;
    #1 wren = 1; wr = 5'h2; wd = 32'h2; rr1 = 5'h1; rr2 = 5'h1; #1;
    #1 wren = 1; wr = 5'h7; wd = 32'h12; rr1 = 5'h2; rr2 = 5'h7; #1;
    #1 wren = 0; wr = 5'h7; wd = 32'h12; rr1 = 5'h7; rr2 = 5'h7; #2;
    $stop;
  end
endmodule



/* //rd1
module tb_reg_file;
  reg clk, wren;
  reg [4:0] rr1, rr2, wr;
  reg [31:0] wd;
  wire [31:0] rd1, rd2;

  // Instantiate the reg_file module
  reg_file TEST (
      .clk(clk),
      .wren(wren),
      .wd(wd),
      .rr1(rr1),
      .rr2(rr2),
      .wr(wr),
      .rd1(rd1),
      .rd2(rd2)
  );

  // Clock generation
  initial begin
    clk = 1; // Clock initialization
  end

  always #0.50 clk = ~clk; // Generate clock with a 1 ns period

  // Monitor output for debugging
  always @(posedge clk) begin
    $display("RegWrite=%h, writeData=%h, address1=%h, address2=%h, writeReg=%h, destR1=%h, destR2=%h",
             wren, wd, rr1, rr2, wr, rd1, rd2);
  end

  // Test sequence
  initial begin
    $display("wren, wd, rr1, rr2, wr, rd1, rd2");

    // Initialize signals and write 0 to address 0
    #0 wren = 1;
    wr = 5'h0;
    wd = 32'h0; // Write 0 to address 0
    rr1 = 5'h0; // rd1 is 32'h0
    rr2 = 5'h0; // rd2 is 32'h0
    #1;

    // Write 1 to address 1
    wren = 1;
    wr = 5'h1;
    wd = 32'h1; // Write 1 to address 1
    rr1 = 5'h0; // rd1 is 32'h0
    rr2 = 5'h1; // rd2 is 32'h1
    #1;

    // Write 2 to address 2
    wren = 1;
    wr = 5'h2;
    wd = 32'h2; // Write 2 to address 2
    rr1 = 5'h0; // rd1 is 32'h0
    rr2 = 5'h1; // rd2 is 32'h1
    #1;

    // Write 0x12 to address 7
    wren = 1;
    wr = 5'h7;
    wd = 32'h12; // Write 0x12 to address 7
    rr1 = 5'h2; // rd1 is 32'h2
    rr2 = 5'h1; // rd2 is 32'h1
    #1;

    // Disable write and check reads
    wren = 0;
    wr = 5'h7;
    wd = 32'h12; // Don't write
    rr1 = 5'h2; // rd1 is 32'h2
    rr2 = 5'h7; // rd2 is 32'h12
    #1;

    // Extra delay to ensure stable outputs
    #1;
    #1;

    // Stop simulation
    $stop;
  end
endmodule*/



