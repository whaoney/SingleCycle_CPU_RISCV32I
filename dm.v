
`include "defines.v"
module dmem(input           	    clk, write,
            // input  [3:0]          amp,
            input  [31:0]         addr, writedata,
            input  [1:0]          lwhb,swhb,
            output reg [31:0]         read);

  // reg  [31:0] RAM[1023:0];
  reg  [7:0] RAM[1023:0];     // word aligned
  // read <= RAM[addr[9:0]]; 

  always @(*) begin
        // read <= RAM[addr[9:0]]; // word aligned
  //lwhb
  // 2'b00: lw
  // 2'b01: lh
  // 2'b10: lb
  if(~write)
  begin
  case (lwhb)
    2'b00:   read   <= {RAM[addr[9:0]+3],RAM[addr[9:0]+2],RAM[addr[9:0]+1],RAM[addr[9:0]]};
    2'b01:   read   <= {{16{RAM[addr[9:0]+1][7]}},RAM[addr[9:0]+1],RAM[addr[9:0]]};
    2'b10:   read   <= {{24{RAM[addr[9:0]][7]}},RAM[addr[9:0]]};
  endcase
  end
  //swhb
  //  2'b01: sw   
  // 2'b10: sh
  // 2'b11: sb
  if(write)
        begin 
          case(swhb)
            2'b01:  begin
                    RAM[addr[9:0]] <= writedata[7:0];
                    RAM[addr[9:0]+1] <= writedata[15:8];
                    RAM[addr[9:0]+2] <= writedata[23:16];
                    RAM[addr[9:0]+3]   <= writedata[31:24];
            end
                   
            2'b10:  begin
                    RAM[addr[9:0]] <= writedata[7:0];
                    #10 RAM[addr[9:0]+1]   <= writedata[15:8];
            end
                    
            2'b11:  RAM[addr[9:0]]   <= writedata[7:0];
        endcase
            // RAM[addr[9:0]] <= writedata;
        end
 
    end
    always @(RAM[0]) begin
       $display("dm0 %h",RAM[0]);
      
    end

  //for different types of store
  // always @(posedge clk)
  //   if (write)
  //     begin
  //     case (amp)
  //       4'b1111: RAM[addr[11:2]]        <= writedata;        // sw
  //       4'b0011: RAM[addr[11:2]][15:0]  <= writedata[15:0];  // sh
  //       4'b1100: RAM[addr[11:2]][31:16] <= writedata[15:0];  // sh
  //       4'b0001: RAM[addr[11:2]][7:0]   <= writedata[7:0];   // sb
  //   	  4'b0010: RAM[addr[11:2]][15:8]  <= writedata[7:0];   // sb
  //       4'b0100: RAM[addr[11:2]][23:16] <= writedata[7:0];   // sb
  //      	4'b1000: RAM[addr[11:2]][31:24] <= writedata[7:0];   // sb
  //      	default: RAM[addr[11:2]]        <= writedata;        // it shouldn't happen
  // 	   endcase

      // $display("dataaddr = %h, writedata = %h", {addr[31:2],2'b00}, writedata);
      // $display("dataaddr = %h, memdata = %h", {a[31:2],2'b00}, RAM[a[11:2]]);
  	  //  end
endmodule