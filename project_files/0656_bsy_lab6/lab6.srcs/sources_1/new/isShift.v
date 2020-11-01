`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/01 11:04:22
// Design Name: 
// Module Name: isShift
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


module IsShift(
    input [5:0] opcode,
    input [5:0] funct,
    output reg shift
    );

    always @ (funct or opcode) begin
        if(opcode == 5'b00000)
        begin
        case (funct)
            6'h02: shift = 1;
            6'h03: shift = 1;
            6'h00: shift = 1;
            default: shift = 0;
        endcase
        end
        else shift = 0;
    end

endmodule
