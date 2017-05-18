module EX_MEM_Reg (
	input clk,
	input reset,
	input [31:0] EX_PC_4,
	output reg [31:0] MEM_PC_4,

	//MEM
	input EX_MemRd,
	output reg MEM_MemRd,
	input EX_MemWr,
	output reg MEM_MemWr,
	
	//WB
	input [1:0] EX_RegDst,
	output reg  [1:0] MEM_RegDst,
	input [1:0] EX_MemToReg,
	output reg [1:0] MEM_MemToReg,
	input EX_RegWr,
	output reg MEM_RegWr,
	
	//databus	
	input [31:0] EX_ALUOut,
	output reg [31:0] MEM_ALUOut,
	input [31:0] EX_DatabusB,
	output reg [31:0] MEM_DatabusB,
	
	//address of register
	input [4:0] EX_WBreg,
	output reg [4:0] MEM_WBreg,
	input [4:0] EX_Rt,
	output reg [4:0] MEM_Rt,
	input [4:0] EX_Rd,
	output reg [4:0] MEM_Rd
	);
	
	always @(posedge clk or negedge reset) begin
		if(~reset)
		begin
			MEM_PC_4 <= 32'b0;
			MEM_MemRd <= 1'b0;
			MEM_MemWr <= 1'b0;
			MEM_MemToReg <= 2'b0;
			MEM_RegWr <= 1'b0;
			MEM_ALUOut <= 32'b0;
			MEM_DatabusB <= 32'b0;
			MEM_WBreg <= 5'b0;
			MEM_RegDst <= 2'b0;
			MEM_Rt <= 5'b0;
			MEM_Rd <= 5'b0;
		end
		else
		begin
			MEM_PC_4 <= EX_PC_4;
			MEM_MemRd <= EX_MemRd;
			MEM_MemWr <= EX_MemWr;
			MEM_MemToReg <= EX_MemToReg;
			MEM_RegWr <= EX_RegWr;
			MEM_ALUOut <= EX_ALUOut;
			MEM_DatabusB <= EX_DatabusB;
			MEM_WBreg <= EX_WBreg;
			MEM_RegDst <= EX_RegDst;
			MEM_Rt <= EX_Rt;
			MEM_Rd <= EX_Rd;
			
		end
	end
	
endmodule