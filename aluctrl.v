module aluctrl(opcode , func , out);
  input [5:0] opcode;
  input [5:0] func;
  output wire [5:0] out;
  wire [5:0] temp;
  
  assign temp = (func == 6'b000000)?6'b100000: //sll
                (func == 6'b000010)?6'b100001: //srl
                (func == 6'b000011)?6'b100011: //sra
                (func == 6'b100000)?6'b000000: //add
                (func == 6'b100001)?6'b000000: //addu
                (func == 6'b100010)?6'b000001: //sub
                (func == 6'b100011)?6'b000001: //subu
                (func == 6'b100100)?6'b011000: //and
                (func == 6'b100101)?6'b011110: //or
                (func == 6'b100110)?6'b010110: //xor
                (func == 6'b100111)?6'b010001: //nor
                (func == 6'b101010)?6'b110101: //slt
                6'b011010; //"A"
  
  assign out = (opcode == 6'b000000)?temp:      //r_type
               (opcode == 6'b001100)?6'b011000: //andi
               (opcode == 6'b001101)?6'b011110: //ori
               (opcode == 6'b001110)?6'b010110: //xori
               (opcode == 6'b001010)?6'b110101: //slti
               (opcode == 6'b001011)?6'b110101: //sltiu
               (opcode == 6'b000100)?6'b110011: //beq
               (opcode == 6'b000101)?6'b110001: //bne
               (opcode == 6'b000110)?6'b111101: //lez
               (opcode == 6'b000001)?6'b111011: //ltz 
               (opcode == 6'b000111)?6'b111111: //gtz
               6'b000000;                       //others_are_add
               

endmodule