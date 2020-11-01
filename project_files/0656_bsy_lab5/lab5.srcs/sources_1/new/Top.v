`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/06 14:49:09
// Design Name: 
// Module Name: Top
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


module Top(
    //input [31:0] INST,
    input RESET,
    input CLK
);
    wire REG_DST, JUMP, BRANCH, MEM_READ, MEM_TO_REG, MEM_WRITE;
    wire [3:0] ALU_OP;
    wire ALU_SRC, REG_WRITE, ZERO, IS_SHIFT;
        

    wire [3:0] ALU_CTR_OUT;
    wire [31:0] INPUT1;
    wire [31:0] INPUT2; 
    wire [31:0] ALU_RES;
    wire [31:0] WRITE_DATA_REG;
    wire [31:0] WRITE_DATA_MEM;
    wire [31:0] READ_DATA1;
    wire [31:0] READ_DATA2;
    wire [31:0] ADDRESS;
    wire [31:0] READ_DATA;
    wire [31:0] EXT_DATA;
    wire [4:0] DST_REGISTER;
    wire [31:0] INST;
    wire [31:0] JUMP_ADDRESS;
    wire [31:0] Branch_res;
    wire [31:0] PC_NEW0;
    wire [31:0] PC_NEW;
    wire [4:0] shamt;
    wire [31:0] PC_4;
    wire [4:0] DST_REGISTER0;
    wire [31:0] WRITE_DATA_REG0;
    reg [31:0] PC;


    reg [31:0] inst_memory [0:31];
    initial begin
    $readmemb("mem_inst.txt", inst_memory ,0);
    end

    initial begin
    PC <= 0;
    end

    always@ (posedge CLK)  
    begin
    if(RESET==1)
        PC<=0;
    else
        PC<=PC_NEW;
    end

    assign INST= inst_memory[PC>>2];
    assign shamt = INST[10:6];
    
    Ctr mainCtr(
        .OpCode(INST[31:26]),
        .regDst(REG_DST),
        .aluSrc(ALU_SRC),
        .memToReg(MEM_TO_REG),
        .regWrite(REG_WRITE),
        .memRead(MEM_READ),
        .memWrite(MEM_WRITE),
        .branch(BRANCH),
        .aluOp(ALU_OP),
        .jump(JUMP)
    );
    
    assign DST_REGISTER0 = (REG_DST == 1) ? INST[15:11] : INST[20:16];
    assign DST_REGISTER = (INST[31:26] == 6'b000011) ? 31 : DST_REGISTER0;     //jal
    assign WRITE_DATA_REG0 = (MEM_TO_REG == 0)? ALU_RES : READ_DATA;
    assign WRITE_DATA_REG = (INST[31:26] == 6'b000011) ? PC : WRITE_DATA_REG0; //jal
    
    IsShift isShift(.opcode(INST[31:26]), .funct(INST[5:0]), .shift(IS_SHIFT));
    
    Registers registers(
        .Clk(CLK),
        .readReg1(INST[25:21]),
        .readReg2(INST[20:16]),
        .writeReg(DST_REGISTER),
        .writeData(WRITE_DATA_REG),
        .regWrite(REG_WRITE),
        .readData1(READ_DATA1),
        .readData2(READ_DATA2)
    );
    
    signext se(
        .inst(INST[15:0]),
        .data(EXT_DATA)
    );
    
    assign INPUT1 = (IS_SHIFT==0) ? READ_DATA1 : shamt;
    assign INPUT2 = (ALU_SRC==1) ? EXT_DATA : READ_DATA2;

    ALUCtr aluCtr(
        .ALUop(ALU_OP),
        .Funct(INST[5:0]),
        .ALUCtrOut(ALU_CTR_OUT)
    );
    
    ALU alu(
        .input1(INPUT1),
        .input2(INPUT2),
        .aluCtr(ALU_CTR_OUT),
        .zero(ZERO),
        .aluRes(ALU_RES)
    );
    
    assign ADDRESS = ALU_RES;    // data address
    
    dataMemory dataMemory(
        .Clk(CLK),
        .address(ADDRESS),
        .writeData(WRITE_DATA_MEM),
        .memWrite(MEM_WRITE),
        .memRead(MEM_READ),
        .readData(READ_DATA)
    );

    assign WRITE_DATA_MEM = READ_DATA2;
    
    assign PC_4 = PC + 4;
    assign JUMP_ADDRESS = {PC_4[31:28],INST[25:0]<<2};
    assign Branch_res =(BRANCH & ZERO) ? (EXT_DATA<<2)+PC_4 : PC_4; // whether Branch is taken
    assign PC_NEW0 = JUMP ? JUMP_ADDRESS : Branch_res;              // whether it is a jump inst
    assign PC_NEW = ({INST[31:26], INST[5:0]} == 12'b000000_001000) ? READ_DATA1 : PC_NEW0; // for jr inst       
    
endmodule
