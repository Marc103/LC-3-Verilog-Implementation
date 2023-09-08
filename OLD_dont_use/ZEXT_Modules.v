module ZEXT_7_0(input [7:0] IR_7_0,
                output [15:0] OUT);
    assign OUT = {{8{1'b0}}, IR_7_0};
endmodule  