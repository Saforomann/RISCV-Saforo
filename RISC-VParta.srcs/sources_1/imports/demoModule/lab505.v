`timescale 1ns/1ns

module lab505(CLOCK_20, reset);
    input CLOCK_20, reset;

    // Registers and Wires
    (* DONT_TOUCH = "TRUE" *) reg [31:0] PC;              // Program Counter
    (* DONT_TOUCH = "TRUE" *) wire signed [31:0] PC_next, PC_plus, PC_offset, to_branch, BRANCH;
    (* DONT_TOUCH = "TRUE" *) wire run;

    (* DONT_TOUCH = "TRUE" *) wire [31:0] A, B, Y;        // ALU inputs and output
    (* DONT_TOUCH = "TRUE" *) wire [1:0] aluop;           // ALU operation control
    (* DONT_TOUCH = "TRUE" *) wire [4:0] aluopcode;       // ALU opcode
    (* DONT_TOUCH = "TRUE" *) wire zero;                  // ALU zero flag

    (* DONT_TOUCH = "TRUE" *) wire [31:0] instr;          // Fetched instruction
    (* DONT_TOUCH = "TRUE" *) wire halt;                  // Halt signal
    (* DONT_TOUCH = "TRUE" *) wire MemtoReg;              // MemtoReg control

    (* DONT_TOUCH = "TRUE" *) wire [31:0] imm_out;        // Immediate value

    (* DONT_TOUCH = "TRUE" *) wire [31:0] rd1, rd2, wd;   // Register file data

    (* DONT_TOUCH = "TRUE" *) wire clk_0, clk_1, clk_2;   // Clock outputs
    (* DONT_TOUCH = "TRUE" *) wire lock;                  // Clock lock

    (* DONT_TOUCH = "TRUE" *) wire ena;                   // Enable signal for RAM
    (* DONT_TOUCH = "TRUE" *) wire [31:0] RAMdataout;     // RAM output
    (* DONT_TOUCH = "TRUE" *) wire [4:0] addr;            // Instruction memory address

    // Control signals
    wire Branch, JLFlg, JLRFlg; // Added declaration for Branching signals
    wire Jump; // Signal for jumps (if needed in future expansion)

    // Debugging initialization
    initial begin
        $monitor("Time=%0t | PC=%h | instr=%h | halt=%b | run=%b | Y=%h | zero=%b | A=%h | B=%h | aluop=%b | aluopcode=%b",
                 $time, PC, instr, halt, run, Y, zero, A, B, aluop, aluopcode);
    end

    // Initialize Program Counter to 0
    initial PC = 32'h00000000; // Start from address 0

    // Run signal logic
    assign run = (halt == 1) ? 1'b0 : 1'b1;

always @(posedge clk_0 or posedge reset) begin
    if (reset) begin
        PC <= 32'b0; // Reset PC to 0
    end else if (run) begin
        $display("PC Update | Time=%0t | Old PC=%h | New PC=%h | Branch=%b | JLFlg=%b | JLRFlg=%b",
                 $time, PC,
                 (Branch ? BRANCH : (JLFlg ? PC_offset : (JLRFlg ? to_branch : PC_plus))),
                 Branch, JLFlg, JLRFlg);

        // Update PC based on the conditions
        PC <= (Branch)  ? BRANCH :               // Branch instructions (e.g., beq, bne)
              (JLFlg)   ? PC_offset :            // JAL (PC + immediate)
              (JLRFlg)  ? to_branch :            // JALR (rd1 + immediate)
                          PC_plus;               // Default case (PC + 4)
    end
end

// Program Counter calculations
assign PC_plus   = PC + 4;                       // Next sequential instruction
assign PC_offset = PC + (imm_out << 1);          // Jump target for JAL
assign to_branch = rd1 + (imm_out << 1);  // Target for JALR (aligned)
assign BRANCH    = PC + (imm_out << 1);          // Branch target (e.g., beq, bne)

    // ================ ALU =====================
    assign A = rd1;
    assign B = (ALUSrc == 1) ? imm_out : rd2;  // ALU source select
    ALU a1 (
        .Y(Y),
        .zero(zero),
        .A(A),
        .B(B),
        .opcode(aluopcode)
    );

    // ================ Control Unit =====================
    control_unit control_unit (
        .instr(instr[6:0]),
        .funct3(instr[14:12]),
        .aluop(aluop),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .JLFlg(JLFlg),
        .JLRFlg(JLRFlg),
        .halt(halt),
        .Jump(Jump)
    );

    // ================ ALU Control =====================
    alu_control ALU_controller (
        .aluopcode(aluopcode),
        .instr_split({instr[30], instr[25], instr[14:12]}), // Updated to use 6 bits
        .aluop(aluop)
    );

    // ================ Register File =====================
    assign wd = (JLFlg | JLRFlg) ? PC_plus : (MemtoReg == 1) ? RAMdataout : Y;
    reg_file register_file (
        .clk(clk_2),
        .wren(RegWrite),
        .wd(wd),
        .rr1(instr[19:15]),
        .rr2(instr[24:20]),
        .wr(instr[11:7]),
        .JLFlg(JLFlg),      
        .PC_plus(PC_plus),  
        .rd1(rd1),
        .rd2(rd2)
    );

    // ================ Immediate Generator ==============
    imm_gen imm_gen (
        .out(imm_out[31:0]),
        .instr(instr[31:0])
        
    );

    // ================ RAM =====================
    assign ena = (MemRead | MemWrite) ? 1'b1 : 1'b0;
    blk_mem_gen_0 ram_unit (
        .clka(clk_1),
        .ena(ena),
        .dina(rd2),
        .addra(Y[7:0]),
        .wea(MemWrite),
        .douta(RAMdataout)
    );

    // ================ Instruction Memory =====================
    assign addr = PC >> 2;
    reg_rom data_rom (
        .q(instr[31:0]),
        .addr(addr[4:0])
        
    );

    // ================ Clock Wizard =====================
    clk_wiz_0 mmcm_data (
        .clk_out1(clk_0),
        .clk_out2(clk_1),
        .clk_out3(clk_2),
        .locked(lock),
        .clk_in1(CLOCK_20),
        .reset(reset) // Connected reset
    );

endmodule




