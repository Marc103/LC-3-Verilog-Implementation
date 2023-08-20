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
                
                input [1:0] ALUK,

                wire [15:0] bus_out,                // shared (one or more)
                wire [15:0] pc_out,
                wire [15:0] pc_out_inc,
                
                // reg file 
                wire [15:0] sr1_out,
                wire [15:0] sr2_out,

                // muxes
                wire [15:0] pcmux_out,
                wire [15:0] marmux_out,
                wire [15:0] addr1mux_out,
                wire [15:0] addr2mux_out,
                wire [15:0] addrmux_adder_out,
                
                // sign extensions
                wire [15:0] ir_zext_7_0_out,
                wire [15:0] ir_sext_10_0_out,       
                wire [15:0] ir_sext_8_0_out,
                wire [15:0] ir_sext_5_0_out,
                wire [15:0] addr2mux_to_bus_driver

                  

                );


    MARMUX marmux (MARMUX_SEL, ir_zext_7_0_out, addrmux_adder_out, marmux_out);   
    
    ADDR1MUX addr1mux (ADDR1MUX_SEL, pc_out, sr1_out, addr1mux_out);
    ADDR2MUX addr2mux (ADDR2MUX_SEL, ir_sext_10_0_out, ir_sext_8_0_out, ir_sext_5_0_out, addr2mux_out);
    ADDRMUX_ADDER addrmux_adder (addr1mux_out, addr2mux_out, addrmux_adder_out);
    
    PCMUX pcmux(PCMUX_SEL, bus_out, addrmux_adder_out, pc_out_inc, pcmux_out);
    PC_INCREMENT pc_increment (pc_out, pc_out_inc);
    PC pc (LD_PC, pcmux_out);
    

endmodule