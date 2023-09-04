/*
For now we will be dealing with the following gates
(see appendix C.3 "The Data Path")
BUS_SEL signal mappings
0. GateMARMUX
1. GatePC
2. GateALU
3. GateMDR 
 
*/

module Bus_Driver(input clk,
                  input reset_,
                  input [1:0] bus_sel,
                  input ld_bus,
                  input [15:0] marmux,
                  input [15:0] pc,
                  input [15:0] alu,
                  input [15:0] mdr,
                  output wire [15:0] bus);

    reg [15:0] in;

    FFReg BUS (.clk(clk),
               .ce(ld_bus),
               .reset_(reset_),
               .d(in),
               .out(bus));

    always@(*)
        begin
            case(bus_sel)
            2'b00: in = marmux;
            2'b01: in = pc;
            2'b10: in = alu;
            2'b11: in = mdr;
            endcase 
        end

    

endmodule