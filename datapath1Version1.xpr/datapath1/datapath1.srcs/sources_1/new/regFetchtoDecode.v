`timescale 1ns/1ps




module regFetchtoDecode(
    input clk,
    input rst,
    input enable,
    input clr,
    input [31:0]instructionF,
    input [7:0]PCF,
    input [7:0]PCPlus4F,
    output reg[31:0] instructionD,
    output reg[7:0] PCD,
    output reg[7:0] PCPlus4D
    );


always@(posedge rst)begin
     instructionD <= 32'b0;
     PCD <= 8'b0;
     PCPlus4D <= 8'b0;
    end
       
always@(posedge clk)begin
     if(enable)begin
        instructionD <= instructionD;
        PCD <= PCD;
        PCPlus4D <= PCPlus4D;
     end
     else if(clr)begin
        instructionD <= 32'b0;
        PCD <= 8'b0;
        PCPlus4D <= 8'b0;
        end
     else begin
        instructionD <= instructionF;
        PCD <= PCF;
        PCPlus4D <= PCPlus4F;
     end
   end
    
endmodule