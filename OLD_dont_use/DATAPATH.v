module DATAPATH(input i_Clk,
                input SR2MUX_SEL, 
                input ADDR1MUX_SEL,
                input [1:0] ADDR2MUX_SEL,
                input MARMUX_SEL,
                input [1:0] PCMUX_SEL,


                input MIO_EN,         // ******************
                input RW,             // MEMORY SIGNALs

                input [2:0] DR,         // ******************
                input LD_REG,           // REGFILE SIGNALs
                input [2:0] SR1_SEL,    //
                input [2:0] SR2_SEL,    //     

                input GateMARMUX, // ******************
                input GateALU,    // BUS_DRIVER SIGNALs
                input GateMDR,    //
                input GatePC,     //
                
                input LD_CC,
                input LD_IR,
                input LD_PC,
                input LD_MAR,
                input LD_MDR,
                
                input [1:0] ALUK,
                input LD_KBDR_EXT,
                input LD_KBSR_EXT,
                input LD_DSR_EXT,
                input [15:0] kbdr_ext_out,
                input [15:0] kbsr_ext_out,
                input [15:0] dsr_ext_out,

                output wire [15:0] bus_out,                // shared (one or more)
                output wire [15:0] pc_out,
                output wire [15:0] pc_out_inc,
                output wire [15:0] ir_out,
                
                // reg file 
                output wire [15:0] sr1_out,
                output wire [15:0] sr2_out,

                // muxes
                output wire [15:0] pcmux_out,
                output wire [15:0] marmux_out,
                output wire [15:0] addr1mux_out,
                output wire [15:0] addr2mux_out,
                output wire [15:0] addrmux_adder_out,
                output wire [15:0] sr2mux_out,
                output wire [15:0] miomux_out,
                output wire [15:0] inmux_out,
                
                // sign extensions
                output wire [15:0] ir_zext_7_0_out,
                output wire [15:0] ir_sext_10_0_out,       
                output wire [15:0] ir_sext_8_0_out,
                output wire [15:0] ir_sext_5_0_out,
                output wire [15:0] ir_sext_4_0_out,
                
                output wire [15:0] alu_out,
                
                output wire n_out,
                output wire p_out,
                output wire z_out,
                
                output wire [15:0] mar_out,
                output wire [15:0] mdr_out,
                
                output wire [15:0] mem_out,
                output wire R_OUT, // *
                output wire MEM_EN, // *
                

                output wire LD_KBSR, // *
                output wire LD_DSR,  // *
                output wire LD_DDR,  // *
                output wire [15:0] kbdr_out,
                output wire [15:0] kbsr_out,
                output wire [15:0] ddr_out,
                output wire [15:0] dsr_out,
                
                output wire [1:0] INMUX_SEL, // *
                output wire R_MMIO, // *
                output wire [15:0] debug_r0_out,
                output wire [15:0] debug_r1_out,
                output wire [15:0] debug_r2_out,
                output wire [15:0] debug_r3_out,
                output wire [15:0] debug_r4_out,
                output wire [15:0] debug_r5_out,
                output wire [15:0] debug_r6_out,
                output wire [15:0] debug_r7_out  
                );


    MARMUX marmux (MARMUX_SEL, ir_zext_7_0_out, addrmux_adder_out, marmux_out);   
    
    ADDR1MUX addr1mux (ADDR1MUX_SEL, pc_out, sr1_out, addr1mux_out);
    ADDR2MUX addr2mux (ADDR2MUX_SEL, ir_sext_10_0_out, ir_sext_8_0_out, ir_sext_5_0_out, addr2mux_out);
    ADDRMUX_ADDER addrmux_adder (addr1mux_out, addr2mux_out, addrmux_adder_out);
    
    PCMUX pcmux (PCMUX_SEL, bus_out, addrmux_adder_out, pc_out_inc, pcmux_out);
    PC_INCREMENT pc_increment (pc_out, pc_out_inc);
    PC pc (i_Clk, LD_PC, pcmux_out, pc_out);
    
    SR2MUX sr2mux (SR2MUX_SEL, ir_sext_4_0_out, sr2_out, sr2mux_out);
    
    IR ir (i_Clk, LD_IR, bus_out, ir_out);
    
    SEXT_10_0 ir_sext_10_0 (ir_out[10:0], ir_sext_10_0_out);
    SEXT_8_0 ir_sext_8_0 (ir_out[8:0], ir_sext_8_0_out);
    SEXT_5_0 ir_sext_5_0 (ir_out[5:0], ir_sext_5_0_out);
    SEXT_4_0 ir_sext_4_0 (ir_out[4:0], ir_sext_4_0_out);

    ZEXT_7_0 ir_zext_7_0 (ir_out[7:0], ir_zext_7_0_out);
    
    
    ALU alu (ALUK, sr2mux_out, sr1_out, alu_out);
    
    NZP nzp (i_Clk, LD_CC, bus_out, n_out, z_out, p_out);
    
    MAR mar (i_Clk, LD_MAR, bus_out, mar_out);
    MDR mdr (i_Clk, LD_MDR, miomux_out, mdr_out);
    
    MIOMUX miomux (MIO_EN, bus_out, inmux_out, miomux_out);
    INMUX inmux (INMUX_SEL, kbdr_out, kbsr_out, dsr_out, mem_out, inmux_out);
    
    REGFILE regfile (i_Clk, DR, LD_REG, SR1_SEL, SR2_SEL, bus_out, sr1_out, sr2_out,
                     debug_r0_out,debug_r1_out,debug_r2_out,debug_r3_out,
                     debug_r4_out,debug_r5_out,debug_r6_out,debug_r7_out);
    
    MEMORY memory (i_Clk, RW, MEM_EN, mar_out, mdr_out, mem_out, R_OUT, R_MMIO);
    
    ADDR_CTRL addr_ctrl(mar_out, MIO_EN, RW, MEM_EN, INMUX_SEL, LD_KBSR, LD_DSR, LD_DDR, R_MMIO);
    KBDR kbdr (i_Clk, kbdr_ext_out, kbdr_out);
    KBSR kbsr (i_Clk, LD_KBSR, LD_KBSR_EXT, mdr_out, kbsr_ext_out, kbsr_out);
    DDR ddr   (i_Clk, LD_DDR, mdr_out, ddr_out);
    DSR dsr   (i_Clk, LD_DSR, LD_DSR_EXT, mdr_out, dsr_ext_out, dsr_out);
    
    BUS_DRIVER bus_driver (i_Clk, GateMARMUX, GateALU, GateMDR, GatePC, marmux_out, pc_out, alu_out, mdr_out, bus_out);
    
endmodule