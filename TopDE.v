`ifndef PARAM
	`include "Parametros.v"
`endif

module TopDE (
	input logic CLOCK, Reset,
	input logic [4:0] Regin,
	output logic ClockDIV,
	output logic [31:0] PC,Instr,Regout, exit,
	output logic [3:0] Estado
	);
	
		
logic ClockDIV1;
		
	initial 
	begin
		ClockDIV <= 1'b1;
		ClockDIV1 <= 1'b1;
	end

	always @(posedge ClockDIV1) 
		begin 		
				ClockDIV <= ~ClockDIV;  //clockDIV metade da frequência do Clock
		end
	
	always @(posedge CLOCK) 
		begin 		
				ClockDIV1 <= ~ClockDIV1;  //clockDIV metade da frequência do Clock
		end

	
	/*Uniciclo UNI1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout));*/

					
Multiciclo MULT1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout), .estado(Estado), .Exit(exit));
						
/* Pipeline PIP1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout)); */
		
	
endmodule
