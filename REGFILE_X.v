module REGFILE(input i_Clk,
               input [2:0] DR,
               input LD_REG,
               input [2:0] SR1_SEL,
               input [2:0] SR2_SEL,
               input [15:0] BUS_OUT,
               output reg [15:0] SR1_OUT = 16'h0000,
               output reg [15:0] SR2_OUT = 16'h0000,
               output [15:0] debug_r0,
               output [15:0] debug_r1,
               output [15:0] debug_r2,
               output [15:0] debug_r3,
               output [15:0] debug_r4,
               output [15:0] debug_r5,
               output [15:0] debug_r6,
               output [15:0] debug_r7);

    // GP registers
    reg [15:0] r0 = 16'h0058;
    reg [15:0] r1 = 16'hff00;
    reg [15:0] r2 = 16'h0001;
    reg [15:0] r3 = 16'h0002;
    reg [15:0] r4 = 16'h0000;
    reg [15:0] r5 = 16'h0000;
    reg [15:0] r6 = 16'h0000;
    reg [15:0] r7 = 16'h0000;
    
    assign debug_r0 = r0;
    assign debug_r1 = r1;
    assign debug_r2 = r2;
    assign debug_r3 = r3;
    assign debug_r4 = r4;
    assign debug_r5 = r5;
    assign debug_r6 = r6;
    assign debug_r7 = r7;
    
    // LD_REG 
    always @(posedge i_Clk)
        begin
            if(LD_REG)
                begin
                    case (DR)
                    3'b000:
                        r0 <= BUS_OUT;
                    3'b001:
                        r1 <= BUS_OUT;
                    3'b010:
                        r2 <= BUS_OUT;
                    3'b011:
                        r3 <= BUS_OUT;
                    3'b100:
                        r4 <= BUS_OUT;
                    3'b101:
                        r5 <= BUS_OUT;
                    3'b110:
                        r6 <= BUS_OUT;
                    3'b111:
                        r7 <= BUS_OUT;
                    endcase
                end
        end

    // SR1 MUX
    always@(*)
        begin
            case (SR1_SEL)
            3'b000:
                SR1_OUT <= r0;
            3'b001:
                SR1_OUT <= r1;
            3'b010:
                SR1_OUT <= r2;
            3'b011:
                SR1_OUT <= r3;
            3'b100:
                SR1_OUT <= r4;
            3'b101:
                SR1_OUT <= r5;
            3'b110:
                SR1_OUT <= r6;
            3'b111:
                SR1_OUT <= r7;  
            endcase
        end
    
    // SR2 MUX
    always@(*)
        begin
            case (SR2_SEL)
            3'b000:
                SR2_OUT <= r0;
            3'b001:
                SR2_OUT <= r1;
            3'b010:
                SR2_OUT <= r2;
            3'b011:
                SR2_OUT <= r3;
            3'b100:
                SR2_OUT <= r4;
            3'b101:
                SR2_OUT <= r5;
            3'b110:
                SR2_OUT <= r6;
            3'b111:
                SR2_OUT <= r7;  
            endcase
        end
endmodule

module PC(input i_Clk,
          input LD_PC,
          input [15:0] PCMUX_OUT,
          output reg [15:0] OUT = 16'h0000);
          
    always @(posedge i_Clk)
        begin
            if(LD_PC) OUT <= PCMUX_OUT;   
        end
endmodule

module IR(input i_Clk,
          input LD_IR,
          input [15:0] BUS,
          output reg [15:0] OUT = 16'h0000);


    always @(posedge i_Clk)
        begin
            if(LD_IR) OUT <= BUS;
        end
endmodule

module MAR(input i_Clk,
           input LD_MAR,
           input [15:0] BUS_OUT,
           output reg [15:0] OUT = 16'h0000);

    always @(posedge i_Clk)
        begin
            if(LD_MAR) OUT <= BUS_OUT;
        end
endmodule

module MDR(input i_Clk,
           input LD_MDR,
           input [15:0] MIOMUX_OUT,
           output reg [15:0] OUT = 16'h0000);

    always @(posedge i_Clk)
        begin
            if(LD_MDR) OUT <= MIOMUX_OUT;
        end
endmodule
// For SRs basic flow will be:
// 0 - No data being requested/outputted (nothing to be done) <Host signal>
// 1 - Awaiting Data in XX DR                                 <Host signal> now input/output device acts
// 2 - Data loaded in/out XX DR from input/output device      <Input device signal> after input/output device is done
// The address control unit 

module KBDR(input i_Clk,
            input [15:0] EXT_OUT,
            output reg [15:0] OUT = 16'h0000);

    always @(posedge i_Clk)
        begin
            OUT <= EXT_OUT;
        end
endmodule

module KBSR(input i_Clk,
            input LD_KBSR,
            input LD_KBSR_EXT,
            input [15:0] MDR_OUT,
            input [15:0] EXT_OUT,
            output reg [15:0] OUT = 16'h0000);
    always @(posedge i_Clk)
        begin
            if(LD_KBSR) OUT <= MDR_OUT;
            else if(LD_KBSR_EXT) OUT <= EXT_OUT;
        end
endmodule

module DDR(input i_Clk,
           input LD_DDR,
           input [15:0] MDR_OUT,
           output reg [15:0] OUT = 16'h0000);

    always @(posedge i_Clk)
        begin
            if(LD_DDR) OUT <= MDR_OUT;
        end
endmodule

module DSR(input i_Clk,
           input LD_DSR,
           input LD_DSR_EXT,
           input [15:0] MDR_OUT,
           input [15:0] EXT_OUT,
           output reg [15:0] OUT = 16'h0000);

    always @(posedge i_Clk)
        begin
            if(LD_DSR) OUT <= MDR_OUT;
            if(LD_DSR_EXT) OUT <= EXT_OUT;
        end
endmodule





