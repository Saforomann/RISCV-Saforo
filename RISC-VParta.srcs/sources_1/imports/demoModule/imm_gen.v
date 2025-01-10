//intermediate generator module
//takes in all 32 bits of instructions
//outputs the 12 bit immediate based on I-type or SB-type or S-type

module imm_gen(
  input  [31:0] instr,   // 32-bit instruction
  output [31:0] out      // 32-bit sign-extended immediate
);

  // Extract opcode and instruction-specific fields
  wire [6:0] opcode = instr[6:0];
  wire [11:0] i_imm = instr[31:20];                    // I-type immediate
  wire [11:0] s_imm = {instr[31:25], instr[11:7]};    // S-type immediate
  wire [12:0] sb_imm = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // SB-type immediate
  wire [19:0] uj_imm = {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // UJ-type immediate

  // Immediate generation based on opcode
  assign out = (opcode == 7'b0010011) ? {{20{i_imm[11]}}, i_imm} :         // I-type (ADDI, etc.)
               (opcode == 7'b0100011) ? {{20{s_imm[11]}}, s_imm} :         // S-type (SW)
               (opcode == 7'b0000011) ? {{20{i_imm[11]}}, i_imm} :         // I-type (LW)
               (opcode == 7'b1100011) ? {{19{sb_imm[12]}}, sb_imm} :       // SB-type (BEQ, BNE)
               (opcode == 7'b1101111) ? {{11{uj_imm[19]}}, uj_imm} :       // UJ-type (JAL)
               (opcode == 7'b1100111) ? {{20{i_imm[11]}}, i_imm} :         // I-type (JALR)
               32'b0;                                                      // Default case

endmodule



