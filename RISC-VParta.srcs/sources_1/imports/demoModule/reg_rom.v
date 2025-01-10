`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 08:29:23 AM
// Design Name: 
// Module Name: register ROM
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

module reg_rom(
    input [4:0] addr,        // 5-bit register address input
    output reg [31:0] q      // Read data output
);
    reg [31:0] file [31:0];  // Memory array: 32 registers, 32 bits each
    integer i;               // Iterator for initialization

    // Initialize the instruction memory
    
    initial begin
    // Initialize all memory locations to HALT
    for (i = 0; i < 32; i = i + 1) begin
        file[i] = 32'h11111111; // Default HALT opcode
    end

/*      // Program 1 Instructions
      file[0]  = 32'h00000093; // addi x1, x0, 0 x
      file[1]  = 32'h01000113; // addi x2, x0, 16 x
      file[2]  = 32'h06400193; // addi x3, x0, 100 x
      file[3]  = 32'h00800213; // addi x4, x0, 8  x
      file[4]  = 32'h002082b3; // add x5, x1, x2  x
      file[5]  = 32'h00418333; // add x6, x3, x4  x
      file[6]  = 32'h0050a023; // sw x5, 0(x1)   x
      file[7]  = 32'h00612223; // sw x6, 4(x2)
      file[8]  = 32'h11111111; // HALT*/
        
 /*     //Program 2 Instructions
      file[0]  = 32'h00800293;
      file[1] = 32'h00f00313;
      file[2] = 32'h0062a023;
      file[3] = 32'h005303b3;
      file[4] = 32'h40530e33;
      file[5] = 32'h03c384b3;
      file[6] = 32'h00428293;	
      file[7] = 32'hffc2a903;
      file[8] = 32'h41248933;	
      file[9] = 32'h00291913;
      file[10] = 32'h0122a023;
      file[11] = 32'h11111111; */
   
      //factorial 6
    
      file[0]  = 32'h00c00513;
      file[1]  = 32'h008000ef;
      file[2]  = 32'h00a02023;
      file[3]  = 32'h11111111;	
      //fact
      file[4]  = 32'hff810113;
      file[5]  = 32'h000112223;
      file[6]  = 32'h00a12023;
      file[7]  = 32'hfff50513;
      file[8]  = 32'h00051863;
      file[9]  = 32'h00100513;
      file[10] = 32'h00810113;
      file[11] = 32'h00008067;
      //else
      file[12] = 32'hfe1ff0ef;
      file[13] = 32'h00050293;
      file[14] = 32'h00012503;
      file[15] = 32'h00412083;	
      file[16] = 32'h00810113;
      file[17] = 32'h02550533;	
      file[18] = 32'h00008067;
      

   
end


    // Assign the instruction corresponding to the address
    always @(*) begin
        q = file[addr];
    end

endmodule










