module ALU(input [1:0] ALUK,
           input [15:0] A,
           input [15:0] B,
           output [15:0] OUT);

    reg [15:0] Result;

    always@(*)
        begin
            case (ALUK)
            2'b00:   // ADD
                Result = A + B;
            2'b01:   // AND
                Result = A & B;
            2'b10:   // NOT
                Result = ~A;
            2'b11: // PASSA
                Result = A;
            endcase
        end

    assign OUT = Result;
endmodule

module ADDRMUX_ADDER(input [15:0] ADDR1MUX_OUT,
                     input [15:0] ADDR2MUX_OUT,
                     output [15:0] OUT);
    assign OUT = ADDR1MUX_OUT + ADDR2MUX_OUT;
endmodule

module PC_INCREMENT(input [15:0] PC,
                    output [15:0] OUT);
    assign OUT = PC + 1;
endmodule 