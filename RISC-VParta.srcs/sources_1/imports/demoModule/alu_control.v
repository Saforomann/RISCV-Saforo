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
module alu_control(
    input [4:0] instr_split,  // {instr[30], instr[25], instr[14:12] (funct3)}
    input [1:0] aluop,        // ALUOp from the control unit
    output wire [4:0] aluopcode // ALU operation code
);

assign aluopcode = (aluop == 2'b00) ? 5'b00000 :          // Load/Store (ADD)
                   (aluop == 2'b01) ? 5'b10000 :          // Branch (SUB)
                   (aluop == 2'b10) ?                     // R-type operation
                       ((instr_split[2:0] == 3'b000) ? ((instr_split[4]) ? 5'b10000 : 5'b00000) :  // SUB or ADD
                        (instr_split[2:0] == 3'b001) ? 5'b00001 :  // SLL
                        (instr_split[2:0] == 3'b010) ? 5'b00010 :  // SLT
                        (instr_split[2:0] == 3'b110) ? 5'b00110 :  // OR
                        (instr_split[2:0] == 3'b111) ? 5'b00111 :  // AND
                        (instr_split[2:0] == 3'b100) ? 5'b01000 :  // XOR
                        5'b11111) :                             // Unsupported R-type
                   (aluop == 2'b11) ?                            // I-type operation
                       ((instr_split[2:0] == 3'b000) ? 5'b00000 : // ADDI
                        (instr_split[2:0] == 3'b100) ? 5'b01000 : // XORI
                        {2'b00, instr_split[2:0]}) :             // Default to funct3
                   5'b11111;                                     // Unsupported case

endmodule


/*module alu_control(
    input [4:0] instr_split,  // {instr[30], instr[25], instr[14:12] (funct3)}
    input [1:0] aluop,        // ALUOp from the control unit
    output wire [4:0] aluopcode // ALU operation code
);

assign aluopcode = (aluop == 2'b00) ? 5'b00000 :          // Load/Store (ADD)
                   (aluop == 2'b01) ? 5'b10000 :          // Branch (SUB)
                   (aluop == 2'b10) ?                     // R-type operation
                       ((instr_split[2:0] == 3'b000) ? 5'b00000 :  // ADD
                        (instr_split[2:0] == 3'b001) ? 5'b00001 :  // SLL
                        (instr_split[2:0] == 3'b010) ? 5'b00010 :  // SLT
                        (instr_split[4])             ? 5'b10000 :  // SUB (funct7=1)
                        5'b00000) :                              // Default
                   (aluop == 2'b11) ?                            // I-type operation
                       ((instr_split[2:0] == 3'b000) ? 5'b00000 : // ADDI
                        (instr_split[2:0] == 3'b100) ? 5'b01000 : // XORI
                        {2'b00, instr_split[2:0]}) :             // Default to funct3
                   5'b11111;                                     // Unsupported case

endmodule
*/

/*
module alu_control (
  input       [4:0] instr_split,  // {instr[30], instr[25], instr[14:12] (funct3)}
  input       [1:0] aluop,       // ALUOp from the control unit
  output wire [4:0] aluopcode    // ALU operation code
);

assign aluopcode = 
  (aluop == 2'b00) ? 5'b00000 :       // Load/Store (ADD)
  (aluop == 2'b01) ? 5'b10000 :       // Branch (SUB)
  (aluop == 2'b10) ? instr_split :    // R-type operation (based on funct2/3)
  (aluop == 2'b11) ? {2'b00, instr_split[2:0]} : // I-type operation (funct3 only)
  5'bxxxxx;                           // Default case for unsupported ALUOp

endmodule
*/


