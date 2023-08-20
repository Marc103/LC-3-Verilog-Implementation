/*
For now we will be dealing with the following gates
(see appendix C.3 "The Data Path")
1. GateMARMUX
2. GatePC
3. GateALU
4. GateMDR 
 
 The combinational logic will determine the signals,
 the sequential part will 'do things' until the next state is determined 
 When reading from the bus, how can we control when it is done?
 
 I think we can deal with cycle accurate instructions later.

 lets wire up the datapath
*/

module BUS_DRIVER(input i_Clk,
                  input GateMARMUX,
                  input GateALU,
                  input GateMDR,
                  input GatePC,
                  input [15:0] MARMUX_OUT,
                  input [15:0] PC_OUT,
                  input [15:0] ALU_OUT,
                  input [15:0] MDR_OUT,
                  output reg [15:0] BUS);

    always@(posedge i_Clk)
        begin
            if(GateMARMUX)   BUS <= MARMUX_OUT;
            else if(GateALU) BUS <= ALU_OUT;
            else if(GateMDR) BUS <= MDR_OUT;
        end

endmodule