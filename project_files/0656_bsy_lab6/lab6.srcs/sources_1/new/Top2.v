`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 17:25:31
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
    input CLK,
    input Reset
    );

    reg [31:0] PC;              // PC
    reg [31:0] INST;            // The inst at IF stage
    reg [31:0] mem_inst[31:0];  
    reg [31:0] Inst_ID;         // The inst at ID stage 

    // pipeline registers
    //For example, the variable ended by xxx_IDEX means it is the pipeline register between ID and EX stage
    reg MemRead_IDEX, MemWrite_IDEX, MemtoReg_IDEX, RegWrite_IDEX, ALUSrc_IDEX, isShift_IDEX;
    reg [3:0] ALUCtrOut_IDEX;
    reg [31:0] ReadData1_EX;
    reg [31:0] ReadData2_EX;
    reg [31:0] Ext_data_IDEX;
    reg [4:0] DstReg_IDEX;
    reg [4:0] shamt_IDEX;
    reg [4:0] Reg_rs_EX;
    reg [4:0] Reg_rt_EX;

    reg MemRead_EXMEM, MemWrite_EXMEM, MemtoReg_EXMEM, RegWrite_EXMEM;
    reg [31:0] ReadData2_EXMEM;
    reg [31:0] ALURes_EXMEM;
    reg Zero_EXMEM;
    reg [4:0] DstReg_EXMEM;

    reg MemtoReg_MEMWB;
    reg RegWrite_MEMWB;
    reg [4:0] DstReg_MEMWB;
    reg [31:0] ALURes_MEMWB;
    reg [31:0] ReadData_MEMWB;
    
    // Those pipeline registers are only used by jal instruction
    reg [31:0] PC_IFID;
    reg [31:0] PC_IDEX;
    reg [31:0] PC_EXMEM;
    reg [31:0] PC_MEMWB;
    reg Jal_IDEX, Jal_EXMEM, Jal_MEMWB;
    

    //Initialize
    initial begin
        $readmemb("mem_inst.txt", mem_inst ,0);
        PC <= 0;
        INST = 0;
    end
    


    //IF STAGE
    wire [31:0] JUMP_ADDRESS;
    wire [31:0] Branch_res;
    wire [31:0] Branch_res0;
    wire [31:0] PC_4;
    wire [31:0] PC_NEW0;
    wire [31:0] PC_NEW;
    wire STALL, FLUSH;
    
    always@ (posedge CLK)  
    begin
        if(Reset)
            PC<=0;
        else
            if(!STALL && !FLUSH)
                PC <= PC_NEW; 
            else PC <= PC_4; 
        INST <= mem_inst[PC>>2];
    end


    always@ (posedge CLK)  
    begin
        if(FLUSH)
            Inst_ID <= 0; // If need flush, do not update ID!
        else if(!STALL) begin
            Inst_ID <= INST;
            PC_IFID <= PC;
        end
        // If stall, do not update PC
    end



    //ID STAGE
    wire REG_DST, JUMP, MEM_READ, MEM_TO_REG, MEM_WRITE, ALU_SRC, REG_WRITE_ID, 
            REG_WRITE, IS_SHIFT;
    wire [1:0] BRANCH; //10 -> beq, 11 -> bne

    wire [3:0] ALU_OP;
    wire [3:0] ALU_CTR_OUT;
    wire [31:0] READ_DATA1;
    wire [31:0] READ_DATA2;
    wire [31:0] EXT_DATA;
    wire [4:0] WRITE_REG;
    wire [31:0] WRITE_DATA_REG;
    wire [31:0] WRITE_DATA_REG0;

    Ctr mainCtr(
        .OpCode(Inst_ID[31:26]),
        .regDst(REG_DST),
        .aluSrc(ALU_SRC),
        .memToReg(MEM_TO_REG),
        .regWrite(REG_WRITE_ID),
        .memRead(MEM_READ),
        .memWrite(MEM_WRITE),
        .branch(BRANCH),
        .aluOp(ALU_OP),
        .jump(JUMP)
    );
    
    Registers registers(
        .Clk(CLK),
        .readReg1(Inst_ID[25:21]),
        .readReg2(Inst_ID[20:16]),
        .writeReg(WRITE_REG),    
        .writeData(WRITE_DATA_REG),          
        .regWrite(REG_WRITE),
        .readData1(READ_DATA1),
        .readData2(READ_DATA2)
    );

    signext se(
        .inst(Inst_ID[15:0]),
        .data(EXT_DATA)
    );

    ALUCtr aluCtr(
        .ALUop(ALU_OP),
        .Funct(Inst_ID[5:0]),
        .ALUCtrOut(ALU_CTR_OUT)
    );

    wire IS_LOAD = MemtoReg_IDEX & RegWrite_IDEX; //whether it is a load instruction

    Stall_detect stalldetect(
        .CLK(CLK),
        .OpCode(Inst_ID[31:26]),
        .funct(Inst_ID[5:0]),
        .readReg1(Inst_ID[25:21]),
        .readReg2(Inst_ID[20:16]),
        .needWrite(RegWrite_IDEX),
        .isLoad(IS_LOAD),
        .LoadReg(DstReg_IDEX),
        .Stall(STALL)
    );

    wire [31:0] INPUT1;
    wire [31:0] INPUT2; 
    wire ZERO, ZERO1, JAL;

    IsShift isShift(.opcode(Inst_ID[31:26]), .funct(Inst_ID[5:0]), .shift(IS_SHIFT)); // whether it is a shift instruction and needs shamt
    assign ZERO1 = READ_DATA1==READ_DATA2 ? 1:0;         // whether rs = rt
    assign JAL = (Inst_ID[31:26] == 6'b000011) ? 1:0;   // whether it is a JAL instruction

    assign PC_4 = PC+4;
    assign JUMP_ADDRESS = {PC_4[31:28],Inst_ID[25:0]<<2};
    assign Branch_res0 =(BRANCH == 2'b10 & ZERO1) ? (EXT_DATA<<2)+PC_4 : PC_4;       // whether beq is taken
    assign Branch_res =(BRANCH == 2'b11 & !ZERO1) ? (EXT_DATA<<2)+PC_4 : Branch_res0;// whether bne is taken
    assign PC_NEW0 = JUMP ? JUMP_ADDRESS : Branch_res;                              // whether it is a jump inst
    assign PC_NEW = ({Inst_ID[31:26], Inst_ID[5:0]} == 12'b000000_001000) ? READ_DATA1 : PC_NEW0; // for jr inst

    NeedFlush needflush(
        .opcode(Inst_ID[31:26]), 
        .funct(Inst_ID[5:0]),
        .zero(ZERO1),
        .flush(FLUSH)
    );

    always@ (posedge CLK)  
    begin
        // Update of IDEX registers
        if(STALL == 0)
        begin
            MemRead_IDEX <= MEM_READ;
            MemWrite_IDEX <= MEM_WRITE;
            MemtoReg_IDEX <= MEM_TO_REG;
            RegWrite_IDEX <= REG_WRITE_ID;
            DstReg_IDEX <= REG_DST ? Inst_ID[15:11] : Inst_ID[20:16]; // Rt : Rd
            ReadData1_EX <= READ_DATA1;
            ReadData2_EX <= READ_DATA2;
            ALUSrc_IDEX <= ALU_SRC;
            Reg_rs_EX <= Inst_ID[25:21];
            Reg_rt_EX <= Inst_ID[20:16];
            isShift_IDEX <= IS_SHIFT;
            shamt_IDEX <= Inst_ID[10:6];

            Ext_data_IDEX <= EXT_DATA;
            ALUCtrOut_IDEX <= ALU_CTR_OUT;
            Jal_IDEX <= JAL;
            PC_IDEX <= PC_IFID;
        end
        
        else begin
            RegWrite_IDEX <= 0;
            MemtoReg_IDEX <= 0;
            MemWrite_IDEX <= 0;
            isShift_IDEX <= 0;
            Jal_IDEX <= 0;
        end
        
    end

    // FORWARD!
    always@*
    begin
        if(Reg_rs_EX == DstReg_EXMEM && RegWrite_EXMEM == 1 && MemtoReg_EXMEM == 0) // R type or immediate, EX-MEM
            ReadData1_EX = ALURes_EXMEM;
        else if(Reg_rt_EX == DstReg_EXMEM && RegWrite_EXMEM == 1 && MemtoReg_EXMEM == 0)
            ReadData2_EX = ALURes_EXMEM;
        else if(Reg_rs_EX == DstReg_MEMWB && RegWrite_MEMWB == 1 && MemtoReg_MEMWB == 0) // R type or immediate, MEM-WB
            ReadData1_EX = ALURes_MEMWB;
        else if(Reg_rt_EX == DstReg_MEMWB && RegWrite_MEMWB == 1 && MemtoReg_MEMWB == 0)
            ReadData2_EX <= ALURes_MEMWB;
        else if(Reg_rs_EX == DstReg_MEMWB && RegWrite_MEMWB == 1 && MemtoReg_MEMWB == 1) //load, MEM-WB
            ReadData1_EX = ReadData_MEMWB;
        else if(Reg_rt_EX == DstReg_MEMWB && RegWrite_MEMWB == 1 && MemtoReg_MEMWB == 1) 
            ReadData2_EX = ReadData_MEMWB;
    end



    //EX STAGE
    wire [31:0] ALU_RES;

    assign INPUT1 = (isShift_IDEX == 0) ? ReadData1_EX : shamt_IDEX;
    assign INPUT2 = (ALUSrc_IDEX == 1)? Ext_data_IDEX : ReadData2_EX;

    ALU alu(
        .input1(INPUT1),
        .input2(INPUT2),
        .aluCtr(ALUCtrOut_IDEX),
        .zero(ZERO),
        .aluRes(ALU_RES)
    );

    always@ (posedge CLK)  
    begin
        // Update of EXMEM registers
        MemRead_EXMEM <= MemRead_IDEX;
        MemWrite_EXMEM <= MemWrite_IDEX;
        MemtoReg_EXMEM <= MemtoReg_IDEX;
        RegWrite_EXMEM <= RegWrite_IDEX;
        ReadData2_EXMEM <= ReadData2_EX;
        ALURes_EXMEM <= ALU_RES;
        Zero_EXMEM <= ZERO;
        Jal_EXMEM <= Jal_IDEX;
        DstReg_EXMEM <= DstReg_IDEX;
        PC_EXMEM <= PC_IDEX;
    end



    //MEM STAGE
    wire [31:0] READ_DATA;
    dataMemory dataMemory(
        .Clk(CLK),
        .address(ALURes_EXMEM),
        .writeData(ReadData2_EXMEM),
        .memWrite(MemWrite_EXMEM),
        .memRead(MemRead_EXMEM),
        .readData(READ_DATA)
    );

    always@ (posedge CLK)  
    begin
        // Update of MEMWB registers
        MemtoReg_MEMWB <= MemtoReg_EXMEM;
        RegWrite_MEMWB <= RegWrite_EXMEM;
        ALURes_MEMWB <= ALURes_EXMEM;
        ReadData_MEMWB <= READ_DATA;
        DstReg_MEMWB <= DstReg_EXMEM;
        Jal_MEMWB <= Jal_EXMEM;
        PC_MEMWB <= PC_EXMEM;
    end


    //WB
    assign WRITE_DATA_REG0 = MemtoReg_MEMWB? ReadData_MEMWB : ALURes_MEMWB;
    assign WRITE_DATA_REG = Jal_MEMWB? PC_MEMWB : WRITE_DATA_REG0;  //jal
    assign REG_WRITE = RegWrite_MEMWB;
    assign WRITE_REG = Jal_MEMWB? 31 : DstReg_MEMWB;                //jal

    
    always @ (CLK)
    begin
        if(Reset)
        begin
            //If Reset
            PC <= 0;
            Inst_ID <= 0;
            INST <= 0;
            MemRead_IDEX <= 0; MemWrite_IDEX <= 0; 
            MemtoReg_IDEX <= 0; RegWrite_IDEX <= 0; ALUSrc_IDEX <= 0;
            Ext_data_IDEX <= 0;
            DstReg_IDEX <= 0;
            shamt_IDEX <= 0;
            Reg_rs_EX <= 0;
            Reg_rt_EX <= 0;
            Jal_IDEX <= 0;

            MemRead_EXMEM <= 0; MemWrite_EXMEM <= 0; MemtoReg_EXMEM <= 0; 
            RegWrite_EXMEM <= 0; Jal_EXMEM <= 0;

            MemtoReg_MEMWB <= 0; RegWrite_MEMWB <= 0; Jal_MEMWB <= 0;

            ReadData_MEMWB <= 0; ALURes_MEMWB <= 0; DstReg_MEMWB <= 0;
        end
    end

endmodule
