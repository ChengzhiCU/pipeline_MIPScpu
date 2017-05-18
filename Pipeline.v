module Pipeline(sysclk,  reset, led, switch, digi1, digi2, digi3, digi4, UART_RX, UART_TX, check , led_beigandiao);
	input sysclk, reset;
	output wire [7:0] led;
	input [7:0] switch;
	output wire [6:0] digi1, digi2, digi3, digi4;
	input UART_RX;
	output wire UART_TX;
	output wire check;
	//wire clk;
	
	wire clk;
	wire [2:0] IF_PCSrc, ID_PCSrc, EX_PCSrc;
	wire IF_ID_clear, ID_EX_clear, IF_ID_stall, ID_EX_stall;
	wire [31:0] IF_Instruction, ID_Instruction, IF_PC, ID_PC, EX_PC;
	wire [4:0] ID_AddrC;
	wire PCWrite, IF_ID_Wr, IRQ;
	wire [15:0] EX_Imm;
	wire [4:0] EX_Shamt, EX_Rs;
	wire [4:0] EX_Rt, EX_Rd, MEM_Rt, MEM_Rd, WB_Rt, WB_Rd;
	wire [5:0]  EX_ALUFun;
	wire ID_Sign, ID_EXTOp, ID_LUOp, ID_ALUSrc1, ID_ALUSrc2, ID_RBack_MUX;
	wire EX_Sign, EX_EXTOp, EX_LUOp, EX_ALUSrc1, EX_ALUSrc2, EX_RBack_MUX;
	wire ID_MemRd, EX_MemRd, MEM_MemRd;
	wire ID_MemWr, EX_MemWr, MEM_MemWr;
	wire [1:0] ID_RegDst, EX_RegDst, MEM_RegDst, WB_RegDst;
	wire [1:0]	ID_MemToReg, EX_MemToReg, MEM_MemToReg, WB_MemToReg;
	wire ID_RegWr, EX_RegWr, MEM_RegWr, WB_RegWr;
	wire [31:0] ID_DatabusA, ID_DatabusB, EX_DatabusA, EX_DatabusB;
	wire [31:0] MEM_DatabusB, DataBusC;
	wire [1:0] forwardA, forwardB;
	wire [31:0] ConBA, MEM_PC, WB_PC;
	wire [31:0] EX_ALUout, MEM_ALUout, WB_ALUout;
	wire [31:0] MEM_dataMEMOut, WB_dataMEMout;
	wire [4:0] EX_WBreg, MEM_WBreg, WB_WBreg;
	wire [31:0] ALUMUX00, ALUMUX01, ALUMUX10, ALUMUX11, ALUMUX0, ALUMUX1;
	wire [31:0] imm_tmp;
	wire ram_wr, ram_rd, per_wr, per_rd, uart_wr, uart_rd;
	wire [31:0] ram_out, per_out, uart_out;
	wire [11:0] digi_temp;
	
	wire [5:0] ALUFunt_code,EX_Opcode;
	
	
	fre_reducer Pipe_frer(sysclk, clk);
	//assign clk = sysclk;
	
	
	
	output wire [7:0] led_beigandiao;
	wire [7:0] led_beigandiao1;
	//assign led=IF_PC[9:2];
	//IF	
	//assign IF_PCSrc = (ID_PCSrc == 3'b001 || EX_PCSrc == 3'b001) ? EX_PCSrc : ID_PCSrc;		//j,jr??ID????????IF??????????EX
	assign IF_PCSrc = (EX_PCSrc == 3'b001 && EX_ALUout[0])?EX_PCSrc:(ID_PCSrc == 3'b001)? 2'b0:ID_PCSrc;
	
	Pipeline_PC pipePc(clk,reset,IF_PCSrc,EX_ALUout[0],ID_Instruction[25:0],ConBA,ID_DatabusA,PCWrite,IF_PC);
	pipe_rom	rom(reset,IF_PC,PCWrite,IF_Instruction);
	
	//IF_ID
	IF_ID_Reg 	ifid_reg(clk, reset, IF_ID_clear, IF_ID_stall, IF_ID_Wr, IF_Instruction, ID_Instruction, IF_PC, ID_PC);
	assign led = IF_PC[9:2];
	//ID	
	Pipeline_hazard ph(EX_MemRd, EX_ALUout[0], EX_Rt, ID_Instruction[25:21], ID_Instruction[20:16], ID_PCSrc, EX_PCSrc,
					   IF_ID_Wr, PCWrite, IF_ID_clear, ID_EX_clear, IF_ID_stall, ID_EX_stall);
	
	control con(ID_Instruction[31:26], ID_Instruction[5:0], IRQ, IF_PC[31], ID_PCSrc, ID_RegDst, ID_MemToReg,
				ID_RegWr, ID_ALUSrc1, ID_ALUSrc2, ID_Sign, ID_MemWr, ID_MemRd, ID_EXTOp, ID_LUOp, ID_RBack_MUX);
	
	assign ID_AddrC = (WB_RegDst == 2'd3) ? 5'd26 :
	                  (WB_RegDst == 2'd2) ? 5'd31 :
	                  (WB_RegDst == 2'd1) ? WB_Rt : WB_Rd;
	
	 //assign [7:0] temp_l;
	RegFile rf(reset, clk, ID_Instruction[25:21], ID_DatabusA, ID_Instruction[20:16], ID_DatabusB, WB_RegWr, ID_AddrC, DataBusC,led_beigandiao);
	
	//ID_EX
	ID_EX_Reg idex_reg(clk, reset, ID_EX_clear, ID_EX_stall, ID_PC, EX_PC, ID_Instruction[15:0], EX_Imm,
	                   ID_Instruction[25:21], EX_Rs, ID_Instruction[20:16], EX_Rt, ID_Instruction[15:11], EX_Rd,
	                   ID_Instruction[10:6], EX_Shamt,
	                   ID_Instruction[31:26], ID_Sign, ID_EXTOp, ID_LUOp, ID_ALUSrc1, ID_ALUSrc2, ID_RBack_MUX,
	                   EX_Opcode, EX_Sign, EX_EXTOp, EX_LUOp, EX_ALUSrc1, EX_ALUSrc2, EX_RBack_MUX,
	                   ID_PCSrc, ID_MemRd, ID_MemWr, EX_PCSrc, EX_MemRd, EX_MemWr,
	                   ID_RegDst, ID_MemToReg, ID_RegWr, EX_RegDst, EX_MemToReg, EX_RegWr,
	                   ID_DatabusA, ID_DatabusB, EX_DatabusA, EX_DatabusB,
	                   ID_Instruction[5:0],EX_ALUFun);
	
	//EX
	assign imm_tmp = {(EX_EXTOp ? {16{EX_Imm[15]}} : 16'b0), EX_Imm};
	
	assign ALUMUX00 = (forwardA==2'b00) ? EX_DatabusA : (forwardA==2'b01) ? DataBusC : MEM_ALUout;//rs
	assign ALUMUX01 = {27'b0, EX_Shamt};
	assign ALUMUX10 = (forwardB==2'b00) ? EX_DatabusB : (forwardB==2'b01) ? DataBusC : MEM_ALUout;//rt
	assign ALUMUX11 = (EX_LUOp==0) ? imm_tmp : {EX_Imm,16'b0};
	assign ALUMUX0 = (EX_ALUSrc1==0) ? ALUMUX00 : ALUMUX01;
	assign ALUMUX1 = (EX_ALUSrc2==0) ? ALUMUX10 : ALUMUX11;
	aluctrl ALUCtrl_Pipe(EX_Opcode, EX_ALUFun,ALUFunt_code);
	alu ALU_Pipe(ALUMUX0, ALUMUX1, ALUFunt_code, EX_Sign, EX_ALUout);
	
	assign ConBA = ID_PC + (imm_tmp<<2);
	
	assign EX_WBreg = (EX_RBack_MUX==0) ? EX_Rt : EX_Rd;
	
	Pipe_Forward forward(MEM_RegWr, WB_RegWr, MEM_WBreg, WB_WBreg, EX_Rs, EX_Rt, forwardA, forwardB);
	
	//EX_MEM
	EX_MEM_Reg 	exmem_reg(clk, reset, EX_PC, MEM_PC, EX_MemRd, MEM_MemRd, EX_MemWr, MEM_MemWr,
						  EX_RegDst, MEM_RegDst, EX_MemToReg, MEM_MemToReg, EX_RegWr, MEM_RegWr,
						  EX_ALUout, MEM_ALUout, ALUMUX10, MEM_DatabusB, EX_WBreg, MEM_WBreg,
						  EX_Rt, MEM_Rt, EX_Rd, MEM_Rd);
	
	//MEM
	assign ram_rd = (MEM_ALUout[31]^MEM_ALUout[30] == 0) ? MEM_MemRd : 1'b0;
	assign ram_wr = (MEM_ALUout[31]^MEM_ALUout[30] == 0) ? MEM_MemWr : 1'b0;
	DataMem Pipe_dm(reset, clk, ram_rd, ram_wr, MEM_ALUout, MEM_DatabusB, ram_out);
	assign per_rd = (MEM_ALUout[31:30] == 2'b01) ? MEM_MemRd : 1'b0;
	assign per_wr = (MEM_ALUout[31:30] == 2'b01) ? MEM_MemWr : 1'b0;
	Peripheral Pipe_per(reset, clk, per_rd, per_wr, MEM_ALUout, MEM_DatabusB, per_out, led_beigandiao1, switch, digi_temp, IRQ);
	digitube_scan Pipe_ds(digi_temp , digi1 , digi2 , digi3 , digi4);
	assign uart_rd = (MEM_ALUout[31:30] == 2'b10) ? MEM_MemRd : 1'b0;
	assign uart_wr = (MEM_ALUout[31:30] == 2'b10) ? MEM_MemWr : 1'b0;
	UART Pipe_uart(clk, sysclk, reset, MEM_ALUout, uart_wr, MEM_DatabusB, uart_rd, uart_out, UART_RX, UART_TX, check);
	assign MEM_dataMEMOut = (MEM_ALUout[31:30] == 2'b10) ? uart_out : (MEM_ALUout[31:30] == 2'b01) ? per_out : ram_out;
	
	//MEM_WB
	MEM_WB_Reg 	memwb_reg(clk, reset, MEM_PC, WB_PC, MEM_RegDst, WB_RegDst, MEM_MemToReg, WB_MemToReg, MEM_RegWr, WB_RegWr,
						  MEM_ALUout, WB_ALUout, MEM_dataMEMOut, WB_dataMEMout, MEM_WBreg, WB_WBreg,
						  MEM_Rt, WB_Rt, MEM_Rd, WB_Rd);
	
	//WB
	assign DataBusC = (WB_MemToReg==2'b00) ? WB_ALUout : (WB_MemToReg==2'b01) ? WB_dataMEMout : WB_PC;
	
endmodule
