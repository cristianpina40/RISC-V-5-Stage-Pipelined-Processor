`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 10:51:03 PM
// Design Name: 
// Module Name: signExtend
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


module signExtend(immSrc, instr, signImm);
input [31:7]instr;
input [1:0]immSrc;
output reg [31:0]signImm;

always@(*)begin
case(immSrc)
    //I-type
    2'b00: begin   
            signImm = $signed({{20{instr[31]}},instr[31:20]});
        end
        //S-type
    2'b01:begin
            signImm = $signed({{20{instr[31]}},instr[31:25],instr[11:7]});
        end
        //B-type
    2'b10:begin
            signImm = $signed({{20{instr[31]}},instr[31:25],instr[11:7]});
        end
        //J-type
    2'b11:begin
            signImm = $signed({{12{instr[31]}}, instr[31:12]});
        end
     default: signImm = 32'bx;    
 endcase 
end
endmodule
