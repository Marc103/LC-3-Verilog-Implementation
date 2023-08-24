`timescale 1ns / 1ns

module TESTBENCH;
  
    wire  i_Clk;
    wire [4:0] SR2MUX_SEL; 
    wire ADDR1MUX_SEL;
    wire [1:0] ADDR2MUX_SEL;
    wire MARMUX_SEL;
          
    wire [1:0] PCMUX_SEL;
    
    wire [1:0] INMUX_SEL;
    wire  MIO_EN,

          RW,         
          MEM_EN;
  
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
          
          wire R_OUT;
                
          wire [15:0]   input_kbdr,
                        input_kbsr,
                        output_dsr,
                        kbdr_out,
                        kbsr_out,
                        dsr_out;
    

    TEST_DATAPATH driver_datapath(i_Clk, SR2MUX_SEL, ADDR1MUX_SEL, ADDR2MUX_SEL, MARMUX_SEL, PCMUX_SEL, INMUX_SEL, MIO_EN,
                                  RW, MEM_EN, DR, LD_REG, SR1_SEL, SR2_SEL, GateMARMUX, GateALU, GateMDR, GatePC, LD_CC,
                                  LD_IR, LD_PC, LD_MAR, LD_MDR, ALUK, bus_out, pc_out, pc_out_inc, ir_out, sr1_out, sr2_out,
                                  pcmux_out, marmux_out, addr1mux_out, addr2mux_out, addrmux_adder_out, sr2mux_out, miomux_out,
                                  inmux_out, ir_zext_7_0_out, ir_sext_10_0_out, ir_sext_8_0_out, ir_sext_5_0_out, ir_sext_4_0_out,
                                  alu_out, n_out, p_out, z_out, mar_out, mdr_out, mem_out, R_OUT, input_kbdr, input_kbsr, output_dsr, 
                                  kbdr_out, kbsr_out, dsr_out);
         
    DATAPATH datapath(i_Clk, SR2MUX_SEL, ADDR1MUX_SEL, ADDR2MUX_SEL, MARMUX_SEL, PCMUX_SEL, INMUX_SEL, MIO_EN,
                      RW, MEM_EN, DR, LD_REG, SR1_SEL, SR2_SEL, GateMARMUX, GateALU, GateMDR, GatePC, LD_CC,
                      LD_IR, LD_PC, LD_MAR, LD_MDR, ALUK, bus_out, pc_out, pc_out_inc, ir_out, sr1_out, sr2_out,
                      pcmux_out, marmux_out, addr1mux_out, addr2mux_out, addrmux_adder_out, sr2mux_out, miomux_out,
                      inmux_out, ir_zext_7_0_out, ir_sext_10_0_out, ir_sext_8_0_out, ir_sext_5_0_out, ir_sext_4_0_out,
                      alu_out, n_out, p_out, z_out, mar_out, mdr_out, mem_out, R_OUT, input_kbdr, input_kbsr, output_dsr, 
                      kbdr_out, kbsr_out, dsr_out);


endmodule

module TEST_DATAPATH(output reg i_Clk,
                     output reg SR2MUX_SEL, 
                     output reg ADDR1MUX_SEL,
                     output reg ADDR2MUX_SEL,
                     output reg MARMUX_SEL,
                     output reg [1:0] PCMUX_SEL,
                     output reg INMUX_SEL,
                     output reg MIO_EN,

                     output reg RW,         // ******************
                     output reg MEM_EN,     // MEMORY SIGNALs
  
                     output reg DR,         // ******************
                     output reg LD_REG,     // REGFILE SIGNALs
                     output reg SR1_SEL,    //
                     output reg SR2_SEL,    //     
                    
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
                     
                     input wire [15:0] bus_out,                // shared (one or more)
                     input wire [15:0] pc_out,
                     input wire [15:0] pc_out_inc,
                     input wire [15:0] ir_out,
                
                     // reg file 
                     input wire [15:0] sr1_out,
                     input wire [15:0] sr2_out,

                     // muxes
                     input wire [15:0] pcmux_out,
                     input wire [15:0] marmux_out,
                     input wire [15:0] addr1mux_out,
                     input wire [15:0] addr2mux_out,
                     input wire [15:0] addrmux_adder_out,
                     input wire [15:0] sr2mux_out,
                     input wire [15:0] miomux_out,
                     input wire [15:0] inmux_out,
                
                     // sign extensions
                     input wire [15:0] ir_zext_7_0_out,
                     input wire [15:0] ir_sext_10_0_out,       
                     input wire [15:0] ir_sext_8_0_out,
                     input wire [15:0] ir_sext_5_0_out,
                     input wire [15:0] ir_sext_4_0_out,
                
                     input wire [15:0] alu_out,
                
                     input wire n_out,
                     input wire p_out,
                     input wire z_out,
                
                     input wire [15:0] mar_out,
                     input wire [15:0] mdr_out,
                
                     input wire [15:0] mem_out,
                     input wire R_OUT,
                
                     input wire [15:0] input_kbdr,
                     input wire [15:0] input_kbsr,
                     input wire [15:0] output_dsr,
                     input wire [15:0] kbdr_out,
                     input wire [15:0] kbsr_out,
                     input wire [15:0] dsr_out);

     initial 
        begin
            i_Clk = 0; 
            forever 
                begin
                #10 i_Clk = ~i_Clk;
            end 
        end



     initial
          begin
          // This is Cycle-accurate Specification 
          // PC should start as 0
          // All signals should be set to some default
          // Any signals used should then be reset to their default after a cycle
          // General Form for driving data onto the bus and loading it onto a register
          //    1. Set bus flag
          //    2. @posedge clock
          //    3. Set register load flag
          //    4. @posedge clock
          //    5. @posedge clock
          // With the way I've implemented the datapath, it will take a minimum of 3 cycles to avoid race conditions
          
          @(posedge i_Clk)
          
          GatePC        <= 0;
          GateMARMUX    <= 0; 
          GateALU       <= 0;    
          GateMDR       <= 0;
          
          LD_PC         <= 0;
          
          PCMUX_SEL     <= 2'b11;
          
          @(posedge i_Clk)
          
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
          
          @(posedge i_Clk)

          // 33 (skipped) -----------------------------------------------------------------
          
          // 28 (28)
          // MDR <- M
          GatePC     <= 0;
          GateMARMUX <= 0; 
          GateALU    <= 0;    
          GateMDR    <= 0;  
          RW         <= 0;
          MIO_EN     <= 0;
          @(posedge i_Clk)
         
          wait(R_OUT)
          @(posedge i_Clk)
          
          LD_MDR     <= 1;
          @(posedge i_Clk)
          @(posedge i_Clk)
          
          
          
          // 30
          GatePC <= 1;
          GateMARMUX <= 0; 
          GateALU <= 0;    
          GateMDR <= 0;  
          
          // 32
          GatePC <= 1;
          GateMARMUX <= 0; 
          GateALU <= 0;    
          GateMDR <= 0;  
            
            
          end
                    

endmodule