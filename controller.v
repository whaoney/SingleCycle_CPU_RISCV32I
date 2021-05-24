//busigned alusrca alusrcb lt aren't used 
`include "defines.v"

module controller(
  input                     clk, reset,
  input [6:0]	              opcode,
  input [2:0]               funct3,
  input [6:0]               funct7,
  input [4:0]               rd, rs1,
  input [11:0]              imm,
  input                     zero, lt, 
  output [4:0]              immctrl,            // for immidiate extention
  output                    jump, jalr, si , bunsigned, pcsrc,//  for srli、slli、srai; jal、jalr for pc; bunsigned for bltu、bgeu; pcsrc for pc 
  output reg  [3:0]         aluctrl,            // for the EX stage 
  output [1:0]              alusrca,
  output                    alusrcb,
  output                    memwrite, lunsigned,  // for the MEM stage，lunsigned for unsigned load
  output [1:0]              lwhb, swhb,          // for different load instruction, instead of memryread
  output                    memtoreg, regwrite,  // for the WB stage
  output                    auipc,alui                
  );

  wire u_lui       = (opcode == `op_lui);
  wire u_auipc     = (opcode == `op_auipc);
  wire j_jal       = (opcode == `op_jal);
  wire i_jalr      = (opcode == `op_jalr);
  wire branch      = (opcode == `op_branch);
  wire load        = (opcode == `op_load);
  wire store       = (opcode == `op_store);
  wire addi        = (opcode == `op_addi);
  wire add         = (opcode == `op_add);

  wire b_beq         = ((opcode == `op_branch) & (funct3 == `funct3_beq));
  wire b_bne         = ((opcode == `op_branch) & (funct3 == `funct3_bne));
  wire b_blt         = ((opcode == `op_branch) & (funct3 == `funct3_blt));
  wire b_bge         = ((opcode == `op_branch) & (funct3 == `funct3_bge));
  wire b_bltu        = ((opcode == `op_branch) & (funct3 == `funct3_bltu));
  wire b_bgeu        = ((opcode == `op_branch) & (funct3 == `funct3_bgeu));

  wire i_lb          = ((opcode == `op_load) & (funct3 == `funct3_lb));
  wire i_lh          = ((opcode == `op_load) & (funct3 == `funct3_lh));
  wire i_lw          = ((opcode == `op_load) & (funct3 == `funct3_lw));
  wire i_lbu         = ((opcode == `op_load) & (funct3 == `funct3_lbu));
  wire i_lhu         = ((opcode == `op_load) & (funct3 == `funct3_lhu));

  wire s_sb          = ((opcode == `op_store) & (funct3 == `funct3_sb));
  wire s_sh          = ((opcode == `op_store) & (funct3 == `funct3_sh));
  wire s_sw          = ((opcode == `op_store) & (funct3 == `funct3_sw));

  wire i_addi        = ((opcode == `op_addi) & (funct3 == `funct3_addi));
  wire i_slti        = ((opcode == `op_addi) & (funct3 == `funct3_slti));
  wire i_sltiu       = ((opcode == `op_addi) & (funct3 == `funct3_sltiu));
  wire i_xori        = ((opcode == `op_addi) & (funct3 == `funct3_xori));
  wire i_ori	        = ((opcode == `op_addi) & (funct3 == `funct3_ori));
  wire i_andi        = ((opcode == `op_addi) & (funct3 == `funct3_andi));
  wire i_slli        = ((opcode == `op_addi) & (funct3 == `funct3_slli) & (funct7 == `funct7_slli));
  wire i_srli        = ((opcode == `op_addi) & (funct3 == `funct3_srli) & (funct7 == `funct7_srli));
  wire i_srai        = ((opcode == `op_addi) & (funct3 == `funct3_srai) & (funct7 == `funct7_srai));

  wire r_add         = ((opcode == `op_add) & (funct3 == `funct3_add) & (funct7 == `funct7_add));
  wire r_sub         = ((opcode == `op_add) & (funct3 == `funct3_sub) & (funct7 == `funct7_sub));
  wire r_sll         = ((opcode == `op_add) & (funct3 == `funct3_sll) & (funct7 == `funct7_sll));
  wire r_slt         = ((opcode == `op_add) & (funct3 == `funct3_slt) & (funct7 == `funct7_slt));
  wire r_sltu        = ((opcode == `op_add) & (funct3 == `funct3_sltu) & (funct7 == `funct7_sltu));
  wire r_xor         = ((opcode == `op_add) & (funct3 == `funct3_xor) & (funct7 == `funct7_xor));
  wire r_srl         = ((opcode == `op_add) & (funct3 == `funct3_srl) & (funct7 == `funct7_srl));
  wire r_sra         = ((opcode == `op_add) & (funct3 == `funct3_sra) & (funct7 == `funct7_sra));
  wire r_or          = ((opcode == `op_add) & (funct3 == `funct3_or)  & (funct7 == `funct7_or));
  wire r_and         = ((opcode == `op_add) & (funct3 == `funct3_and) & (funct7 == `funct7_and));

  wire fence         = ((opcode == `op_fence) & (funct3 == `funct3_fence));
  wire ecall         = ((opcode == `op_ecall) & (funct3 == `funct3_ecall));
  wire ebreak        = ((opcode == `op_ebreak) & (funct3 == `funct3_ebreak));

  wire rs1_x0        = (rs1 == 5'b00000);
  wire rd_x0         = (rd == 5'b00000);
  wire nop           = addi & rs1_x0 & rd_x0 & (imm == 12'b0); // nop == addi x0,x0,0


  wire       itype = addi | i_jalr | load;
  wire       stype = store; 
  wire       btype = branch;
  wire       utype = u_lui | u_auipc; 
  wire       jtype = j_jal; 

  assign immctrl = {itype, stype, btype, utype, jtype};

  assign si  =  i_slli | i_srli | i_srai;

  assign jump = j_jal | i_jalr;
  
  assign jalr = i_jalr;

  assign bunsigned = b_bltu | b_bgeu;

  assign pcsrc = j_jal | i_jalr | (b_beq & zero) | (b_bne & !zero) | ((b_blt | b_bltu) & lt) | ((b_bge | b_bgeu) & !lt);

  assign alusrca = u_lui ? 2'b01 : (u_auipc ? 2'b10 : ((j_jal | i_jalr) ? 2'b11 : 2'b00));

  assign alusrcb = u_lui | u_auipc | load | store | addi;

  assign memwrite = store;

  assign swhb = ({2{s_sw}}&2'b01) | ({2{s_sh}}&2'b10) | ({2{s_sb}}&2'b11);

  assign lwhb = ({2{i_lw}}&2'b00) | ({2{i_lh | i_lhu}}&2'b01) | ({2{i_lb | i_lbu}}&2'b10);

  assign lunsigned = i_lhu | i_lbu;

  assign memtoreg = load;

  assign regwrite = u_lui | u_auipc | j_jal | i_jalr | load | addi | add;    

  assign auipc = u_auipc;

  assign alui = addi | load | store ;
  //i_typle  signed extention
  assign ityple      = addi | i_jalr | load;
  //alu controller
  always @(*)
    case(opcode)
      `op_auipc:	  aluctrl <= `aluctrl_add;
      `op_jal:      aluctrl <= `aluctrl_zero; 
      `op_jalr:	    aluctrl <= `aluctrl_zero;
	  `op_branch: case(funct3)
						        `funct3_bltu:	aluctrl <= `aluctrl_subu;
						        `funct3_bgeu:	aluctrl <= `aluctrl_subu;
                                `funct3_beq:    aluctrl <= `aluctrl_sub;
                                `funct3_bne:    aluctrl <= `aluctrl_sub;
                                `funct3_blt:    aluctrl <= `aluctrl_sub;
                                `funct3_bge:    aluctrl <= `aluctrl_sub;
						        default:		aluctrl <= `aluctrl_zero;
                  endcase

      `op_load:	  aluctrl <= `aluctrl_add;
      `op_store:	aluctrl <= `aluctrl_add;
      `op_lui:    aluctrl <= `aluctrl_lui;

      `op_addi:	  case(funct3)
						        `funct3_addi:	aluctrl <= `aluctrl_add;
						        `funct3_slti:	aluctrl <= `aluctrl_slt;
						        `funct3_sltiu:  aluctrl <= `aluctrl_sltu;
						        `funct3_xori:	aluctrl <= `aluctrl_xor;
        						`funct3_ori:	aluctrl <= `aluctrl_or;
        						`funct3_andi:	aluctrl <= `aluctrl_and;

        						`funct3_slli:   case (funct7)
                                                    `funct7_slli: aluctrl <= `aluctrl_sll;
                                                    default:      aluctrl <= `aluctrl_zero;
                                                endcase

                    `funct3_srli:   case (funct7)
              									                    `funct7_srli:	aluctrl <= `aluctrl_srl;
                                                    `funct7_srai:   aluctrl <= `aluctrl_sra;
              										default:		aluctrl <= `aluctrl_zero;
              								    endcase

						        default:		aluctrl <= `aluctrl_zero;

                  endcase

	  // `op_add
    7'b0110011:    case(funct3)
        						`funct3_add:	case(funct7)
                                                `funct7_add:  aluctrl <= `aluctrl_add;
        										                    `funct7_sub:  aluctrl <= `aluctrl_sub;
                                                default:      aluctrl <= `aluctrl_zero;
        									        endcase

        						`funct3_sll:	aluctrl <= `aluctrl_sll;
        						`funct3_slt:	aluctrl <= `aluctrl_slt;
        						`funct3_sltu:	aluctrl <= `aluctrl_sltu;
        						`funct3_xor:	aluctrl <= `aluctrl_xor;

                    `funct3_srl:     case(funct7)
                                                    `funct7_srl:  aluctrl <= `aluctrl_srl;
                                                    `funct7_sra:  aluctrl <= `aluctrl_sra;
                                                    default:      aluctrl <= `aluctrl_zero;
                                                endcase

        						`funct3_or:		aluctrl <= `aluctrl_or;
        						`funct3_and:	aluctrl <= `aluctrl_and;
                    default:		  aluctrl <= `aluctrl_zero;
        		  endcase
      default:   aluctrl <= `aluctrl_zero;
	endcase

endmodule