`timescale 1ns / 1ps 

module TOP ( // input  i_Clk,
            input  RsRx,
            output RsTx);
            
    reg i_Clk = 0;
    initial 
        begin
            i_Clk = 0; 
            forever 
                begin
                #10 i_Clk = ~i_Clk;
            end 
        end
    
      
    reg reset_ = 1; 
      
    // FSM output wires
    wire [1:0] ALUK;
    
    wire [1:0] BUS_SEL;
    wire LD_BUS;
    
    wire RW;
    wire MIO_EN;
    
    wire [2:0] DR;
    wire [2:0] SR1_SEL;
    wire [2:0] SR2_SEL;
    
    wire [1:0] PCMUX_SEL;
    wire MARMUX_SEL;
    wire ADDR1MUX_SEL;
    wire [1:0] ADDR2MUX_SEL;
    wire SR2MUX_SEL;
    
    wire LD_CC;
    wire LD_REG;
    wire LD_IR;
    wire LD_PC;
    wire LD_MAR;  
    wire LD_MDR;
    wire LD_KBSR;
    wire LD_DDR;
    wire LD_DSR;
    
    // Datapath output wires
    wire [15:0] IR;
    wire R;
    wire [15:0] DDR;
    wire [15:0] DSR;
    
    // Output output wires
    wire SEND;
    wire [15:0] status;
    wire LD_DSR_EXT;
    
    // Uart TX output wires
    wire DONE;
    
    // Debug
    wire [15:0] d_mar;
    wire [15:0] d_mdr;
    wire [15:0] d_mem;
    wire [15:0] d_bus;
    
    wire [9:0] d_state;
      
      
    FSM fsm (// --------------- INPUTS
             .i_Clk(i_Clk),
             .reset_(reset_),
             .ir(IR),
             .r(R),
             // --------------- OUTPUTS
             .aluk(ALUK),
             
             .bus_sel(BUS_SEL),
             .ld_bus(LD_BUS),
             
             .rw(RW),
             .mio_en(MIO_EN),
             
             .dr(DR),
             .sr1_sel(SR1_SEL),
             .sr2_sel(SR2_SEL),
             
             .pcmux_sel(PCMUX_SEL),
             .marmux_sel(MARMUX_SEL),
             .addr1mux_sel(ADDR1MUX_SEL),
             .addr2mux_sel(ADDR2MUX_SEL),
             .sr2mux_sel(SR2MUX_SEL),
             
             .ld_cc(LD_CC),
             .ld_reg(LD_REG),
             .ld_ir(LD_IR),
             .ld_pc(LD_PC),
             .ld_mar(LD_MAR),
             .ld_mdr(LD_MDR),
             
             .ld_kbsr(LD_KBSR),
             .ld_ddr(LD_DDR),
             .ld_dsr(LD_DSR),
             
             .debug_state(d_state));
             
    DATAPATH datapath(// INPUTS --------------------
                      .i_Clk(i_Clk),
                      .reset_(reset_),
                     
                      .ALUK(ALUK),
                      
                      .BUS_SEL(BUS_SEL),
                      .LD_BUS(LD_BUS),
                      
                      .RW(RW),
                      .MIO_EN(MIO_EN),
                      
                      .DR(DR),
                      .SR1_SEL(SR1_SEL),
                      .SR2_SEL(SR2_SEL),
                      
                      .PCMUX_SEL(PCMUX_SEL),
                      .SR2MUX_SEL(SR2MUX_SEL),
                      .MARMUX_SEL(MARMUX_SEL),
                      .ADDR1MUX_SEL(ADDR1MUX_SEL),
                      .ADDR2MUX_SEL(ADDR2MUX_SEL),
                      
                      .LD_CC(LD_CC),
                      .LD_REG(LD_REG),
                      .LD_IR(LD_IR),
                      .LD_PC(LD_PC),
                      .LD_MAR(LD_MAR),
                      .LD_MDR(LD_MDR),
                      
                      // OUTPUTS -----------------
                      .R(R),
                      .ir(IR),
                      .ddr(DDR),
                      .dsr(DSR),
                      // Debugs
                      .debug_mar(d_mar),
                      .debug_mdr(d_mdr),
                      .debug_memory(d_mem),
                      .debug_bus(d_bus));
                      
        OUTPUT ot (.clk(i_Clk),
                   .dsr(DSR),
                   .done(DONE),
                   .send(SEND),
                   .status(status),
                   .ld_dsr_ext(LD_DSR_EXT));
                   
        uart_tx utx (.i_Clock(i_Clk),
                     .i_Tx_DV(SEND),
                     .i_Tx_Byte(DDR[7:0]),
                     .o_Tx_Active(),
                     .o_Tx_Serial(RsTx),
                     .o_Tx_Done(DONE));
                     
    
     
             
    
    
endmodule