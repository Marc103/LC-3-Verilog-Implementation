module SEXT_10_0(input [10:0] d,
                output [15:0] out);
    assign out = {{5{d[10]}}, d};
endmodule  

module SEXT_8_0(input [8:0] d,
                output [15:0] out);
    assign out = {{7{d[8]}}, d};
endmodule  

module SEXT_5_0(input [5:0] d,
                output [15:0] out);
    assign out = {{10{d[5]}}, d};
endmodule  

module SEXT_4_0(input [4:0] d,
                output [15:0] out);
    assign out = {{11{d[4]}}, d};
endmodule
