`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2024 04:52:52 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
  input signed[31:0] A_in ,B_in , // ALU 32 bit inputs
  input Carry_in,
  input [3:0] ALU_Sel , // ALU 4 bits selection
  output signed[31:0] ALU_Out , // ALU 32 bits output
  output reg Carry_Out ,
  output reg branchCond , // 1 bit Zero Flag
  output reg Overflow = 1'b0, // 1 bit Overflow flag
  output reg[31:0] CC
 );
  reg signed[31:0] ALU_Result ;
  reg [63:0] temp = 64'b0;
  reg [63:0] temp2= 64'b0;
  reg [31:0] temp3 = 32'b0;
  reg [31:0] temp4 = 32'b1;
  reg [31:0] temp5;
  reg [32:0] twos_com ; // to hold 2 'sc of second source of ALU
  reg [31:0] Ci;
  assign Carry_in = 0;
  assign ALU_Out = ALU_Result ; // ALU Out
  integer i,j,k,l,m;
  always @ (*)
   begin
    Overflow = 1'b0;
    Carry_Out = 1'b0;
    case ( ALU_Sel )   
      4'b1111 : begin // bit - wise XOR
      ALU_Result = A_in ^ B_in ;
       branchCond = 1'b0;
      end
      4'b0001 : begin // bit - wise NOT A
      ALU_Result = ~A_in ;
       branchCond = 1'b0;
      end
      4'b1010: begin// bit - wise not B
      ALU_Result = ~B_in;
       branchCond = 1'b0;
      end
      4'b0010: begin//bit-wise AND
      ALU_Result = A_in & B_in;
       branchCond = 1'b0;
      end
      4'b0011:begin //bit -wise OR
      ALU_Result = A_in | B_in;
       branchCond = 1'b0;
      end
      4'b0100 : // Signed Addition with Overflow and Carry_out checking
       begin
        Ci[0] = Carry_in;
        for(j = 1; j < 32; j = j + 4)begin
         if(j > 1)begin
         Ci[j-1] = (A_in[j-2] & B_in[j-2])|(Ci[j-2]&(A_in[j-2] | B_in[j-2]));
         end
         Ci[j] = (A_in[j-1] & B_in[j-1])|(Ci[j-1]&(A_in[j-1]^B_in[j-1]));
         Ci[j+1] = (A_in[j] & B_in[j]) | ((A_in[j] ^ B_in[j])& Ci[j]);
         Ci[j+2] = (A_in[j+1] & B_in[j+1]) | ( (A_in[j+1] ^ B_in[j+1]) & Ci[j+1]);
      
         ALU_Result[j-1] = A_in[j-1] ^ B_in[j-1] ^ Ci[j-1];
         ALU_Result[j] =  A_in[j] ^ B_in[j] ^ Ci[j];
         ALU_Result[j+1] = A_in[j+1] ^ B_in[j+1] ^ Ci[j+1];
         ALU_Result[j+2] = A_in[j+2] ^ B_in[j+2] ^ Ci[j+2];
         end
         temp[32] = (A_in[31] & B_in[31]) | (B_in[31] & Ci[31]) | (A_in[31] & Ci[31]);        
        // Overflow and Underflow Checks
        if (A_in[31] && B_in[31] && ~ALU_Result[31]) begin
        // Reset overflow when underflow occurs
        CC <= 32'd2;  
        end 
        else if (A_in[31] == B_in[31] && ALU_Result[31] != A_in[31]) begin
      // Reset underflow when overflow occurs
        CC <= 32'd1; 
        end 
        else begin
        CC <= 32'd0; 
        end    
        // Carry_Out logic (if needed, based on final bit result)
        if (temp[32] == 1'b0) begin
            Carry_Out <= 1'b0;
        end else begin
            Carry_Out <= 1'b1;
        end        
      end
    
     
      4'b0101 : // Signed Subtraction with Overflow checking
      begin
            branchCond = 1'b0;
          //twos complement B
          for(i = 0; i < 32; i = i +1)begin
                temp3[i] = ~B_in[i] ;
                end
                
        for(j = 1; j < 32; j = j + 4)begin
        Ci[0] = Carry_in; 
         if(j > 1)begin
         Ci[j-1] = (temp3[j-2] & temp4[j-2])|(Ci[j-2]&(temp3[j-2] | temp4[j-2]));
         end
         Ci[j] = (temp3[j-1] & temp4[j-1])|(Ci[j-1]&(temp3[j-1]^temp4[j-1]));
         Ci[j+1] = (temp3[j] & temp4[j]) | ((temp3[j] ^ temp4[j])& Ci[j]);
         Ci[j+2] = (temp3[j+1] & temp4[j+1]) | ( (temp3[j+1] ^ temp4[j+1]) & Ci[j+1]);
      
         temp5[j-1] = $signed(temp3[j-1] ^ temp4[j-1] ^ Ci[j-1]);
         temp5[j] =  $signed(temp3[j] ^ temp4[j] ^ Ci[j]);
         temp5[j+1] = $signed(temp3[j+1] ^ temp4[j+1] ^ Ci[j+1]);
         temp5[j+2] = $signed(temp3[j+2] ^ temp4[j+2] ^ Ci[j+2]);
         end  
                
        //subtract
        Ci[0] = Carry_in; 
        for(j = 1; j < 32; j = j + 4)begin
         if(j > 1)begin
         Ci[j-1] = (A_in[j-2] & temp5[j-2])|(Ci[j-2]&(A_in[j-2] | temp5[j-2]));
         end
         Ci[j] = (A_in[j-1] & temp5[j-1])|(Ci[j-1]&(A_in[j-1]^temp5[j-1]));
         Ci[j+1] = (A_in[j] & temp5[j]) | ((A_in[j] ^ temp5[j])& Ci[j]);
         Ci[j+2] = (A_in[j+1] & temp5[j+1]) | ( (A_in[j+1] ^ temp5[j+1]) & Ci[j+1]);
      
         ALU_Result[j-1] = $signed(A_in[j-1] ^ temp5[j-1] ^ Ci[j-1]);
         ALU_Result[j] =  $signed(A_in[j] ^ temp5[j] ^ Ci[j]);
         ALU_Result[j+1] = $signed(A_in[j+1] ^ temp5[j+1] ^ Ci[j+1]);
         ALU_Result[j+2] = $signed(A_in[j+2] ^ temp5[j+2] ^ Ci[j+2]);
         end
         // Overflow and Underflow Checks for Signed Subtraction
    if ((A_in[31] == 1'b0 && B_in[31] == 1'b1 && ALU_Result[31] == 1'b1)) begin
         // Positive minus Negative, resulting in a Negative -> Overflow
        // Reset underflow when overflow occurs
        CC <= 32'd1;  // Overflow flag in CC_reg
    end
     else if ((A_in[31] == 1'b1 && B_in[31] == 1'b0 && ALU_Result[31] == 1'b0)) begin
       // Reset overflow when underflow occurs
        CC <= 32'd2;  // Underflow flag in CC_reg
    end 
    else begin
        CC <= 32'd0;  // No flags set
    end
    end
     
     4'b0110: //signed multiplication
      begin   
       branchCond = 1'b0; 
      for(i = 0; i < 32; i= i+1)begin   
       if(B_in[i] == 1'b1)begin
         temp2 = temp;
         for(j = 0; j < 32 ; j = j+4)begin
         if(j == 0)begin
         Ci[j] = 1'b0;
         end
         Ci[j+1] = (A_in[j] & temp[j+32])|(Ci[j]&(A_in[j]^temp[j+32]));
         Ci[j+2] = (A_in[j+1] & temp[j+33]) | ((A_in[j+1] ^ temp[j+33])& Ci[j+1]);
         Ci[j+3] = (A_in[j+2] & temp[j+34]) | ((A_in[j+2] ^ temp[j+34]) & Ci[j+2]);  
         Ci[j+4] = (A_in[j+3] & temp[j+35]) | ((A_in[j+3] ^ temp[j+35]) & Ci[j+3]);
         temp[j+32] = A_in[j] ^ temp[j+32] ^ Ci[j];
         temp[j+33] =  A_in[j+1] ^ temp[j+33] ^ Ci[j+1];
         temp[j+34] = A_in[j+2] ^ temp[j+34] ^ Ci[j+2];
         temp[j+35] = A_in[j+3] ^ temp[j+35] ^ Ci[j+3];
         temp2[j+32] = temp[j+32];
         temp2[j+33] = temp[j+33];
         temp2[j+34] = temp[j+34];
         temp2[j+35] = temp[j+35];
         end      
         for(k = 63; k > 0; k = k-1)begin 
         temp[k-1] = temp2[k];  
         end
         temp[63] = 1'b0;  
        end
        else if(B_in[i] == 1'b0)begin
        temp2 = temp;
        for(k = 63; k > 0; k = k-1)begin   
         temp[k-1] = temp2[k]; 
         end
         temp[63] = 1'b0;
        end
       end
       ALU_Result = $signed(temp[31:0]);
       branchCond = 1'b0;
       
        // Overflow and Underflow Checks for Multiplication
       if ((A_in[31] == 1'b0 && B_in[31] == 1'b0 && ALU_Result[31] == 1'b1) || // Positive overflow
        (A_in[31] == 1'b1 && B_in[31] == 1'b1 && ALU_Result[31] == 1'b0)) begin // Negative overflow 
        CC <= 32'd1;  // Overflow flag
        end 
        else if ((A_in[31] != B_in[31] && ALU_Result[31] == (A_in[31] ^ B_in[31]))) begin // Underflow case  
        CC <= 32'd2;  // Underflow flag
        end 
        else begin
       // No overflow or underflow  
        CC <= 32'd0;  
        end
         end
         
     
     4'b1000 :begin // Signed less than comparison
      ALU_Result = ($signed(A_in) < $signed( B_in ))?32'd1:32'd0;
      if(ALU_Result == 32'd1)begin
        branchCond = 1'b1;
        end
        else if(ALU_Result == 32'd0)begin
        branchCond = 1'b0;
       end
       end
     4'b1001 : begin// Less than Equal to       
       ALU_Result = (A_in <= B_in) ? 32'd1 : 32'd0;
        if(ALU_Result == 32'd1)begin
        branchCond = 1'b1;
        end
        else if(ALU_Result == 32'd0)begin
        branchCond = 1'b0;
        end
      end

     4'b0111 : begin // Equal comparison
      ALU_Result = ( A_in == B_in) ? 32'd1:32'd0;
       if(ALU_Result == 32'd1)begin
        branchCond = 1'b1;
        end
        else if(ALU_Result == 32'd0)begin
        branchCond = 1'b0;
       end
       end

     default : ALU_Result = A_in;
    endcase
   end

 endmodule
