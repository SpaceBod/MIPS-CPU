`timescale 1ns / 100ps
module mips_cpu_register_tb ();
  reg [31:0] write_data;
  reg [4:0] read_reg_1;
  reg [4:0] read_reg_2;
  reg [4:0] write_reg;
  wire [31:0] read_data_1;
  wire [31:0] read_data_2;
  wire [31:0] read_data_v0;
  reg clk;
  reg reset;
  reg write_enable;

  mips_cpu_register_file inst_reg (
      .write_data(write_data),
      .read_reg_1(read_reg_1),
      .read_reg_2(read_reg_2),
      .write_reg(write_reg),
      .read_data_1(read_data_1),
      .read_data_2(read_data_2),
      .read_data_v0(read_data_v0),
      .clk(clk),
      .reset(reset),
      .write_enable(write_enable)
  );

  initial begin
    $timeformat(-9, 1, " ns", 100);
    $dumpfile("mips_cpu_register_tb.vcd");
    $dumpvars(0, mips_cpu_register_tb);

    // initialise
    clk = 0;

    reset = 1;
    write_reg = 0;
    write_enable = 0;
    write_data = 0;

    #5 clk = 1;
    #5 clk = 0;

    // test writing and reading single register
    $display("\n-=-=-=- TEST SINGLE WRITE & READ -=-=-=-");
    reset = 0;
    write_enable = 1;
    write_data = 1234567;
    write_reg = 16;
    read_reg_1 = 16;

    #5 clk = 1;
    #5 clk = 0;

    write_enable = 0;
    assert (read_data_1 == 1234567);
    $display("[READ EVENT]\tREG%d\t->%d", read_reg_1, read_data_1);

    #5 clk = 1;
    #5 clk = 0;

    // testing dual read port
    $display("\n-=-=-=- TEST DUAL READ PORTS -=-=-=-");
    write_enable = 1;
    write_data = 7654321;
    write_reg = 20;

    // dual read ports set
    read_reg_1 = 16;
    read_reg_2 = 20;

    #5 clk = 1;
    #5 clk = 0;

    write_enable = 0;
    assert (read_data_2 == 7654321);
    $display("[READ EVENT]\tREG%d\t->%d", read_reg_1, read_data_1);
    $display("[READ EVENT]\tREG%d\t->%d", read_reg_2, read_data_2);

    #5 clk = 1;
    #5 clk = 0;

    // test reset
    $display("\n-=-=-=- TEST REGISTER RESET -=-=-=-");
    reset = 1;

    #5 clk = 1;
    #5 clk = 0;

    assert (read_data_1 == 0);
    assert (read_data_2 == 0);
    $display("[READ EVENT]\tREG%d\t->%d", read_reg_1, read_data_1);
    $display("[READ EVENT]\tREG%d\t->%d", read_reg_2, read_data_2);

    $finish;


  end
endmodule
