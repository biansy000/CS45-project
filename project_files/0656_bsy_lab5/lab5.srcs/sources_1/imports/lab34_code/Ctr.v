`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/22 10:28:24
// Design Name: 
// Module Name: Ctr
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


module Ctr(
    input [5:0] OpCode,
    output regDst,
    output aluSrc,
    output memToReg,
    output regWrite,
    output memRead,
    output memWrite,
    output branch,
    output [3:0] aluOp,
    output jump
    );
    
    reg RegDst;
    reg ALUSrc;
    reg MemToReg;
    reg RegWrite;
    reg MemRead;
    reg MemWrite;
    reg Branch;
    reg [3:0] ALUOp;
    reg Jump;
    
    always @ (OpCode)
    begin
        case(OpCode)
        6'b000000:  // R type
        begin
            RegDst = 1;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b1000;
            Jump = 0;
        end
        
        6'b001000:  // addi
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
        end
        
       6'b001001:  // addiu
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
        end
        
        6'b001100:  // andi
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0010;
            Jump = 0;
        end
        
        6'b001101:  // ori
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0011;
            Jump = 0;
        end
        
        6'b001110:  // xori
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0100;
            Jump = 0;
        end
        
        6'b001010:  // slti
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0101;
            Jump = 0;
        end
        
        6'b001011:  // sltiu
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0101;
            Jump = 0;
        end
                
        6'b100011:  // lw
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
        end
        
        6'b101011:  // sw
        begin
            //RegDst = x;
            ALUSrc = 1;
            //MemToReg = x;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
        end
        
        6'b000100:  // beq
        begin
            //RegDst = x;
            ALUSrc = 0;
            //MemToReg = x;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 1;
            ALUOp = 4'b0001;
            Jump = 0;
        end
        
        6'b000010:  // jump
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 1;
        end
        
        6'b000011:  // jal
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 1;
        end
        
        default:
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 4'b0000;
            Jump = 0;
        end
        endcase
    end
    
    assign regDst = RegDst;
    assign aluSrc = ALUSrc;
    assign memToReg = MemToReg;
    assign regWrite = RegWrite;
    assign memRead = MemRead;
    assign memWrite = MemWrite;
    assign branch = Branch;
    assign aluOp = ALUOp;
    assign jump = Jump;
endmodule
