`timescale 1ns / 1ps 

module TOP (input  i_Clk,
            input  RsRx,
            output RsTx,
            output [15:0] LED);
            
    //reg i_Clk = 0;
    //initial 
    //    begin
    //        i_Clk = 0; 
    //        forever 
    //            begin
    //            #10 i_Clk = ~i_Clk;
    //       end 
    //   end
    
      
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
    wire [2:0] NZP;
    wire [15:0] DDR;
    wire [15:0] DSR;
    wire [15:0] KBDR;
    wire [15:0] KBSR;
    
    
    // Output output wires
    wire SEND;

    wire LD_DSR_EXT;
    wire [15:0] dsr_status;
    

    // Input output wires
    wire RECIEVE;

    

    wire LD_KBSR_EXT;
    wire [15:0] kbsr_status;
    
    // Uart TX output wires
    wire DONE_TX;

    // Uart RX output wires
    wire DONE_RX; // feed to LD_KBDR_EXT
    wire [15:0] kbdr_ext; 

    
    // Debug
    wire [15:0] d_mar;
    wire [15:0] d_mdr;
    wire [15:0] d_mem;
    wire [15:0] d_bus;
    
    
    wire [9:0] d_state;
    wire d_ben;
    
    wire [15:0] d_r0;
    wire [15:0] d_r1;
    wire [15:0] d_r2;
    wire [15:0] d_r3;
    wire [15:0] d_r4;
    wire [15:0] d_r5;
    wire [15:0] d_r6;
    wire [15:0] d_r7;
    
    wire [15:0] d_pc;
    
    assign LED = d_r0;
      
    FSM fsm (// --------------- INPUTS
             .i_Clk(i_Clk),
             .reset_(reset_),
             .ir(IR),
             .r(R),
             .nzp(NZP),
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
              // Debugs
             .debug_state(d_state),
             .debug_ben(d_ben));
             
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
                      
                      .LD_DSR_EXT(LD_DSR_EXT),
                      .dsr_ext(dsr_status),

                      .LD_KBDR_EXT(DONE_RX),
                      .kbdr_ext(kbdr_ext),

                      .LD_KBSR_EXT(LD_KBSR_EXT),
                      .kbsr_ext(kbsr_status),
                      
                      // OUTPUTS -----------------
                      .R(R),
                      .ir(IR),
                      .nzp(NZP),
                      .ddr(DDR),
                      .dsr(DSR),
                      .kbdr(KBDR),
                      .kbsr(KBSR),

                      // Debugs
                      .debug_mar(d_mar),
                      .debug_mdr(d_mdr),
                      .debug_memory(d_mem),
                      .debug_bus(d_bus),
                      .debug_r0(d_r0),
                      .debug_r1(d_r1),
                      .debug_r2(d_r2),
                      .debug_r3(d_r3),
                      .debug_r4(d_r4),
                      .debug_r5(d_r5),
                      .debug_r6(d_r6),
                      .debug_r7(d_r7),
                      .debug_pc(d_pc));
                      
        OUTPUT ot (.clk(i_Clk),
                   .dsr(DSR),
                   .done(DONE_TX),
                   .send(SEND),
                   .status(dsr_status),
                   .ld_dsr_ext(LD_DSR_EXT));
                   
        uart_tx utx (.i_Clock(i_Clk),
                     .i_Tx_DV(SEND),
                     .i_Tx_Byte(DDR[7:0]),
                     .o_Tx_Active(),
                     .o_Tx_Serial(RsTx),
                     .o_Tx_Done(DONE_TX));

        INPUT in (.clk(i_Clk),
                  .kbsr(KBSR),
                  .done(DONE_RX),
                  .recieve(RECIEVE),
                  .status(kbsr_status),
                  .ld_kbsr_ext(LD_KBSR_EXT));

        uart_rx urx (.i_Clock(i_Clk),
                     .i_Rx_Serial(RsRx),
                     .i_Recieve(RECIEVE),
                     .o_Rx_DV(DONE_RX),
                     .o_Rx_Byte(kbdr_ext));
                     
    
     
             
    
    
endmodule