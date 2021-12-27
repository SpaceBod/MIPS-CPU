module mips_cpu_controller (
    input logic [5:0] opcode,
    input logic [5:0] fncode,
    input logic [31:0] memoryadress,
    input logic [4:0] regimm,
    input logic [2:0] state,
    input logic waitrequest,

    output logic [1:0] regdst,
    output logic [2:0] loadtype,
    output logic loadlorloadr,
    output logic [1:0] endiantype,
    output logic regwrite,
    output logic orwrite,
    output logic iord,
    output logic irwrite,
    output logic pcwrite,
    output logic [1:0] pcsource,
    output logic pcwritecond,
    output logic jump,
    output logic jumpconen,
    output logic threestate,
    output logic memread,
    output logic memwrite,
    output logic [1:0] shiftdata,
    output logic [3:0] byteenable,
    output logic memtoreg,
    output logic [3:0] aluop,
    output logic muldivwrite,
    output logic alusrca,
    output logic [2:0] alusrcb,
    output logic aluouten

);

  logic exec1, exec2;

  always_comb begin
    exec1 = (state == 3);
    exec2 = (state == 4);

    if (state == 0) begin  //haulted
      regwrite = 0;
      iord = 0;
      irwrite = 0;
      pcwrite = 0;
      pcwritecond = 0;
      jump = 0;
      jumpconen = 0;
      memread = 0;
      memwrite = 0;
      aluouten = 0;
      muldivwrite = 0;
    end else if (state == 1) begin  //fetch     
      regwrite = 0;
      iord = 0;
      irwrite = 0;
      pcwrite = !waitrequest;
      pcsource = 0;
      pcwritecond = 0;
      jump = 0;
      jumpconen = !waitrequest;
      memread = 1;
      memwrite = 0;
      byteenable = 4'b1111;
      aluop = 0;
      alusrca = 0;
      alusrcb = 1;
      aluouten = 1;
      muldivwrite = 0;
    end else if (state == 2) begin  //decode
      regwrite = 0;
      irwrite = 1;
      pcwrite = 0;
      pcwritecond = 0;
      jump = 0;
      memread = 0;
      memwrite = 0;
      byteenable = 4'b1111;
      aluop = 0;
      alusrca = 0;
      alusrcb = 3;
      aluouten = 1;
      muldivwrite = 0;
    end else begin  //exec1 and exec2
      case (opcode)
        6'h0: begin  //Rtype and Special
          case (fncode)
            6'h0, 6'h2, 6'h3, 6'h4, 6'h6, 6'h7, 6'h21, 6'h23, 6'h24, 6'h25, 6'h26, 6'h2a, 6'h2b: begin  //SLL, SRL, SRA, SLLV, SRLV, SRAV, ADDU, SUBU, AND, OR, XOR, SLT, SLTU
              regdst = 1;
              loadtype = 0;
              regwrite = 1;
              orwrite = 0;
              endiantype = 0;
              irwrite = 0;
              pcwrite = 0;
              pcwritecond = 0;
              jump = 0;
              threestate = 1;
              memread = 0;
              memwrite = 0;
              memtoreg = 0;
              aluop = 2;
              alusrca = 1;
              alusrcb = 0;
              aluouten = 1;
              muldivwrite = 0;
            end
            6'h8: begin  //JR
              regwrite = 0;
              irwrite = 0;
              endiantype = 0;
              pcwrite = 0;
              pcsource = 3;
              pcwritecond = 0;
              jump = 1;
              threestate = 1;
              memread = 0;
              memwrite = 0;
              aluop = 0;
              alusrca = 0;
              alusrcb = 0;
              aluouten = 1;
              muldivwrite = 0;
            end
            6'h9: begin  //JALR
              regdst = 1;
              loadtype = 0;
              regwrite = 1;
              orwrite = 0;
              endiantype = 0;
              iord = 0;
              irwrite = 0;
              pcwrite = 0;
              pcsource = 3;
              pcwritecond = 0;
              jump = 1;
              threestate = 1;
              memread = 0;
              memwrite = 0;
              byteenable = 0;
              memtoreg = 0;
              aluop = 0;
              alusrca = 0;
              alusrcb = 1;
              aluouten = 1;
              muldivwrite = 0;
            end
            6'h10, 6'h12: begin  //MFHI, MFLO
              regdst = 1;
              loadtype = 0;
              regwrite = 1;
              orwrite = 0;
              endiantype = 0;
              iord = 0;
              irwrite = 0;
              pcwrite = 0;
              pcsource = 0;
              pcwritecond = 0;
              jump = 0;
              threestate = 1;
              memread = 0;
              memwrite = 0;
              byteenable = 0;
              memtoreg = 0;
              aluop = 9;
              alusrca = 0;
              alusrcb = 0;
              aluouten = 1;
              muldivwrite = 0;
            end
            6'h11, 6'h13, 6'h18, 6'h19, 6'h1a, 6'h1b: begin  //MTHI, MTLO, MULT, MULTU, DIV, DIVU
              regdst = 0;
              loadtype = 0;
              regwrite = 0;
              orwrite = 0;
              endiantype = 0;
              iord = 0;
              irwrite = 0;
              pcwrite = 0;
              pcsource = 0;
              pcwritecond = 0;
              jump = 0;
              threestate = 1;
              memread = 0;
              memwrite = 0;
              byteenable = 0;
              memtoreg = 0;
              aluop = 9;
              alusrca = 1;
              alusrcb = 0;
              aluouten = 1;
              muldivwrite = 1;
            end
            default: begin
              regwrite = 0;
              iord = 0;
              irwrite = 0;
              pcwrite = 0;
              pcwritecond = 0;
              jump = 0;
              jumpconen = 0;
              memread = 0;
              memwrite = 0;
              aluouten = 0;
              muldivwrite = 0;
            end
          endcase
        end
        6'h1: begin  //REGIMM     BLTZ, BLTZAL, BGEZ, BGEZAL
          if (regimm < 2) begin  //BLTZ, BGEZ
            regwrite = 0;
            orwrite = 0;
            endiantype = 0;
            loadtype = 0;
            regdst = 0;
            iord = 0;
            irwrite = 0;
            pcwrite = 0;
            pcsource = 1;
            pcwritecond = 1;
            jump = 0;
            threestate = 1;
            memread = 0;
            memwrite = 0;
            byteenable = 0;
            memtoreg = 0;
            aluop = regimm == 0 ? 7 : 4;
            alusrca = 1;
            alusrcb = 0;
            aluouten = 1;
            muldivwrite = 0;
          end else begin  //BLTZAL, BGEZAL
            regdst = 2;
            loadtype = 0;
            regwrite = exec1;
            orwrite = 0;
            endiantype = 0;
            iord = 0;
            irwrite = 0;
            pcwrite = 0;
            pcsource = 1;
            pcwritecond = exec2;
            jump = 0;
            threestate = 0;
            memread = 0;
            memwrite = 0;
            byteenable = 0;
            memtoreg = 0;
            aluop = exec2 * (regimm == 16) ? 7 : exec2 ? 4 : 0;
            alusrca = exec2;
            alusrcb = 1;
            aluouten = 0;
            muldivwrite = 0;
          end
        end
        6'h2: begin  //J
          regwrite = 0;
          orwrite = 0;
          endiantype = 0;
          loadtype = 0;
          regdst = 0;
          iord = 0;
          irwrite = 0;
          pcwrite = 0;
          pcsource = 2;
          pcwritecond = 0;
          jump = 1;
          threestate = 1;
          memread = 0;
          memwrite = 0;
          byteenable = 0;
          memtoreg = 0;
          aluop = 0;
          alusrca = 0;
          alusrcb = 0;
          aluouten = 1;
          muldivwrite = 0;
        end
        6'h3: begin  //JAL
          regdst = 2;
          loadtype = 0;
          regwrite = 1;
          orwrite = 0;
          endiantype = 0;
          iord = 0;
          irwrite = 0;
          pcwrite = 0;
          pcsource = 2;
          pcwritecond = 0;
          jump = 1;
          threestate = 1;
          memread = 0;
          memwrite = 0;
          byteenable = 0;
          memtoreg = 0;
          aluop = 0;
          alusrca = 0;
          alusrcb = 1;
          aluouten = 1;
          muldivwrite = 0;
        end
        6'h4, 6'h5, 6'h6, 6'h7: begin  //BEQ, BNE, BLEZ, BGTZ
          regwrite = 0;
          loadtype = 0;
          orwrite = 0;
          endiantype = 0;
          regdst = 0;
          iord = 0;
          irwrite = 0;
          pcwrite = 0;
          pcsource = 1;
          pcwritecond = 1;
          jump = 0;
          threestate = 1;
          memread = 0;
          memwrite = 0;
          byteenable = 0;
          memtoreg = 0;
          aluop = opcode == 6'h4 ? 3 : opcode == 6'h5 ? 8 : opcode == 6'h6 ? 6 : 5;
          alusrca = 1;
          alusrcb = 0;
          aluouten = 1;
          muldivwrite = 0;
        end
        6'h9: begin  //ADDIU
          regdst = 0;
          loadtype = 0;
          regwrite = 1;
          orwrite = 0;
          endiantype = 0;
          iord = 0;
          irwrite = 0;
          pcwrite = 0;
          pcsource = 0;
          pcwritecond = 0;
          jump = 0;
          threestate = 1;
          memread = 0;
          memwrite = 0;
          byteenable = 0;
          memtoreg = 0;
          aluop = 0;
          alusrca = 1;
          alusrcb = 2;
          aluouten = 1;
          muldivwrite = 0;
        end
        6'ha, 6'hb, 6'hc, 6'hd, 6'he: begin  //SLTI. SLTIU ANDI, ORI, XORI
          regdst = 0;
          loadtype = 0;
          regwrite = 1;
          orwrite = 0;
          endiantype = 0;
          iord = 0;
          irwrite = 0;
          pcwrite = 0;
          pcsource = 0;
          pcwritecond = 0;
          jump = 0;
          threestate = 1;
          memread = 0;
          memwrite = 0;
          byteenable = 0;
          memtoreg = 0;
          aluop = opcode == 6'ha ? 13 : opcode == 6'hb ? 14 : opcode == 6'hc ? 10 : opcode == 6'hd ? 11 : 12;
          alusrca = 1;
          alusrcb = 4;
          aluouten = 1;
          muldivwrite = 0;
        end
        6'hf: begin  //LUI
          regdst = 0;
          loadtype = 2;
          regwrite = 1;
          orwrite = 0;
          endiantype = 0;
          iord = 0;
          irwrite = 0;
          pcwrite = 0;
          pcsource = 0;
          pcwritecond = 0;
          jump = 0;
          threestate = 1;
          memread = 0;
          memwrite = 0;
          byteenable = 0;
          memtoreg = 0;
          aluop = 0;
          alusrca = 0;
          alusrcb = 0;
          aluouten = 1;
          muldivwrite = 0;
        end
        6'h20, 6'h21, 6'h22, 6'h23, 6'h24, 6'h25, 6'h26: begin  //LB, LH, LWL, LW, LBU, LHU, LWR
          regdst = 0;
          shiftdata = memoryadress % 4;
          loadtype = (opcode == 6'h24 || opcode == 6'h25) ? 4 : (opcode == 6'h22 || opcode == 6'h26) ? 3 : (opcode == 6'h20 || opcode == 6'h21 || opcode == 6'h23) ? 1 : 0;
          loadlorloadr = opcode == 6'h26;
          endiantype = (opcode == 6'h22 || opcode == 6'h26 || opcode == 6'h23) ? 2 : (opcode == 6'h21 || opcode == 6'h25) ? 1 : 0;
          regwrite = exec2;
          orwrite = opcode == 6'h22 || opcode == 6'h26;
          iord = 1;
          irwrite = 0;
          pcwrite = 0;
          pcsource = 0;
          pcwritecond = 0;
          jump = 0;
          threestate = 0;
          memread = exec1;
          memwrite = 0;
          byteenable = (opcode == 6'h22 || opcode == 6'h26 || opcode == 6'h23) ? 4'b1111 : (opcode == 6'h21 || opcode == 6'h25) ? 3 << (memoryadress % 4) : 1 << (memoryadress % 4);
          memtoreg = 1;
          aluop = 0;
          alusrca = 1;
          alusrcb = 2;
          aluouten = 1;
          muldivwrite = 0;
        end
        6'h28, 6'h29, 6'h2b: begin  //SB, SH, SW
          regdst = 0;
          loadtype = 0;
          regwrite = 0;
          orwrite = 0;
          iord = 1;
          irwrite = 0;
          pcwrite = 0;
          pcsource = 0;
          pcwritecond = 0;
          jump = 0;
          threestate = 1;
          memread = 0;
          memwrite = 1;
          endiantype = opcode == 6'h2b ? 2 : opcode == 6'h29 ? 1 : 0;
          shiftdata = memoryadress % 4;
          byteenable = opcode == 6'h2b ? 4'b1111 : opcode == 6'h29 ? 3 << (memoryadress % 4) : 1 << (memoryadress % 4);
          memtoreg = 0;
          aluop = 0;
          alusrca = 1;
          alusrcb = 2;
          aluouten = 1;
          muldivwrite = 0;
        end
        default: begin
          regwrite = 0;
          iord = 0;
          irwrite = 0;
          pcwrite = 0;
          pcwritecond = 0;
          jump = 0;
          jumpconen = 0;
          memread = 0;
          memwrite = 0;
          aluouten = 0;
          muldivwrite = 0;
        end
      endcase
    end
  end
endmodule
