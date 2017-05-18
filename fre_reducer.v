module fre_reducer(sysclk , clk);
  input sysclk;
  output reg clk;
  integer i;
  
  initial begin
    clk = 0;
    i = 0;
  end
  
  always@(posedge sysclk) begin
    i = i + 1;
    if(i == 20000000) begin
      clk = ~clk;
      i = 0;
    end
  end
endmodule
