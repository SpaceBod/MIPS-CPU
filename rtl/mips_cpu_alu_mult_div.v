module mips_cpu_alu_mult_div (
    input logic [31:0] a,
    b,
    input logic [2:0] op,
    input logic clk,
    input logic write,
    input logic reset,

    output logic [31:0] hi, lo
);

  logic [31:0] signed_a, signed_b, unsigned_a, unsigned_b, div_u, div, rem_u, rem;
  logic [63:0] mult_u, mult;

  always_comb begin

    div_u = $unsigned(a) / $unsigned(b);
    rem_u = $unsigned(a) % $unsigned(b);
    mult_u = $unsigned(a) * $unsigned(b);

    div = $signed(a)/ $signed(b);
    rem = $signed(a) % $signed(b);
    mult = $signed(a) * $signed(b);


  end


  always_ff @(posedge clk) begin

    if (reset) begin
      hi <= 0;
      lo <= 0;
    end else if (write) begin
      case (op)
        3'b000: begin
          hi <= rem_u;
          lo <= div_u[31:0];  //DIVU
        end
        3'b001: begin
          hi <= mult_u[63:32];
          lo <= mult_u[31:0];  //MULTU
        end
        3'b010: begin
          hi <= rem;
          lo <= div[31:0];  //DIV
        end
        3'b011: begin
          hi <= $signed(mult[63:32]);
          lo <= $signed(mult[31:0]);  //MULT
        end
        3'b100: hi <= a;  //MTHI
        3'b101: lo <= a;  //MTLO
        3'b110: hi <= hi;  //MFHI
        3'b111: lo <= lo;  //MFLO
      endcase
      ;
    end
  end

endmodule
