`ifndef PARAM
	`include "Parametros.v"
`endif

module Uniciclo (
	input logic clockCPU, clockMem,
	input logic reset,
	output reg [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout
	);
	
	
	initial
		begin
			PC<=TEXT_ADDRESS;
			Instr <= 32'b0;
			regout <= 32'b0;
		end
		
		logic [31:0] SaidaULA, Leitura2, MemData;
		wire EscreveMem, LeMem;
		
//******************************************
// Aqui vai o seu código do seu processador

wire [4:0] rs1; 
wire [4:0] rs2;
wire [4:0] rd;		// indices dos registradores (x0, x1, x2...)

wire EscreveReg;						// sinal de escrita no registrador
wire Mem2Reg;							// sinal do mux de selecao de memoria de dados
wire [1:0] op;							// salva o ALUop
wire muxJal;							// o mux de escrita no banco de registradores
wire muxALU;							// mux da operação da ALU
wire jalR;								// verifica se é um jalr
wire beq;								// mux do branch para escrita no pc
wire jump;								// sinal de jump para OR com o branch
wire [4:0] ALUinput;					// ALUop
logic resOr;								// resultado do or entre beq e jal para escrita no pc
wire equals;							// pega o ZERO da ALU

wire [31:0] Imm;						// imediato da geração de imediatos
logic [31:0] reg1, reg2, regR, regD;		// valores dos resgistradores analisados
logic [31:0] ULAexit;

logic [31:0] PCin;
logic [31:0] PCImm;
logic [31:0] PCJalr;

always @(posedge clockCPU  or posedge reset)
begin
	if(reset)
		PC <= TEXT_ADDRESS;
	else
		PC <= PCin;
end

always @(*)
begin

	// pega os registradores
	rs1 <= Instr[19:15];
	rs2 <= Instr[24:20];
	rd <= Instr[11:7];
			
	// ve qual o dado da ula a ser usado (reg 2 ou imm)
	ULAexit <= (muxALU) ? Imm : reg2;
			
	// pega o sinal de jump (beq ou jal)
	resOr <= (equals & beq) | jump;
	
	// Verifica o proximo valor de PC
	PCImm <= (resOr) ? PC + Imm : PC + 32'd4;
	PCJalr <= (jalR) ? SaidaULA : PC + 32'd4;
	PCin <= (jalR) ?  PCJalr : PCImm;
	
	// verifica o que será regR
	regD <= (Mem2Reg) ? MemData : SaidaULA;
	
	// checa por jumps
	regR <= (muxJal) ? PC + 32'd4 : regD;
	
	// checa pela memoria
	Leitura2 <= reg2;
	
end

// gera o imediato
ImmGen gerador(.iInstrucao(Instr), .oImm(Imm));

// Gera os sinais do controle
Control ctrl(.opcode(Instr[6:0]), .branch(beq), .memRead(LeMem), .memToReg(Mem2Reg), .memWrite(EscreveMem), .ALUsrc(muxALU), .regWrite(EscreveReg), .jumpMux(muxJal), .jumpPc(jump), .jumpSc(jalR), .ALUinput(op)); 
		
// Acessa o banco de registradores
Registers bank1(.iCLK(clockCPU), .iRST(reset), .iRegWrite(EscreveReg), .iReadRegister1(rs1), .iReadRegister2(rs2), .iWriteRegister(rd), .iWriteData(regR), .iRegDispSelect(regin), .oReadData1(reg1), .oReadData2(reg2), .oRegDisp(regout));
		
// Gera o sinal de controle da ALU, depois gera o resultado da ALU
ALUControl ulaC(.ALUop(op), .funct3(Instr[14:12]), .funct7(Instr[31:25]), .ALUsign(ALUinput));
		
ALU ula(.iControl(ALUinput), .iA(reg1), .iB(ULAexit), .oResult(SaidaULA), .equal(equals));
// Instanciação das memórias
ramI MemC (.address(PC[11:2]), .clock(clockMem), .data(), .wren(1'b0), .rden(1'b1), .q(Instr));
ramD MemD (.address(SaidaULA[11:2]), .clock(clockMem), .data(Leitura2), .wren(EscreveMem), .rden(LeMem),.q(MemData));
		

	
		
//*****************************************	
			
endmodule
