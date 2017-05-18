module IF_ID_Reg (
      	  input 	    clk,
		  input 	    reset,//active low
		  input      	clear,//active low,clear the pipeline
		  input 		stall,//active_low
		  input 	    IF_ID_Wr,//!!control signals
		  input [31:0] 	    IF_Instruction,
		  output reg [31:0] ID_Instruction,
		  input [31:0]      IF_PC,
		  output reg [31:0] ID_PC
		  );
		  
	always @(posedge clk or negedge reset)
		begin
		if (~reset)
		begin
			//IF_Instruction <= 32'b0;
			ID_Instruction <= 32'b0;
			ID_PC <= 32'b0;
		end
		else if(~clear)
		begin
			//IF_Instruction <= 32'b0;
			ID_Instruction <= 32'b0;
			ID_PC <= 32'b0;
		end
		else if(~stall)
		begin
			//IF_Instruction <= IF_Instruction;
			ID_Instruction <= ID_Instruction;
			ID_PC <= ID_PC;
		end
		else if(IF_ID_Wr)
		begin
			ID_Instruction <= IF_Instruction;
			ID_PC <= IF_PC;
		end
		else	
			ID_Instruction <= ID_Instruction;//保持ID当前的状态，
	end
	
endmodule
