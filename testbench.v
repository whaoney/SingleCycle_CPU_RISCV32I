
// `timescale 1ns/1ps
// module sccpu_tb();
    
//    reg  clk, reset;

 
//   wwhcpu U_wwhcpu(.clk(clk), .reset(reset));// instantiation of riscv
  
//    integer counter;
   
//    initial begin
//       clk = 0;
//       counter =0;
//       // reset = 1;
//       // #5 ;
//       reset = 0; #100;
//       reset = 1; #100;
//       reset = 0; #100;
//    end
   
//   always begin
    
//     #(100) clk = ~clk;   
  
//     if (clk == 1'b1) 
//       begin
//     	counter = counter + 1;
//     	$display("clock: %d", counter);
// 		$display("pc:\t\t%h", imem.pc);
// 		$display("instr:\t%h", imem.instr);
//       end
//    end //end always
   
// endmodule