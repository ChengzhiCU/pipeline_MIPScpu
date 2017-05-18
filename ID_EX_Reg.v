module ID_EX_Reg(  
	input clk,
	input reset,
	input clear,
	input stall,
	input [31:0] ID_PC,
	output reg [31:0] EX_PC,
	input [15:0] ID_Imm,
	output reg [15:0] EX_Imm,
	
	input [4:0] ID_Rs,output reg [4:0] EX_Rs,
	input [4:0] ID_Rt,output reg [4:0] EX_Rt,
	input [4:0] ID_Rd,output reg [4:0] EX_Rd,
	input [4:0] ID_shamt,output reg [4:0] EX_shamt,	
	//input [4:0] ID_WBreg,output [4:0] EX_WBreg
	
	//for EX
	input [5:0] ID_ALUFun,
	input 	    ID_Sign,//决定ALU是不是又符号,ID阶段control产生的。
	input 	    ID_EXTOp,//16位数 产生扩展，分为有符号和无符号扩展
	input 	    ID_LUOp,//Lui使用
	input 	    ID_ALUSrc1,
	input 	    ID_ALUSrc2,
	input		ID_RBack_MUX,
	output reg  [5:0]  EX_ALUFun,
	output reg 	EX_Sign,
	output reg 	EX_EXTOp,
	output reg 	EX_LUOp,
	output reg 	EX_ALUSrc1,
	output reg 	EX_ALUSrc2,
	output reg	EX_RBack_MUX,
	
	//for MEM
	input [2:0] ID_PCSrc,
	input ID_MemRd,
	input ID_MemWr,
	output reg [2:0] EX_PCSrc,
	output reg EX_MemRd,
	output reg EX_MemWr,
	
	//for WB
	input [1:0] ID_RegDst,
	input [1:0] ID_MemToReg,
	input       ID_RegWr,
	output reg  [1:0] EX_RegDst,
	output reg  [1:0] EX_MemToReg,
	output reg 	   EX_RegWr,
	
	input [31:0] ID_DatabusA,
	input [31:0] ID_DatabusB,
	output reg [31:0] EX_DatabusA,
	output reg [31:0] EX_DatabusB,
	
	input [5:0] ID_func,
	output reg [5:0] EX_func
	);
	
	always @(posedge clk or negedge reset)
	begin
		if(~reset)
		begin
			EX_PC <= 32'b0;
			EX_Imm <= 16'b0;
			EX_MemToReg <= 2'b0;
			EX_RegWr <= 1'b0;
			EX_PCSrc <= 3'b0;
			EX_MemRd <= 1'b0;
			EX_MemWr <= 1'b0;
			EX_RegDst <= 2'b0;
			EX_ALUFun <= 6'b0;
			EX_Sign <= 1'b0;
			EX_EXTOp <= 1'b0;
			EX_LUOp <= 1'b0;
			EX_ALUSrc1 <= 1'b0;
			EX_ALUSrc2 <= 1'b0;
			EX_shamt <= 5'b0;
			EX_Rs <= 5'b0;
			EX_Rt <= 5'b0;
			EX_Rd <= 5'b0;
			EX_DatabusA <= 32'b0;
			EX_DatabusB <= 32'b0;
			EX_RBack_MUX <= 0;
			EX_func <= 6'b0;
		end 
		else if(~clear)
		begin
			EX_PC <= 32'b0;
			EX_Imm <= 16'b0;
			EX_MemToReg <= 2'b0;
			EX_RegWr <= 1'b0;
			EX_PCSrc <= 3'b0;
			EX_MemRd <= 1'b0;
			EX_MemWr <= 1'b0;
			EX_RegDst <= 2'b0;
			EX_ALUFun <= 6'b0;
			EX_Sign <= 1'b0;
			EX_EXTOp <= 1'b0;
			EX_LUOp <= 1'b0;
			EX_ALUSrc1 <= 1'b0;
			EX_ALUSrc2 <= 1'b0;
			EX_shamt <= 5'b0;
			EX_Rs <= 5'b0;
			EX_Rt <= 5'b0;
			EX_Rd <= 5'b0;
			EX_DatabusA <= 32'b0;
			EX_DatabusB <= 32'b0;
			EX_func <= 6'b0;
			EX_RBack_MUX <= 0;
		end 
		else if(~stall)
		begin
			EX_PC <= EX_PC;
			EX_Imm <= EX_Imm;
			EX_MemToReg <= EX_MemToReg;
			EX_RegWr <= EX_RegWr;
			EX_PCSrc <= EX_PCSrc;
			EX_MemRd <= EX_MemRd;
			EX_MemWr <= EX_MemWr;
			EX_RegDst <= EX_RegDst;
			EX_ALUFun <= EX_ALUFun;
			EX_Sign <= EX_Sign;
			EX_EXTOp <= EX_EXTOp;
			EX_LUOp <= EX_LUOp;
			EX_ALUSrc1 <= EX_ALUSrc1;
			EX_ALUSrc2 <= EX_ALUSrc2;
			EX_shamt <= EX_shamt;
			EX_Rs <= EX_Rs;
			EX_Rt <= EX_Rt;
			EX_Rd <= EX_Rd;
			EX_DatabusA <= EX_DatabusA;
			EX_DatabusB <= EX_DatabusB;
			EX_RBack_MUX <= EX_RBack_MUX;
			EX_func <= EX_func;
		end 
		
		else
		begin
			EX_PC <= ID_PC;
			EX_Imm <= ID_Imm;
			EX_MemToReg <= ID_MemToReg;
			EX_RegWr <= ID_RegWr;
			EX_PCSrc <= ID_PCSrc;
			EX_MemRd <= ID_MemRd;
			EX_MemWr <= ID_MemWr;
			EX_RegDst <= ID_RegDst;
			EX_ALUFun <= ID_ALUFun;
			EX_Sign <= ID_Sign;
			EX_EXTOp <= ID_EXTOp;
			EX_LUOp <= ID_LUOp;
			EX_ALUSrc1 <= ID_ALUSrc1;
			EX_ALUSrc2 <= ID_ALUSrc2;
			EX_shamt <= ID_shamt;
			EX_Rs <= ID_Rs;
			EX_Rt <= ID_Rt;
			EX_Rd <= ID_Rd;
			EX_DatabusA <= ID_DatabusA;
			EX_DatabusB <= ID_DatabusB;
			EX_RBack_MUX <= ID_RBack_MUX;
			EX_func <= ID_func;
		end 
	end 
	
endmodule
