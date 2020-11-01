`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 08:32:05
// Design Name: 
// Module Name: ALUCtr_tb
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


module ALUCtr_tb( );
    
    reg[1:0] ALUop;
    reg[5:0] Funct;
    wire[3:0] ALUCtrOut;
    
    ALUCtr u0(
       .ALUop(ALUop),
       .Funct(Funct),
       .ALUCtrOut(ALUCtrOut)
    );
    
    initial begin
    // Initialize inputs
    ALUop = 0;
    Funct = 0;
    
    //wait 100ns
    #50
    
    #50
    ALUop = 2'b00;
    
    #50
    ALUop = 2'bx1;
    
    #50
    ALUop = 2'b1x;
    Funct = 6'bxx0000;
    
    #50 
    ALUop = 2'b1x;
    Funct = 6'bxx0000;
    
    #50 
    ALUop = 2'b1x;
    Funct = 6'bxx0010;
    
    #50 
    ALUop = 2'b1x;
    Funct = 6'bxx0100;
    
    #50 
    ALUop = 2'b1x;
    Funct = 6'bxx0101;
    
    #50 
    ALUop = 2'b1x;
    Funct = 6'bxx1010;
    
    end
endmodule
