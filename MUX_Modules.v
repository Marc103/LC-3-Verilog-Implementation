module SR2MUX(input IR_5,
              input [4:0] IR_SEXT_4_0,
              input [15:0] SR2OUT,
              output [15:0] OUT);
    reg [15:0] Result;
    
    always@(*)
        begin
            case (IR_5)
            1'b0: 
                Result = IR_SEXT_4_0;
            1'b1:
                Result = SR2OUT; 
            endcase
        end

    assign OUT = Result;
endmodule

module ADDR1MUX(input ADDR1MUX_SEL,
                input [15:0] PC,
                input [15:0] SR1OUT,
                output [15:0] OUT);
    reg [15:0] Result;

    always@(*)
        begin
            case(ADDR1MUX_SEL)
            1'b0:
                Result = PC;
            1'b1:
                Result = SR1OUT;
            endcase
        end

    assign OUT = Result;
endmodule

module ADDR2MUX(input [1:0] ADDR2MUX_SEL,
                input [15:0] IR_SEXT_10_0,
                input [15:0] IR_SEXT_8_0,
                input [15:0] IR_SEXT_5_0,
                output [15:0] OUT);
    reg [15:0] Result;

    always@(*)
        begin
            case(ADDR2MUX_SEL)
            2'b00:
                Result = IR_SEXT_10_0;
            2'b01:
                Result = IR_SEXT_8_0;
            2'b10:
                Result = IR_SEXT_5_0;
            2'b11:
                Result = 16'b0000000000000000;
            endcase 
        end

    assign OUT = Result;
endmodule

module MARMUX(input MARMUX_SEL,
              input [15:0] IR_ZEXT_7_0,
              input [15:0] ADDRMUX_ADDER_OUT);
    reg [15:0] Result;

    always@(*)
        begin
            case(MARMUX_SEL)
            1'b0:
                Result = IR_ZEXT_7_0;
            1'b1:
                Result = ADDRMUX_ADDER_OUT;
            endcase
        end

    assign OUT = Result;
endmodule
