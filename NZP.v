module NZP(input i_Clk,
           input BUS,
           input LD_CC,
           output N_OUT,
           output Z_OUT,
           output P_OUT,);

    reg N;
    reg Z;
    reg P;

    always @(negedge i_Clk) 
        begin
            if (!LD_CC) // if LD_CC is 0, keep nzp regs updated
                begin
                    if (BUS > 0) 
                        begin
                            N <= 0;
                            Z <= 0;
                            P <= 1;
                        end
                    if (BUS == 0)
                        begin
                            N <= 0;
                            Z <= 1;
                            P <= 0;
                        end
                    if(BUS < 1)
                        begin
                            N <= 1;
                            Z <= 0;
                            P <= 0;
                        end
                end
        end
    
    assign N_OUT = N;
    assign Z_OUT = Z;
    assign P_OUT = P;
    
endmodule