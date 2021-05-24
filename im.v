`include "defines.v"

module imem(input  [31:0]            pc,
            output reg [31:0]   instr);

  reg  [31:0]   im_RAM[1024:0];

  
  // initial  
  // begin
  //           im_RAM[0]<=32'h00000037;
  //           im_RAM[1]<=32'h000000b7;
  //           im_RAM[2]<=32'h02002103;
  //           im_RAM[3]<=32'h000001B7;
  //           im_RAM[4]<=32'h00402203;
  //           im_RAM[5]<=32'h000002B7;
  //           im_RAM[6]<=32'h00000337;
  //           im_RAM[7]<=32'h00802383;
  //           im_RAM[8]<=32'h00000437;
  //           im_RAM[9]<=32'h000004B7;
  //           im_RAM[10]<=32'h00000537;
  //           im_RAM[11]<=32'h00C02583;
  //           im_RAM[12]<=32'h000004B3;
  //           im_RAM[13]<=32'h001102B3;
  //           im_RAM[14]<=32'h0242C1B3;
  //           im_RAM[15]<=32'h02B181B3;
  //           im_RAM[16]<=32'h0001A303;
  //           im_RAM[17]<=32'h02730263;
  //           im_RAM[18]<=32'h00735463;
  //           im_RAM[19]<=32'h00734863;
  //           im_RAM[20]<=32'h00300133;
  //           im_RAM[21]<=32'h02B14133;
  //           im_RAM[22]<=32'hFDDFF46F;
  //           im_RAM[23]<=32'h003000B3;
  //           im_RAM[24]<=32'h02B0C0B3;
  //           im_RAM[25]<=32'hFD1FF46F;
  //           im_RAM[26]<=32'h003004B3;
  //           im_RAM[27]<=32'h02B4C4B3;
  //   end
 initial
    begin
      $readmemh("D:/code/vscode/cpu/sccpu/Test_37_Instr.dat", im_RAM);
    end
  always @(*) begin
     instr <= im_RAM[pc[11:2]]; // instruction size aligned 
  end  
   
endmodule

