
`include "defines.v"
module regfile (
input                          clk, reset,
input                          rf_w,
input[31:0]                    npc,
input                          auipc,
input[4:0]                     addr_r1,
input[4:0]                     addr_r2,
input[4:0]                     addr_w,
input[31:0]                    data_w,
input                          jump,
input[31:0]                    pcplus4,
output[31:0]                   data_r1,
output[31:0]                   data_r2                
);

integer i;
reg[31:0]                      rf[31:0]; //32 registers
assign data_r1 = (addr_r1 != 0) ? rf[addr_r1] : 0;
assign data_r2 = (addr_r2 != 0) ? rf[addr_r2] : 0;


always @(negedge clk, posedge reset) begin
    if (reset) begin    
      for (i=0; i<32; i=i+1)
        rf[i] <= 0; 
    end
    
    if (rf_w && addr_w!= 0)
    begin
        if (jump)
       rf[addr_w] <= pcplus4;   //rd = pc+4
        else if (auipc)
        rf[addr_w] <= npc;  
        else if (!auipc)
        rf[addr_w] <= data_w;  
    end
         // $display("r[%2d] = 0x%8X,", addr_w, data_w);     
end
always @(posedge clk) begin
    #50
    $display("r3: %h",rf[3]);
    $display("r4: %h",rf[4]);
    $display("r5:  %h", rf[5]);
		$display("r7: %h", rf[7]);
        $display("r8: %h", rf[8]);
        $display("r9: %h", rf[9]);
        $display("r23: %h",rf[23]);
        $display("r24: %h",rf[24]);
end

endmodule