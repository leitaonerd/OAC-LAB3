`ifndef PARAM
	`include "Parametros.v"
`endif

module ControlM(
input logic [6:0] opcode,
input logic [3:0] estado,
output logic [3:0] proximo,
output logic [2:0]  Mem2Reg, OrigAULA, OrigBULA,
output logic EscreveReg, OrigPC, EscrevePCB, EscrevePCCond, EscrevePC, IouD, EscreveIR, LeMem, EscreveMem,
output logic [1:0] op, CtrlEnd
);

always @(*)
begin
	case(CtrlEnd)
		0 : proximo <= 3'b000;
				
		1 :
			case(opcode)
				7'b0110011 : proximo <= 4'b0110;
				7'b1101111 : proximo <= 4'b1001;
				7'b1100011 : proximo <= 4'b1000;
				7'b0000011 : proximo <= 4'b0010;
				7'b0100011 : proximo <= 4'b0010;
				7'b0010011 : proximo <= 4'b0010;
				7'b1101111 : proximo <= 4'b0010;
				//7'b1100111 : proximo <= 4'b0010; //verificar do jalr
				default : proximo <= 4'b0000; 
			endcase
		2 :
			case(opcode)
				7'b0000011 : proximo <= 4'b0011;
				7'b0100011 : proximo <= 4'b0101;
				7'b0010011 : proximo <= 4'b0111;
				7'b1101111 : proximo <= 4'b1001;
				//7'b1100111 : proximo <= 4'b1010; //verificar do jalr
				default : proximo <= 4'b0000; 
			endcase
		3 :
			begin
				proximo <= estado + 4'b0001;
			end
		default: proximo <= 4'b0000;
	endcase
	case(estado)
		//leitao: implementar estado -1, para emular o 0 duas vezes
		0 : 
			begin
				CtrlEnd <= 2'b11;
				EscreveReg <= 0;
				OrigPC <= 0;
				EscrevePCB <= 1;
				Mem2Reg <= 0;
				EscrevePCCond <= 0;
				EscrevePC <= 1;
				EscreveMem <= 0;
				IouD <= 0;
				LeMem <= 1;
				EscreveIR <= 1;
				op <= 2'b00;
				OrigAULA <= 2'b10;
				OrigBULA <= 2'b01;
			end
		1 :	
			begin
				CtrlEnd <= 2'b01;
				OrigAULA <= 2'b00;
				OrigBULA <= 2'b10;
				op <= 2'b00;
				EscreveReg <= 0;
				OrigPC <= 0;
				EscrevePCB <= 0;
				Mem2Reg <= 0;
				EscrevePCCond <= 0;
				EscrevePC <= 0;
				EscreveMem <= 0;
				IouD <= 0;
				LeMem <= 0;
				EscreveIR <= 0;
			end
		2 :
			begin
				CtrlEnd <= 2'b10;
				OrigAULA <= 2'b01;
				OrigBULA <= 2'b10;
				op <= 2'b00;
				EscreveReg <= 0;
				OrigPC <= 0;
				EscrevePCB <= 0;
				Mem2Reg <= 0;
				EscrevePCCond <= 0;
				EscrevePC <= 0;
				EscreveMem <= 0;
				IouD <= 0;
				LeMem <= 0;
				EscreveIR <= 0;
			end
		3 :
			begin
				CtrlEnd <= 2'b11;
				IouD <= 1;
				LeMem <= 1;
				EscreveReg <= 0;
				OrigPC <= 0;
				EscrevePCB <= 0;
				Mem2Reg <= 0;
				EscrevePCCond <= 0;
				EscrevePC <= 0;
				EscreveMem <= 0;
				OrigAULA <= 2'b00;
				OrigBULA <= 2'b00;
				op <= 2'b00;
				EscreveIR <= 0;
			end
		4 :
			begin
				CtrlEnd <= 2'b00;
				Mem2Reg <= 2'b10;
				EscreveReg <= 1;
				IouD <= 0;
				LeMem <= 0;
				OrigPC <= 0;
				EscrevePCB <= 0;
				EscrevePCCond <= 0;
				EscrevePC <= 0;
				EscreveMem <= 0;
				OrigAULA <= 2'b00;
				OrigBULA <= 2'b00;
				op <= 2'b00;
				EscreveIR <= 0;
			end
		5 :
			begin
				CtrlEnd <= 2'b00;
				IouD <= 1;
				EscreveMem <= 1;
				LeMem <= 0;
				EscreveReg <= 0;
				OrigPC <= 0;
				EscrevePCB <= 0;
				Mem2Reg <= 0;
				EscrevePCCond <= 0;
				EscrevePC <= 0;
				OrigAULA <= 2'b00;
				OrigBULA <= 2'b00;
				op <= 2'b00;
				EscreveIR <= 0;
			end
		6 :
			begin
				CtrlEnd <= 2'b11;
				OrigAULA <= 2'b01;
				OrigBULA <= 2'b00;
				op <= 2'b10;
				IouD <= 0;
				EscreveMem <= 0;
				LeMem <= 0;
				EscreveReg <= 0;
				OrigPC <= 0;
				EscrevePCB <= 0;
				Mem2Reg <= 0;
				EscrevePCCond <= 0;
				EscrevePC <= 0;
				EscreveIR <= 0;
			end
		7 :
			begin
				CtrlEnd <= 2'b00;
				Mem2Reg <= 2'b00;
				EscreveReg <= 1;
				IouD <= 0;
				EscreveMem <= 0;
				LeMem <= 0;
				OrigPC <= 0;
				EscrevePCB <= 0;
				EscrevePCCond <= 0;
				EscrevePC <= 0;
				OrigAULA <= 2'b00;
				OrigBULA <= 2'b00;
				op <= 2'b00;
				EscreveIR <= 0;
			end
		8 :
			begin
				CtrlEnd <= 2'b00;
				OrigAULA <= 2'b01;
				OrigBULA <= 2'b00;
				op <= 2'b01;
				OrigPC <= 1;
				EscrevePCCond <= 1;
				IouD <= 0;
				EscreveMem <= 0;
				LeMem <= 0;
				EscreveReg <= 0;
				EscrevePCB <= 0;
				Mem2Reg <= 0;
				EscrevePC <= 0;
				EscreveIR <= 0;
			end
		9 :
			begin
				CtrlEnd <= 2'b00;
				OrigPC <= 1;
				EscrevePC <= 1;
				Mem2Reg <= 2'b01;
				EscreveReg <= 1;
				IouD <= 0;
				EscreveMem <= 0;
				LeMem <= 0;
				EscrevePCB <= 0;
				EscrevePCCond <= 0;
				OrigAULA <= 2'b00;
				OrigBULA <= 2'b00;
				op <= 2'b00;
				EscreveIR <= 0;
			end
		/*jalr
		10:
			begin
				CtrlEend <= 2'b00;
				OrigPC <= 1;
				EscrevePC <= 1;
				Mem2Reg <= 2'b01;  //conferir depois mas acho que PC+4 -> rd
				EscreveRege <= 1;	 //e ai depois escreve no rd
				IouD <= 0;
				EscreveMem <= 0;
				LeMem <= 0;
				EscrevePCB <= 0;
				EscrevePCCond <= 0;
				OrigAULA <= 2'b00;
				OrigBULA <= 2'b00;
				op <= 2'b00;
				EscreveIR <= 0;
			end
		*/
		default:
			begin
				CtrlEnd <= 2'b00;
				OrigPC <= 0;
				EscrevePC <= 0;
				Mem2Reg <= 2'b00;
				EscreveReg <= 0;
				IouD <= 0;
				EscreveMem <= 0;
				LeMem <= 0;
				EscrevePCB <= 0;
				EscrevePCCond <= 0;
				OrigAULA <= 2'b00;
				OrigBULA <= 2'b00;
				op <= 2'b00;
				EscreveIR <= 0;
			end
	endcase
end

endmodule
	