/*
For now we will be dealing with the following gates
(see appendix C.3 "The Data Path")
1. GateMARMUX
2. GatePC
3. GateALU
4. GateMDR 
 
 and have one control signal determine what drives the bus
 (basically another MUX).
 This makes it simple and is possible because at any given moment
 only one output can drive the bus anyway.
*/

module BUS_DRIVER(input [1:0] BUS_SEL,
                  input [15:0] MARMUX_OUT,
                  input [15:0] PC_OUT,
                  input [15:0] ALU_OUT,
                  input [15:0] MDR_OUT,
                  output [15:0] BUS);
    reg [15:0] Result; 

    always@(*)
        begin
            case (BUS_SEL)
            2'b00:  // GateMARMUX
                Result = MARMUX_OUT;
            2'b01:  // GatePC
                Result = PC_OUT;
            2'b10:  // GateALU
                Result = ALU_OUT;
            2'b11:  // GateMDR
                Result = MDR_OUT;
            endcase
        end

    assign BUS = Result;

endmodule