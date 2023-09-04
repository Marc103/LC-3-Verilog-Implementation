module FSM(input i_Clk,
           input reset_,
           input [15:0] ir,
           input r,
           
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
    reg BEN = 0;
    
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
            
            NEXT_STATE = 18;
            end
        
        
        default:
            begin
            end
        
        
        
        
        endcase
        
        
        
        
        
    end
        
        
    always@(posedge i_Clk or negedge reset_)
        begin
            if(~reset_) begin
                CURRENT_STATE <= 0;
                NEXT_STATE <= 0;
            end
            else
                CURRENT_STATE <= NEXT_STATE;
        
        end
           
           
                             
                             
           
           
           
           
          

endmodule 