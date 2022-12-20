module SEXT_10_0(input [10:0] IR_10_0,
                output [15:0] OUT);
    assign OUT = {IR_10_0[10], IR_10_0}
endmodule  

module SEXT_8_0(input [8:0] IR_8_0,
                output [15:0] OUT);
    assign OUT = {IR_8_0[8], IR_8_0}
endmodule  

module SEXT_5_0(input [5:0] IR_5_0,
                output [15:0] OUT);
    assign OUT = {IR_5_0[5], IR_5_0}
endmodule  

module SEXT_4_0(input [4:0] IR_4_0,
                output [15:0] OUT);
    assign OUT = {IR_4_0[4], IR_4_0}
endmodule
