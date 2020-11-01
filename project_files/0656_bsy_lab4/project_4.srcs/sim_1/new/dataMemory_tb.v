`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 11:31:19
// Design Name: 
// Module Name: dataMemory_tb
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


module dataMemory_tb( );
    reg Clk;
    reg [31:0] address;
    reg [31:0] writeData;
    reg memWrite;
    reg memRead;
    wire [31:0] readData;
    
    dataMemory u0(
        .Clk(Clk),
        .address(address),
        .writeData(writeData),
        .memWrite(memWrite),
        .memRead(memRead),
        .readData(readData)
    );
    
    parameter PERIOD = 10;
    always #(PERIOD) Clk = !Clk;
    
    initial begin
        //initialize inputs
        Clk = 0;
        address = 0;
        memWrite = 1'b0;
        memRead = 1'b0;
        writeData = 32'h0000_0000;
        address = 32'h0000_0000;

        #185;
        memWrite = 1'b1;
        address = 32'h0000_0007;
        writeData = 32'he000_0000;
        

        #100;
        memWrite = 1'b1;
        writeData = 32'hffff_ffff;
        address = 32'h0000_0006;
        
        #185
        memRead = 1'b1;
        memWrite = 1'b0;
        // ------------
        
        #80;
        memRead = 1'b0;
        memWrite = 1'b1;
        address = 8;
        writeData = 32'haaaaaaaa;
        
        #80;
        memWrite = 1'b0;
        memRead = 1'b1;
        // ----------------
       
   end
endmodule
