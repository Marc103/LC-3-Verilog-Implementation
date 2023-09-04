module Alu #(parameter WIDTH = 16)
            (input [1:0] aluk,
             input [WIDTH-1:0] a,
             input [WIDTH-1:0] b,
             output reg [WIDTH-1:0] out = 16'h0000);

    always@(*)
        begin
            case (aluk)
            2'b00:   // ADD
                out = a + b;
            2'b01:   // AND
                out = a & b;
            2'b10:   // NOT
                out = ~a;
            2'b11: // PASSA
                out = a;
            endcase
        end
endmodule

module Adder #(parameter WIDTH = 16) 
              (input [WIDTH-1:0] d0,
               input [WIDTH-1:0] d1,
               output [WIDTH-1:0] out);
    assign out = d0 + d1;
endmodule

module Increment(input [15:0] d,
                    output [15:0] out);
    assign out = d + 1;
endmodule 