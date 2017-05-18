module Pipeline_PC(clk,reset,PCSrc,ALUOut,JT,ConBA,DatabusA,PCWrite,PC);
	input clk,reset,ALUOut,PCWrite;
	input [2:0] PCSrc;
	input [25:0] JT;
	input [31:0] DatabusA,ConBA;
	output reg [31:0] PC;
	
	wire [31:0] PC_4,Branch;
	
	parameter ILLOP=32'h8000_0004;
	parameter XADR=32'h8000_0008;
	
	assign PC_4 = {PC[31],(PC[30:0] + 31'h00000004)};
	assign Branch = ALUOut ? ConBA:PC_4;// 1->conBA ;0->PC+4
	
	always @(posedge clk,negedge reset)
	begin
		if(~reset)
			PC<=32'b0;
		else if(PCWrite)
		begin
			case(PCSrc)
			3'b000: PC <= PC_4;
			3'b001: PC <=Branch;
			3'b010: PC <= {PC[31:28],JT,2'b0};
			3'b011: PC <= {DatabusA[29:0],2'b00};
			3'b100: PC <= ILLOP;
			3'b101: PC <= XADR;
			endcase
		end
	end
endmodule
	