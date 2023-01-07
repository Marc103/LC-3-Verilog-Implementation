module REGFILE(input i_Clk,
               input [15:0] BUS,
               input [2:0] DR,
               input LD_REG,
               input [2:0] SR1_SEL,
               input [2:0] SR2_SEL,
               output [15:0] SR1_OUT
               output [15:0] SR2_OUT)
    // GP registers
    reg [15:0] r0;
    reg [15:0] r1;
    reg [15:0] r2;
    reg [15:0] r3;
    reg [15:0] r4;
    reg [15:0] r5;
    reg [15:0] r6;
    reg [15:0] r7;
    
    reg [15:0] Result_SR1;
    reg [15:0] Result_SR2;

    // LD_REG 
    always @(posedge i_Clk)
        begin
            if(LD_REG)
                begin
                    case (DR)
                    3'b000:
                        r0 <= BUS;
                    3'b001:
                        r1 <= BUS;
                    3'b010:
                        r2 <= BUS;
                    3'b011:
                        r3 <= BUS;
                    3'b100:
                        r4 <= BUS;
                    3'b101:
                        r5 <= BUS;
                    3'b110:
                        r6 <= BUS;
                    3'b111:
                        r7 <= BUS;
                end
        end

    // SR1 MUX
    always@(*)
        begin
            case (SR1_SEL)
            3'b000:
                Result_SR1 = r0;
            3'b001:
                Result_SR1 = r1;
            3'b010:
                Result_SR1 = r2;
            3'b011:
                Result_SR1 = r3;
            3'b100:
                Result_SR1 = r4;
            3'b101:
                Result_SR1 = r5;
            3'b110:
                Result_SR1 = r6;
            3'b111:
                Result_SR1 = r7;  
            endcase
        end
    
    // SR2 MUX
    always@(*)
        begin
            case (SR2_SEL)
            3'b000:
                Result_SR2 = r0;
            3'b001:
                Result_SR2 = r1;
            3'b010:
                Result_SR2 = r2;
            3'b011:
                Result_SR2 = r3;
            3'b100:
                Result_SR2 = r4;
            3'b101:
                Result_SR2 = r5;
            3'b110:
                Result_SR2 = r6;
            3'b111:
                Result_SR2 = r7;  
            endcase
        end
    
    assign SR1_OUT = Result_SR1;
    assign SR2_OUT = Result_SR2;
    
endmodule
