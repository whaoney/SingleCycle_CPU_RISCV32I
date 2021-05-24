
`include "defines.v"
module wwhcpu  ();
   
    integer counter;
    reg clk;
    reg reset;
   initial begin
      clk = 0;
       counter =0;
      // reset = 1;
      // #5 ;
      reset = 0; #100;
      reset = 1; #100;
      reset = 0; #100;
   end
     
  always begin
    
    #(100) clk = ~clk;   
  
    if (clk == 1'b1) 
      begin
    	$display("clock: %d", counter);
		counter = counter + 1;
      end
   end
    //pc
    wire [31:0]               nextpc;
    wire [31:0]               instr;
    wire [31:0]               pc;
    wire [31:0]               npc;
    wire [31:0]               pcplus4;
    //rf
    // wire [4:0]                addr_w;
    // wire [4:0]                addr_rs1;
    // wire [4:0]                addr_rs2;
    wire [31:0]               data_r1;
    wire [31:0]               data_r2;
    wire [31:0]               data_w;
    wire                      rf_w;
    
    
    wire                      mem_w;
    wire [31:0]               mem_read;
    
    wire [31:0]               aluout;
    wire                      overflow;
    
    wire [31:0]               imm;
    wire                      ge;
    wire                      zero;
    wire                      lt;
    wire [4:0]                immctrl;           
    wire                      jump; 
    wire                      jalr; 
    wire                      si ;
    wire                      bunsigned;
    wire                      pcsrc;
    wire  [3:0]               aluctrl;            
    wire  [1:0]               alusrca;
    wire                      alusrcb;
    wire                      lunsigned; 
    wire [1:0]                lwhb;
    wire [1:0]                swhb;       
    wire                      memtoreg;

    wire [31:0]               writedata;
    wire [31:0]               memout;
    wire                      auipc;
    wire                      alui;

//IF stage
pc  pc0(
        .clk(clk),
        .reset(reset),
        .nextpc(nextpc),
        .pc(pc)
    );

pcplusfour pcplusfour0( 
        .pc(pc),
        .pcplus4(pcplus4)       
    );

pcaddimm  pcaddimm0(  
        .pc(pc),
	    .data_r1(data_r1),
	    .imm(imm),
	    .jalr(jalr), 
	    .npc(npc)
    );

pc_mux pc_mux0(
        .npc(npc),
        .pcplus4(pcplus4),
        .pcsrc(pcsrc),
        .nextpc(nextpc)
);
 
imem   imem0(
        .pc(pc),
        .instr(instr)
    );

//ID stage
regfile regfile0(
        .clk(clk),
        .reset(reset),
        .rf_w(rf_w),
        .npc(npc),
        .auipc(auipc),
        .addr_r1(instr[19:15]),
        .addr_r2(instr[24:20]),
        .addr_w(instr[11:7]),
        .data_w(data_w),
        .jump(jump),
        .pcplus4(pcplus4),
        .data_r1(data_r1),
        .data_r2(data_r2) 
    );

imm_ext imm_ext0(
    .instr(instr),
    .immctrl(immctrl),
    .si(si),
    .immout(imm)
);

controller controller0(
    .clk(clk), 
    .reset(reset),
    .opcode(instr[6:0]),
    .funct3(instr[14:12]),
    .funct7(instr[31:25]),
    .rd(instr[11:7]), 
    .rs1(instr[19:15]),
    .imm(imm[11:0]),
    .zero(zero), 
    .lt(lt), 
    .immctrl(immctrl),            
    .jump(jump), 
    .jalr(jalr), 
    .si(si), 
    .bunsigned(bunsigned), 
    .pcsrc(pcsrc),
    .aluctrl(aluctrl),            
    .alusrca(alusrca),
    .alusrcb(alusrcb),
    .memwrite(mem_w), 
    .lunsigned(lunsigned), 
    .lwhb(lwhb), 
    .swhb(swhb),          
    .memtoreg(memtoreg), 
    .regwrite(rf_w), 
    .auipc(auipc),
    .alui(alui)
);

//EX stage
alu alu0(
    .r1(data_r1),
    .r2(data_r2), 
	.imm(imm), 
	.aluctrl(aluctrl),
    .alui(alui), 
	.aluout(aluout),
	.overflow(overflow),
	.zero(zero),
    .lt(lt),
	.ge(ge)
);

//MEM stage
dmem dmem0(
    .clk(clk), 
    .write(mem_w),
    .addr(aluout), 
    .writedata(data_r2),
    .lwhb(lwhb),
    .swhb(swhb),
    .read(mem_read)
);

// s_mux s_mux0(
//     .d(data_r2),
//     .s(swhb),
//     .y(writedata)
// );

// l_mux l_mux0(
//     .d(mem_read),
//     .s(lwhb),
//     .y(memout)
// );

mux2 mux2_memtoreg(
    .d0(mem_read),
    .d1(aluout),
    .s(memtoreg),
    .y(data_w)
);
endmodule