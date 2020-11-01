`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/06 11:08:10
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
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] aluCtr,
    output zero,
    output [31:0] aluRes
    );
    
    reg Zero;
    reg [31:0] AluRes;
    
    always @(input1 or input2 or aluCtr)
    begin
        if(aluCtr == 4'b0000) // and
            AluRes = input1 & input2;
        else if(aluCtr == 4'b0001) // or
            AluRes = input1|input2;
        else if(aluCtr == 4'b0010) //add
            AluRes = input1 + input2;
        else if(aluCtr == 4'b0011) // sub
            AluRes = input1 - input2;
        else if(aluCtr == 4'b0100) //shift left
            AluRes = input2 <<< input1;
        else if(aluCtr == 4'b0101) //shift right
            AluRes = input2 >>> input1;
        else if(aluCtr == 4'b0110) //xor
            AluRes = input2 ^ input1;
        else if(aluCtr == 4'b1000) //nor
            AluRes = ~(input2 | input1);
        else // set on less than
            AluRes = input1 < input2 ? 1 : 0;
            
        if(AluRes == 0)
            Zero = 1;
        else 
            Zero = 0;
    end
    
    assign aluRes = AluRes;
    assign zero = Zero;
    
endmodule
