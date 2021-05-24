
`include "defines.v"
module alu(
	input	[31:0]			       r1, r2, 
	input	[31:0]       	       imm, 
	input	[3:0]                 aluctrl, 
	input                          alui,
	output reg [31:0]		       aluout,
	output                      overflow,
	output 						    zero,
	output 			                lt,
	output 						    ge
	);
    wire [31:0]                    a;
	wire [31:0]                    b;
	wire op_unsigned = ~aluctrl[3]&aluctrl[2]&aluctrl[1]&~aluctrl[0]	//aluctrl_addu	4'b0110
					| ~aluctrl[3]&aluctrl[2]&aluctrl[1]&aluctrl[0] 	      //aluctrl_subu	4'b0111
					| aluctrl[3]&aluctrl[2]&aluctrl[1]&~aluctrl[0]; 	   //aluctrl_sltu	4'b1110

	wire [31:0] 		         b2;  //inverse code of b
	wire [32:0] 			      sum; //adder of length 33
  
	wire   sub = ~aluctrl[3]&~aluctrl[2]&aluctrl[1]&~aluctrl[0] // aluctrl_sub 4'0010 
             | ~aluctrl[3]&aluctrl[2]&aluctrl[1]&aluctrl[0]; // aluctrl_subu 4'0111
   assign b2 =sub ? ~b:b;                                      // if sub, b will be inversed, don't care about other
	assign sum = (op_unsigned & ({1'b0, r1} + {1'b0, b2} + sub)) | (~op_unsigned & ({r1[31], r1} + {b2[31], b2} + sub));

    assign a = r1;

	assign b = alui ? imm : r2 ;
	

	always@(*)
		case(aluctrl)
		`aluctrl_move: 	    aluout <= r1;
		`aluctrl_add: 		aluout <= sum[31:0];
		`aluctrl_addu:		aluout <= sum[31:0];	
		`aluctrl_or:		aluout <= a | b;
		`aluctrl_xor: 		aluout <= a ^ b;
		`aluctrl_and:		aluout <= a & b;
		`aluctrl_sll: 		aluout <= r1 << imm; 
		`aluctrl_srl: 		aluout <= r1 >> imm;
		`aluctrl_sra: 		aluout <= {{(31){a[31]}},a} >> imm;  //don't use >>> to prevent error when insert code into demo board
		`aluctrl_sub: 	    aluout <= sum[31:0];
		`aluctrl_subu: 	    aluout <= sum[31:0];
		`aluctrl_slt: 	    aluout <= sum[31]^overflow;
		`aluctrl_sltu:      aluout <= (a < b);
		`aluctrl_lui:	    aluout <= imm; //a=0,b=immout
		`aluctrl_auipc:	    aluout <= sum[31:0]; //a=pc,b=immout		
		default: 			aluout <= 32'b0;  //aluctrl_zero
	 endcase
	    
	assign overflow = sum[31] ^ sum[32];
	assign zero = (aluout == 32'b0);
	assign lt = (~op_unsigned & aluout[31] ) | (op_unsigned & (a < b));
	assign ge = ~((~op_unsigned & aluout[31] ) | (op_unsigned & (a < b)));
endmodule
