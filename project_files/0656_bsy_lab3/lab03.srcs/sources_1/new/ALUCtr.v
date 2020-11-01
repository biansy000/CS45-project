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
    input [1:0] ALUop,
    input [5:0] Funct,
    output [3:0] ALUCtrOut
    );
    
    reg[3:0] aLUCtrOut;
    
    always @ (ALUop or Funct)
    begin
        casex ({ALUop, Funct})
            8'b00xxxxxx : aLUCtrOut = 4'b0010;
            8'b01xxxxxx : aLUCtrOut = 4'b0110;
            8'b1xxx0000 : aLUCtrOut = 4'b0010;
            8'b1xxx0010 : aLUCtrOut = 4'b0110;
            8'b1xxx0100 : aLUCtrOut = 4'b0000;
            8'b1xxx0101 : aLUCtrOut = 4'b0001;
            default: aLUCtrOut = 4'b0111;
        endcase
    end
    assign ALUCtrOut = aLUCtrOut;
endmodule
