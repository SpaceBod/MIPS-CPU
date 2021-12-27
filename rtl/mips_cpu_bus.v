module mips_cpu_bus (
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic [31:0] register_v0,

    /* Avalon memory mapped bus controller */
    output logic [31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic [31:0] writedata,
    output logic [3:0] byteenable,
    input logic [31:0] readdata
);
  //variables for pc
  logic [31:0] pc_address_in, pc_value;

  //variables for alu (need to add in the alu_control)
  logic [31:0] alu_result, alu_in_a, alu_in_b, alu_out;
  logic condition;

  //variables for alu control
  logic [4:0] toalu;
  logic [2:0] tomult;

  //variables for A and B registers
  logic [31:0] read_reg_a_current, read_reg_b_current;

  //variables for memory data register
  logic [31:0] mem_reg_current;

  //variables for jumps and branching
  logic jumpcondreg;
  logic [31:0] jumpdestreg, increment_pc;

  //variables for ir
  logic [4:0] shift;
  logic [5:0] opcode, fncode;
  logic [25:0] jmp_address;
  logic [15:0] immediate;
  logic [31:0] sign_extended_immediate;
  logic [31:0] zero_extended_immediate;

  //variables for register file
  logic [4:0] reg_source_1, reg_source_2, reg_dest;
  logic [31:0]
      to_reg_write,
      reg_write_data,
      sign_extended_reg_write_data,
      final_reg_write_data,
      read_reg_1,
      read_reg_2;
  logic [4:0] reg_write_address;

  //variables for control
  logic
      pcwritecond,
      pcwrite,
      iord,
      ir_write,
      memtoreg,
      regwrite,
      alusrca,
      muldivwrite,
      threestate,
      aluouten,
      orwrite,
      loadlorloadr,
      jump,
      jumpconen;

  logic [1:0] pcsource, regdst, shiftdata, endiantype;
  logic [2:0] alusrcb, loadtype;
  logic [ 3:0] aluop;

  //variables for state machine
  logic [ 2:0] state;

  //varibles for memory endian conversion
  logic [31:0] fixed_endian_reg_write_data;
  logic [31:0] dataflipped;

  //initial conditions
  initial begin
    state = 0;
    active = 0;
    jumpcondreg = 0;
  end

  //state machine
  always_ff @(posedge clk) begin
    if (reset) begin
      state  <= 1;
      active <= 1;
    end else if (pc_value == 0 && (state == 4 || (state == 3 && threestate))) begin
      state  <= 0;
      active <= 0;
    end else if (!waitrequest || (!read && !write)) begin
      if (state == 4 || (state == 3 && threestate)) begin
        state <= 1;
      end else if (!state == 0) begin
        state <= state + 1;
      end
    end
  end

  //interpreting the readdata from RAM as big endian
  assign dataflipped = {{readdata[07:00]}, {readdata[15:08]}, {readdata[23:16]}, {readdata[31:24]}};

  //sign extending
  assign sign_extended_immediate = immediate[15] ? {16'hFFFF, immediate} : {16'h0000, immediate};
  assign zero_extended_immediate = {16'h0000, immediate};

  //assign where to write to memory from and shifting correct bits to match endians
  assign writedata = endiantype[1] ? {{read_reg_b_current[07:00]}, {read_reg_b_current[15:08]}, {read_reg_b_current[23:16]}, {read_reg_b_current[31:24]}} : endiantype[0] ? {{read_reg_b_current[07:00]}, {read_reg_b_current[15:08]}, {read_reg_b_current[07:00]}, {read_reg_b_current[15:08]}} : read_reg_b_current << (8 * shiftdata);

  //assigns for load instrutions
  assign fixed_endian_reg_write_data = endiantype[1] ? {{to_reg_write[07:00]}, {to_reg_write[15:08]}, {to_reg_write[23:16]}, {to_reg_write[31:24]}} : endiantype[0] ? {{to_reg_write[23:16]}, {to_reg_write[31:24]}, {to_reg_write[07:00]}, {to_reg_write[15:08]}} : to_reg_write;
  assign reg_write_data = fixed_endian_reg_write_data >> (8 * shiftdata);
  assign sign_extended_reg_write_data = reg_write_data[15:8] == 0 ? reg_write_data[7] ? {24'hFFFFFF, reg_write_data[7:0]} : reg_write_data : reg_write_data[15] ? {16'hFFFF, reg_write_data[15:0]} : reg_write_data;
  assign final_reg_write_data = loadtype[2] ? reg_write_data : loadtype[1] ? loadtype[0] ? loadlorloadr ? fixed_endian_reg_write_data >> (8*(3 - shiftdata)) : fixed_endian_reg_write_data << (8*shiftdata) : {immediate, 16'h0000} :loadtype[0] ? sign_extended_reg_write_data : fixed_endian_reg_write_data;


  //implementing main multiplexers
  assign address = iord ? alu_result : pc_value;
  assign reg_write_address = regdst[1] ? 31 : regdst[0] ? reg_dest : reg_source_2;
  assign to_reg_write = memtoreg ? readdata : alu_result;
  assign alu_in_a = alusrca ? read_reg_a_current : pc_value;
  assign alu_in_b = alusrcb[2] ? zero_extended_immediate : alusrcb[1] ? (alusrcb[0] ? (sign_extended_immediate << 2) : sign_extended_immediate ) : (alusrcb[0] ? 4 : read_reg_b_current);
  assign increment_pc = pcsource[1] ? (pcsource[0] ? read_reg_a_current : {pc_value[31:28], jmp_address, 2'b00}) : (pcsource[0] ? alu_out: alu_result);
  assign pc_address_in = jumpcondreg ? jumpdestreg : increment_pc;


  //implementing all single registers
  always_ff @(posedge clk) begin
    read_reg_a_current <= read_reg_1;
    read_reg_b_current <= read_reg_2;
    if (jumpconen) begin
      jumpcondreg <= ((condition & pcwritecond) || jump);
    end
    if ((condition & pcwritecond) || jump) begin
      jumpdestreg <= increment_pc;
    end
    if (aluouten) begin
      alu_out <= alu_result;
    end
  end

  //instantiate all modules 
  mips_cpu_pc cpu_pc (
      .pcin(pc_address_in),
      .clk(clk),
      .reset(reset),
      .pcenable(pcwrite),
      .pcout(pc_value)
  );

  mips_cpu_controller cpu_control (
      .opcode(opcode),
      .fncode(fncode),
      .memoryadress(alu_result),
      .regimm(reg_source_2),
      .state(state),
      .waitrequest(waitrequest),
      .regdst(regdst),
      .loadtype(loadtype),
      .loadlorloadr(loadlorloadr),
      .regwrite(regwrite),
      .orwrite(orwrite),
      .iord(iord),
      .irwrite(ir_write),
      .pcwrite(pcwrite),
      .jump(jump),
      .jumpconen(jumpconen),
      .threestate(threestate),
      .pcsource(pcsource),
      .pcwritecond(pcwritecond),
      .memread(read),
      .memwrite(write),
      .endiantype(endiantype),
      .shiftdata(shiftdata),
      .byteenable(byteenable),
      .memtoreg(memtoreg),
      .aluop(aluop),
      .muldivwrite(muldivwrite),
      .alusrcb(alusrcb),
      .alusrca(alusrca),
      .aluouten(aluouten)
  );

  mips_cpu_instruction_reg cpu_instruction_register (
      .clk(clk),
      .enable(ir_write),
      .state(state),
      .memory_output(dataflipped),
      .control_input(opcode),  //instruction[31-26]
      .source_1(reg_source_1),  // instruction[25:21] 
      .source_2(reg_source_2),  //instruction[20:16]   
      .dest(reg_dest),  //instruction[15:11]
      .immediate(immediate),  //instruction[15:0]
      .jmp_address(jmp_address),  //instruction[25:0]
      .shamt(shift),  //instruction[6:10]
      .funct(fncode)  //instruction[5:0]
  );

  mips_cpu_register_file cpu_register_file (
      .clk(clk),
      .reset(reset),
      .orwrite(orwrite),
      .shiftdata(shiftdata),
      .loadlorloadr(loadlorloadr),
      .write_enable(regwrite),
      .read_reg_1(reg_source_1),
      .read_reg_2(reg_source_2),
      .write_reg(reg_write_address),
      .write_data(final_reg_write_data),
      .read_data_1(read_reg_1),
      .read_data_2(read_reg_2),
      .read_data_v0(register_v0)
  );

  mips_cpu_alu cpu_alu (
      .clk(clk),
      .reset(reset),
      .state(state),
      .alu_func(toalu),
      .mult_op(tomult),
      .a(alu_in_a),
      .b(alu_in_b),
      .shift(shift),
      .write(muldivwrite),
      .condition(condition),
      .result(alu_result)
  );

  mips_cpu_alu_control cpu_alu_control (
      .aluOp (aluop),
      .funct (fncode),
      .toAlu (toalu),
      .toMult(tomult)
  );


endmodule
