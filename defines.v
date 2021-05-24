`define addr_size                32 //address size
`define inst_size                32 //instruction size
`define inst_width               5  //width of instruction
`define reg_size                 32 //register reg_size
`define reg_width                5  //width of instruction

//opcode
`define op_lui                 7'b0110111
`define op_auipc               7'b0010111
`define op_jal                 7'b1101111
`define op_jalr                7'b1100111
`define op_branch              7'b1100011
`define op_load                7'b0000011
`define op_store               7'b0100011
`define op_addi                7'b0010011
`define op_add                 7'b0110011
`define op_fence               7'b0010111
`define op_ecall               7'b1110011
`define op_ebreak              7'b1110011

//funct7
`define funct7_slli             7'b0000000
`define funct7_srli             7'b0000000
`define funct7_srai             7'b0100000
`define funct7_add              7'b0000000
`define funct7_sub              7'b0100000
`define funct7_sll              7'b0000000
`define funct7_slt              7'b0000000
`define funct7_sltu             7'b0000000
`define funct7_xor              7'b0000000
`define funct7_srl              7'b0000000
`define funct7_sra              7'b0100000
`define funct7_or               7'b0000000
`define funct7_and              7'b0000000

//funct3
`define funct3_jalr             3'b000
`define funct3_beq              3'b000
`define funct3_bne              3'b001
`define funct3_blt              3'b100
`define funct3_bge              3'b101
`define funct3_bltu             3'b110 
`define funct3_bgeu             3'b111
`define funct3_lb               3'b000
`define funct3_lh               3'b001
`define funct3_lw               3'b010
`define funct3_lbu              3'b100
`define funct3_lhu              3'b101
`define funct3_sb               3'b000
`define funct3_sh               3'b001
`define funct3_sw               3'b010
`define funct3_addi             3'b000
`define funct3_slti             3'b010
`define funct3_sltiu            3'b011
`define funct3_xori             3'b100
`define funct3_ori              3'b110
`define funct3_andi             3'b111
`define funct3_slli             3'b001
`define funct3_srli             3'b101
`define funct3_srai             3'b101
`define funct3_add              3'b000
`define funct3_sub              3'b000
`define funct3_sll              3'b001
`define funct3_slt              3'b010
`define funct3_sltu             3'b011  
`define funct3_xor              3'b100
`define funct3_srl              3'b101
`define funct3_sra              3'b101
`define funct3_or               3'b110
`define funct3_and              3'b111
`define funct3_fence            3'b000
`define funct3_ecall            3'b000 
`define funct3_ebreak           3'b000

//aluctrl
`define aluctrl_move            4'b0000
`define aluctrl_add             4'b0001
`define aluctrl_sub             4'b0010
`define aluctrl_and             4'b0011
`define aluctrl_or              4'b0100
`define aluctrl_xor             4'b0101
`define aluctrl_addu            4'b0110
`define aluctrl_subu            4'b0111
`define aluctrl_sll             4'b1000
`define aluctrl_srl             4'b1001 
`define aluctrl_sra             4'b1010 
`define aluctrl_slt             4'b1011 
`define aluctrl_lui             4'b1100
`define aluctrl_auipc           4'b1101
`define aluctrl_sltu            4'b1110
`define aluctrl_zero            4'b1111

//the typle of instruction for immidiate controller
`define ctrl_ityple                 5'b10000 
`define ctrl_styple                 5'b01000
`define ctrl_btyple                  5'b00100 
`define ctrl_utyple                  5'b00010 
`define ctrl_jtyple                  5'b00001 

//pc control
`define  npc_plus4   2'b00
`define  npc_branch  2'b01
`define  npc_jump    2'b10
  

