module Pipe_Forward(MEM_RegWr,WB_RegWr,MEM_Rd,WB_Rd,EX_RS,EX_Rt,forwardA,forwardB);
  input MEM_RegWr;
  input WB_RegWr;
  input[4:0] MEM_Rd;
  input[4:0] WB_Rd;
  input[4:0] EX_RS;
  input[4:0] EX_Rt; 
  output reg [1:0] forwardA;
  output reg [1:0] forwardB;
  
  always @(*)
  begin
    if(MEM_RegWr && MEM_Rd !=0 && MEM_Rd==EX_RS)
      forwardA<=2'b10;
    else
      if(WB_RegWr && WB_Rd != 0 && WB_Rd==EX_RS && (MEM_Rd != EX_RS || ~MEM_RegWr))
        forwardA<=2'b01;//未完，forward要是最新的才可以
      else
        forwardA<=2'b0;
  end
  
  always @(*)
  begin
  if((MEM_RegWr && MEM_Rd != 0 && MEM_Rd==EX_Rt))
      forwardB<=2'b10;
    else
      if((WB_RegWr && WB_Rd != 0 && WB_Rd==EX_Rt) && (MEM_Rd != EX_Rt || ~MEM_RegWr))
        forwardB<=2'b01;
      else
        forwardB<=2'b0;   
  end
  
endmodule
