`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/03 11:54:18
// Design Name: 
// Module Name: Registers_tb
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


module Registers_tb(  );
    reg Clk;
    reg [25:21] readReg1;
    reg [20:16] readReg2;
    reg [4:0] writeReg;
    reg [31:0] writeData;
    reg regWrite;
    wire [31:0] readData1;
    wire [31:0] readData2;
    
    Registers u0(
        .Clk(Clk),
        .readReg1(readReg1),
        .readReg2(readReg2),
        .writeReg(writeReg),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2)
    );
    
    parameter PERIOD = 10;
    always #(PERIOD) Clk = !Clk;
    
    initial begin
        //initialize inputs
        Clk = 0;
        readReg1 = 5'b00000;
        readReg2 = 5'b00000;
        regWrite = 1'b0;
        writeReg = 5'b00000;
        writeData = 32'h0000_0000;
        
        //current time: 285ns
        #285;
        regWrite = 1'b1;
        writeReg = 5'b10101;
        writeData = 32'hffff_0000;
        
        //current time: 485ns
        #200;
        writeReg = 5'b01010;
        writeData = 32'h0000_ffff;
        
        #200;
        regWrite = 1'b0;
        writeReg = 5'b00000;
        writeData = 32'h0000_0000;
        
       // Current time:735ns
       #50;
       readReg1 = 5'b10101;
       readReg2 = 5'b01010;
       
   end
        
endmodule
