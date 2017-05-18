module control(opcode , func , irq , pctop, pcsrc , regdst , memtoreg ,
			   regwr , alusrc1 , alusrc2 , sign , memwr , memrd , extop , luop , ID_RBack_MUX);
  input [5:0] opcode , func;
  input irq , pctop;
  output reg [2:0] pcsrc;
  output reg [1:0] regdst , memtoreg;
  output reg regwr , alusrc1 , alusrc2 , sign , memwr , memrd , extop , luop, ID_RBack_MUX;
  
  always@(*) begin
    if(pctop==0 && irq) begin        //break off while irq is effective 
                                     //and PC is in the region from
                                     //0x00000000 to 0x7FFFFFFF
      ID_RBack_MUX <= 0;
	  pcsrc = 3'b100;
      regdst = 2'b11;
      regwr = 1;
	  alusrc1 = 0;
	  alusrc2 = 0;
      memwr = 0;
      memrd = 0;
      memtoreg = 2'b11;
	  sign = 0;
	  extop = 0;
	  luop = 0;
    end
	
    else begin
      if (opcode == 6'b000000) begin //r-type
        if (func == 6'b000000 || func == 6'b000010 || func == 6'b000011) begin //shift 
		  ID_RBack_MUX <= 1;
          pcsrc = 3'b000;
		  regdst = 2'b00;
		  regwr = 1;
          alusrc1 = 1;
		  alusrc2 = 0;
		  memwr = 0;
		  memrd = 0;
		  memtoreg = 2'b00;
          sign = 1;
		  extop = 0;
		  luop = 0;
        end
		
        else if(func == 6'b100000 || func == 100010) begin //add & sub
		  ID_RBack_MUX <= 1;
          pcsrc = 3'b000;
		  regdst = 2'b00;
		  regwr = 1;
		  alusrc1 = 0;
		  alusrc2 = 0;
		  memwr = 0;
		  memrd = 0;
		  memtoreg = 2'b00;
          sign = 1;
		  extop = 0;
		  luop = 0;
        end
		
        else if(func == 6'b101010) begin //slt
		  ID_RBack_MUX <= 1;
          pcsrc = 3'b000;
		  regdst = 2'b00;
		  regwr = 1;
		  alusrc1 = 0;
		  alusrc2 = 0;
		  memwr = 0;
		  memrd = 0;
		  memtoreg = 2'b00;
          sign = 1;
		  extop = 0;
		  luop = 0;
        end
		
        else if(func == 6'b001000) begin //jr
		  ID_RBack_MUX <= 1;
          pcsrc = 3'b011;
		  regdst = 2'b00;
          regwr = 0;
		  alusrc1 = 0;
		  alusrc2 = 0;
		  memwr = 0;
		  memrd = 0;
		  memtoreg = 2'b00;
          sign = 1;
		  extop = 0;
		  luop = 0;
        end
		
        else if(func == 6'b001001) begin //jalr
		  ID_RBack_MUX <= 1;
          pcsrc = 3'b011;
          regdst = 2'b01;
		  regwr = 1;
		  alusrc1 = 0;
		  alusrc2 = 0;
		  memwr = 0;
		  memrd = 0;
		  memtoreg = 2'b10;
          sign = 1;
		  extop = 0;
		  luop = 0;
        end
		
        else begin //add
		  ID_RBack_MUX <= 1;
		  pcsrc = 3'b000;
		  regdst = 2'b00;
		  regwr = 1;
		  alusrc1 = 0;
		  alusrc2 = 0;
		  memwr = 0;
		  memrd = 0;
		  memtoreg = 2'b00;
          sign = 1;
		  extop = 0;
		  luop = 0;
        end
		
      end
	  
      else if(opcode == 6'b100011) begin //lw
		ID_RBack_MUX <= 0;
        pcsrc = 3'b000;
        regdst = 2'b01;
        regwr = 1;
        alusrc1 = 0;
        alusrc2 = 1;
        memwr = 0;
        memrd = 1;
        memtoreg = 2'b01;
		sign = 1;
        extop = 1;
        luop = 0;
      end
	  
      else if(opcode == 6'b101011) begin //sw
		ID_RBack_MUX <= 0;
        pcsrc = 3'b000;
        regdst = 2'b01;
        regwr = 0;
        alusrc1 = 0;
        alusrc2 = 1;
        memwr = 1;
        memrd = 0;
		memtoreg = 2'b00;
		sign = 1;
        extop = 1;
        luop = 0;
      end
	  
      else if(opcode == 6'b001111) begin //lui
		ID_RBack_MUX <= 0;
        pcsrc = 3'b000;
        regdst = 2'b01;
        regwr = 1;
        alusrc1 = 0;
        alusrc2 = 1;
        memwr = 0;
        memrd = 0;
        memtoreg = 2'b00;
		sign = 1;
        extop = 1;
        luop = 1;
      end
	  
      else if(opcode == 6'b001000) begin //addi
		ID_RBack_MUX <= 0;
        pcsrc = 3'b000;
        regdst = 2'b01;
        regwr = 1;
        alusrc1 = 0;
        alusrc2 = 1;
        memwr = 0;
        memrd = 0;
        memtoreg = 2'b00;
        sign = 1;
        extop = 1;
        luop = 0;
      end
	  
      else if(opcode == 6'b001001) begin //addiu
		ID_RBack_MUX <= 0;
        pcsrc = 3'b000;
        regdst = 2'b01;
        regwr = 1;
        alusrc1 = 0;
        alusrc2 = 1;
        memwr = 0;
        memrd = 0;
        memtoreg = 2'b00;
		sign = 0;
        extop = 0;
        luop = 0;
      end
	  
      else if(opcode == 6'b001100) begin //andi
		ID_RBack_MUX <= 0;
        pcsrc = 3'b000;
        regdst = 2'b01;
        regwr = 1;
        alusrc1 = 0;
        alusrc2 = 1;
        memwr = 0;
        memrd = 0;
        memtoreg = 2'b00;
        extop = 0;
        luop = 0;
        sign = 0;
      end
	  
      else if(opcode == 6'b001101) begin //ori
		ID_RBack_MUX <= 0;
        pcsrc = 3'b000;
        regdst = 2'b01;
        regwr = 1;
        alusrc1 = 0;
        alusrc2 = 1;
        memwr = 0;
        memrd = 0;
        memtoreg = 2'b00;
        extop = 0;
        luop = 0;
        sign = 0;
      end
	  
      else if(opcode == 6'b001010) begin //slti
		ID_RBack_MUX <= 0;
        pcsrc = 3'b000;
        regdst = 2'b01;
        regwr = 1;
        alusrc1 = 0;
        alusrc2 = 1;
        memwr = 0;
        memrd = 0;
        memtoreg = 2'b00;
        extop = 1;
        luop = 0;
        sign = 1;
      end
	  
      else if(opcode == 6'b001010) begin //sltiu
		ID_RBack_MUX <= 0;
        pcsrc = 3'b000;
        regdst = 2'b01;
        regwr = 1;
        alusrc1 = 0;
        alusrc2 = 1;
        memwr = 0;
        memrd = 0;
        memtoreg = 2'b00;
        extop = 0;
        luop = 0;
        sign = 0;
      end
	  
      else if(opcode == 6'b000100) begin //beq
		ID_RBack_MUX <= 0;
        pcsrc = 3'b001;
		regdst = 2'b00;
        regwr = 0;
        alusrc1 = 0;
        alusrc2 = 0;
        memwr = 0;
        memrd = 0;
		memtoreg = 2'b00;
        extop = 1;
		luop = 0;
        sign = 1;
      end
	  
      else if(opcode == 6'b000101) begin //bne
		ID_RBack_MUX <= 0;
        pcsrc = 3'b001;
		regdst = 2'b00;
        regwr = 0;
        alusrc1 = 0;
        alusrc2 = 0;
        memwr = 0;
        memrd = 0;
		memtoreg = 2'b00;
        extop = 1;
		luop = 0;
        sign = 1;
      end
	  
      else if(opcode == 6'b000110) begin //blez
		ID_RBack_MUX <= 0;
        pcsrc = 3'b001;
		regdst = 2'b00;
        regwr = 0;
        alusrc1 = 0;
        alusrc2 = 0;
        memwr = 0;
        memrd = 0;
		memtoreg = 2'b00;
        extop = 1;
		luop = 0;
        sign = 1;
      end
	  
      else if(opcode == 6'b000111) begin //bgtz
		ID_RBack_MUX <= 0;
        pcsrc = 3'b001;
		regdst = 2'b00;
        regwr = 0;
        alusrc1 = 0;
        alusrc2 = 0;
        memwr = 0;
        memrd = 0;
		memtoreg = 2'b00;
        extop = 1;
		luop = 0;
        sign = 1;
      end
	  
      else if(opcode == 6'b000001) begin //bltz
		ID_RBack_MUX <= 0;
        pcsrc = 3'b001;
		regdst = 2'b00;
        regwr = 0;
        alusrc1 = 0;
        alusrc2 = 0;
        memwr = 0;
        memrd = 0;
		memtoreg = 2'b00;
        extop = 1;
		luop = 0;
        sign = 1;
      end
	  
      else if(opcode == 6'b000010) begin //j
		ID_RBack_MUX <= 0;
        pcsrc = 3'b010;
		regdst = 2'b00;
		regwr = 0;
		alusrc1 = 0;
        alusrc2 = 0;
        memwr = 0;
        memrd = 0;
		memtoreg = 2'b00;
        extop = 0;
		luop = 0;
        sign = 1;
      end
	  
      else if(opcode == 6'b000011) begin //jal
		ID_RBack_MUX <= 0;
        pcsrc = 3'b010;
        regdst = 2'b10;
        regwr = 1;
		alusrc1 = 0;
        alusrc2 = 0;
        memwr = 0;
        memrd = 0;
        memtoreg = 2'b10;
		extop = 0;
		luop = 0;
        sign = 1;
      end
	  
      else begin //nondefined code
        if(pctop==0) begin //normal code
          ID_RBack_MUX <= 0;
		  pcsrc = 3'b101;
          regdst = 2'b11;
          regwr = 1;
		  alusrc1 = 0;
		  alusrc2 = 0;
          memwr = 0;
          memrd = 0;
          memtoreg = 2'b10;
		  extop = 0;
		  luop = 0;
          sign = 1;
        end
        else begin //inner code
          ID_RBack_MUX <= 0;
		  pcsrc = 3'b000;
		  regdst = 2'b11;
          regwr = 0;
		  alusrc1 = 0;
		  alusrc2 = 0;
          memwr = 0;
          memrd = 0;
		  memtoreg = 2'b00;
		  extop = 0;
		  luop = 0;
          sign = 1;
        end
      end
    end
  end
  
endmodule
