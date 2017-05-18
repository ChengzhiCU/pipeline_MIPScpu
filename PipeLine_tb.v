`timescale 1ns/1ps

module PipeLine_tb;
  reg sysclk , reset , UART_RX;
  reg [7:0] switch;
  wire [7:0] led;
  wire [6:0] digi1,digi2,digi3,digi4;
  wire UART_TX;
  wire check;
  wire tt;
  wire [7:0] yy;
  initial begin
    switch = 8'b11001001;
  end
  
  initial begin
    sysclk = 0;
    repeat(600000) begin
      #2 sysclk = ~sysclk;
    end
  end
  
  initial begin
    UART_RX = 1;
      #40000 UART_RX=0;
      #20824 UART_RX=0;
      #20824 UART_RX=0;
      #20824 UART_RX=1;
      #20824 UART_RX=1;
      #20824 UART_RX=0;
      #20824 UART_RX=0;
      #20824 UART_RX=0;
      #20824 UART_RX=0;
      #20824 UART_RX=1;
      #80000 UART_RX=0;
      #20824 UART_RX=1;
      #20824 UART_RX=0;
      #20824 UART_RX=0;
      #20824 UART_RX=1;
      #20824 UART_RX=0;
      #20824 UART_RX=0;
      #20824 UART_RX=0;
      #20824 UART_RX=0;
      #20824 UART_RX=1;
      
  end
  
  initial fork
    reset = 1;
    #15 reset = ~reset;
    #20 reset = ~reset;
  join
  fre_reducer fffr(sysclk , clk);
  Pipeline pipe(sysclk, clk,reset, led, switch, digi1, digi2, digi3, digi4, UART_RX, UART_TX, check,yy);
  
endmodule
