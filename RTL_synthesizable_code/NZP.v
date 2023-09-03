module NZP(input i_Clk,
           input LD_CC,
           input signed [15:0] BUS_OUT,
           output N_OUT,
           output Z_OUT,
           output P_OUT);

    reg N = 0;
    reg Z = 0;
    reg P = 0;

    always @(posedge i_Clk) 
        begin
            if (LD_CC) // if LD_CC is 1, update nzp regs
                begin
                    if (BUS_OUT > 0) 
                        begin
                            N <= 0;
                            Z <= 0;
                            P <= 1;
                        end
                    else if (BUS_OUT == 0)
                        begin
                            N <= 0;
                            Z <= 1;
                            P <= 0;
                        end
                    else
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