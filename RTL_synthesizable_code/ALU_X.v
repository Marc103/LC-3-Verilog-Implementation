module Alu #(parameter WIDTH = 16)
            (input [1:0] aluk,
             input [WIDTH-1:0] a,
             input [WIDTH-1:0] b,
             output reg [WIDTH-1:0] out = 16'h0000);

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

module Adder #(parameter WIDTH = 16) 
              (input [WIDTH-1:0] d0,
               input [WIDTH-1:0] d1,
               output [WIDTH-1:0] out);
    assign out = d0 + d1;
endmodule

module PC_INCREMENT(input [15:0] PC,
                    output [15:0] PC_INC);
    assign PC_INC = PC_INC + 1;
endmodule 