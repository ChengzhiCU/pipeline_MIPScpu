`timescale 1ns/1ps


module UART(clk , sysclk , reset , addr , wr , datain , rd , dataout , rx , tx , outled);
  input clk , reset , wr , rd , rx , sysclk;
  input [31:0] datain , addr;
  output wire tx;
  output reg [31:0] dataout;
  output wire outled;
  
  
  wire clk_9600 , highclk;
  wire rstatus , tstatus;
  reg tenable;
  integer temp ;
  reg temp2;
  reg [4:0] uartcon;
  wire [7:0] rxdata;
  reg [7:0] txdata , rxtemp , txtemp; 
  
  initial begin 
    tenable = 0;
    temp = 0;
    temp2 = 0;
  end
  
  generator gen(sysclk , clk_9600 , highclk);
  receiver rec(rx , clk_9600 , highclk , rxdata , rstatus);
  sender sen(tenable , clk_9600 , txdata , tx , tstatus);
  assign outled = tenable;
  always@(*) begin
    uartcon[4] = ~tstatus;
  end
  
  always@(*) begin
    if(rd) begin
    if(addr == 32'h80000018)
      dataout = {24'b0 , txdata};
    else if(addr == 32'h8000001c)
      dataout = {24'b0 , rxdata};
    else if(addr == 32'h80000020)
      dataout = {28'b0 , uartcon[3:0]};
    else 
      dataout = 32'b0;
  end
  end
  
  always@(negedge reset or posedge clk) begin
    if(~reset) begin
      txtemp = 8'b0;
      uartcon[1:0] = 2'b00;
      
    end
    else begin
      if(wr) begin
        if(addr == 32'h80000018)
          txdata = datain[7:0];
        else if(addr == 32'h80000020)
          uartcon[1:0] = datain[1:0];
      end
    end
  end
  
  always@(negedge reset or posedge clk_9600) begin
    if(~reset) begin
      uartcon[3:2] = 0;
      temp = 0;
    end
    else begin
      if(uartcon[3] == 0 && uartcon[1] == 1) begin
          
            
         
        if(rstatus == 1) begin
          rxtemp = rxdata;
          uartcon[3] = 1;
        end
      end
      if(uartcon[3] == 1 && uartcon[1] == 0) begin
        uartcon[3] = 0;
      end
      if(uartcon[0] == 1 && uartcon[2] == 0) begin
        if(temp == 0) begin
		  tenable = 1;
         
        end
        temp = temp + 1;
        if(temp == 12) begin
          tenable = 0;
          uartcon[2] = 1;
        end
      end
      if(uartcon[2] == 1 && uartcon[0] == 0) begin
        uartcon[2] = 0;
      end
    end
  end

  
endmodule



module generator(sysclk , clk , highclk);
  input sysclk;
  output reg clk , highclk;
  integer temp1 , temp2;
  
  initial begin
    clk = 0;
    highclk = 0;
    temp1 = 0;
    temp2 = 0;
  end
  
  always @(posedge sysclk) begin
    temp1 = temp1 + 1;
    if (temp1 == 1) begin
      clk = ~clk;
    end
    
    if (temp1 == 2603) begin
      temp1 = 0;
    end
  end
  
  always @(posedge sysclk) begin
    temp2 = temp2 + 1;
    if (temp2 == 1) begin
      highclk = ~highclk;
    end
    if (temp2 == 163) begin
      temp2 = 0;
    end
  end
endmodule
  
module receiver(RX , clk , highclk , data , status);
  input RX , clk , highclk;
  output reg [7:0] data;
  output reg status;
  reg temp , temp2;
  reg [7:0] temp_data;
  integer cnt1 , cnt2;
  //output wire led;
  
	

  //assign led = data[7];
  initial begin
    temp = 0;
    //led = 0;
    temp2 = 0;
    cnt1 = 0;
    cnt2 = 0;
    status = 0;
    temp_data[0] = 0;
    temp_data[7] = 0;
    temp_data[6] = 0;
    temp_data[5] = 0;
    temp_data[4] = 0;
    temp_data[3] = 0;
    temp_data[2] = 0;
    temp_data[1] = 0;
  end
  
 
  always @(posedge highclk) begin
    if(RX == 0 && temp == 0) begin
      temp = 1;
    end
  
    if(temp) begin
      cnt1 = cnt1 + 1;
      if (cnt1 == 8) begin
		    temp_data[7] = temp_data[6];
        temp_data[6] = temp_data[5];
        temp_data[5] = temp_data[4];
        temp_data[4] = temp_data[3];
        temp_data[3] = temp_data[2];
        temp_data[2] = temp_data[1];
        temp_data[1] = temp_data[0];
        temp_data[0] = RX;
      end
      else if (cnt1 == 16) begin
        cnt2 = cnt2 + 1;
        cnt1 = 0;
      end
    end
  
    if(cnt2 == 9 && temp2 == 0) begin
      status = 1;
      temp2 = 1;
      data[0] = temp_data[7];
      data[1] = temp_data[6];
      data[2] = temp_data[5];
      data[3] = temp_data[4];
      data[4] = temp_data[3];
      data[5] = temp_data[2];
      data[6] = temp_data[1];
      data[7] = temp_data[0];
    end
    else if(temp2 == 1 && cnt2 == 10) begin
      status = 0;
      temp2 = 0;
      temp = 0;
      cnt2 = 0;
      temp_data[0] = 0;
      temp_data[7] = 0;
      temp_data[6] = 0;
      temp_data[5] = 0;
      temp_data[4] = 0;
      temp_data[3] = 0; 
      temp_data[2] = 0;
      temp_data[1] = 0;
    end
  end
endmodule

module sender( TXE , sysclk , data , UTX , TXS );
  input [7:0] data;
  input TXE , sysclk;
  output reg TXS , UTX;
  reg [7:0] TX;
  reg temp ;
  integer cnt, foot;
  //output wire led;
  
  initial begin
    TXS = 1;
    cnt = 0;
    temp = 0;
    UTX = 1;
    //repeat(1000) begin
		//#104 UTX = ~UTX;
	//end
  end
  
  always@(posedge TXE) begin
    TX[0] = data[7];
    TX[1] = data[6];
    TX[2] = data[5];
    TX[3] = data[4];
    TX[4] = data[3];
    TX[5] = data[2];
    TX[6] = data[1];
    TX[7] = data[0];
    //temp = temp + 1;
  end
  
  always@(posedge sysclk) begin
    if(TXE) begin
      cnt = cnt + 1;
      TXS = 0;
      if (cnt == 1) begin
        UTX = 0;
      end
      else if (cnt == 10) begin
        UTX = 1;
      end
      else if (cnt == 11) begin
        UTX = 1;
        TXS = 1;
        cnt = 0;
        temp = 0;
      end 
      else begin
        foot = 9 - cnt;
        UTX = TX[foot];
      end
    end
   
  end
  
endmodule
        

    