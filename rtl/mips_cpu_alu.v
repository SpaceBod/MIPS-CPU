module mips_cpu_alu (
    input logic clk,
    input logic reset,
    input logic [2:0] state,
    input logic [4:0] alu_func,
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [4:0] shift,
    input logic [2:0] mult_op,
    input logic write,

    output logic [31:0] result,
    output logic condition
);

  logic [31:0] hi, lo;

  mips_cpu_alu_mult_div alu_mult (
      .a(a),
      .b(b),
      .op(mult_op),
      .clk(clk),
      .write(write),
      .reset(reset),
      .hi(hi),
      .lo(lo)
  );

  always_comb begin

    if (mult_op == 3'b110 && state == 3) begin
      result = hi;
    end else if (mult_op == 3'b111 && state == 3) begin
      result = lo;
    end else begin
      case (alu_func)
        5'b00000: result = a + b;  // ADDU  (immediate or not determined elsewhere)
        5'b00001: result = a & b;  // AND
        5'b00010: result = a | b;  // OR
        5'b00011: result = a - b;  // SUBU
        5'b00100: result = $signed(a) < $signed(b);  // SLT
        5'b00101: result = $signed(a) < $signed(b);  // SLTU
        5'b00110: result = (b << shift);  // SLL
        5'b00111: result = b << a;  // SLLV
        5'b01000: result = b >> shift;  // SRL
        5'b01001: result = b >> a;  // SRLV
        5'b01010: result = $signed(b) >>> shift;  // SRA
        5'b01011: result = $signed(b) >>> a;  // SRAV
        5'b01100: result = a ^ b;  // XOR

        //branch conditions
        5'b10010: result = (a == b);  // BEQ
        5'b01101: result = $signed(a) >= 0;  // BGEZ (and link?)
        5'b01110: result = $signed(a) > 0;  // BGTZ
        5'b01111: result = $signed(a) <= 0;  // BLEZ
        5'b10000: result = $signed(a) < 0;  // BLTZ (and link?)
        5'b10001: result = (a != b);  // BNE
        default:  result = 0;
      endcase
    end
  end


  assign condition = (result == 1);

endmodule
