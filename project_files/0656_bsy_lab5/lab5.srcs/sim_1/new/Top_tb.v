`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/12 09:59:59
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


module Top_tb( );
/*    reg [31:0] DataMem[0:127];
    reg [31:0] InstMem[0:127];
    reg [31:0] Reg[0:15];
    reg Clk;

    Top top0(.Clk(Clk));

    parameter PERIOD = 10;
    always #(PERIOD) Clk = !Clk;

    initial
        begin
        $readmemh("mem_data", DataMem);
        $readmemh("mem_inst", InstMem);
    
        end */
    reg Reset;
    reg Clk;

    Top top0(
        .CLK(Clk),
        .RESET(Reset)
        );

    parameter PERIOD = 25;
    always #(PERIOD) Clk = !Clk;

    initial
        begin
        Clk = 0;
		Reset = 0;
		
		#1100
		Reset = 1;
    
        end

endmodule
