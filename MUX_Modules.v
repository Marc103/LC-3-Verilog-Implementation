module SR2MUX(input IR_5,
              input [4:0] IR_SEXT_4_0,
              input [15:0] SR2OUT,
              output [15:0] OUT);
    reg [15:0] Result
    
    always@(*)
        begin
            case (IR_5)
            1'b0: 
                Result = SR2OUT;
            1'b1:
                Result = IR_SEXT_4_0;
            endcase
        end
endmodule