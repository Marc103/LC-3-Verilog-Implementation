module Regfile (input i_Clk,
                input reset_,
                input [2:0] DR,
                input LD_REG,
                input [2:0] SR1_SEL,
                input [2:0] SR2_SEL,
                input [15:0] bus,
                output [15:0] sr1,
                output [15:0] sr2);

    
    // GP registers
    reg ld_r0;
    reg ld_r1;
    reg ld_r2;
    reg ld_r3;
    reg ld_r4;
    reg ld_r5;
    reg ld_r6;
    reg ld_r7;

    wire [15:0] r0;
    FFReg R0 (.clk(i_Clk),
              .ce(ld_r0),
              .reset_(reset_),
              .d(bus),
              .out(r0));

    wire [15:0] r1;
    FFReg R1 (.clk(i_Clk),
              .ce(ld_r1),
              .reset_(reset_),
              .d(bus),
              .out(r1));

    wire [15:0] r2;
    FFReg R2 (.clk(i_Clk),
              .ce(ld_r2),
              .reset_(reset_),
              .d(bus),
              .out(r2));

    wire [15:0] r3;
    FFReg R3 (.clk(i_Clk),
              .ce(ld_r3),
              .reset_(reset_),
              .d(bus),
              .out(r3));

    wire [15:0] r4;
    FFReg R4 (.clk(i_Clk),
              .ce(ld_r4),
              .reset_(reset_),
              .d(bus),
              .out(r4));

    wire [15:0] r5;
    FFReg R5 (.clk(i_Clk),
              .ce(ld_r5),
              .reset_(reset_),
              .d(bus),
              .out(r5));

    wire [15:0] r6;
    FFReg R6 (.clk(i_Clk),
              .ce(ld_r6),
              .reset_(reset_),
              .d(bus),
              .out(r6));

    wire [15:0] r7;
    FFReg R7 (.clk(i_Clk),
              .ce(ld_r7),
              .reset_(reset_),
              .d(bus),
              .out(r7));
    
    // LD REG signal combinatorial logic
    always@(*)
        begin
            ld_r0 = 0;
            ld_r1 = 0;
            ld_r2 = 0;
            ld_r3 = 0;
            ld_r4 = 0;
            ld_r5 = 0;
            ld_r6 = 0;
            ld_r7 = 0;
            if(LD_REG)
                begin
                    case(DR)
                        3'b000: ld_r0 = 1;
                        3'b001: ld_r1 = 1;
                        3'b010: ld_r2 = 1;
                        3'b011: ld_r3 = 1;
                        3'b100: ld_r4 = 1;
                        3'b101: ld_r5 = 1;
                        3'b110: ld_r6 = 1;
                        3'b111: ld_r7 = 1;
                    endcase
                end
        end
    

    // Output combinatorial logic 
     assign sr1 = SR1_SEL[2] ? (SR1_SEL[1] ? (SR1_SEL[0] ? (r7) : (r6)) : (SR1_SEL[0] ? (r5) : (r4))) : (SR1_SEL[1] ? (SR1_SEL[0] ? (r3) : (r2)) : (SR1_SEL[0] ? (r1) : (r0)));
     assign sr2 = SR2_SEL[2] ? (SR2_SEL[1] ? (SR2_SEL[0] ? (r7) : (r6)) : (SR2_SEL[0] ? (r5) : (r4))) : (SR2_SEL[1] ? (SR2_SEL[0] ? (r3) : (r2)) : (SR2_SEL[0] ? (r1) : (r0)));

endmodule


// D Flip-Flop with Clock Enable and Asynchronous Clear
module FFReg #(parameter WIDTH = 16) 
              (input clk, 
               input ce,
               input reset_, 
               input [WIDTH-1:0] d, 
               output [WIDTH-1:0] out);
               
    reg [WIDTH-1:0] register = 16'h0000;
    
    always@(posedge clk or negedge reset_)
        if(~reset_) register <= 0;
        else if(ce) register <= d;
    
    assign out = register;
    
endmodule






module KBSR(input i_Clk,
            input LD_KBSR,
            input LD_KBSR_EXT,
            input [15:0] MDR_OUT,
            input [15:0] EXT_OUT,
            output reg [15:0] OUT = 16'h0000);
    always @(posedge i_Clk)
        begin
            if(LD_KBSR) OUT <= MDR_OUT;
            else if(LD_KBSR_EXT) OUT <= EXT_OUT;
        end
endmodule



module DSR(input i_Clk,
           input LD_DSR,
           input LD_DSR_EXT,
           input [15:0] MDR_OUT,
           input [15:0] EXT_OUT,
           output reg [15:0] OUT = 16'h0000);

    always @(posedge i_Clk)
        begin
            if(LD_DSR) OUT <= MDR_OUT;
            if(LD_DSR_EXT) OUT <= EXT_OUT;
        end
endmodule





