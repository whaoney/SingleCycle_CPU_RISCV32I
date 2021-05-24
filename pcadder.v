
`include "defines.v"
// pc register with write enable
module pcaddimm (
	input      [31:0]       pc,
	input      [31:0]       data_r1,
	input      [31:0]	    imm,
	input                   jalr, 
	output reg [31:0]	    npc);
 
	always @(*)begin
		if (~jalr) npc <= pc+imm;
		else if(jalr) npc <= data_r1 +imm;
	end 
    	
endmodule

module pcplusfour(
  input  [31:0]                  pc,
  output reg [31:0]              pcplus4
);
  always @(*) begin
	  pcplus4 <= pc+4;	  
  end
endmodule
