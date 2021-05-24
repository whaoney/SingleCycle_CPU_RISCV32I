// module addr_adder (
// 	input  [31:0] a, b,
// 	output [31:0] y);

// 	assign  y = a + b;
// endmodule

// shift left by 1 for address calculation
// module sl1(
//     input  [31:0] a,
// 	  output [31:0] y);
//     assign  y = {a[30:0], 1'b0};
// endmodule

// module cmp(
//   input [31:0]      a, b,
//   input             op_unsigned,
//   output            zero,
//   output            lt);

//   assign zero = (a == b);
//   assign lt = (!op_unsigned & ($signed(a) < $signed(b))) | (op_unsigned & (a < b));
// endmodule

//amp for store
// module ampattern (input [1:0] addr, input [1:0] swhb, output reg [3:0] amp); //amp: access memory pattern
//   always@(*)
//   case (swhb)
//     2'b01: amp <= 4'b1111;
//     2'b10: if (addr[1]) amp <= 4'b1100;
//            else         amp <= 4'b0011; //addr[0]
//     2'b11: case (addr)
//               2'b00: amp <= 4'b0001;
//               2'b01: amp <= 4'b0010;
//               2'b10: amp <= 4'b0100;
//               2'b11: amp <= 4'b1000;
//            endcase
//     default: amp <= 4'b1111;// it shouldn't happen
//   endcase
// endmodule