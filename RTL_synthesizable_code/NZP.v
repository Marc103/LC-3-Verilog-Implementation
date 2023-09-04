module Nzp(input clk,
           input reset_,
           input ld_cc,
           input signed [15:0] bus,
           output [2:0] out);

    
    reg [2:0] bus_nzp;
    wire [2:0] nzp;
    
    FFReg #(3) NZP (.clk(clk),
                    .ce(ld_cc),
                    .reset_(reset_),
                    .d(bus_nzp),
                    .out(nzp));
    assign out = nzp;

    always @(*) 
        begin
            if(bus < 0) bus_nzp = 3'b100;
            else if(bus == 0) bus_nzp = 3'b010;
            else bus_nzp = 3'b001;
        end
    
endmodule