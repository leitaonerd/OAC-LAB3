`ifndef PARAM
	`include "Parametros.v"
`endif

`define RV32I;
//`define RV32IM

module Control (
	input [6:0] opcode,
	output logic branch,
	output logic memRead,
	output logic memToReg,
	output logic memWrite,
	output logic ALUsrc,
	output logic regWrite,
	output logic jumpMux,
	output logic jumpPc,
	output logic jumpSc,
	output logic [1:0] ALUinput
);	

always @(*)
begin
	case(opcode)
		OPC_LOAD : 
			begin
				branch <= 0;
				memRead <= 1;
				memToReg <= 1;
				memWrite <= 0;
				ALUsrc <= 1;
				regWrite <= 1;
				jumpMux <= 0;
				jumpPc <= 0;
				jumpSc <= 0;
				ALUinput <= 2'b00;
			end
		OPC_OPIMM :
			begin
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				ALUsrc <= 1;
				regWrite <= 1;
				jumpMux <= 0;
				jumpPc <= 0;
				jumpSc <= 0;
				ALUinput <= 2'b00;
			end
		OPC_STORE :
			begin
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 1;
				ALUsrc <= 1;
				regWrite <= 0;
				jumpMux <= 0;
				jumpPc <= 0;
				jumpSc <= 0;
				ALUinput <= 2'b00;
			end
		OPC_RTYPE :
			begin
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				ALUsrc <= 0;
				regWrite <= 1;
				jumpMux <= 0;
				jumpPc <= 0;
				jumpSc <= 0;
				ALUinput <= 2'b10;
			end
		OPC_BRANCH :
			begin
				branch <= 1;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				ALUsrc <= 1;
				regWrite <= 0;
				jumpMux <= 0;
				jumpPc <= 0;
				jumpSc <= 0;
				ALUinput <= 2'b00;
			end
		OPC_JAL :
			begin
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				ALUsrc <= 1;
				regWrite <= 1;
				jumpMux <= 1;
				jumpPc <= 1;
				jumpSc <= 0;
				ALUinput <= 2'b00;
			end
		OPC_JALR :
			begin
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				ALUsrc <= 1;
				regWrite <= 1;
				jumpMux <= 1;
				jumpPc <= 1;
				jumpSc <= 1;
				ALUinput <= 2'b00;
			end
		default :
			begin
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				ALUsrc <= 0;
				regWrite <= 0;
				jumpMux <= 0;
				jumpPc <= 0;
				jumpSc <= 0;
				ALUinput <= 2'b00;
			end
	endcase
end

endmodule