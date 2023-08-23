module DATAPATH(input i_Clk,
                input SR2MUX_SEL, 
                input ADDR1MUX_SEL,
                input ADDR2MUX_SEL,
                input MARMUX_SEL,
                input PCMUX_SEL,
                input INMUX_SEL,
                input MIO_EN,

                input RW,         // ******************
                input MEM_EN,     // MEMORY SIGNALs

                input DR,         // ******************
                input LD_REG,     // REGFILE SIGNALs
                input SR1_SEL,    //
                input SR2_SEL,    //     

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

                wire [15:0] bus_out,                // shared (one or more)
                wire [15:0] pc_out,
                wire [15:0] pc_out_inc,
                wire [15:0] ir_out,
                
                // reg file 
                wire [15:0] sr1_out,
                wire [15:0] sr2_out,

                // muxes
                wire [15:0] pcmux_out,
                wire [15:0] marmux_out,
                wire [15:0] addr1mux_out,
                wire [15:0] addr2mux_out,
                wire [15:0] addrmux_adder_out,
                wire [15:0] sr2mux_out,
                wire [15:0] miomux_out,
                wire [15:0] inmux_out,
                
                // sign extensions
                wire [15:0] ir_zext_7_0_out,
                wire [15:0] ir_sext_10_0_out,       
                wire [15:0] ir_sext_8_0_out,
                wire [15:0] ir_sext_5_0_out,
                wire [15:0] ir_sext_4_0_out,
                wire [15:0] ir_zext_7_0_out,
                
                wire [15:0] alu_out,
                
                wire n_out,
                wire p_out,
                wire z_out,
                
                wire [15:0] mar_out,
                wire [15:0] mdr_out,
                
                wire [15:0] mem_out,
                wire R_OUT,
                
                wire [15:0] input_kbdr,
                wire [15:0] output_dsr,
                wire [15:0] kbdr_out,
                wire [15:0] kbsr_out,
                wire [15:0] dsr_out
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
    MDR mdr (i_Clk, LD_MDR, bus_out, mdr_out);
    
    MIOMUX miomux (MIO_EN, bus_out, inmux_out, miomux_out);
    INMUX inmux (INMUX_SEL, kbdr_out, kbsr_out, dsr_out, mem_out, inmux_out);
    
    REGFILE regfile (i_Clk, DR, LD_REG, SR1_SEL, SR2_SEL, bus_out, sr1_out, sr2_out);
    
    MEMORY memory (i_Clk, RW, MEM_EN, mar_out, mdr_out, mem_out, R_OUT);
    
    ADDR_CTRL addr_ctrl(mar_out, MIO_EN, RW, MEM_EN, INMUX_SEL, LD_KBSR, LD_DSR, LD_DDR);
    KBDR kbdr (i_Clk, input_kbdr, kbdr_out);
    KBSR kbsr (i_Clk, LD_KBSR, input_kbsr, mar_out, kbsr_out);
    DDR ddr   (i_Clk, LD_DDR, mar_out, dsr_out);
    DSR dsr   (i_Clk, LD_DSR, output_dsr, mar_out, dsr_out);
    
    BUS_DRIVER bus_driver (i_Clk, GateMARMUX, GateALU, GateMDR, GatePC, marmux_out, pc_out, alu_out, mdr_out, bus_out);
    
endmodule