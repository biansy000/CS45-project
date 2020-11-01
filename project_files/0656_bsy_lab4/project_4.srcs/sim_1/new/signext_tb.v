`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/06 10:51:11
// Design Name: 
// Module Name: signext_tb
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


module signext_tb();
    reg [15:0] inst;
    wire [31:0] data;
    
    signext u0(
        .inst(inst),
        .data(data)
    );
    
    initial begin
        inst = 16'hff0f;
    
        #200
        inst = 16'h00ff;
        
        #200
        inst = 16'hffff;
        
    end
endmodule
