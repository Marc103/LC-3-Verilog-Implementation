module OUTPUT(input i_Clk,
              input [15:0] dsr,
              input ready,
              output reg send = 1,
              output reg [15:0] status = 16'h0000,
              output reg LD = 0);
    
    reg [3:0] cstate = 0;
    reg [3:0] nstate = 0;
    
    
    always@(cstate, dsr, ready)
        begin
            case(cstate)
            0:
                if(dsr == 1) begin send = 1; nstate = 1; end
                else nstate = 0;
            1:
                begin send = 0; nstate = 2; end
            2:
                if(!ready)  nstate = 2;
                else nstate = 3;
            3:
                begin LD = 1; nstate = 4; end
            4:
                begin LD = 0; nstate = 5; end
            5:
                nstate = 0;
                  
            endcase
        end
        
    always@(posedge i_Clk)
        begin
            cstate <= nstate;
        end
    

endmodule