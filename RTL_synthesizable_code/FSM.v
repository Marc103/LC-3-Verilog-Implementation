module FSM(input i_Clk,
           input reset_,
           input [15:0] ir,
           input r,
           input [2:0] nzp,
           
           output reg [1:0] aluk,
           
           output reg [1:0] bus_sel,
           output reg ld_bus,
           
           output reg rw,
           output reg mio_en,
           
           output reg [2:0] dr,
           output reg [2:0] sr1_sel,
           output reg [2:0] sr2_sel,
           
           output reg [1:0] pcmux_sel,
           output reg marmux_sel,
           output reg addr1mux_sel,
           output reg [1:0] addr2mux_sel,
           output reg sr2mux_sel,
           
           output reg ld_cc,
           output reg ld_reg,
           output reg ld_ir,
           output reg ld_pc,
           output reg ld_mar,
           output reg ld_mdr,
           
           output reg ld_kbsr,
           output reg ld_ddr,
           output reg ld_dsr,
           // Debug
           output [9:0] debug_state);
           
    reg [9:0] CURRENT_STATE = 18;
    reg [9:0] NEXT_STATE = 18;
    
    reg LD_BEN = 0;
    
    wire BEN;
    assign BEN = (ir[11] & nzp[2]) | (ir[10] & nzp[1]) | (ir[9] | nzp[0]);
    
    // Debug
    assign debug_state = CURRENT_STATE;
    
    always@(*)
    begin
        // Default values for ALL the outputs (just no latches pls)
        aluk = 0;
        
        bus_sel = 0;
        ld_bus = 0;
           
        rw = 0;
        mio_en = 0;
           
        dr = 0;
        sr1_sel = 0;
        sr2_sel = 0;
           
        pcmux_sel = 0;
        marmux_sel = 0;
        addr1mux_sel = 0;
        addr2mux_sel = 0;
        sr2mux_sel = 0;
           
        ld_cc = 0;
        ld_reg = 0;
        ld_ir = 0;
        ld_pc = 0;
        ld_mar = 0;
        ld_mdr = 0;
           
        ld_kbsr = 0;
        ld_ddr = 0;
        ld_dsr = 0;
        
        NEXT_STATE = 18;
    
        
        case (CURRENT_STATE)
        18:
            begin
            // 18 -------------------------------------------------------------------------
            // MAR <- PC
            // PC <- PC + 1
            // set ACV 
            // [INT]
            ld_bus = 1;
            bus_sel = 2'b01;
            
            NEXT_STATE = 180;
            end
         180:
            begin
            ld_mar = 1;
            
            ld_pc = 1;
            pcmux_sel = 2'b10;
            
            NEXT_STATE = 33;
            end
            
         33:
            begin
            // 33  -------------------------------------------------------------------------
            // [ACV]
            NEXT_STATE = 28;
            end 
            
         28:
            begin
            // 28 (28) ----------------------------------------------------------------------
            // MDR <- M[MAR]
            rw = 0;
            mio_en = 1;
            NEXT_STATE = 280;
            end   
         280:
            begin
            rw = 0;
            mio_en = 1;
            if(r) NEXT_STATE = 281;
            else NEXT_STATE = 280;
            end
           
         281:
            begin
            rw = 0;
            mio_en = 1;
            ld_mdr = 1;
            NEXT_STATE = 30;
            end
            
         30:
            begin
            // 30 ---------------------------------------------------------------------------
            // IR <- MDR
            ld_bus = 1;
            bus_sel = 2'b11;
            NEXT_STATE = 300;
            end
         300:
            begin
            ld_ir = 1;
            
            NEXT_STATE = 32;
            end
        
         32:
            begin
            case(ir[15:12])
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
            end
        1: // ADD
            begin
            // DR <- SR1 + OP2* (bit[5] determines if an immediate value is used, 1 means immediate)
            // set CC
            aluk = 2'b00;
            sr1_sel = ir[8:6];
            sr2_sel = ir[2:0];
            if(ir[5] == 0) sr2mux_sel = 1;
            else sr2mux_sel = 0;
            
            ld_bus = 1;
            bus_sel = 2'b10;
            
            NEXT_STATE = 110;
            end
         110:
            begin
            ld_cc = 1;
            ld_reg = 1;
            dr = ir[11:9];
            NEXT_STATE = 18;
            end
         
         5: // AND
            begin
            // DR <- SR1 & OP2* (bit[5] determines if an immediate value is used, 1 means immediate)
            // set CC
            aluk = 2'b01;
            sr1_sel = ir[8:6];
            sr2_sel = ir[2:0];
            if(ir[5] == 0) sr2mux_sel = 1;
            else sr2mux_sel = 0;
            
            ld_bus = 1;
            bus_sel = 2'b10;
            
            NEXT_STATE = 550;
            end
         550:
            begin
            ld_cc = 1;
            ld_reg = 1;
            dr = ir[11:9];
            NEXT_STATE = 18;
            end
            
          
         9: // NOT
            begin
            // DR <- NOT(SR1)
            // set CC
            aluk = 2'b01;
            sr1_sel = ir[8:6];

            ld_bus = 1;
            bus_sel = 2'b11;
            
            NEXT_STATE = 990;
            end
         990:
            begin
            ld_cc = 1;
            ld_reg = 1;
            dr = ir[11:9];
            NEXT_STATE = 18;
            end
            
         14:// LEA
            begin
            // DR <- PC + offset9
            addr1mux_sel = 1'b1;
            addr2mux_sel = 2'b01;
            marmux_sel = 1'b1;
            
            ld_bus = 1;
            bus_sel = 2'b00;
            
            NEXT_STATE = 140;
            end
         140:
            begin
            dr = ir[11:9];
            ld_reg = 1;
            NEXT_STATE = 18;
            end
         
         2: // LD
            begin
            // MAR <- PC + SEXT[offset9]
            // set ACV
            addr1mux_sel = 1'b1;
            addr2mux_sel = 2'b01;
            marmux_sel = 1'b1;
            
            ld_bus = 1;
            bus_sel = 2'b00;
            
            NEXT_STATE = 220;
            end
         220:
            begin
            ld_mar = 1;
            NEXT_STATE = 35;
            end
            
         6: // LDR
            begin
            // MAR <- B + SEXT[offset9]
            // set ACV
            sr1_sel = ir[8:6];
            addr1mux_sel = 1'b0;
            addr2mux_sel = 2'b10;
            marmux_sel = 1'b1;
            
            ld_bus = 1;
            bus_sel = 2'b00;
            NEXT_STATE = 660;
            end
         660:
            begin
            ld_mar = 1;
            NEXT_STATE = 35;
            end
         
         10: // LDI
            begin
            // MAR <- PC + SEXT[offset9]
            // set ACV
            addr1mux_sel = 1'b1;
            addr2mux_sel = 2'b01;
            marmux_sel = 1'b1;
            
            ld_bus = 1;
            bus_sel = 2'b00;
            
            NEXT_STATE = 100;
            end
         100:
            begin
            ld_mar = 1;
            NEXT_STATE = 17;
            end
         17:
            begin
            // [ACV]
            NEXT_STATE = 24;
            end
         24:
            begin
            // MDR <- M[MAR]
            rw = 0;
            mio_en = 1;
            NEXT_STATE = 240;
            end   
         240:
            begin
            rw = 0;
            mio_en = 1;
            if(r) NEXT_STATE = 241;
            else NEXT_STATE = 240;
            end
         241:
            begin
            rw = 0;
            mio_en = 1;
            ld_mdr = 1;
            NEXT_STATE = 26;
            end
         26:
            begin
            // MAR <- MDR
            // set ACV
            ld_bus = 1;
            bus_sel = 2'b11;
            NEXT_STATE = 260;
            end
         260:
            begin
            ld_mar = 1;
            NEXT_STATE = 35;
            end
            
         35:
            begin
            NEXT_STATE = 25;
            end
            
  
            
         25:
            begin
            // 28 (28) ----------------------------------------------------------------------
            // MDR <- M[MAR]
            rw = 0;
            mio_en = 1;
            NEXT_STATE = 250;
            end   
         250:
            begin
            rw = 0;
            mio_en = 1;
            if(r) NEXT_STATE = 251;
            else NEXT_STATE = 250;
            end
         251:
            begin
            rw = 0;
            mio_en = 1;
            ld_mdr = 1;
            NEXT_STATE = 27;
            end
         27:
            begin
            ld_bus = 1; 
            bus_sel = 2'b11;
            NEXT_STATE = 277;
            end
         277:
            begin
            ld_reg = 1;
            dr = ir[11:9];
            ld_cc = 1;
            NEXT_STATE = 18;
            end
            
         11: // STI
            begin
            // MAR <- PC + SEXT[offset9]
            // set ACV
            addr1mux_sel = 1'b1;
            addr2mux_sel = 2'b01;
            marmux_sel = 1'b1;
            
            ld_bus = 1;
            bus_sel = 2'b00;
            
            NEXT_STATE = 111;
            end
         111:
            begin
            ld_mar = 1;
            NEXT_STATE = 19;
            end
         19:
            begin
            // set ACV
            NEXT_STATE = 29;
            end
         29:
            begin
            // MDR <- M[MAR]
            rw = 0;
            mio_en = 1;
            NEXT_STATE = 290;
            end   
         290:
            begin
            rw = 0;
            mio_en = 1;
            if(r) NEXT_STATE = 291;
            else NEXT_STATE = 290;
            end
         291:
            begin
            rw = 0;
            mio_en = 1;
            ld_mdr = 1;
            NEXT_STATE = 31;
            end  
         31:
            begin
            // MAR <- MDR
            // set ACV
            ld_bus = 1;
            bus_sel = 2'b11;
            NEXT_STATE = 310;
            end
         310:
            begin
            ld_mar = 1;
            NEXT_STATE = 23;
            end
         
         7: // STR
            begin
            // MAR <- B + SEXT[offset6]
            // set ACV
            sr1_sel = ir[8:6];
            addr1mux_sel = 1'b0;
            addr2mux_sel = 2'b10;
            marmux_sel = 1'b1;
            
            ld_bus = 1;
            bus_sel = 2'b00;
            
            NEXT_STATE = 899;
            end
         899:
            begin
            ld_mar = 1;
            NEXT_STATE = 23;
            end

         3: // ST
            begin
            // MAR <- PC + SEXT[offset9]
            // set ACV
            addr1mux_sel = 1'b1;
            addr2mux_sel = 2'b01;
            marmux_sel = 1'b1;
            
            ld_bus = 1;
            bus_sel = 2'b00;
            
            NEXT_STATE = 300;
            end
         330:
            begin
            ld_mar = 1;
            NEXT_STATE = 23;
            end
            
         23:
            begin
            // MDR <- SR
            // [ACV]
            sr1_sel = ir[11:9];
            aluk = 2'b11;
            
            ld_bus = 1;
            bus_sel = 2'b10;
            
            NEXT_STATE = 230;
            end
            
         230:
            begin
            ld_mdr = 1;
            NEXT_STATE = 16;
            end
            
         16:
            begin
            rw = 1;
            mio_en = 1;
            NEXT_STATE = 160;
            end
         160:
            begin
            rw = 1;
            mio_en = 1;
            if(r) NEXT_STATE = 18;
            else NEXT_STATE = 160;
            end
            
            
          0: // BR
            begin
            if(BEN) NEXT_STATE = 22;
            else NEXT_STATE = 18;
            end
          22:
            begin
            // PC <- PC + offset9
            marmux_sel = 1;
            addr1mux_sel = 1'b1;
            addr2mux_sel = 2'b01;
            
            ld_bus = 1;
            bus_sel = 2'b00;
            NEXT_STATE = 225;
            end
          225:
            begin
            pcmux_sel = 2'b0;
            ld_pc = 1;
            NEXT_STATE = 18;
            end
          
          
          12: // JMP
            begin
            aluk = 2'b11;
            sr1_sel = ir[8:6];
            
            ld_bus = 1;
            bus_sel = 2'b10;
            NEXT_STATE = 18;
            end
          
          4: // JSR
            begin
            if(ir[11]) NEXT_STATE = 21;
            else NEXT_STATE = 20;
            end
            
          21:
            begin
            // R7 <- PC
            // PC <- PC + off11
            ld_bus = 1;
            bus_sel = 2'b01;
            
            NEXT_STATE = 701;
            end
         701:
            begin
            pcmux_sel = 2'b01;
            addr1mux_sel = 1'b1;
            addr2mux_sel = 2'b00;
            ld_pc = 1;
            
            dr = 3'b111;
            ld_reg = 1;
             
            NEXT_STATE = 18;
            end
            
          20:
            begin
            // R7 <- PC
            // PC <- BaseR
            ld_bus = 1;
            bus_sel = 2'b01;
            
            NEXT_STATE = 702;
            end
          702:
            begin
            dr = 3'b111;
            ld_reg = 1;
            
            pcmux_sel = 2'b01;
            sr1_sel = ir[8:6];
            addr1mux_sel = 1'b0;
            addr2mux_sel = 2'b11;
            
            ld_pc = 1;
            NEXT_STATE = 18;
            end

        default:
            begin
                NEXT_STATE = 18;
            end
        
        endcase
    end
        
        
    always@(posedge i_Clk or negedge reset_)
        begin
            if(~reset_) begin
                CURRENT_STATE <= 18;
            end
            else
                CURRENT_STATE <= NEXT_STATE;
        end
           
           
                             
                             
           
           
           
           
          

endmodule 