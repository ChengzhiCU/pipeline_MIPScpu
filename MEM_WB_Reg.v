module MEM_WB_Reg(
	input clk,
	input reset,
	input [31:0] MEM_PC_4,
	output reg [31:0] WB_PC_4,
	
	//WB
	input [1:0] MEM_RegDst,
	output reg  [1:0] WB_RegDst,
	input [1:0]	MEM_MemToReg,
	output reg [1:0] WB_MemToReg,
	input MEM_RegWr,
	output reg WB_RegWr,
	
	//databus
	input [31:0] MEM_ALUOut,
	output reg [31:0] WB_ALUOut,
	input [31:0] MEM_dataMEMOut,
	output reg [31:0] WB_dataMEMOut,
	
	//address of register
	input [4:0] MEM_WBreg,
	output reg [4:0] WB_WBreg,
	input [4:0] MEM_Rt,
	output reg [4:0] WB_Rt,
	input [4:0] MEM_Rd,
	output reg [4:0] WB_Rd
	);
	
	always @(posedge clk or negedge reset)
	begin
		if(~reset)
		begin
			WB_PC_4 <= 32'b0;
			WB_MemToReg <= 2'b0;
			WB_RegWr <= 1'b0;
			WB_ALUOut <= 32'b0;
			WB_dataMEMOut <= 32'b0;
			WB_WBreg <= 5'b0;
			WB_RegDst <= 2'b0;
			WB_Rt <= 5'b0;
			WB_Rd <= 5'b0;
		end
		else begin
			WB_PC_4 <= MEM_PC_4;
			WB_MemToReg <= MEM_MemToReg;
			WB_RegWr <= MEM_RegWr;
			WB_ALUOut <= MEM_ALUOut;
			WB_dataMEMOut <= MEM_dataMEMOut;
			WB_WBreg <= MEM_WBreg;
			WB_RegDst <= MEM_RegDst;
			WB_Rt <= MEM_Rt;
			WB_Rd <= MEM_Rd;
		end
	end
	
endmodule
