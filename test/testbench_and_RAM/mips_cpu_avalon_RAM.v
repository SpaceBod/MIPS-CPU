module mips_cpu_avalon_RAM (
    input logic clk,
    input logic [31:0] address,
    input logic [3:0] byteenable,
    input logic read,
    input logic write,
    input logic [31:0] writedata,
    output logic waitrequest,
    output logic [31:0] readdata

);

  parameter RAM_INIT_FILE = "";
  logic [31:0] memory[4095:0];

  logic [31:0] sim_address;
  //simulate address in memory 
  assign sim_address = ((address - 32'hBFC00000) >> 2) % 4096;

  initial begin

    for (int i = 0; i < 4096; i++) begin
      memory[i] = 0;
    end

    if (RAM_INIT_FILE != "") begin
      $display("Loading RAM contents from %s", RAM_INIT_FILE);
      $readmemh(RAM_INIT_FILE, memory);
    end
  end

  integer waittime;
  // initialise values
  initial begin
    waitrequest = 0;
    readdata = 0;
    waittime = 0;
  end

  //start wait request if reading or writing
  always_ff @(posedge read or posedge write) begin
    waittime <= $urandom % 5;
  end

  always_comb begin
    if (waittime != 0) begin
      waitrequest = 1;
    end else begin
      waitrequest = 0;
    end
  end

  always_ff @(posedge clk) begin
    waittime <= $urandom % 5;  //tests cpu does not stall if it isn't reading or writing even if wait request is high
    if (!waitrequest) begin
      if (read) begin
        readdata[31:24] <= byteenable[3] ? memory[sim_address][31:24] : 0;
        readdata[23:16] <= byteenable[2] ? memory[sim_address][23:16] : 0;
        readdata[15:8]  <= byteenable[1] ? memory[sim_address][15:8] : 0;
        readdata[7:0]   <= byteenable[0] ? memory[sim_address][7:0] : 0;
      end else if (write) begin
        memory[sim_address][31:24] <= (byteenable[3] ? writedata[31:24] : memory[sim_address][31:24]);
        memory[sim_address][23:16] <= (byteenable[2] ? writedata[23:16] : memory[sim_address][23:16]);
        memory[sim_address][15:8] <= (byteenable[1] ? writedata[15:8] : memory[sim_address][15:8]);
        memory[sim_address][7:0] <= (byteenable[0] ? writedata[7:0] : memory[sim_address][7:0]);
      end
    end else begin
      waittime <= waittime - 1;
    end

  end



endmodule
