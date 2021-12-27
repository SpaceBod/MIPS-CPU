module mips_cpu_alu_control (
    input  logic [3:0] aluOp,
    input  logic [5:0] funct,
    output logic [4:0] toAlu,
    output logic [2:0] toMult
);
  always_comb begin
    case (aluOp)
      4'b0000: begin
        toMult = 0;
        toAlu  = 5'b00000;  // add
      end
      4'b0001: begin
        toMult = 0;
        toAlu  = 5'b00011;  // subtract
      end
      4'b0010: begin
        toMult = 0;
        case (funct)
          6'b100001: toAlu = 5'b00000;  // add unsigned
          6'b100100: toAlu = 5'b00001;  // AND
          6'b100101: toAlu = 5'b00010;  // OR
          6'b101010: toAlu = 5'b00100;  // SLT
          6'b101011: toAlu = 5'b00101;  // SLTU
          6'b000000: toAlu = 5'b00110;  // SLL
          6'b000100: toAlu = 5'b00111;  // SLLV
          6'b000010: toAlu = 5'b01000;  // SRL
          6'b000110: toAlu = 5'b01001;  // SRLV
          6'b000011: toAlu = 5'b01010;  // SRA
          6'b000111: toAlu = 5'b01011;  // SRAV
          6'b100011: toAlu = 5'b00011;  // SUBU
          6'b100110: toAlu = 5'b01100;  // XOR
        endcase
      end

      4'b0011: begin
        toMult = 0;
        toAlu  = 5'b10010;  // BEQ
      end
      4'b0100: begin
        toMult = 0;
        toAlu  = 5'b01101;  // BGEZ
      end
      4'b0101: begin
        toMult = 0;
        toAlu  = 5'b01110;  // BGTZ
      end
      4'b0110: begin
        toMult = 0;
        toAlu  = 5'b01111;  // BLEZ
      end
      4'b0111: begin
        toMult = 0;
        toAlu  = 5'b10000;  // BLTZ
      end
      4'b1000: begin
        toMult = 0;
        toAlu  = 5'b10001;  // BNE
      end
      // MULT, DIV etc.
      4'b1001:
      case (funct)
        6'b011000: toMult = 3'b011;  // MULT
        6'b011001: toMult = 3'b001;  // MULTU
        6'b011010: toMult = 3'b010;  // DIV
        6'b011011: toMult = 3'b000;  // DIVU
        6'b010001: toMult = 3'b100;  // MTHI
        6'b010011: toMult = 3'b101;  // MTLO
        6'b010000: toMult = 3'b110;  // MFHI
        6'b010010: toMult = 3'b111;  // MFLO
      endcase

      // for I type instructions
      4'b1010: begin
        toMult = 0;
        toAlu  = 5'b00001;  // ANDI
      end
      4'b1011: begin
        toMult = 0;
        toAlu  = 5'b00010;  // ORI
      end
      4'b1100: begin
        toMult = 0;
        toAlu  = 5'b01100;  // XORI
      end
      4'b1101: begin
        toMult = 0;
        toAlu  = 5'b00100;  // SLTI
      end
      4'b1110: begin
        toMult = 0;
        toAlu  = 5'b00101;  // SLTUI
      end

      default: begin
        toAlu  = 5'b00000;
        toMult = 3'b000;
      end

    endcase
  end

endmodule
