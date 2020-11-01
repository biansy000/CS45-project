`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/01 20:57:26
// Design Name: 
// Module Name: NeedFlush
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


module NeedFlush(
    input [5:0] opcode, 
    input [5:0] funct,
    input zero, 
    output flush
    );
    
    reg Flush;
    
    always@ (opcode or zero or funct)
    begin
        if(opcode == 6'b000010 || opcode == 6'b000011) //jump, jal
            Flush = 1;
        else if(opcode == 6'b000000 && funct == 6'b001000)  //jr
            Flush = 1;
        else if(opcode == 6'b000100 && zero == 1)   //beq
            Flush = 1;
        else if(opcode == 6'b000101 && zero == 0)   //bne
            Flush = 1;
        else Flush = 0;
    end
    
    assign flush = Flush;
endmodule
