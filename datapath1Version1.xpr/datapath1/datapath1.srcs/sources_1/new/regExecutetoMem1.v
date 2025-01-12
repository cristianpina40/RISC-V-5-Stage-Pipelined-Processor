`timescale 1ns/1ps


module regExecutetoMem1(clk, rst, ALUresultE, WriteDataE, RdE,
    PCPlus4E, RegWriteE, ResultSrcE, MemWriteE, ALUresultM, WriteDataM, RdM,
    PCPlus4M, RegWriteM, ResultSrcM, MemWriteM
    );
 
input clk;
input rst;
input [31:0]ALUresultE;
input [31:0]WriteDataE;
input [4:0]RdE;
input [7:0]PCPlus4E;
input RegWriteE;
input [1:0]ResultSrcE;
input MemWriteE;
output reg [31:0]ALUresultM;
output reg [31:0]WriteDataM;
output reg [4:0]RdM;
output reg [7:0]PCPlus4M;
output reg RegWriteM;
output reg [1:0]ResultSrcM;
output reg MemWriteM;

always@(posedge rst)begin
     
     RegWriteM <= 1'b0;
     ResultSrcM <= 2'b0;
     ALUresultM <= 32'b0;
     RdM <= 5'b0;
     WriteDataM <= 32'b0;
     PCPlus4M <= 8'b0;    
     MemWriteM <= 1'b0;
     
   end
   
always@(posedge clk)begin

    ALUresultM <= ALUresultE;
    WriteDataM <= WriteDataE;
    RdM <= RdE;
    PCPlus4M <= PCPlus4E;
    RegWriteM <= RegWriteE;
    ResultSrcM <= ResultSrcE;
    MemWriteM <= MemWriteE;
    
end
    
endmodule
