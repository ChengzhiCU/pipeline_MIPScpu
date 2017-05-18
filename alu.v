module anotheradder(a,b,fun,z,v,n,sign,out);
  input [31:0] a,b;
  input fun,sign;
  output reg z,v,n;
  output wire [31:0] out;
  wire [31:0] b_use;
  
  assign b_use[31:0] = (fun)?((~b[31:0])+1):b[31:0];
  
  assign out = a+b_use;
  
  always@(*) begin
    if (out == 0)
      z = 1;
    else
      z = 0;
  //end
  
  //always@(*) begin
    if(sign == 0)
      v = 0;
    else begin
      if(fun==0) 
        v = ((a[31]^(~b[31]))&(a[31]^out[31]))?1'b1:1'b0;
      else
        v = ((a[31]^b[31])&((~b[31])^out[31]))?1'b1:1'b0;
    end
  //end
  
  //always@(*) begin
    if(sign == 1)
      n=(out[31]&~v)|(~out[31]&v);
    else
      n=fun&(b>a);
  end
endmodule




module onebitadder(a , b , binvert , carryin , carryout , result);
  input a,b,carryin,binvert;
  output wire carryout,result;
  reg [1:0] temp;
  wire b_use;
  
  assign b_use = binvert?(~b):b; 
  
  always@(*) begin
    temp = a+b_use+carryin;
  end
  
  assign carryout = temp[1];
  assign result = temp[0];
  
endmodule

module fourbitadder(a , b , carryin , binvert , carryout , result);
  input [3:0] a,b;
  input binvert , carryin;
  output wire carryout ;
  output wire [3:0] result;
  wire [3:0] G,P,C;
  wire [3:0] temp;
  wire [3:0] b_use;
  
  assign b_use = binvert?(~b):b;
  
  assign G[0]=a[0]&b_use[0];
  assign G[1]=a[1]&b_use[1];
  assign G[2]=a[2]&b_use[2];
  assign G[3]=a[3]&b_use[3];
 
  assign P[0]=a[0]^b_use[0];
  assign P[1]=a[1]^b_use[1];
  assign P[2]=a[2]^b_use[2];
  assign P[3]=a[3]^b_use[3];
  
  assign C[1]=G[0]|(P[0]&carryin);
  assign C[2]=G[1]|(P[1]&G[0])|(P[1]&P[0]&carryin);
  assign C[3]=G[2]|(G[1]&P[2])|(P[2]&P[1]&G[0])|(P[2]&P[1]&P[0]&carryin);
  assign carryout=G[3]|(P[3]&G[2])|(P[3]&P[2]&G[1])|(P[3]&P[2]&P[1]&G[0])|(P[3]&P[2]&P[1]&P[0]&carryin);
  
  onebitadder u1(a[0],b[0],binvert,carryin,temp[0],result[0]);
  onebitadder u2(a[1],b[1],binvert,C[1],temp[1],result[1]);
  onebitadder u3(a[2],b[2],binvert,C[2],temp[2],result[2]);
  onebitadder u4(a[3],b[3],binvert,C[3],temp[3],result[3]);
  
endmodule

module adder(a , b , fun , sign , out , z , n , v);
  input [31:0] a,b;
  input fun;
  input sign;
  output wire [31:0] out;
  output reg z,n,v;
  wire carryin , binvert;
  wire [7:0] carry;
  
  assign binvert=fun?1:0;
  assign carryin=fun;
  
  fourbitadder u1(a[3:0],b[3:0],carryin,binvert,carry[0],out[3:0]);
  fourbitadder u2(a[7:4],b[7:4],carry[0],binvert,carry[1],out[7:4]);
  fourbitadder u3(a[11:8],b[11:8],carry[1],binvert,carry[2],out[11:8]);
  fourbitadder u4(a[15:12],b[15:12],carry[2],binvert,carry[3],out[15:12]);
  fourbitadder u5(a[19:16],b[19:16],carry[3],binvert,carry[4],out[19:16]);
  fourbitadder u6(a[23:20],b[23:20],carry[4],binvert,carry[5],out[23:20]);
  fourbitadder u7(a[27:24],b[27:24],carry[5],binvert,carry[6],out[27:24]);
  fourbitadder u8(a[31:28],b[31:28],carry[6],binvert,carry[7],out[31:28]);
  
  always@(*) begin
    if (out == 0)
      z = 1;
    else
      z = 0;
  //end
  
  //always@(*) begin
    if(sign == 0)
      v = 0;
    else begin
      if(fun==0) 
        v = ((a[31]^(~b[31]))&(a[31]^out[31]))?1:0;
      else
        v = ((a[31]^b[31])&((~b[31])^out[31]))?1:0;
    end
  //end
  
  //always@(*) begin
    if(sign == 1) begin
      if(out[31] == 0)
        n = v;
      if(out[31] == 1)
        n = (~v);
    end
    else
      n = 0;
  end
endmodule
  
  module cmp(z,v,n,fun,out,a);
    input z,n,v;
    input [31:0] a;
    input [2:0] fun;
    output reg [31:0] out;
    
    always@(*) begin
      if (fun == 3'b001)
        out = (z)?32'b1:32'b0;
      else if (fun == 3'b000)
        out = (z)?32'b0:32'b1;
      else if (fun == 3'b010)
        out = (n)?32'b1:32'b0;
      else if (fun == 3'b110)
        out = ((a==0)|(a[31]==1))?32'b1:32'b0;
      else if (fun == 3'b101)
        out = (a[31]==1)?32'b1:32'b0;
      else if (fun == 3'b111)
        out = ((a[31]==0)&(a!=0))?32'b1:32'b0;
      else
        out = 32'b0;
    end
  endmodule
  
  module mylogic(a,b,fun,out);
    input [31:0] a,b;
    input [3:0] fun;
    output reg [31:0] out;
    
    always@(*) begin
      if (fun == 4'b1000)
        out = a&b;
      else if (fun == 4'b1110)
        out = a|b;
      else if (fun == 4'b0110)
        out = a^b;
      else if (fun == 4'b0001)
        out = ~(a|b);
      else if (fun == 4'b1010)
        out = a;
      else
        out = 0;
    end
  endmodule
  
  module shift(a,b,fun,out);
    input [31:0] a,b;
    input [1:0] fun;
    output reg [31:0] out;
    reg [31:0] temp1,temp2;
    
    initial begin
      temp1 = 32'b11111111111111111111111111111111;
    end
    
    always@(*) begin
      if (fun == 2'b00)
        out = b<<a[4:0];
      else if(fun == 2'b01)
        out = b>>a[4:0];
      else if(fun == 2'b11) begin
        out = b>>a[4:0];
        if (b[31] == 1) begin
          temp2 = temp1<<1;
          if (a[0] == 0)
            temp2 = temp2<<1;
          if (a[1] == 0)
            temp2 = temp2<<2;
          if (a[2] == 0)
            temp2 = temp2<<4;
          if (a[3] == 0)
            temp2 = temp2<<8;
          if (a[4] == 0)
            temp2 = temp2<<16;
          out = out|temp2;
        end
      end
    end       
  endmodule
      
  module alu(a,b,fun,sign,zout);
    input [31:0] a,b;
    input [5:0] fun;
    input sign;
    output reg [31:0] zout;
    
    wire [31:0] temp1,temp2,temp3,temp4;
    wire z,v,n;
    
    //adder u1(a,b,fun[0],sign,temp1,z,v,n);
    anotheradder u1(a,b,fun[0],z,v,n,sign,temp1);
    cmp u2(z,v,n,fun[3:1],temp2,a);
    mylogic u3(a,b,fun[3:0],temp3);
    shift u4(a,b,fun[1:0],temp4);
    
    always@(*) begin
      if (fun[5:4] == 2'b00)
        zout <= temp1;
      else if (fun[5:4] == 2'b11)
        zout <= temp2;
      else if (fun[5:4] == 2'b01)
        zout <= temp3;
      else if (fun[5:4] == 2'b10)
        zout <= temp4;
    end
        
    
  endmodule
    
      
   
      
    
    
  
  
