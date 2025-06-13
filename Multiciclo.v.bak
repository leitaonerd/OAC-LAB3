`ifndef PARAM
	`include "Parametros.v"
`endif

module Multiciclo (
	input logic clockCPU, clockMem,
	input logic reset,
	output logic [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout, Exit,
	output logic [3:0] estado
	);
	
	reg [31:0] PCBack;
	
	// flag para a atualização do primeiro PC
	logic flag;
	// proximo estado
	logic [3:0] proximo;
	// saida da ula apos a borda de clock, resultado do MDR, registrador A e B, valor a ser colocado em PC no primo clock, dado a ser gravado no banco de registradores
	logic [31:0] SaidaULA, Leitura2, A, B, PCIn, regR;
	// escrita da memória
	logic EscreveMem;
	// word da leitura da memoria, leitura da memoria de dados, resultado da leitura apos a borda do clock e imediato
	logic [31:0] wIouD, MemData, rmem, Imm;
	// mux de seleção do dado a ser gravado
	logic [2:0] Mem2Reg;
	// escrita no registrador, ZERO da ULA, origem do PC, escrita do PCBack, sinal de branch, escrita do PC, destino do dado da memória, escrita no IR, controle para escrita do PC, leitura de memória
	logic EscreveReg, equals, OrigPC, EscrevePCB, EscrevePCCond, EscrevePC, IouD, EscreveIR, resOr, LeMem;
	// indices dos registradores e operação da ULA
	logic [4:0] rs1, rs2, rd, ALUinput;
	// valores dos registradores, saida da ula antes do clock, entrada A e B da ULA
	logic [31:0] reg1, reg2, ULAprev, ULAExitA, ULAExitB;
	// seleção do ALUinput, seleçao dos mux da ULA, mux do próximo estado da MEF
	logic [1:0] op, OrigAULA, OrigBULA, CtrlEnd;
	
	initial
		begin
			PC<=32'h0040_0000;
			Instr<=32'b0;
			regout<=32'b0;
			EscreveMem <= 1'b0;
			proximo <= 3'b0;
			SaidaULA <= 32'b0;
			flag <= 1;
		end
		
		
//******************************************
// Aqui vai o seu código do seu processador

always @(posedge clockCPU or posedge reset)
	if(reset)
		begin
			PC <= 32'h0040_0000;
			PCBack <= 32'h0040_0000;
			estado <= 4'b0000;
		end
	else
		begin
			// atualiza os elementos sequenciais (estado do controle, SaidaULA, PCBack, PC, IR, MDR, A, B)
			estado <= proximo;
			SaidaULA <= ULAprev;
			if (EscrevePCB)
				PCBack <= PC;
			if (flag)
				flag <= 0;
			else
				begin
					if (resOr)
						PC <= PCIn;	
				end
			if (EscreveIR)
				rmem <= Instr;
			else
				if (LeMem)
				begin
					rmem <= MemData;
					Leitura2 <= MemData;
				end
			A <= reg1;
			B <= reg2;
		end


always @(*)
begin
	Exit <= PCIn;
	// rs1 / rs2 / rd
	rs1 <= Instr[19:15];
	rs2 <= Instr[24:20];
	rd <= Instr[11:7];
	
	// ve o resultado da escrita no PC / PCBack
	resOr = EscrevePC | (equals & EscrevePCCond);
	
	// ve qual o dado a ser lido (instrucao / memoria)
	wIouD <= (IouD) ? SaidaULA : PC;
	
	// ve qual o dado a ser escrito
	case(Mem2Reg)
		2'b00: regR <= SaidaULA;
		2'b01: regR <= PCIn; 
		2'b10: regR <= Leitura2;
		default: regR <= Leitura2;
	endcase
	
	// ve o dado A da ULA
	case(OrigAULA)
		2'b00: ULAExitA <= PCBack;
		2'b01: ULAExitA <= A;
		2'b10: ULAExitA <= PC;
		default: ULAExitA <= A;
	endcase
	
	// ve o dado B da ULA
	case(OrigBULA)
		2'b00: ULAExitB <= B;
		2'b01: ULAExitB <= 32'd4;
		2'b10: ULAExitB <= Imm;
		default: ULAExitB <= B;
	endcase
	
	// Ver a origem do PC, se for uma operação de jump, tira uma word de PCIn para evitar o truncamento da instrução na passagem de estado para 0
	if (estado == 9)
		PCIn <= (OrigPC) ? SaidaULA - 32'd4 : ULAprev - 32'd4;
	else
		PCIn <= (OrigPC) ? SaidaULA : ULAprev;
	
end
// Banco de registradores
Registers bank(.iCLK(clockCPU), .iRST(reset), .iRegWrite(EscreveReg), .iReadRegister1(rs1), .iReadRegister2(rs2), .iWriteRegister(rd), .iWriteData(regR), .iRegDispSelect(regin), .oReadData1(reg1), .oReadData2(reg2), .oRegDisp(regout));

// Gerador de Imediatos
ImmGen gerador(.iInstrucao(Instr), .oImm(Imm));

// ULA
ALU ula(.iControl(ALUinput), .iA(ULAExitA), .iB(ULAExitB), .oResult(ULAprev), .equal(equals));

// Controle da ULA
ALUControl ulaC(.ALUop(op), .funct3(Instr[14:12]), .funct7(Instr[31:25]), .ALUsign(ALUinput));

// Controle do Multiciclo
ControlM ctrl(.opcode(Instr[6:0]), .estado(estado), .proximo(proximo), .EscreveReg(EscreveReg), .OrigPC(OrigPc), .EscrevePCB(EscrevePCB), .Mem2Reg(Mem2Reg), .EscrevePCCond(EscrevePCCond), .EscrevePC(EscrevePC), .IouD(IouD), .EscreveIR(EscreveIR), .LeMem(LeMem), .op(op), .OrigAULA(OrigAULA), .OrigBULA(OrigBULA), .CtrlEnd(CtrlEnd));
 

ramI MemC (.address(wIouD[11:2]), .clock(clockMem), .data(B), .wren(EscreveMem & ~wIouD[28]), .q(Instr));
ramD MemD (.address(wIouD[11:2]), .clock(clockMem), .data(B), .wren(EscreveMem & wIouD[28]), .q(MemData));


	
//*****************************************
	
			
endmodule
