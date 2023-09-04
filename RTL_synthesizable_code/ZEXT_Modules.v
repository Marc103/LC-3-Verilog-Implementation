module ZEXT_7_0(input [7:0] d,
                output [15:0] out);
    assign out = {{8{1'b0}}, d};
endmodule  