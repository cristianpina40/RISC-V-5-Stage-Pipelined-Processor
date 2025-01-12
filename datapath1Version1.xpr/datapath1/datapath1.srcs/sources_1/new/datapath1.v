`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2024 01:16:51 PM
// Design Name: 
// Module Name: datapath1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath1(clk, rst, ResultSrc, mem_write,
ALUControl, ALUSrc, ImmSrc, RegWrite, opcode, funct7, funct3, 
 result, Jump, Branch,ALURes1,ALURes2,ALURes3, WriteDataIncheck,
 currentAddress, RS1E_DB, RdW_DB,RdM_DB,ForwardAE_DB);
parameter PC_W = 8; //Program counter bit width
parameter INS_W = 32; // Instruction width
parameter RF_A = 5; //register file address
parameter DATA_W = 32; //Write data 
parameter DM_A = 8; //Data memory address
parameter ALU_CC = 4; //ALU control code

input clk;
input rst;
input [1:0]ResultSrc; //Result source
input mem_write; //write enable to data mem
input [ALU_CC - 1:0]ALUControl; //alu control code
input ALUSrc; //source b to alu select
input [1:0]ImmSrc; //source for sign extend\
input RegWrite; //write enable to register
input Jump;
input Branch;


output [6:0] opcode;
output [6:0]funct7; 
output [2:0]funct3; 
output signed[DATA_W - 1: 0] result;
output [31:0]ALURes1;
output [31:0]ALURes2;
output [31:0]ALURes3;
output [31:0]WriteDataIncheck;

output [7:0]currentAddress;
output [4:0]RS1E_DB;
output [4:0]RdW_DB;
output [4:0]RdM_DB;
output [1:0]ForwardAE_DB;


wire branchCondition;
wire [PC_W -1:0] PC, PCNext, PCPlus4, PCTarget, PCTargetE;
wire [INS_W - 1: 0] instruction;
wire [DATA_W -1: 0] readAddress1, readAddress2, immExtended;
wire [DATA_W - 1: 0] ALUResult_1;
wire [DATA_W - 1: 0] readData;
wire [DATA_W - 1: 0] sourceB;
wire [23:0] zeros = 24'b0;
wire [31:0] CC_reg;
wire RegWriteW;
wire PCSrc;
wire [4:0]RdW;
wire JumpE;
wire BranchE;
wire [31:0]ALUresultM;
wire [4:0]RdM;
wire StallF;
wire StallD;
wire FlushE;
wire FlushD;
wire [1:0]ForwardSW;
wire [4:0]RS1E;
wire [1:0]ForwardAE;
wire ForwardAD;

assign currentAddress = PC;
assign RS1E_DB = RS1E;
assign RdW_DB = RdW;
assign RdM_DB = RdM;
assign ForwardAE_DB = ForwardAE;
//--------------------FETCH----------------------FETCH----------------------------FETCH--------------------------------------//

assign PCSrc = (branchCondition && BranchE) || JumpE;
assign PCNext = PCSrc ? PCTargetE : PCPlus4;

halfAdder PC1_datapath( 
        .in(PC), 
        .result(PCPlus4)
        );
        
flipFlop data_ff(
    .D(PCNext),
    .reset(rst),
    .Q(PC),
    .clk(clk),
    .enable(StallF)
    );

instMem datainstmem( 
    .A(PC), 
    .RD(instruction)
    );

 
//-----------------------------Pipeline register stage between Fetch and Decode----------------------------------------------------//
wire [31:0] instructionD;
wire [7:0] PCD;
wire [7:0] PCPlus4D;    

regFetchtoDecode PipelineRegisterOne(
    .clk(clk),
    .rst(rst),
    .enable(StallD),
    .instructionF(instruction),
    .PCF(PC),
    .PCPlus4F(PCPlus4),
    .instructionD(instructionD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .clr(FlushD)
    );
 

//---------------DECODE-------------------------------------DECODE-----------------------------------------------------------------//
assign opcode = instructionD[6:0];
assign funct7 = instructionD[31:25];
assign funct3 = instructionD[14:12];

//Register File
regFile datareg( 
        .reset(rst),
        .clk(clk),
        .A1(instructionD[19:15]), //Write Address 1
        .A2(instructionD[24:20]), //Write Address 2
        .WA(RdW),                 //new write in address
        .WD3(result),             // end result written in processor
        .PC({zeros,PC}),          //Program counter for Reg0
        .SP(instructionD),
        .CC(CC_reg),              //Stack pointer for Reg1
        .WE(RegWriteW),           //write enable signal
        .RD1(readAddress1),       //Output from Address 1
        .RD2(readAddress2)        //Output from Address 2
        );

//sign extender 
signExtend data_signE( 
        .immSrc(ImmSrc),
        .instr(instructionD[31:7]),
        .signImm(immExtended)
        );
 
 //--------------------------------Pipeline between Decode and Execute stage--------------------------------------//
    wire RegWriteE;
    wire [1:0]ResultSrcE;
    wire MemWriteE;
    wire [3:0]ALUControlE;
    wire ALUSrcE;
    wire [31:0]RD1E;
    wire [31:0]RD2E;
    wire [7:0]PCE;
    wire [4:0]RdE;
    wire [31:0]ImmExtE;
    wire [7:0]PCPlus4E;
   // wire [4:0]RS1E;
    wire [4:0]RS2E;
    wire [31:0]RD1in;
    
assign RD1in = ForwardAD ? result : readAddress1;

regDecodetoExecute PipelineRegisterTwo(
    .clk(clk),
    .rst(rst),
    .clr(FlushE),
    .RegWriteD(RegWrite),
    .ResultSrcD(ResultSrc),
    .MemWriteD(mem_write),
    .JumpD(Jump),
    .BranchD(Branch),
    .ALUControlD(ALUControl),
    .ALUSrcD(ALUSrc),
    .RD1D(RD1in),
    .RD2D(readAddress2),
    .PCD(PCD),
    .RdD(instructionD[11:7]),
    .ImmExtD(immExtended),
    .PCPlus4D(PCPlus4D),
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .BranchE(BranchE),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .PCE(PCE),
    .RdE(RdE),
    .ImmExtE(ImmExtE),
    .PCPlus4E(PCPlus4E),
    .RS1D(instructionD[19:15]),
    .RS2D(instructionD[24:20]),
    .RS1E(RS1E),
    .RS2E(RS2E)
    );
    
   

//---------------------EXECUTE--------------EXECUTE---------------------EXECUTE--------------------//



wire [31:0]SrcAE;
wire [31:0]SrcBE;
//wire [1:0]ForwardAE;
wire [1:0]ForwardBE;
wire [31:0]WriteDataIn;
fullAdder PC_immnext(
    .in(ImmExtE),
    .B(PCE),
    .Result(PCTargetE)
    );


mux3to1 hazardA(
    .inZero(RD1E),
    .inOne(ALUresultM),
    .inTwo(result),
    .select(ForwardAE),
    .out(SrcAE)
    );

mux3to1 hazardB(
    .inZero(RD2E),
    .inOne(ALUresultM),
    .inTwo(result),
    .select(ForwardBE),
    .out(SrcBE)
    );
 
assign sourceB = ALUSrcE ? ImmExtE : SrcBE;

mux3to1 WriteData(
    .inZero(SrcBE),
    .inOne(ALUresultM),
    .inTwo(result),
    .select(ForwardSW),
    .out(WriteDataIn)
    );
    
ALU data_ALU( 
    .A_in(SrcAE),
    .B_in(sourceB),
    .ALU_Sel(ALUControlE),
    .ALU_Out(ALUResult_1),
    .branchCond(branchCondition),
    .CC(CC_reg)
    );
    
assign ALURes1 = ALUResult_1;
assign WriteDataIncheck = WriteDataIn;
//-------------------------------Pipeline between Execute and Memory-------------------------------------//
   
    
    wire [31:0]WriteDataM;
    wire [7:0]PCPlus4M;
    wire RegWriteM;
    wire [1:0] ResultSrcM;
    wire MemWriteM;
regExecutetoMem1 PipleineRegisterThree(
    .clk(clk),
    .rst(rst),
    .ALUresultE(ALUResult_1),
    .WriteDataE(WriteDataIn),
    .RdE(RdE),
    .PCPlus4E(PCPlus4E),
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .ALUresultM(ALUresultM),
    .WriteDataM(WriteDataM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM)
    );
    
 assign ALURes2 = ALUresultM;


//-----------WRITE/WRITEBACK-----------------------------------------------------WRITE/WRITEBACK----------
//data memory
datamem data_datamem(
    .wrtEnable(MemWriteM),
    .clk(clk),
    .address(ALUresultM),
    .write_data(WriteDataM),
    .read_data(readData)
    );


//-------------------------Pipeline between Write and Writeback stage---------------------------------//

    
   
    wire [1:0]ResultSrcW;
    wire [31:0]ALUresultW;
    wire [31:0]ReadDataW;
    wire [7:0]PCPlus4W;
    
regMemtoWB PipelineRegisterFour(
    .clk(clk),
    .rst(rst),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .ALUresultM(ALUresultM),
    .ReadDataM(readData),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M),
    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),
    .ALUresultW(ALUresultW),
    .ReadDataW(ReadDataW),
    .RdW(RdW),
    .PCPlus4W(PCPlus4W)
    );
 
assign ALURes3 = ALUresultW;

//---------------------------------WriteBack stage---------------------------------------------------//
mux3to1 data_mux(
    .select(ResultSrcW),
    .out(result),
    .inZero(ALUresultW),
    .inOne(ReadDataW),
    .inTwo({zeros,PCPlus4W})
    );
    
    
    
    
controlHazards hazardUnit(
    .RS1E(RS1E),
    .RS2E(RS2E),
    .RdM(RdM),
    .RdW(RdW),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .MemWriteE(MemWriteE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .ForwardSW(ForwardSW),
    .ResultSrcE(ResultSrcE[0]),
    .RS1D(instructionD[19:15]),
    .RS2D(instructionD[24:20]),
    .RdE(RdE),
    .StallF(StallF),
    .StallD(StallD),
    .FlushE(FlushE),
    .FlushD(FlushD),
    .PCSrcE(PCSrc),
    .resultM(ALUresultM[4:0]),
    .resultW(result[4:0]),
    .ForwardAD(ForwardAD),
    .MemWrite(mem_write)
    );
endmodule
