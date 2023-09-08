`timescale 1ns / 10ps

module TESTBENCH;
  
    reg  i_Clk = 0;
    wire SR2MUX_SEL; 
    wire ADDR1MUX_SEL;
    wire [1:0] ADDR2MUX_SEL;
    wire MARMUX_SEL;
          
    wire [1:0] PCMUX_SEL;
    
    wire  MIO_EN,
          RW;
  
    wire [2:0]  DR;         
    wire    LD_REG;     
    wire [2:0]  SR1_SEL,    
                SR2_SEL;        
                    
    wire  GateMARMUX, 
          GateALU,    
          GateMDR,    
          GatePC,     

          LD_CC,
          LD_IR,
          LD_PC,
          LD_MAR,
          LD_MDR;

    wire [1:0]  ALUK; 
    
    wire LD_KBDR_EXT,
         LD_KBSR_EXT,
         LD_DSR_EXT;
         
    wire [15:0] kbdr_ext_out, // external (uart RX)
                kbsr_ext_out, // external (uart RX)
                dsr_ext_out;  // external (uart TX)
          // -------------------
    wire [15:0] bus_out,                // shared (one or more)
                pc_out,
                pc_out_inc,
                ir_out,
                
                sr1_out,
                sr2_out,

                pcmux_out,
                marmux_out,
                addr1mux_out,
                addr2mux_out,
                addrmux_adder_out,
                sr2mux_out,
                miomux_out,
                inmux_out,
                
                ir_zext_7_0_out,
                ir_sext_10_0_out,       
                ir_sext_8_0_out,
                ir_sext_5_0_out,
                ir_sext_4_0_out,
                
                alu_out;
                
          wire  n_out,
                p_out,
                z_out;
                
                
          wire [15:0]   mar_out,
                        mdr_out,
                        mem_out;
                        
          wire R_OUT, // *
               MEM_EN; // *
          
                
          wire  LD_KBSR, // *
                LD_DSR, // *
                LD_DDR; // *

          wire [15:0]   kbdr_out,
                        kbsr_out,
                        ddr_out,
                        dsr_out;
                        
          wire [1:0] INMUX_SEL; // *
          wire  R_MMIO; // *
          wire [15:0] debug_r0_out,
                      debug_r1_out,
                      debug_r2_out,
                      debug_r3_out,
                      debug_r4_out,
                      debug_r5_out,
                      debug_r6_out,
                      debug_r7_out;
                      
          wire [7:0]  CURRENT_STATE_OUT,
                      NEXT_STATE_OUT,
                      mini_state_out,
                      next_mini_state_out;
          
    FSM fsm (i_Clk, ir_out, n_out, z_out, p_out, R_OUT,
             SR2MUX_SEL, ADDR1MUX_SEL, ADDR2MUX_SEL, MARMUX_SEL, PCMUX_SEL, MIO_EN,
             RW, DR, LD_REG, SR1_SEL, SR2_SEL, GateMARMUX, GateALU, GateMDR, GatePC, LD_CC,
             LD_IR, LD_PC, LD_MAR, LD_MDR, ALUK, CURRENT_STATE_OUT, NEXT_STATE_OUT, mini_state_out, next_mini_state_out);
              
    DATAPATH datapath(i_Clk, SR2MUX_SEL, ADDR1MUX_SEL, ADDR2MUX_SEL, MARMUX_SEL, PCMUX_SEL, MIO_EN,
                      RW, DR, LD_REG, SR1_SEL, SR2_SEL, GateMARMUX, GateALU, GateMDR, GatePC, LD_CC,
                      LD_IR, LD_PC, LD_MAR, LD_MDR, ALUK,
                      LD_KBDR_EXT, LD_KBSR_EXT, LD_DSR_EXT, kbdr_ext_out, kbsr_ext_out, dsr_ext_out,
                      bus_out, pc_out, pc_out_inc, ir_out, sr1_out, sr2_out,
                      pcmux_out, marmux_out, addr1mux_out, addr2mux_out, addrmux_adder_out, sr2mux_out, miomux_out,
                      inmux_out, ir_zext_7_0_out, ir_sext_10_0_out, ir_sext_8_0_out, ir_sext_5_0_out, ir_sext_4_0_out,
                      alu_out, n_out, p_out, z_out, mar_out, mdr_out, mem_out, R_OUT, MEM_EN, LD_KBSR, LD_DSR, LD_DDR, 
                      kbdr_out, kbsr_out, ddr_out, dsr_out, INMUX_SEL, R_MMIO,
                      debug_r0_out,debug_r1_out,debug_r2_out,debug_r3_out,debug_r4_out,debug_r5_out,debug_r6_out,debug_r7_out);

    OUTPUT ot(i_Clk, dsr_out, ready, send, dsr_ext_out, LD_DSR_EXT);
    
    wire ready;
    wire send;
    
    uart_tx #(868) utx(.i_Clock(i_Clk),
                       .i_Tx_DV(send),
                       .i_Tx_Byte(8'h58),
                       .o_Tx_Active(),
                       .o_Tx_Serial(RsTx),
                       .o_Tx_Done(ready));

    initial 
        begin
            i_Clk = 0; 
            forever 
                begin
                #10 i_Clk = ~i_Clk;
            end 
        end

endmodule

