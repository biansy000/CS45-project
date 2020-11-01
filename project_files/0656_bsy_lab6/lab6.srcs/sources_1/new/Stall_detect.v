module Stall_detect(
        input CLK,
        input [5:0] OpCode,
        input [5:0] funct,
        input [4:0] readReg1,
        input [4:0] readReg2,
        input needWrite,
        input isLoad,
        input [4:0] LoadReg,
        output Stall
    );
    
    reg stall;
    
    always@ (OpCode or readReg1 or readReg2 or isLoad or LoadReg or needWrite)
    begin
        if(isLoad == 1)
        begin
            if(OpCode == 6'b000000) 
            // current is R type, and previous is LW
            begin
                if(readReg1 == LoadReg || readReg2 == LoadReg)
                    stall = 1;
            end
            else if(OpCode != 6'b000010)
            // all other instruction except jump type
            begin
                if(readReg1 == LoadReg)
                    stall = 1;
            end
        end
        else if(OpCode == 6'b000000 && funct == 6'b001000 && needWrite)
        //jr, need to get register result at ID stage
        begin
            if(readReg1 == LoadReg)
                    stall = 1;
        end
        else if((OpCode == 6'b000100 || OpCode == 6'b000101) && needWrite)
        //branch, need to get register result at ID stage
        begin
            if(readReg1 == LoadReg)
                    stall = 1;
            else if(readReg2 == LoadReg)
                    stall = 1;
        end
        else stall = 0;
        
        if(needWrite != 1) stall = 0;
    end
    
    assign Stall = stall;
    
endmodule