`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 08:44:33 PM
// Design Name: 
// Module Name: datamem
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


module datamem(wrtEnable, clk, address, 
write_data, read_data);
input wrtEnable;
input clk;
input [31:0]address;
input [31:0]write_data;
output reg [31:0]read_data;

reg [31:0]memory[255:0];

integer i;
initial begin
 read_data = 32'b0;
 for(i = 0; i < 256; i = i+1)begin
    memory[i] = i;
 end
end 

always@(*)begin
read_data <= memory[address];
end
 
 always@(posedge clk)begin
    if(wrtEnable == 1'b1)begin
        memory[address] <= write_data;
    end
  end

endmodule
