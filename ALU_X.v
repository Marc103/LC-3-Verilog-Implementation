module ALU(input [1:0] ALUK,
           input [15:0] A,
           input [15:0] B,
           output reg [15:0] OUT = 16'h0000);

    always@(*)
        begin
            case (ALUK)
            2'b00:   // ADD
                OUT = A + B;
            2'b01:   // AND
                OUT = A & B;
            2'b10:   // NOT
                OUT = ~A;
            2'b11: // PASSA
                OUT = A;
            endcase
        end
endmodule

module ADDRMUX_ADDER(input [15:0] ADDR1MUX_OUT,
                     input [15:0] ADDR2MUX_OUT,
                     output [15:0] OUT);
    assign OUT = ADDR1MUX_OUT + ADDR2MUX_OUT;
endmodule

module PC_INCREMENT(input [15:0] PC_OUT,
                    output [15:0] PC_OUT_INC);
    assign PC_OUT_INC = PC_OUT + 1;
endmodule 