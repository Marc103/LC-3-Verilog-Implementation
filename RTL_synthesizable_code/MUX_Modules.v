module 2MUX1 #(parameter WIDTH = 16) 
              (input sel,
               input [WIDTH-1: 0] d0,
               input [WIDTH-1: 0] d1,
               output reg [WIDTH-1:0] out);
    always@(*)
        begin
            case (sel)
            1'b0: out = d0;
            1'b1: out = d1;
            endcase
        end
endmodule

module 4MUX2 #(parameter WIDTH = 16) 
              (input [1:0] sel,
               input [WIDTH-1: 0] d0,
               input [WIDTH-1: 0] d1,
               input [WIDTH-1: 0] d2,
               input [WIDTH-1: 0] d3,
               output reg [WIDTH-1:0] out);
    always@(*)
        begin
            case (sel)
            1'b00: out = d0;
            1'b01: out = d1;
            1'b10: out = d2;
            1'b11: out = d3;
            endcase
        end
endmodule


