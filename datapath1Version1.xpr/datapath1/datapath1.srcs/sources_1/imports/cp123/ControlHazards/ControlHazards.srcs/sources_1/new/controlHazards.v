`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2024 11:19:23 PM
// Design Name: 
// Module Name: controlHazards
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


module controlHazards(
    input [4:0]RS1E,
    input [4:0]RS2E,
    input [4:0]RdM,
    input [4:0]RdW,
    input RegWriteM,
    input RegWriteW,
    input ResultSrcE,
    input [4:0]RS1D,
    input [4:0]RS2D,
    input [4:0]RdE,
    input MemWrite,
    input MemWriteE,
    input PCSrcE,
    input [4:0]resultM,
    input [4:0]resultW,
    output reg [1:0]ForwardAE,
    output reg [1:0]ForwardBE,
    output reg ForwardAD,
    output reg StallF,
    output reg StallD,
    output reg FlushE,
    output reg [1:0]ForwardSW,
    output reg FlushD
    );
    
reg LWStall;

//Data stalling and flushing for LW hazard
always@(*)begin
    if(ResultSrcE && ((RS1D == RdE) || (RS2D == RdE)))begin
        StallF = 1'b1;
        StallD = 1'b1;
        LWStall = 1'b1;     
     end
     else begin
        StallF = 1'b0;
        StallD = 1'b0;
        LWStall = 1'b0;
     end  
   end

always@(*)begin
      if(PCSrcE == 1'b1 || LWStall == 1'b1) FlushE = 1'b1;
      else FlushE = 1'b0;
      
      if(PCSrcE == 1'b1) FlushD = 1'b1;
      else FlushD = 1'b0;
      end
//Data Forwarding for A input includes SW hazards
always@(*)begin
   if(((RS1E == RdM) && (RegWriteM == 1'b1)) && RS1E != 5'b0) ForwardAE = 2'b01;
   else if(((RS1E == RdM) && (RegWriteM == 1'b1 && MemWriteE == 1'b1)) && RS1E != 5'b0) ForwardAE = 2'b01;
   else if(((RS1E == RdW) && (RegWriteW == 1'b1 && MemWriteE == 1'b1)) && RS1E != 5'b0) ForwardAE = 2'b10;
   else if(((RS1E == RdW) && (RegWriteW == 1'b1)) && RS1E != 5'b0) ForwardAE = 2'b10;
   else ForwardAE = 2'b00;
end   

always@(*)begin
    if(((RS1D == RdW) && (RegWriteW == 1'b1 && MemWrite == 1'b1)) && RS1D != 5'b0) ForwardAD = 1'b1;
    else ForwardAD = 1'b0;
    end


//Data Forwarding for B input
always@(*)begin
    if(((RS2E == RdM) && RegWriteM == 1'b1) && RS2E != 5'b0) ForwardBE = 2'b01;
    else if(((RS2E == RdW) && RegWriteW == 1'b1 ) && RS2E != 5'b0) ForwardBE = 2'b10;
    else ForwardBE = 2'b00;
end
//Data forwarding for SW operations
always@(*)begin
    if((RS2E == RdM) && MemWriteE == 1'b1) ForwardSW = 2'b01;
    else if((RS2E == RdW) && MemWriteE == 1'b1) ForwardSW = 2'b10;
    else ForwardSW = 2'b00;
    end
    
/*always@(*)begin  
    if(((RS1E == RdM) && ((MemWriteE == 1'b1) && (RegWriteM == 1'b1)))) ForwardAE = 2'b01;
    if(((RS1E == RdM) && ((MemWriteE == 1'b1) && (RegWriteW == 1'b1)))) ForwardAE = 2'b10;
    else ForwardAE = 2'b00;
    end
 */   
endmodule

    
