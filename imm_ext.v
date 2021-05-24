
`include "defines.v"
 module imm_ext (
    input [31:0]          instr,
    input[4:0]            immctrl,
    input                 si,
    output reg[31:0]      immout
 );
 always @(*) 
   case (immctrl)
       `ctrl_ityple:   begin
                            if   (si) 
                          immout <= {{26{instr[24]}},instr[24:20]};
                            else if (~si)
                          immout <= {{20{instr[31]}}, instr[31:20]};
                       end
                           
       `ctrl_styple:      immout <= {{20{instr[31]}}, instr[31:25],instr[11:7]};
       `ctrl_btyple:      immout <= {{20{instr[31]}}, instr[7],instr[30:25],instr[11:8],1'b0};
       `ctrl_utyple:      immout <= {instr[31:12], 12'b0};
       `ctrl_jtyple:      immout <= {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; 
       default:           immout <= 32'b0;
   endcase
     
 endmodule