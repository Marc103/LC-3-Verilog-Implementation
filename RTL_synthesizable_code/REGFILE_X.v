module Regfile (input clk,
                input reset_,
                input [2:0] dr,
                input ld_reg,
                input [2:0] sr1_sel,
                input [2:0] sr2_sel,
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
    FFReg R0 (.clk(clk),
              .ce(ld_r0),
              .reset_(reset_),
              .d(bus),
              .out(r0));

    wire [15:0] r1;
    FFReg R1 (.clk(clk),
              .ce(ld_r1),
              .reset_(reset_),
              .d(bus),
              .out(r1));

    wire [15:0] r2;
    FFReg R2 (.clk(clk),
              .ce(ld_r2),
              .reset_(reset_),
              .d(bus),
              .out(r2));

    wire [15:0] r3;
    FFReg R3 (.clk(clk),
              .ce(ld_r3),
              .reset_(reset_),
              .d(bus),
              .out(r3));

    wire [15:0] r4;
    FFReg R4 (.clk(clk),
              .ce(ld_r4),
              .reset_(reset_),
              .d(bus),
              .out(r4));

    wire [15:0] r5;
    FFReg R5 (.clk(clk),
              .ce(ld_r5),
              .reset_(reset_),
              .d(bus),
              .out(r5));

    wire [15:0] r6;
    FFReg R6 (.clk(clk),
              .ce(ld_r6),
              .reset_(reset_),
              .d(bus),
              .out(r6));

    wire [15:0] r7;
    FFReg R7 (.clk(clk),
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
            if(ld_reg)
                begin
                    case(dr)
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
     assign sr1 = sr1_sel[2] ? (sr1_sel[1] ? (sr1_sel[0] ? (r7) : (r6)) : (sr1_sel[0] ? (r5) : (r4))) : (sr1_sel[1] ? (sr1_sel[0] ? (r3) : (r2)) : (sr1_sel[0] ? (r1) : (r0)));
     assign sr2 = sr2_sel[2] ? (sr2_sel[1] ? (sr2_sel[0] ? (r7) : (r6)) : (sr2_sel[0] ? (r5) : (r4))) : (sr2_sel[1] ? (sr2_sel[0] ? (r3) : (r2)) : (sr2_sel[0] ? (r1) : (r0)));

endmodule


// FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
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


module StatusRegister (input clk,
                       input ld_sr,
                       input ld_sr_ext,
                       input reset_,
                       input [15:0] d,
                       input [15:0] d_ext,
                       output [15:0] out);
    reg sel;
    reg ld;
    always@(*)
        begin
            if(ld_sr) begin
                sel = 0;
                ld = 1;
            end
            else if (ld_sr_ext) begin
                sel = 1;
                ld = 1;
            end
            else begin
                sel = 0;
                ld = 0;
            end
        end
    
    wire [15:0] data;
    assign data = sel ? (d_ext) : (d);

    FFReg SR (.clk(clk),
              .ce(ld),
              .reset_(reset_),
              .d(data),
              .out(out));
endmodule






