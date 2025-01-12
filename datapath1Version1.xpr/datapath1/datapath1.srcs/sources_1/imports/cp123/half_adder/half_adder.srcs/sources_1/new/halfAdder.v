`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2024 05:53:48 PM
// Design Name: 
// Module Name: halfAdder
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


module halfAdder(in, result);

input [7:0]in;
output reg[7:0]result;
reg [7:0]B = 8'b0100;
integer i,j;
reg [7:0]Ci;


always@(*)begin
for(j = 1; j < 8; j = j + 4)begin
         Ci[0] = 1'b0;
         if(j > 1)begin
         Ci[j-1] = (in[j-2] & B[j-2])|(Ci[j-2]&(in[j-2] | B[j-2]));
         end
         Ci[j] = (in[j-1] & B[j-1])|(Ci[j-1]&(in[j-1]^B[j-1]));
         Ci[j+1] = (in[j] & B[j]) | ((in[j] ^ B[j])& Ci[j]);
         Ci[j+2] = (in[j+1] & B[j+1]) | ( (in[j+1] ^ B[j+1]) & Ci[j+1]);
      
         result[j-1] = in[j-1] ^ B[j-1] ^ Ci[j-1];
         result[j] =  in[j] ^ B[j] ^ Ci[j];
         result[j+1] = in[j+1] ^ B[j+1] ^ Ci[j+1];
         result[j+2] = in[j+2] ^ B[j+2] ^ Ci[j+2];
         end  
        end
endmodule
