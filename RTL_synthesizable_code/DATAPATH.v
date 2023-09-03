module DATAPATH(input i_Clk,
                input reset,
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
                input [15:0] dsr_ext_out );

    Alu ALU (.aluk(),
             .a(),
             .b(),
             .out());
    
    
    // Registers
    FFReg IR (.clk(i_Clk),
              .ce(LD_IR),
              .r(reset),
              .d()
              .out(ir));
    wire [15:0] ir;

    FFReg PC (.clk(i_Clk),
              .ce(LD_PC),
              .r(reset),
              .d()
              .out(pc));
    wire [15:0] pc;

    FFReg MAR (.clk(i_Clk),
               .ce(LD_MAR),
               .r(reset),
               .d()
               .out(mar));
    wire [15:0] mar;
    
    FFReg MDR (.clk(i_Clk),
               .ce(LD_MDR),
               .r(reset),
               .d()
               .out(mdr));
    wire [15:0] mdr;



    // Muxes
    2MUX1 MARMUX (.sel(MARMUX_SEL),
                  .d0(),
                  .d1(),
                  .out(marmux));
    wire [15:0] marmux; 

    2MUX1 ADDR1MUX (.sel(),
                    .d0(),
                    .d1(),
                    .out(addr1mux));
    wire [15:0] addr1mux;

    2MUX1 SR2MUX (.sel(),
                  .d0(),
                  .d1(),
                  .out(sr2mux));
    wire [15:0] sr2mux;

    2MUX1 MIOMUX (.sel(),
                  .d0(),
                  .d1(),
                  .out(miomux));
    wire [15:0] miomux;

    4MUX2 PCMUX (.sel(),
                 .d0(),
                 .d1(),
                 .d2(),
                 .d3(),
                 .out(pcmux));
    wire [15:0] pcmux;

    4MUX2 ADDR2MUX (.sel(),
                    .d0(),
                    .d1(),
                    .d2(),
                    .d3(),
                    .out(addr2mux));
    wire [15:0] addr2mux;

    4MUX2 INMUX    (.sel(),
                    .d0(),
                    .d1(),
                    .d2(),
                    .d3(),
                    .out(inmux));
    wire [15:0] inmux;




    

    
endmodule