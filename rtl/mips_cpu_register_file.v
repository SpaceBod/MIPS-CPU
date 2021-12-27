module mips_cpu_register_file (
    // control ports
    input logic clk,
    input logic reset,
    input logic write_enable,
    input logic orwrite,
    input logic [1:0] shiftdata,
    input logic loadlorloadr,
    // dual input read ports & write input ports
    input logic [4:0] read_reg_1,
    input logic [4:0] read_reg_2,
    input logic [4:0] write_reg,
    input logic [31:0] write_data,
    // dual read output ports & v0 port
    output logic [31:0] read_data_1,
    output logic [31:0] read_data_2,
    output logic [31:0] read_data_v0
);
  // create 32x32-bit register
  logic [31:0] register[31:0];

  // return data
  assign read_data_v0 = register[2];
  assign read_data_1  = register[read_reg_1];
  assign read_data_2  = register[read_reg_2];

  logic [31:0] finalwritedataleft, finalwritedataright;
  assign finalwritedataleft = (shiftdata == 3 ? {8'h00, register[write_reg][23:0]} : shiftdata == 2 ? {16'h0000, register[write_reg][15:0]} : shiftdata == 1 ? {24'h000000, register[write_reg][7:0]} : 32'h00000000);
  assign finalwritedataright = (shiftdata == 0 ? {register[write_reg][31:8], 8'h00} : shiftdata == 1 ? {register[write_reg][31:16], 16'h0000} : shiftdata == 2 ? {register[write_reg][31:24], 24'h000000} : 32'h00000000);

  // reset & write
  always_ff @(posedge clk) begin  //TODO: remove dispays and state as an input when done testing
    // reset register
    if (reset) begin
      for (int i = 0; i < 32; i++) begin
        register[i] <= 0;
      end
    end else begin
      // write to register
      if (write_enable && write_reg != 0) begin
        if (orwrite) begin
          register[write_reg] <= loadlorloadr ? (write_data | finalwritedataright) : (write_data | finalwritedataleft);
        end else begin
          register[write_reg] <= write_data;
        end
      end
    end
  end

endmodule
