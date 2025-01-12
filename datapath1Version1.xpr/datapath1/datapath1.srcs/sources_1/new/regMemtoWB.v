`timescale 1ns/1ps



module regMemtoWB(
    input clk,
    input rst,
    input RegWriteM,
    input [1:0] ResultSrcM,
    input [31:0]ALUresultM,
    input [31:0]ReadDataM,
    input [4:0]RdM,
    input [7:0]PCPlus4M,
    output reg RegWriteW,
    output reg [1:0] ResultSrcW,
    output reg [31:0]ALUresultW,
    output reg [31:0]ReadDataW,
    output reg [4:0]RdW,
    output reg [7:0]PCPlus4W
    );

always@(posedge rst)begin   

     RegWriteW <= 1'b0;
     ResultSrcW <= 2'b0;
     ALUresultW <= 32'b0;
     ReadDataW <= 32'b0;
     RdW <= 8'b0;
     PCPlus4W <= 8'b0;
     
end

always@(posedge clk)begin   

     RegWriteW <= RegWriteM;
     ResultSrcW <= ResultSrcM;
     ALUresultW <= ALUresultM;
     ReadDataW <= ReadDataM;
     RdW <= RdM;
     PCPlus4W <= PCPlus4M;
     
end
    
endmodule
    