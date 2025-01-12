`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 11:33:23 PM
// Design Name: 
// Module Name: regFile
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


module regFile(reset, clk, A1, A2, WA, WD3, SP, PC, CC, WE, RD1, RD2);

input [4:0]A1;   //Write Address 1
input [4:0]A2;   //Write Address 2
input clk, WE, reset;   //Clock, reset, and write enable signals 
input [31:0]SP;  //Stack pointer for Reg1
inout [31:0]PC;
input [31:0]CC;   //Program counter for Reg0
input [31:0]WD3; //Data to write in
input [4:0]WA;   //Write in Address
output reg [31:0]RD1; //Output from Address 1
output reg [31:0]RD2;  //Output from Address 2

reg [31:0]register[16:0]; //16 32-bit registers
integer i;

initial begin
for(i = 0; i <16 ; i = i +1)begin
    register[i] = 32'b0;    //Register initialize to 0
  end
end

always@(A1 or A2 or SP or PC or CC)begin
RD1 <= register[A1];    //Asynchronous outputs for A1 and A2
RD2 <= register[A2];
register[1] <= SP;  //New values always given to SP,PC, and CC
register[0] <= PC;
register[15] <= CC;
end


always@(posedge clk)begin
    if(WE == 1'b1)begin
        register[WA] <= WD3;
    end
 end
 
 always@(posedge reset)begin
 for(i = 0; i < 16; i = i +1)begin
    register[i] = 32'b0;    //Register initialize to 0
  end
end
 
endmodule
