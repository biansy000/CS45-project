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
        Zero = 0;
        if(aluCtr == 4'b0000) // and
            AluRes = input1 & input2;
        else if(aluCtr == 4'b0001) // or
            AluRes = input1|input2;
        else if(aluCtr == 4'b0010) //add
            AluRes = input1 + input2;
        else if(aluCtr == 4'b0110) // sub
        begin
            AluRes = input1 - input2;
            if(AluRes == 0)
                Zero = 1;
            else 
                Zero = 0;
        end
        else if(aluCtr == 4'b0111) // set on less than
            AluRes = input1 - input2;
        else if(aluCtr == 4'b1100)
        begin
            AluRes = ~(input1 | input2);
            if(AluRes == 0)
                Zero = 1;
            else 
                Zero = 0;
        end
    end
    
    assign aluRes = AluRes;
    assign zero = Zero;
    
endmodule
