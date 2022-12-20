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
            default: // PASSA
                Result = A;
            endcase
        end

    assign OUT = Result;
endmodule