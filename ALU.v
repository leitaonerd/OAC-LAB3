/*
 * ALU     PRECISA SIMPLIFICAR!!!!
 *
 */

 `ifndef PARAM
	`include "Parametros.v"
`endif

`define RV32I;
//`define RV32IM;
 
module ALU (
	input 		 [4:0]  iControl,
	input signed [31:0] iA, 
	input signed [31:0] iB,
	output logic [31:0] oResult,
	output logic equal
	);

	//wire [4:0] iControl=OPADD;		// Usado para as analises

assign equal = (iA == iB) ? 1 : 0;

always @(*)
begin
    case (iControl)
		OPAND:
			oResult  <= iA & iB;
		OPOR:
			oResult  <= iA | iB;
		OPADD:
			oResult  <= iA + iB;
		OPSUB:
			oResult  <= iA - iB;
		OPSLT:
			oResult  <= iA < iB;		
		default:
			oResult  <= ZERO;
    endcase
end

endmodule
