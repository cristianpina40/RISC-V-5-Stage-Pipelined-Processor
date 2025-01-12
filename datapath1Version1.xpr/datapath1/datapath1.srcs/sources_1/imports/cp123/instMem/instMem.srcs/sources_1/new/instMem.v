`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 01:58:26 PM
// Design Name: 
// Module Name: instMem
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


module instMem(A, RD);
input [7:0]A;
output reg [31:0]RD;

reg [31:0]memory[127:0];

initial begin


memory[0] = 32'h01910113; //begin : addi x2, x2, 25
memory[4] = 32'h01418193; //        addi x3, x3, 20
memory[8] = 32'h00A11213; //        subi x4, x2, 10
memory[12] = 32'h0191A293;//        multi x5, x3, 25
memory[16] = 32'h00518023; //       sw x5, 0(x3)
memory[20] = 32'h00018383; //       lw x7, 0(x3)
memory[24] = 32'h0001076F; //       jal x14, next (next = address 40, program saved at x14)
memory[28] = 32'h605385B3; //back : mul x11, x5, x7
memory[32] = 32'h0052C633;//        not x12, x5, x5
memory[36] = 32'h00B5A863;//        blte x11, x11 end   (end = address 52)
memory[40] = 32'h00250433;// next :  add x8, x2, x10
memory[44] = 32'h404284B3;//        sub x9, x5, x4
memory[48] = 32'hFE240663;//        beq x2, x8, back    (address 28 held in x14)
memory[52] = 32'hFC329663;// end  :  blt x3, x5, begin   (address 0 not taken)
memory[56] = 32'h0072F6B3;//        and x13, x5, x7
memory[60] = 32'h00226433;//        or x8, x2, x4
memory[64] = 32'h00219533;//        xor x10, x3, x2
memory[68] = 32'h40B384B3;//        sub x9, x7, x11 




//memory[72] = 32'h60B581B3;//      mul x3, x11, x11

/*memory[0] = 32'h00007033; // and r0, r0, r0 32'h00000000
memory[1] = 32'h00100093; // addi r1, r0, 1 32'h00000001
memory[2] = 32'h00200113; // addi r2, r0, 2 32'h00000002
memory[3] = 32'h00308193; // addi r3, r1, 3 32'h00000004
memory[4] = 32'h00408213; // addi r4, r1, 4 32'h00000005
memory[5] = 32'h00510293; // addi r5, r2, 5 32'h00000007
memory[6] = 32'h00610313; // addi r6, r2, 6 32'h00000008
memory[7] = 32'h00718393; // addi r7, r3, 7 32'h0000000B
memory[8] = 32'h00208433; // add r8, r1, r2 32'h00000003
memory[9] = 32'h404404b3; // sub r9, r8, r4 32'hfffffffe
memory[10] = 32'h00317533; // and r10, r2, r3 32'h00000000
memory[11] = 32'h0041e5b3; // or r11, r3, r4 32'h00000005
memory[12] = 32'h0041a633; // if r3 is less than r4 then r12 = 1 32'h00000001
memory[13] = 32'h007346b3; // nor r13, r6, r7 32'hfffffff4
memory[14] = 32'h4d34f713; // andi r14, r9, "4D3" 32'h000004D2
memory[15] = 32'h8d35e793; // ori r15, r11, "8d3" 32'hfffff8d7
memory[16] = 32'h4d26a813; // if r13 is less than 32'h000004D2 then r16 = 1 32'h00000000
memory[17] = 32'h4d244893; // nori r17, r8, "4D2" 32'hfffffb2C
memory[18] = 32'h02b02823; // sw r11, 48(r0) alu result = 32'h00000030
memory[19] = 32'h03002603; // lw r12, 48(r0) alu result = 32'h00000030 , r12 = 32'h00000005
*/
end

always@(A)begin

RD <= memory[A];

end

endmodule
