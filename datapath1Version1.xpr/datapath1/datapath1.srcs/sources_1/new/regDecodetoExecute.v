`timescale 1ns/1ps


module regDecodetoExecute(
    input clk,
    input rst,
    input clr,
    input RegWriteD,
    input [1:0]ResultSrcD,
    input MemWriteD,
    input JumpD,
    input BranchD,
    input [3:0]ALUControlD,
    input [4:0]RS1D,
    input [4:0]RS2D,
    input ALUSrcD,
    input [31:0]RD1D,
    input [31:0]RD2D,
    input [7:0]PCD,
    input [4:0] RdD,
    input [31:0]ImmExtD,
    input [7:0] PCPlus4D,
    output reg [4:0] RS1E,
    output reg [4:0] RS2E,
    output reg RegWriteE,
    output reg [1:0]ResultSrcE,
    output reg MemWriteE,
    output reg JumpE,
    output reg BranchE,
    output reg [3:0]ALUControlE,
    output reg ALUSrcE,
    output reg [31:0]RD1E,
    output reg [31:0]RD2E,
    output reg [7:0]PCE,
    output reg [4:0] RdE,
    output reg [31:0]ImmExtE,
    output reg [7:0] PCPlus4E
    );

always@(posedge rst)begin
     
     RegWriteE <= 1'b0;
     ResultSrcE <= 2'b0;
     MemWriteE <= 1'b0;
     JumpE <= 1'b0;
     BranchE <= 1'b0;
     ALUControlE <= 3'b0;
     ALUSrcE <= 1'b0;
     RD1E <= 32'b0;
     RD2E <= 32'b0;
     PCE <= 8'b0;
     RdE <= 5'b0;
     ImmExtE <= 32'b0;
     PCPlus4E <= 8'b0;
     RS1E <= 5'b0;
     RS2E <= 5'b0;
     
   end
always@(posedge clk)begin
    
     if(clr)begin
        RegWriteE <= 1'b0;
        ResultSrcE <= 2'b0;
        MemWriteE <= 1'b0;
        JumpE <= 1'b0;
        BranchE <= 1'b0;
        ALUControlE <= 3'b0;
        ALUSrcE <= 1'b0;
        RD1E <= 32'b0;
        RD2E <= 32'b0;
        PCE <= 8'b0;
        RdE <= 5'b0;
        ImmExtE <= 32'b0;
        PCPlus4E <= 8'b0;
        RS1E <= 5'b0;
        RS2E <= 5'b0;
     end
     else begin
        RegWriteE <= RegWriteD;
        ResultSrcE <= ResultSrcD;
        MemWriteE <= MemWriteD;
        JumpE <= JumpD;
        BranchE <= BranchD;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrcD;
        RD1E <= RD1D;
        RD2E <= RD2D;
        PCE <= PCD;
        RdE <= RdD;
        ImmExtE <= ImmExtD;
        PCPlus4E <= PCPlus4D;
        RS1E <= RS1D;
        RS2E <= RS2D;
     end
end
    
endmodule