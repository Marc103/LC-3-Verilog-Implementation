module DATAPATH(input i_Clk,
                input reset_,
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

                input [1:0] BUS_SEL,
                
                input LD_CC,
                input LD_IR,
                input LD_PC,
                input LD_MAR,
                input LD_MDR,
                input LD_BUS,
                
                input [1:0] ALUK,
                input LD_KBDR_EXT,
                input LD_KBSR_EXT,
                input LD_DSR_EXT,
                input [15:0] kbdr_ext,
                input [15:0] kbsr_ext,
                input [15:0] dsr_ext,
                
                output R,
                output [15:0] ir,
                output [2:0] nzp,
                output [15:0] ddr,
                output [15:0] dsr,
                output [15:0] kbdr,
                output [15:0] kbsr,
                
                output [15:0] debug_mdr,
                output [15:0] debug_mar,
                output [15:0] debug_memory,
                output [15:0] debug_bus,
                output [15:0] debug_r0,
                output [15:0] debug_r1,
                output [15:0] debug_r2,
                output [15:0] debug_r3,
                output [15:0] debug_r4,
                output [15:0] debug_r5,
                output [15:0] debug_r6,
                output [15:0] debug_r7,
                output [15:0] debug_pc
                );

    // Datapath Wires
    wire [15:0] alu_results;
    wire [15:0] bus;
    wire [15:0] sr1;
    wire [15:0] sr2;
    wire [15:0] memory;
    wire MEM_EN;
    wire [1:0] INMUX_SEL;
    wire LD_KBSR;
    wire LD_DDR;
    wire LD_DSR;
    wire [15:0] pc;
    wire [15:0] mar;
    wire [15:0] mdr;
    wire [15:0] marmux;
    wire [15:0] addr1mux;
    wire [15:0] sr2mux;
    wire [15:0] miomux;
    wire [15:0] pcmux;
    wire [15:0] addr2mux;
    wire [15:0] inmux;
    wire [15:0] ir_s_10_0;
    wire [15:0] ir_s_8_0;
    wire [15:0] ir_s_5_0;
    wire [15:0] ir_s_4_0;
    wire [15:0] ir_z_7_0;
    wire [15:0] pc_inc;
    wire [15:0] addrmuxes_added;
    
    // Debug wires
    assign debug_mdr = mdr;
    assign debug_mar = mar;
    assign debug_memory = memory;
    assign debug_bus = bus;
    assign debug_pc = pc;
    
    // ALU
    Alu ALU (.aluk(ALUK),
             .a(sr1),
             .b(sr2mux),
             .out(alu_results));
    
    // NZP
    Nzp NZP (.clk(i_Clk),
             .ld_cc(LD_CC),
             .reset_(reset_),
             .bus(bus),
             .out(nzp));
    
    // Bus
    Bus_Driver BUS_DRIVER (.clk(i_Clk),
                           .reset_(reset_),
                           .bus_sel(BUS_SEL),
                           .ld_bus(LD_BUS),
                           .marmux(marmux),
                           .pc(pc),
                           .alu(alu_results),
                           .mdr(mdr),
                           .bus(bus));

    // Reg file
    Regfile REGFILE (.clk(i_Clk),
                     .reset_(reset_),
                     .dr(DR),
                     .ld_reg(LD_REG),
                     .sr1_sel(SR1_SEL),
                     .sr2_sel(SR2_SEL),
                     .bus(bus),
                     .sr1(sr1),
                     .sr2(sr2),
                     .debug_r0(debug_r0),
                     .debug_r1(debug_r1),
                     .debug_r2(debug_r2),
                     .debug_r3(debug_r3),
                     .debug_r4(debug_r4),
                     .debug_r5(debug_r5),
                     .debug_r6(debug_r6),
                     .debug_r7(debug_r7));
    
    // Memory
    Sram sram (.clk(i_Clk),
               .data(mdr),
               .addr(mar),
               .mem_en(MEM_EN),
               .rw(RW),
               .r(R),
               .out(memory));

    // Address Control Unit
    AddrCtrl addr_ctrl(.mar(mar),
                      .mio_en(MIO_EN),
                      .rw(RW),
                      .mem_en(MEM_EN),
                      .inmux_sel(INMUX_SEL),
                      .ld_kbsr(LD_KBSR),
                      .ld_ddr(LD_DDR),
                      .ld_dsr(LD_DSR));
    
    // Registers 
    FFReg IR (.clk(i_Clk),
              .ce(LD_IR),
              .reset_(reset_),
              .d(bus),
              .out(ir));
    
    FFReg PC (.clk(i_Clk),
              .ce(LD_PC),
              .reset_(reset_),
              .d(pcmux),
              .out(pc));

    FFReg MAR (.clk(i_Clk),
               .ce(LD_MAR),
               .reset_(reset_),
               .d(bus),
               .out(mar));
    
    FFReg MDR (.clk(i_Clk),
               .ce(LD_MDR),
               .reset_(reset_),
               .d(miomux),
               .out(mdr));
    
    // Muxes
    MUX2 MARMUX (.sel(MARMUX_SEL),
                  .d0(ir_z_7_0),
                  .d1(addrmuxes_added),
                  .out(marmux));

    MUX2 ADDR1MUX (.sel(ADDR1MUX_SEL),
                    .d0(sr1),
                    .d1(pc),
                    .out(addr1mux));
    
    MUX2 SR2MUX (.sel(SR2MUX_SEL),
                  .d0(ir_s_4_0),
                  .d1(sr2),
                  .out(sr2mux));
    
    MUX2 MIOMUX (.sel(MIO_EN),
                  .d0(bus),
                  .d1(inmux),
                  .out(miomux));
    
    MUX4 PCMUX (.sel(PCMUX_SEL),
                 .d0(bus),
                 .d1(addrmuxes_added),
                 .d2(pc_inc),
                 .d3(16'h0000),
                 .out(pcmux));
    
    MUX4 ADDR2MUX (.sel(ADDR2MUX_SEL),
                    .d0(ir_s_10_0),
                    .d1(ir_s_8_0),
                    .d2(ir_s_5_0),
                    .d3(16'h0000),
                    .out(addr2mux));
    
    MUX4 INMUX    (.sel(INMUX_SEL),
                    .d0(kbdr),
                    .d1(kbsr),
                    .d2(dsr),
                    .d3(memory),
                    .out(inmux));


    // Extenders
    SEXT_10_0 s_10_0 (.d(ir[10:0]),
                      .out(ir_s_10_0));
    
    SEXT_8_0 s_8_0 (.d(ir[8:0]),
                    .out(ir_s_8_0));
    
    SEXT_5_0 s_5_0 (.d(ir[5:0]),
                    .out(ir_s_5_0));

    SEXT_4_0 s_4_0 (.d(ir[4:0]),
                    .out(ir_s_4_0));
    
    ZEXT_7_0 z_7_0 (.d(ir[7:0]),
                    .out(ir_z_7_0));


    // IO related
    FFReg KBDR (.clk(i_Clk),
                .ce(LD_KBDR_EXT),
                .reset_(reset_),
                .d(kbdr_ext),
                .out(kbdr));

    StatusRegister KBSR (.clk(i_Clk),
                         .ld_sr(LD_KBSR),
                         .ld_sr_ext(LD_KBSR_EXT),
                         .reset_(reset_),
                         .d(bus),
                         .d_ext(kbsr_ext),
                         .out(kbsr));

    FFReg DDR (.clk(i_Clk),
                .ce(LD_DDR),
                .reset_(reset_),
                .d(bus),
                .out(ddr));
    
    StatusRegister DSR (.clk(i_Clk),
                         .ld_sr(LD_DSR),
                         .ld_sr_ext(LD_DSR_EXT),
                         .reset_(reset_),
                         .d(bus),
                         .d_ext(dsr_ext),
                         .out(dsr));
    

    // Intermediate
    Increment pci (.d(pc),
                   .out(pc_inc));
    
    Adder addrmux_adder(.d0(addr1mux),
                        .d1(addr2mux),
                        .out(addrmuxes_added));
    
endmodule