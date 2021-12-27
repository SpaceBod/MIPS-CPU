module mips_cpu_bus_tb;
  //timeunit 1ns / 10ps;
  parameter RAM_INIT_FILE = "";
  parameter TIMEOUT_CYCLES = 10000;
  int resultfile;

  logic clk;
  logic reset;
  logic active;

  logic read;
  logic write;
  logic waitrequest;

  logic [3:0] byteenable;

  logic [31:0] register_v0;
  logic [31:0] address;
  logic [31:0] readdata;
  logic [31:0] writedata;

  mips_cpu_avalon_RAM #(RAM_INIT_FILE) RAMInst (
      .clk(clk),
      .address(address),
      .byteenable(byteenable),
      .read(read),
      .write(write),
      .waitrequest(waitrequest),
      .readdata(readdata),
      .writedata(writedata)
  );

  mips_cpu_bus cpuBusInst (
      .clk(clk),
      .reset(reset),
      .active(active),
      .register_v0(register_v0),
      .address(address),
      .write(write),
      .read(read),
      .waitrequest(waitrequest),
      .writedata(writedata),
      .byteenable(byteenable),
      .readdata(readdata)
  );

  // generate clock
  initial begin
    // $timeformat(-9, 1, " ns", 20);
    resultfile = $fopen("./test/testbench_and_RAM/compiled_results/result.txt", "w");
    $dumpfile("./test/testbench_and_RAM/mips_cpu_bus_tb.vcd");
    $dumpvars(0, mips_cpu_bus_tb);
    clk = 0;

    repeat (TIMEOUT_CYCLES) begin
      #10;
      clk = !clk;
      #10;
      clk = !clk;
    end

    $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
  end

  initial begin
    reset <= 1;

    @(posedge clk);
    #1;
    reset <= 0;

    @(posedge clk);
    //$display("address = %h", mem_address);
    assert (active == 1)
    else $display("TB: CPU did not set active=1 after reset.");

    forever begin
      @(posedge clk);
      if (!active) begin
        #20;
        $display("CPU HALUTED, register_v0 = %h", register_v0);
        $fwrite(resultfile, register_v0);
        $fclose(resultfile);
        $finish;
      end
    end
  end
endmodule
