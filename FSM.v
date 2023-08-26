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
           output [7:0] NEXT_STATE_OUT
);

    reg [7:0] CURRENT_STATE = 100;
    reg [7:0] NEXT_STATE = 100;
    reg BEN = 0;
    
    assign CURRENT_STATE_OUT = CURRENT_STATE;
    assign NEXT_STATE_OUT = NEXT_STATE;

    always@(posedge i_Clk)
        begin
            case(CURRENT_STATE)
            100:
                begin
                // Setting default flags
                GatePC        <= 0;
                GateMARMUX    <= 0; 
                GateALU       <= 0;    
                GateMDR       <= 0;
          
                LD_PC         <= 0;
          
                PCMUX_SEL     <= 2'b11;
                SR2MUX_SEL    <= 1;
                SR1_SEL       <= 2'b00;
                SR2_SEL       <= 2'b00;
          
                DR            <= 3'b000;
          
                ALUK          <= 2'b00;
          
                MIO_EN        <= 0;
                RW            <= 0;
                @(posedge i_Clk);
                NEXT_STATE = 18;
                end
            
            18:
                begin
                // 18 -------------------------------------------------------------------------
                // MAR <- PC
                // PC <- PC + 1
                // set ACV 
                // [INT]
                GatePC <= 1; // remeber to reset flag in next cycle           
                @(posedge i_Clk)
                GatePC <= 0;
                LD_MAR <= 1; // while waiting for the value to be driven on the bus, 
                             // signal the load mar flag (since it takes a cycle to be 'seen'        
                @(posedge i_Clk)
                LD_MAR <= 0;
                LD_PC <= 1;
                PCMUX_SEL <= 2'b10;    
                @(posedge i_Clk)
                LD_PC <= 0;
                PCMUX_SEL <= 0;
                @(posedge i_Clk);
                NEXT_STATE = 28;
                end
                
            33:
                begin
                // 33 (skipped) -----------------------------------------------------------------
                end
                
            28:
                begin
                // 28 (28) ----------------------------------------------------------------------
                // MDR <- M
                RW         <= 0;
                MIO_EN     <= 1;
                @(posedge i_Clk)
                wait(R_OUT)
                @(posedge i_Clk)
                LD_MDR     <= 1;
                @(posedge i_Clk)
                LD_MDR <= 0;
                @(posedge i_Clk)
                MIO_EN <= 0;
                NEXT_STATE <= 30; 
                end
                
            30:
                begin
                // 30 ---------------------------------------------------------------------------
                // IR <- MDR
                GateMDR <= 1;
                @(posedge i_Clk)
                GateMDR <= 0;
                LD_IR <= 1;
                @(posedge i_Clk)
                LD_IR <= 0;
                @(posedge i_Clk);
                NEXT_STATE <= 32;
                end
                
            32:
                begin
                if ((ir_out[11] & n_out) | (ir_out[10] & z_out) | (ir_out[9] & p_out)) BEN <= 1;
                else BEN <= 0; 
                @(posedge i_Clk)
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
                    4'b0001: // Reserved 
                        NEXT_STATE = 18; // just skip
                endcase  
                @(posedge i_Clk);
                end
                
            1: // ADD s
                begin
                // 01 ---------------------------------------------------------------------------------
                // DR <- SR1 + OP2* (bit[5] determines if an immediate value is used, 1 means immediate)
                // set CC
                ALUK       <= 2'b00;
                SR1_SEL    <= ir_out[8:6];
                SR2_SEL    <= ir_out[2:0];
                if(ir_out[5] == 0)    SR2MUX_SEL <= 1;
                else                  SR2MUX_SEL <= 0;
                GateALU    <= 1;
                @(posedge i_Clk)
                GateALU    <= 0;
                LD_CC      <= 1;
                LD_REG     <= 1;
                DR         <= ir_out[11:9];
                @(posedge i_Clk)
                LD_CC      <= 0;
                LD_REG     <= 0;
                @(posedge i_Clk);
                NEXT_STATE <= 18;
                end
                
            5: // AND
                begin
                // 01 ---------------------------------------------------------------------------------
                // DR <- SR1 & OP2* (bit[5] determines if an immediate value is used, 1 means immediate)
                // set CC
                ALUK       <= 2'b01;
                SR1_SEL    <= ir_out[8:6];
                SR2_SEL    <= ir_out[2:0];
                if(ir_out[5] == 0)    SR2MUX_SEL <= 1;
                else                  SR2MUX_SEL <= 0;
                GateALU    <= 1;
                @(posedge i_Clk)
                GateALU    <= 0;
                LD_CC      <= 1;
                LD_REG     <= 1;
                DR         <= ir_out[11:9];
                @(posedge i_Clk)
                LD_CC      <= 0;
                LD_REG     <= 0;
                @(posedge i_Clk);
                NEXT_STATE <= 18;
                end
            9:
                begin
                // 01 ---------------------------------------------------------------------------------
                // DR <- SR1 & OP2* (bit[5] determines if an immediate value is used, 1 means immediate)
                // set CC
                ALUK       <= 2'b10;
                SR1_SEL    <= ir_out[8:6];
                GateALU    <= 1;
                @(posedge i_Clk)
                GateALU    <= 0;
                LD_CC      <= 1;
                LD_REG     <= 1;
                DR         <= ir_out[11:9];
                @(posedge i_Clk)
                LD_CC      <= 0;
                LD_REG     <= 0;
                @(posedge i_Clk);
                NEXT_STATE <= 18;
                end
            
            default:
            ;
            
            endcase

        end

    always@(*)
        begin
            CURRENT_STATE <= NEXT_STATE;
        end


endmodule 