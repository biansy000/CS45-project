`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 17:25:51
// Design Name: 
// Module Name: Top_tb
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


module Top_tb();
    reg clk, reset;
    always #20 clk = !clk;

    Top top(.CLK(clk), .Reset(reset));
    
    initial begin
        clk = 1;
        reset = 1;

        #40 reset = 0;
        
        #1450 reset = 1;
    end
endmodule
