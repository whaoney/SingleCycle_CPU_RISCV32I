

module pc(
    input            clk,reset,
    input  [31:0]    nextpc,
    output reg[31:0] pc
    // input            pcsrc   //the sigal for pc control
 );

always @(posedge clk,posedge reset) begin
    if (reset)
        pc <= 32'b0;
    // else if (pcsrc & ~reset)
    //     pc <= npc; 
    // else if(~pcsrc & ~reset)
    else  
        pc <= nextpc;      
end
endmodule