`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 08:16:19
// Design Name: 
// Module Name: ALU_tb
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


module ALUCtr(
    input [3:0] ALUop,
    input [5:0] Funct,
    output [3:0] ALUCtrOut
    );
    
    reg[3:0] aLUCtrOut;
    
    always @ (ALUop or Funct)
    begin
        casex ({ALUop, Funct})
            10'b0000xxxxxx : aLUCtrOut = 4'b0010; //add
            10'b0001xxxxxx : aLUCtrOut = 4'b0011; //sub
            10'b0010xxxxxx : aLUCtrOut = 4'b0000; //and
            10'b0011xxxxxx : aLUCtrOut = 4'b0001; //or
            10'b0100xxxxxx : aLUCtrOut = 4'b0110; //xor
            10'b0101xxxxxx : aLUCtrOut = 4'b0111; //slt
            
            10'b1xxx100000 : aLUCtrOut = 4'b0010; //add
            10'b1xxx100001 : aLUCtrOut = 4'b0010; //addu
            10'b1xxx100010 : aLUCtrOut = 4'b0011; //sub
            10'b1xxx100011 : aLUCtrOut = 4'b0011; //subu
            10'b1xxx100100 : aLUCtrOut = 4'b0000; //and
            10'b1xxx100101 : aLUCtrOut = 4'b0001; //or
            10'b1xxx000000 : aLUCtrOut = 4'b0100; //sll
            10'b1xxx000010 : aLUCtrOut = 4'b0101; // srl
            10'b1xxx000100 : aLUCtrOut = 4'b0100; // sllv
            10'b1xxx000110 : aLUCtrOut = 4'b0101; // srlv
            10'b1xxx100110 : aLUCtrOut = 4'b0110; // xor
            10'b1xxx100111 : aLUCtrOut = 4'b1000; // nor
            default: aLUCtrOut = 4'b0111; //slt + sltu
        endcase
    end
    assign ALUCtrOut = aLUCtrOut;
endmodule
