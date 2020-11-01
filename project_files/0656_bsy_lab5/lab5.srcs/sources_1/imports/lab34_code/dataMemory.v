`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 11:26:49
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
    input Clk,
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output [31:0] readData
    );
    
    reg [31:0] memFile[31:0];
    reg [31:0] ReadData;
    
    initial begin
	$readmemb("data_mem.txt",memFile,0);
	ReadData = 0;
	end
	
    always @(address or memRead or memWrite)
        begin
        if(memRead) 
            ReadData = memFile[address];
        end
    always @ (negedge Clk)
        begin
            if(memWrite)
                memFile[address] = writeData;
        end
    
    assign readData = ReadData;
endmodule
