module FSM(input i_Clk,
           input [15:0] ir_out,
           input n_out,
           input z_out,
           input p_out,
           input R_OUT,
           output reg SR2MUX_SEL, 
           output reg ADDR1MUX_SEL,
           output reg [1:0] ADDR2MUX_SEL,
           output reg MARMUX_SEL,
           output reg [1:0] PCMUX_SEL,


           output reg MIO_EN,         // ******************
           output reg RW,             // MEMORY SIGNALs

           output reg [2:0] DR,         // ******************
           output reg LD_REG,           // REGFILE SIGNALs
           output reg [2:0] SR1_SEL,    //
           output reg [2:0] SR2_SEL,    //     

           output reg GateMARMUX, // ******************
           output reg GateALU,    // BUS_DRIVER SIGNALs
           output reg GateMDR,    //
           output reg GatePC,     //
                
           output reg LD_CC,
           output reg LD_IR,
           output reg LD_PC,
           output reg LD_MAR,
           output reg LD_MDR,
                
           output reg [1:0] ALUK,
           output [7:0] CURRENT_STATE_OUT,
           output [7:0] NEXT_STATE_OUT,
           output [7:0] mini_state_out,
           output [7:0] next_mini_state_out
);

    reg [7:0] CURRENT_STATE = 100;
    reg [7:0] NEXT_STATE = 100;
    reg BEN = 0;
    reg [7:0] mini_state = 0;
    reg [7:0] next_mini_state = 0;
    
    assign CURRENT_STATE_OUT = CURRENT_STATE;
    assign NEXT_STATE_OUT = NEXT_STATE;
    assign mini_state_out = mini_state;
    assign next_mini_state_out = next_mini_state;

    always@(*)
        begin
            case(CURRENT_STATE)
            100:
                begin
                if(mini_state == 0)
                    begin
                    // Setting default flags
                    GatePC        = 0;
                    GateMARMUX    = 0; 
                    GateALU       = 0;    
                    GateMDR       = 0;
          
                    LD_PC         = 0;
                    LD_IR         = 0;
                    LD_MAR        = 0;
                    LD_MDR        = 0;
                    LD_REG        = 0;
                    LD_CC         = 0;
                    
                    PCMUX_SEL     = 2'b11;
                    SR2MUX_SEL    = 1;
                    SR1_SEL       = 2'b00;
                    SR2_SEL       = 2'b00;
                    ADDR1MUX_SEL  = 0;
                    ADDR2MUX_SEL  = 2'b00;
                    MARMUX_SEL    = 0;
                    
          
                    DR            = 3'b000;
          
                    ALUK          = 2'b00;
          
                    MIO_EN        = 0;
                    RW            = 0;
                    next_mini_state = 1;
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end
                end
            
            18:
                begin
                // 18 -------------------------------------------------------------------------
                // MAR <- PC
                // PC <- PC + 1
                // set ACV 
                // [INT]
                if(mini_state == 0)
                    begin
                    GatePC = 1; // remeber to reset flag in next cycle
                    next_mini_state = 1;
                    end
                else if(mini_state == 1)
                    begin       
                    //@(posedge i_Clk)
                    GatePC = 0;
                    LD_MAR = 1; // while waiting for the value to be driven on the bus, 
                                // signal the load mar flag (since it takes a cycle to be 'seen' 
                    next_mini_state = 2;
                    end
                else if(mini_state == 2)
                    begin       
                    //@(posedge i_Clk)
                    LD_MAR = 0;
                    LD_PC = 1;
                    PCMUX_SEL = 2'b10;
                    next_mini_state = 3;
                    end  
                else if(mini_state == 3)
                    begin  
                    //@(posedge i_Clk)
                    LD_PC = 0;
                    PCMUX_SEL = 0;
                    next_mini_state = 4;
                    end
                else
                    begin
                    //@(posedge i_Clk);
                    next_mini_state = 0;
                    NEXT_STATE = 33;
                    end
                end
                
            33:
                begin
                // 33  -------------------------------------------------------------------------
                // [ACV]
                next_mini_state = 0;
                NEXT_STATE = 28;
                //@(posedge i_Clk);
                end
                
            28:
                begin
                // 28 (28) ----------------------------------------------------------------------
                // MDR <- M[MAR]
                if(mini_state == 0)
                    begin
                    RW         = 0;
                    MIO_EN     = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 1;
                    end
                else if (!R_OUT)
                    //wait(R_OUT)
                    //@(posedge i_Clk)
                    ;
                else if (mini_state == 1 & R_OUT)
                    begin
                    next_mini_state = 2;
                    end
                else if (mini_state == 2)
                    begin
                    LD_MDR = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 3;
                    end
                else if (mini_state == 3)
                    begin
                    LD_MDR = 0;
                    //@(posedge i_Clk)
                    next_mini_state = 4;
                    end
                else
                    begin
                    MIO_EN = 0;
                    next_mini_state = 0;
                    NEXT_STATE  = 30;
                    end
                end
                
            30:
                begin
                // 30 ---------------------------------------------------------------------------
                // IR <- MDR
                if(mini_state == 0)
                    begin
                    GateMDR = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 1;
                    end
                else if (mini_state == 1)
                    begin
                    GateMDR = 0;
                    LD_IR = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 2;
                    end
                    
                else if (mini_state == 2)
                    begin
                    LD_IR = 0;
                    //@(posedge i_Clk);
                    next_mini_state = 3;
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 32;
                    end
                end
                
            32:
                begin
                // 32 ----------------------------------------------------------------------------
                // BEN <- IR[11] & N | IR[10] & Z | IR[9] & P
                if(mini_state == 0)
                    begin
                        if ((ir_out[11] & n_out) | (ir_out[10] & z_out) | (ir_out[9] & p_out)) BEN = 1;
                        else BEN = 0; 
                        next_mini_state = 1;
                    end
                    //@(posedge i_Clk)
                if(mini_state == 1)
                    begin
                case(ir_out[15:12])
                    4'b0001: // ADD
                        NEXT_STATE = 1;
                    4'b0101: // AND
                        NEXT_STATE = 5;
                    4'b0000: // BR
                        NEXT_STATE = 0;
                    4'b1100: // JMP - RET
                        NEXT_STATE = 12;
                    4'b0100: // JSR - JSRR
                        NEXT_STATE = 4;
                    4'b0010: // LD
                        NEXT_STATE = 2;
                    4'b1010: // LDI
                        NEXT_STATE = 10;
                    4'b0110: // LDR
                        NEXT_STATE = 6;
                    4'b1110: // LEA
                        NEXT_STATE = 14;
                    4'b1001: // NOT
                        NEXT_STATE = 9;
                    4'b1000: // RTI
                        NEXT_STATE = 8;
                    4'b0011: // ST
                        NEXT_STATE = 3;
                    4'b1011: // STI
                        NEXT_STATE = 11;
                    4'b0111: // STR
                        NEXT_STATE = 7;
                    4'b1111: // TRAP
                        NEXT_STATE = 15;
                    4'b1101: // Reserved 
                        NEXT_STATE = 18; // just skip
                endcase  
                next_mini_state = 0;
                //@(posedge i_Clk);
                end
                end
                
            1: // ADD 
                begin
                // DR <- SR1 + OP2* (bit[5] determines if an immediate value is used, 1 means immediate)
                // set CC
                if(mini_state == 0)
                    begin
                    ALUK       = 2'b00;
                    SR1_SEL    = ir_out[8:6];
                    SR2_SEL    = ir_out[2:0];
                    if(ir_out[5] == 0)    SR2MUX_SEL = 1;
                    else                  SR2MUX_SEL = 0;
                    GateALU    = 1;
                    next_mini_state = 1; 
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateALU    = 0;
                    LD_REG     = 1;
                    DR         = ir_out[11:9];
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_CC      = 1;
                    LD_REG     = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk);
                    end
                else if(mini_state == 3)
                    begin
                    LD_CC = 0;
                    next_mini_state = 4;
                    //@(posedge i_Clk);
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end
                end
                
            5: // AND
                begin
                // DR <- SR1 & OP2* (bit[5] determines if an immediate value is used, 1 means immediate)
                // set CC
                if(mini_state == 0)
                    begin
                    ALUK       = 2'b01;
                    SR1_SEL    = ir_out[8:6];
                    SR2_SEL    = ir_out[2:0];
                    if(ir_out[5] == 0)    SR2MUX_SEL = 1;
                    else                  SR2MUX_SEL = 0;
                    GateALU    = 1;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateALU    = 0;
                    LD_REG     = 1;
                    DR         = ir_out[11:9];
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end 
                else if(mini_state == 2)
                    begin    
                    LD_CC      = 1;
                    LD_REG     = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 3)
                    begin
                    LD_CC = 0;
                    next_mini_state = 4;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end
                end
                
            9: // NOT
                begin
                // DR <- SR1 & OP2* (bit[5] determines if an immediate value is used, 1 means immediate)
                // set CC
                if(mini_state == 0)
                    begin
                    ALUK       = 2'b10;
                    SR1_SEL    = ir_out[8:6];
                    GateALU    = 1;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateALU    = 0;
                    LD_REG     = 1;
                    DR         = ir_out[11:9];
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_CC      = 1;
                    LD_REG     = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk);
                    end
                else if(mini_state == 3)
                    begin
                    LD_CC      = 0;
                    next_mini_state = 4;
                    //@(posedge i_Clk)
                    end 
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end
                end
            
            14:// LEA
                begin
                // DR <- PC + offset9
                if(mini_state == 0)
                    begin
                    GateMARMUX = 1;
                    MARMUX_SEL = 1;
                    ADDR1MUX_SEL = 0;
                    ADDR2MUX_SEL = 2'b01;
                    DR <= ir_out[11:9];
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateMARMUX = 0;
                    LD_REG = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_REG <= 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end
                end
              
            2: // LD
                begin
                // MAR <- PC + SEXT[offset9]
                // set ACV
                if(mini_state == 0)
                    begin
                    GateMARMUX = 1;
                    MARMUX_SEL = 1;
                    ADDR1MUX_SEL = 0;
                    ADDR2MUX_SEL = 2'b01;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateMARMUX = 0;
                    LD_MAR = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_MAR = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk);
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 35;
                    end
                end
            
            6: // LDR
                begin
                // MAR <= BaseR + offset9
                // set ACV
                if(mini_state == 0)
                    begin 
                    GateMARMUX = 1;
                    MARMUX_SEL = 1;
                    ADDR1MUX_SEL = 1;
                    ADDR2MUX_SEL = 2'b10;
                    SR1_SEL = ir_out[8:6];
                    next_mini_state = 1;
                    //@(posedge i_Clk);
                    end
                else if(mini_state == 1)
                    begin
                    GateMARMUX = 0;
                    LD_MAR = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk);
                    end
                else if(mini_state == 2)
                    begin
                    LD_MAR = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk);
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE <= 35;
                    end
                end
            
            10:// LDI
                begin
                // MAR <- PC + SEXT[offset9]
                // set ACV
                if(mini_state == 0)
                    begin
                    GateMARMUX = 1;
                    MARMUX_SEL = 1;
                    ADDR1MUX_SEL = 0;
                    ADDR2MUX_SEL = 2'b01;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateMARMUX = 0;
                    LD_MAR = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_MAR = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk);
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 17;
                    end
                end
           
            11:// STI
                begin
                // MAR <- PC + SEXT[offset9]
                // set ACV
                if(mini_state == 0)
                    begin
                    GateMARMUX = 1;
                    MARMUX_SEL = 1;
                    ADDR1MUX_SEL = 0;
                    ADDR2MUX_SEL = 2'b01;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateMARMUX = 0;
                    LD_MAR = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_MAR = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk);
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 19;
                    end
                end
            
            7: // STR
                begin
                // MAR <= BaseR + offset9
                // set ACV
                if(mini_state == 0)
                    begin
                    GateMARMUX = 1;
                    MARMUX_SEL = 1;
                    ADDR1MUX_SEL = 1;
                    ADDR2MUX_SEL = 2'b10;
                    SR1_SEL = ir_out[8:6];
                    next_mini_state = 1;
                    //@(posedge i_Clk);
                    end
                else if(mini_state == 1)
                    begin
                    GateMARMUX = 0;
                    LD_MAR = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk);
                    end
                else if(mini_state == 2)
                    begin
                    LD_MAR = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk);
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 23;
                    end
                end
                
            3: // ST
                begin
                // MAR <- PC + SEXT[offset9]
                // set ACV
                if(mini_state == 0)
                    begin
                    GateMARMUX = 1;
                    MARMUX_SEL = 1;
                    ADDR1MUX_SEL = 0;
                    ADDR2MUX_SEL = 2'b01;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateMARMUX = 0;
                    LD_MAR = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_MAR = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk);
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 23;
                    end
                end
                
            4:// JSR
                begin
                next_mini_state = 0;
                if(ir_out[11]) NEXT_STATE = 21;
                else NEXT_STATE = 20;
                end
                
            12:// JMP
                begin
                // PC <- BaseR
                if(mini_state == 0)
                    begin
                    SR2_SEL = ir_out[11:9];
                    SR2MUX_SEL = 1;
                    ALUK = 2'b11;
                    GateALU = 1;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateALU = 0;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    PCMUX_SEL = 2'b00;
                    LD_PC = 1;
                    next_mini_state = 3;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 3)
                    begin
                    LD_PC = 0;
                    next_mini_state = 4;
                    //@(posedge i_Clk)
                    end
                else
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                end
                
            0: // BR
                begin
                next_mini_state = 0;
                if(BEN)NEXT_STATE = 22;
                else NEXT_STATE = 18;
                //@(posedge i_Clk);
                end
                
            22:
                begin
                // PC <- PC + offset9
                if(mini_state == 0)
                    begin
                    PCMUX_SEL = 2'b01;
                    ADDR1MUX_SEL = 0;
                    ADDR2MUX_SEL = 2'b01;
                    LD_PC = 1;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    LD_PC = 0;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end
                end
                
            20:
                begin
                // R7 <- PC
                // PC <- BaseR
                if(mini_state == 0)
                    begin
                    GatePC = 1;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GatePC = 0;
                    DR = 3'b111;
                    LD_REG = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_REG = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk);
                    end
                else if(mini_state == 3)
                    begin
                    SR2_SEL = ir_out[11:9];
                    SR2MUX_SEL = 1;
                    ALUK = 2'b11;
                    GateALU = 1;
                    next_mini_state = 4;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 4)
                    begin
                    GateALU = 0;
                    next_mini_state = 5;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 5)
                    begin
                    PCMUX_SEL = 2'b00;
                    LD_PC = 1;
                    next_mini_state = 6;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 6)
                    begin
                    LD_PC = 0;
                    next_mini_state = 7;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end
                end
            
            21:
                begin
                // R7 <- PC
                // PC <- PC + offset11
                if(mini_state == 0)
                    begin
                    GatePC = 1;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GatePC = 0;
                    DR = 3'b111;
                    LD_REG = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_REG = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 3)
                    begin
                    LD_PC = 1;
                    PCMUX_SEL = 2'b01;
                    ADDR1MUX_SEL = 0;
                    ADDR2MUX_SEL = 2'b00; 
                    next_mini_state = 4;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 4)
                    begin
                    LD_PC = 0;
                    next_mini_state = 5;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end
                end
                
            19:
                // [ACV]
                begin
                //@(posedge i_Clk)
                next_mini_state = 0;
                NEXT_STATE = 29;
                end
            
            29:
                // MDR <- M[MAR]
                begin
                if(mini_state == 0)
                    begin
                    RW         = 0;
                    MIO_EN     = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 1;
                    end
                else if (!R_OUT)
                    //wait(R_OUT)
                    //@(posedge i_Clk)
                    ;
                else if (mini_state == 1 & R_OUT)
                    begin
                    next_mini_state = 2;
                    end
                else if (mini_state == 2)
                    begin
                    LD_MDR = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 3;
                    end
                else if (mini_state == 3)
                    begin
                    LD_MDR = 0;
                    //@(posedge i_Clk)
                    next_mini_state = 4;
                    end
                else
                    begin
                    MIO_EN = 0;
                    next_mini_state = 0;
                    NEXT_STATE  = 30;
                    end
                end

            31:
                // MAR <- MDR
                // set ACV
                begin
                if(mini_state == 0)
                    begin
                    GateMDR = 1;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateMDR = 0;
                    LD_MAR = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_MAR <= 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 23;
                    end
                end
                
            23:
                // MDR <- SR
                // [ACV]
                begin
                if(mini_state == 0)
                    begin
                    GateALU = 1;
                    SR2_SEL = ir_out[11:9];
                    ALUK = 2'b11;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateALU = 0;
                    LD_MDR = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_MDR = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 16;
                    end
                end
                
            16:
                // M[MAR] <- MDR
                begin
                if(mini_state == 0)
                    begin
                    RW         = 1;
                    MIO_EN     = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 1;
                    end
                else if (!R_OUT)
                    //wait(R_OUT)
                    //@(posedge i_Clk)
                    ;
                else if (mini_state == 1 & R_OUT)
                    begin
                    next_mini_state = 2;
                    end
                else if (mini_state == 2)
                    begin
                    next_mini_state = 3;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    MIO_EN = 0;
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end           
                end
                
            17:
                // [ACV]
                begin
                //@(posedge i_Clk)
                next_mini_state = 0;
                NEXT_STATE = 24;
                end
            
            24:
                // MDR <- M[MAR]
                begin
                if(mini_state == 0)
                    begin
                    RW         = 0;
                    MIO_EN     = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 1;
                    end
                else if (!R_OUT)
                    //wait(R_OUT)
                    //@(posedge i_Clk)
                    ;
                else if (mini_state == 1 & R_OUT)
                    begin
                    next_mini_state = 2;
                    end
                else if (mini_state == 2)
                    begin
                    LD_MDR = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 3;
                    end
                else if (mini_state == 3)
                    begin
                    LD_MDR = 0;
                    //@(posedge i_Clk)
                    next_mini_state = 4;
                    end
                else
                    begin
                    MIO_EN = 0;
                    next_mini_state = 0;
                    NEXT_STATE  = 26;
                    end
                end
                
            26:
                // MAR <- MDR
                // set ACV
                begin
                if(mini_state == 0)
                    begin
                    GateMDR = 1;
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateMDR = 0;
                    LD_MAR = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_MAR = 0;
                    next_mini_state = 3;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 35;
                    end
                end
                
             
            35:
                // [ACV]
                begin
                //@(posedge i_Clk)
                next_mini_state = 0;
                NEXT_STATE = 25;
                end
                
            25:
                // MDR <- M[MAR]
                begin
                if(mini_state == 0)
                    begin
                    RW         = 0;
                    MIO_EN     = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 1;
                    end
                else if (!R_OUT)
                    //wait(R_OUT)
                    //@(posedge i_Clk)
                    ;
                else if (mini_state == 1 & R_OUT)
                    begin
                    next_mini_state = 2;
                    end
                else if (mini_state == 2)
                    begin
                    LD_MDR = 1;
                    //@(posedge i_Clk)
                    next_mini_state = 3;
                    end
                else if (mini_state == 3)
                    begin
                    LD_MDR = 0;
                    //@(posedge i_Clk)
                    next_mini_state = 4;
                    end
                else
                    begin
                    MIO_EN = 0;
                    next_mini_state = 0;
                    NEXT_STATE  = 27;
                    end
                end
            
            27:
                // DR <= MDR
                // set CC
                begin
                if(mini_state == 0)
                    begin
                    GateMDR = 1;
                    DR = ir_out[11:9];
                    next_mini_state = 1;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 1)
                    begin
                    GateMDR = 0;
                    LD_REG = 1;
                    next_mini_state = 2;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 2)
                    begin
                    LD_REG = 0;
                    LD_CC = 1;
                    next_mini_state = 3;
                    //@(posedge i_Clk)
                    end
                else if(mini_state == 3)
                    begin
                    LD_CC = 0;
                    next_mini_state = 4;
                    //@(posedge i_Clk)
                    end
                else
                    begin
                    next_mini_state = 0;
                    NEXT_STATE = 18;
                    end
                end
           
            default:
            ;
            
            endcase

        end

    always@(posedge i_Clk)
        begin
            mini_state <= next_mini_state;
            CURRENT_STATE <= NEXT_STATE;
            
        end


endmodule 