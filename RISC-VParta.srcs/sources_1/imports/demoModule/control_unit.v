`timescale 1ns / 1ps
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

module control_unit(
    input   [6:0] instr,     // Instruction opcode
    input   [2:0] funct3,    // Function field (used for branching conditions)
    output  [1:0] aluop,     // ALU operation code
    output  Branch,          // Branch control signal
    output  MemRead,         // Memory read enable
    output  MemtoReg,        // Memory to register enable
    output  MemWrite,        // Memory write enable
    output  ALUSrc,          // ALU source select (register or immediate)
    output  RegWrite,        // Register write enable
    output  Jump,            // Jump control signal
    output  JLFlg,           // JAL flag
    output  JLRFlg,          // JALR flag
    output  halt             // Halt signal
);

    // ALU operation codes
    assign aluop = (instr == 7'b0110011) ? 2'b10 : // R-type
                   (instr == 7'b0010011) ? 2'b11 : // I-type
                   (instr == 7'b1100011) ? 2'b01 : // B-type
                   2'b00;                         // Default (no operation)

    // Control signal assignments based on instruction type
    assign RegWrite = (instr == 7'b0110011) || // R-type
                      (instr == 7'b0010011) || // I-type
                      (instr == 7'b0000011) || // L-type (LW)
                      (instr == 7'b1101111) || // JAL
                      (instr == 7'b1100111);   // JALR

    assign MemRead = (instr == 7'b0000011);  // L-type (LW)
    assign MemtoReg = (instr == 7'b0000011); // L-type (LW)
    assign MemWrite = (instr == 7'b0100011); // S-type (SW)
    assign ALUSrc = (instr == 7'b0010011) || // I-type
                    (instr == 7'b0100011) || // S-type
                    (instr == 7'b0000011) || // L-type
                    (instr == 7'b1100111);   // JALR

    assign Branch = (instr == 7'b1100011);   // B-type (Branch)

    // Jump signals
    assign Jump = (instr == 7'b1101111) || (instr == 7'b1100111); // JAL/JALR
    assign JLFlg = (instr == 7'b1101111);                        // JAL
    assign JLRFlg = (instr == 7'b1100111);                       // JALR

    // Halt signal
    assign halt = (instr == 7'b1111111); // HALT instruction

endmodule


/*module control_unit(
    input   [6:0] instr,     // Instruction opcode
    input   [2:0] funct3,    // Function field (used for branching conditions)
    output reg [1:0] aluop,  // ALU operation code
    output reg Branch,       // Branch control signal
    output reg MemRead,      // Memory read enable
    output reg MemtoReg,     // Memory to register enable
    output reg MemWrite,     // Memory write enable
    output reg ALUSrc,       // ALU source select (register or immediate)
    output reg RegWrite,     // Register write enable
    output Jump,             // Jump control signal
    output JLFlg,            // JAL flag
    output JLRFlg,           // JALR flag
    output halt              // Halt signal
);

    always @(*) begin
        // Default values for all signals
        MemRead  = 1'b0;
        MemtoReg = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b0;
        RegWrite = 1'b0;
        aluop    = 2'b00;
        Branch   = 1'b0;

        case (instr)
            7'b0110011: begin // R-type
                RegWrite = 1'b1;
                aluop = 2'b10;
            end
            7'b0010011: begin // I-type
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                aluop = 2'b11;
            end
            7'b0100011: begin // S-type (SW)
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
            end
            7'b0000011: begin // L-type (LW)
                MemRead = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
            end
            7'b1100011: begin // B-type (Branch)
                aluop = 2'b01; // ALU performs comparison for branches
                Branch = 1'b1; // Always assert branch signal for B-type instructions
            end
            
            7'b1101111: begin // JAL
                RegWrite = 1'b1;
                //ALUSrc = 1'b1;
                Branch = 1'b1; //temp, added
            end
            7'b1100111: begin // JALR
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
            end
            default: begin
                // Default case ensures all signals are deasserted
                MemRead  = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc   = 1'b0;
                RegWrite = 1'b0;
                aluop    = 2'b00;
                Branch   = 1'b0;
            end
        endcase
    end

    // Jump Signals
    assign Jump = (instr == 7'b1101111 || instr == 7'b1100111); // JAL/JALR
    assign JLFlg = (instr == 7'b1101111);                       // JAL
    assign JLRFlg = (instr == 7'b1100111);                      // JALR

    // Halt Signal
    assign halt = (instr == 7'b1111111) ? 1'b1 : 1'b0;

endmodule*/




