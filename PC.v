module PC(input i_Clk,
          input LD_PC,
          input PCMUX_OUT,
          output reg OUT);

    always@(posedge i_Clk)
        begin
            if(LD_PC) OUT <= PCMUX_OUT;
        end
endmodule