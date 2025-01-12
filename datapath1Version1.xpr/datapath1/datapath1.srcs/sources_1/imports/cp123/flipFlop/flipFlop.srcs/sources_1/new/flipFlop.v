`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2024 06:33:10 PM
// Design Name: 
// Module Name: flipFlop
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


module flipFlop(D, enable, reset, Q,clk);
input [7:0]D;
input enable;
input reset;
input clk;
output reg [7:0]Q;

always@(posedge reset)begin
    Q <= 7'b0;
    end

always@(posedge clk)begin
    if(enable)
        Q <= Q;
    else
        Q <= D;
   end
endmodule
