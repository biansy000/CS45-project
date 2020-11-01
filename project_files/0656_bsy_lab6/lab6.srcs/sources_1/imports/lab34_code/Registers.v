`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/03 10:40:55
// Design Name: 
// Module Name: Registers
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


module Registers(
    input reset,
    input Clk,
    input [25:21] readReg1,
    input [20:16] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    input regWrite,
    output [31:0] readData1,
    output [31:0] readData2
    );
    
    reg [31:0] regFile[31:0];
    reg [31:0] ReadData1;
    reg [31:0] ReadData2;
    integer i;
    
    initial begin
	$readmemb("reg.txt",regFile,0);
	ReadData1=0;
	ReadData2=0;
	end
    
    always @(readReg1 or readReg2 or writeReg or regWrite or writeData or reset)
        begin 
            ReadData1 = regFile[readReg1];
            ReadData2 = regFile[readReg2];
        end
    always @ (negedge Clk)
        begin
            if(reset)
                begin
                for(i=0;i<31;i=i+1)
                    regFile[i] = 32'h0000_0000;
                end
            else if(regWrite)
                regFile[writeReg] = writeData;
        end
    
    assign readData1 = ReadData1;
    assign readData2 = ReadData2;
endmodule
