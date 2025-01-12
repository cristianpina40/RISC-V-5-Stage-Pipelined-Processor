`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2024 01:19:05 PM
// Design Name: 
// Module Name: datapath1_tb
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


module datapath1_tb();

/** Clock & reset **/
 reg clk , rst ;

always begin
#2
clk = ~clk;
rst = 0;
end

initial begin 
clk = 0;
rst = 1;
end



 /** DUT Instantiation **/
 wire [31:0]ALURes1;
 wire [31:0]ALURes2;
 wire [31:0]ALURes3;
 wire reg_write ;
 wire mem_write ;
 wire [1:0]resultSrc;
 wire ALUSrc;
 wire [1:0] ImmSrc;
 wire [3:0] ALUControl ;
 wire [6:0] opcode ;
 wire [6:0] funct7 ;
 wire [2:0] funct3 ;
 wire [31:0] result ;
 wire branch;
 wire jump;
 wire [1:0]ALUOp;
 wire [31:0]WriteDataIn;
 
wire [7:0]currentAddress;
wire [4:0]RS1E_DB;
wire [4:0]RdW_DB;
wire [4:0]RdM_DB;
wire [1:0]ForwardAE_DB;

datapath1 instant(
 .clk(clk),
 .rst(rst),
 .RegWrite(reg_write),
 .ALUSrc(ALUSrc),
 .ImmSrc(ImmSrc),
 .ResultSrc(resultSrc),
 .mem_write(mem_write),
 .ALUControl(ALUControl),
 .opcode(opcode),
 .funct7(funct7),
 .funct3(funct3),
 .result(result),
 .Jump(jump),
 .Branch(branch),
 .ALURes1(ALURes1),
 .ALURes2(ALURes2),
 .ALURes3(ALURes3),
 .WriteDataIncheck(WriteDataIn),
 .currentAddress(currentAddress),
 .RS1E_DB(RS1E_DB),
 .RdW_DB(RdW_DB),
 .RdM_DB(RdM_DB),
 .ForwardAE_DB(ForwardAE_DB)
 );

 /** Stimulus **/
 wire [6:0] R , LW , SW , I, B, J;


 assign R = 7'b0110011;
 assign LW = 7'b0000011;
 assign SW = 7'b0100011; 
 assign I = 7'b0010011;
 assign B = 7'b1100011;
 assign J = 7'b1101111;
 assign reg_write = (opcode == LW || opcode == R || opcode == I || opcode == J) ? 1'b1 : 1'b0;
 assign mem_write = ( opcode == SW ) ? 1'b1 : 1'b0;
 assign resultSrc[0] = (opcode == LW) ? 1'b1 : 1'b0;
 assign resultSrc[1] = ( opcode == J) ? 1'b1 : 1'b0;
 assign ALUSrc = (opcode == LW || opcode == SW || opcode == I) ? 1'b1 : 1'b0;
 assign branch = (opcode == B) ? 1'b1 : 1'b0;
 assign jump = (opcode == J) ? 1'b1 : 1'b0;
 assign ALUOp[0] = (opcode == B) ? 1'b1 : 1'b0;
 assign ALUOp[1] = (opcode == R  || opcode == I) ? 1'b1 : 1'b0;
 assign ImmSrc[0] = (opcode == SW || opcode == J) ? 1'b1 : 1'b0;
 assign ImmSrc[1] = (opcode == B || opcode == J) ? 1'b1 : 1'b0;
 
 assign ALUControl[3] = (((funct3 == 3'b001) && (ALUOp == 2'b01)  ) || 
                   ( (ALUOp == 2'b10) && (funct3 == 3'b001) && (funct7 == 7'b0000001)) ||
                    ((funct3 == 3'b010) && (ALUOp == 2'b01)  )) ? 1'b1 : 1'b0;
                    
assign ALUControl[2] = ( ((ALUOp == 2'b00) && (funct3 == 3'bx)   ) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b010) ) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b001) ) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b000) ) ||
                   ( (ALUOp == 2'b01) && (funct3 == 3'b000) ) ||
                   (            (ALUOp == 2'b00)            ) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b000) && (funct7 == 7'b0110000)) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b000) && (funct7 == 7'b0100000)) ||  
                   ( (ALUOp == 2'b10) && (funct3 == 3'b000) && (funct7 == 7'b0000000))) ? 1'b1 : 1'b0;
                    
assign ALUControl[1] =  ( ((ALUOp == 2'b10) && (funct3 == 3'b010) ) ||
                   ( (ALUOp == 2'b01) && (funct3 == 3'b000) ) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b001) && (funct7 == 7'b0000001)) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b110) && (funct7 == 7'b0000000)) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b111) && (funct7 == 7'b000000)) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b000) && (funct7 == 7'b0110000))) ? 1'b1 : 1'b0;
                    
assign ALUControl[0] = (( (ALUOp == 2'b01) &&((funct3 == 3'b000) || (funct3 == 3'b010)) ) || 
                   ( (ALUOp == 2'b10) && (funct3 == 3'b000) && (funct7 == 7'b0100000)) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b001) && (funct7 == 7'b0000001)) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b110) && (funct7 == 7'b0000000)) ||
                   ( (ALUOp == 2'b10) && (funct3 == 3'b100) && (funct7 == 7'b0000000)) || 
                   ( (ALUOp == 2'b10) && (funct3 == 3'b001) )) ? 1'b1 : 1'b0;
 
 
 

 initial begin
 #325;
 $finish ;
 end

endmodule
