module MUX2 #(parameter WIDTH = 16) 
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

module MUX4 #(parameter WIDTH = 16) 
              (input [1:0] sel,
               input [WIDTH-1: 0] d0,
               input [WIDTH-1: 0] d1,
               input [WIDTH-1: 0] d2,
               input [WIDTH-1: 0] d3,
               output reg [WIDTH-1:0] out);
    always@(*)
        begin
            case (sel)
            2'b00: out = d0;
            2'b01: out = d1;
            2'b10: out = d2;
            2'b11: out = d3;
            endcase
        end
endmodule


