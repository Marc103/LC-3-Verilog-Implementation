module SR2MUX(input SR2MUX_SEL,
              input [4:0] IR_SEXT_4_0_OUT,
              input [15:0] SR2_OUT,
              output reg [15:0] OUT);
    
    always@(*)
        begin
            case (SR2MUX_SEL)
            1'b0: 
                OUT = IR_SEXT_4_0_OUT;
            1'b1:
                OUT = SR2_OUT; 
            endcase
        end
endmodule

module ADDR1MUX(input ADDR1MUX_SEL,
                input [15:0] PC_OUT,
                input [15:0] SR1_OUT,
                output reg [15:0] OUT);

    always@(*)
        begin
            case(ADDR1MUX_SEL)
            1'b0:
                OUT = PC;
            1'b1:
                OUT = SR1_OUT;
            endcase
        end
endmodule

module ADDR2MUX(input [1:0] ADDR2MUX_SEL,
                input [15:0] IR_SEXT_10_0_OUT,
                input [15:0] IR_SEXT_8_0_OUT,
                input [15:0] IR_SEXT_5_0_OUT,
                output reg [15:0] OUT);

    always@(*)
        begin
            case(ADDR2MUX_SEL)
            2'b00:
                OUT = IR_SEXT_10_0_OUT;
            2'b01:
                OUT = IR_SEXT_8_0_OUT;
            2'b10:
                OUT = IR_SEXT_5_0_OUT;
            2'b11:
                OUT = 16'b0000000000000000;
            endcase 
        end
endmodule

module MARMUX(input MARMUX_SEL,
              input [15:0] IR_ZEXT_7_0_OUT,
              input [15:0] ADDRMUX_ADDER_OUT,
              output reg [15:0] OUT);

    always@(*)
        begin
            case(MARMUX_SEL)
            1'b0:
                OUT = IR_ZEXT_7_0;
            1'b1:
                OUT = ADDRMUX_ADDER_OUT;
            endcase
        end
endmodule

module PCMUX(input [1:0] PCMUX_SEL,
             input [15:0] BUS_OUT,
             input [15:0] ADDRMUX_ADDER_OUT,
             input [15:0] PC_OUT_INC,
             output reg [15:0] OUT);

    always@(*)
        begin
            case(PCMUX_SEL)
            2'b00:
                OUT = BUS_OUT;
            2'b01:
                OUT = ADDRMUX_ADDER_OUT;
            2'b10:
                OUT = PC_OUT_INC;
            2'b11:
                OUT = 16'b0000000000000000;
            endcase
        end
endmodule

module INMUX(input [1:0] INMUX_SEL,
             input [15:0] KBDR_OUT,
             input [15:0] KBSR_OUT,
             input [15:0] DSR_OUT,
             input [15:0] MEM_OUT,
             output reg [15:0] OUT);

    always@(*)
        begin
            case(INMUX_SEL)
            2'b00:
                OUT = KBDR_OUT;
            2'b01:
                OUT = KBSR_OUT;
            2'b10:
                OUT = DSR_OUT;
            2'b11:
                OUT = MEM_OUT;
            endcase
        end
endmodule

module MIOMUX(input MIO_EN,
              input [15:0] BUS_OUT,
              input [15:0] INMUX_OUT,
              output [15:0] OUT);

    always@(*)
        begin
            case(MIO_EN)
            1'b0:
                OUT = INMUX_OUT;
            1'b11:
                OUT = BUS_OUT;
            endcase
        end
endmodule

