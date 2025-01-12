`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 09:49:11 PM
// Design Name: 
// Module Name: fullAdder
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


module fullAdder(in, B, Result);

input signed[31:0]in;
output reg [7:0]Result;
input signed[7:0]B;
integer i,j;
reg [31:0]Ci;



always@(*)begin
for(j = 1; j < 12; j = j + 4)begin
         Ci[0] = 1'b0;
         if(j > 1)begin
         Ci[j-1] = (in[j-2] & B[j-2])|(Ci[j-2]&(in[j-2] | B[j-2]));
         end
         Ci[j] = (in[j-1] & B[j-1])|(Ci[j-1]&(in[j-1]^B[j-1]));
         Ci[j+1] = (in[j] & B[j]) | ((in[j] ^ B[j])& Ci[j]);
         Ci[j+2] = (in[j+1] & B[j+1]) | ( (in[j+1] ^ B[j+1]) & Ci[j+1]);
      
         Result[j-1] = $signed(in[j-1] ^ B[j-1] ^ Ci[j-1]);
         Result[j] =  $signed(in[j] ^ B[j] ^ Ci[j]);
         Result[j+1] = $signed(in[j+1] ^ B[j+1] ^ Ci[j+1]);
         Result[j+2] = $signed(in[j+2] ^ B[j+2] ^ Ci[j+2]);
         end  
        end
endmodule

