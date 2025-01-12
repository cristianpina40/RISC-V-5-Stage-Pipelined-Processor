`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 08:34:48 PM
// Design Name: 
// Module Name: mux3to1
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


module mux3to1(select, out, inZero, inOne, inTwo);

input [1:0]select;
input [31:0]inTwo;
input [31:0]inOne;
input [31:0]inZero;

output reg [31:0]out;

always@(*)begin
    if(select == 2'b00)begin
        out = inZero;
    end
    else if(select == 2'b01)begin
        out = inOne;
     end
     else if(select == 2'b10)begin
        out = inTwo;
     end
end
endmodule
