`ifndef PARAM
	`include "Parametros.v"
`endif

`define RV32I;
//`define RV32IM

module ALUControl (
	input logic [1:0] ALUop,
	input logic [2:0] funct3,
	input logic [6:0] funct7,
	output logic [4:0] ALUsign
);

logic [9:0] funct10;
assign funct10 = {funct7, funct3};

always @(*)
begin
	case(ALUop)
		2'b00 : ALUsign <= OPADD;
		2'b01 : ALUsign <= OPSUB;
		2'b10 :
			case(funct10)
				{FUNCT7_ADD,FUNCT3_ADD}: ALUsign <= OPADD;
            {FUNCT7_SUB,FUNCT3_SUB}: ALUsign <= OPSUB;
            {FUNCT7_AND,FUNCT3_AND}: ALUsign <= OPAND;
            {FUNCT7_OR,FUNCT3_OR}: ALUsign <= OPOR;
            {FUNCT7_SLT,FUNCT3_SLT}: ALUsign <= OPSLT;
            default: ALUsign <= OPNULL;
			endcase
		default : ALUsign <= OPNULL;
	endcase
end

endmodule