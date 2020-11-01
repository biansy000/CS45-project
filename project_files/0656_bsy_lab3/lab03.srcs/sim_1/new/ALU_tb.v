`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/06 12:09:34
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


module ALU_tb( );
    reg [31:0] input1;
    reg [31:0] input2;
    reg [3:0] aluCtr;
    wire zero;
    wire [31:0] aluRes;
    
    ALU u0(
        .input1(input1),
        .input2(input2),
        .aluCtr(aluCtr),
        .zero(zero),
        .aluRes(aluRes)
    );
    
    initial begin
    input1 = 32'hff00;
    input2 = 32'hf0f0;
    
    #100
    aluCtr = 4'b0000;
    
    #100
    aluCtr = 4'b0001;
    
    #100
    aluCtr = 4'b0010;
    
    #100
    aluCtr = 4'b0110;
    
    #100
    aluCtr = 4'b0111;
    
    #100
    aluCtr = 4'b1100;
    
    #100
    input1 = 32'hffff;
    input2 = 32'hffff;
    aluCtr = 4'b0110;
    
    end
    
endmodule
