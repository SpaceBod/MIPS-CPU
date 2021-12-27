module alucontrol_tb ();
  //from alucontrol
  logic [3:0] aluOp;
  logic [5:0] funct;
  //logic[4:0] toAlu;
  //from alu
  //logic[4:0] alu_func;
  logic [4:0] tempOp;
  logic [31:0] a;
  logic [31:0] b;
  logic [4:0] shift;
  logic [31:0] result;
  logic zero;

  aluControl control (
      .aluOp(aluOp),
      .funct(funct),
      .toAlu(tempOp)
  );

  ALU alu (
      .alu_func(tempOp),
      .a(a),
      .b(b),
      .shift(shift),
      .result(result),
      .zero(zero)
  );

  initial begin
    a = 6'b001100;
    b = 2'b10;
    shift = 1;
    aluOp = 4'b0010;
    funct = 6'b000100;
    #1 $display("aluop = %b", aluOp);
    assert (result == 6'b110000)
    else $fatal(1, "result = %b, tempop = %b", result, tempOp);
    $display("success");
  end
endmodule
