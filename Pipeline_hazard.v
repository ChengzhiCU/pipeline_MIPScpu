module Pipeline_hazard(ID_EX_MEMRd,ALUOut0,ID_EX_Rt,IF_ID_Rs,IF_ID_Rt,ID_PCSrc,ID_EX_PCSrc,IF_ID_Wr,PCWr,IF_ID_clear,
ID_EX_clear,IF_ID_stall,ID_EX_stall);
	input ID_EX_MEMRd,ALUOut0;
	input [4:0] ID_EX_Rt,IF_ID_Rs,IF_ID_Rt;
	input [2:0] ID_PCSrc,ID_EX_PCSrc;
	output reg IF_ID_Wr,PCWr;
	
	//clear pipeline registers, Clear active low
	output reg IF_ID_clear,ID_EX_clear;
	output reg IF_ID_stall,ID_EX_stall;

	always @(*) begin
		
		if(ID_EX_MEMRd && (ID_EX_Rt == IF_ID_Rs || ID_EX_Rt == IF_ID_Rt) )//data hazard stall,lw-use
		begin
				IF_ID_clear <= 1'b1;
				ID_EX_clear <= 1'b0;
				IF_ID_stall <= 1'b0;
				ID_EX_stall <= 1'b1;
				IF_ID_Wr <= 1'b0;
				PCWr <= 1'b0;
		end
			//branch
		else if(ID_EX_PCSrc == 3'b001 && ALUOut0 == 1'b1) begin
				IF_ID_clear <= 1'b0;
				ID_EX_clear <= 1'b0;
				IF_ID_stall <= 1'b1;
				ID_EX_stall <= 1'b1;
				IF_ID_Wr <= 1'b1;
				PCWr <= 1'b1;
				
		end
			//j jr
		else if(ID_PCSrc == 3'b010 || ID_PCSrc == 3'b011) begin
				IF_ID_clear <= 1'b0;
				ID_EX_clear <= 1'b1;
				IF_ID_stall <= 1'b1;
				ID_EX_stall <= 1'b1;
				IF_ID_Wr <= 1'b1;
				PCWr <= 1'b1;
				
		end
		else begin
				IF_ID_clear <= 1'b1;
				ID_EX_clear <= 1'b1;
				IF_ID_stall <= 1'b1;
				ID_EX_stall <= 1'b1;
				IF_ID_Wr <= 1'b1;
				PCWr <= 1'b1;
		end
	end
	
endmodule
