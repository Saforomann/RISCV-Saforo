`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 08:29:23 AM
// Design Name: 
// Module Name: 
// Project Name: RISC-V Single Cycle Processor
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

module ALU (
    output reg signed [31:0] Y,   // Output of A B compute result
    output zero,                  // Flag to indicate the output is zero
    input signed [31:0] A,        // Data A (e.g., register value)
    input signed [31:0] B,        // Data B (e.g., immediate value or register value)
    input [4:0] opcode            // Operation Code
);

  wire unsigned_a;
  wire unsigned_b;
  
  assign unsigned_a = A;
  assign unsigned_b = B;
    // Generate zero flag
    assign zero = (Y == 0) ? 1'b1 : 1'b0;

    // Perform ALU operations
    always @(*) begin
        case (opcode)
            5'b00111: Y = A & B;          // AND
            5'b00110: Y = A | B;          // OR
            5'b00000: Y = A + B;          // ADD (used for LW/SW effective address)
            5'b10000: Y = A - B;          // SUB
            5'b01001: Y = A * B;          // MUL
            5'b00001: Y = A << B;         // SLL (Shift Left Logical)
            5'b00101: Y = A >> B;         // SRL (Shift Right Logical)
            5'b00100: Y = A ^ B;          // XOR
            5'b01000: begin
                if(A - B ==0) begin
                    Y = 1'b1;
                    end 
                        else begin
                        Y = (A -B);
                        end 
                    end   
            
            
            5'b00010: begin 
                  if(A < B == 0) begin
                    Y = 1'b1;
                    end
                    else begin
                     Y = 1'b0;
                     end
                  end// Signed comparison
            5'b00011: begin 
              if(unsigned_a < unsigned_b) begin
                Y = 1'b1;
                end
                else begin
                Y = 1'b0;
                 end
              end
              default: Y = 32'b0;          // Default to zero for unknown opcodes
        endcase
    end
endmodule



